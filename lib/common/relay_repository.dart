import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../utils.dart';
import 'constants.dart';
import 'models/event.dart';
import 'models/relay.dart';
import 'models/tag.dart';

class RelayRepository {
  final List<Relay> _relays = [];
  final Map<Relay, WebSocketChannel> _channels = {};
  final Map<Relay, StreamSubscription> _subs = {};

  final _eventStreamController = StreamController<List<Event>>();
  late final Stream<List<Event>> _eventStream;
  final Map<String, Event> _eventMap = {};

  final _noticeStreamController = StreamController<String>();
  late final Stream<String> _noticeStream;
  final List<String> _notices = [];

  late final Box _box;

  // we'll cache incoming events and send them every
  // x milliseconds to clients to avoid back pressure issues
  final int _flushTime = 500;
  var _eventCache = <Event>[];
  bool _awaitingFlush = false;

  /// Subscribe to new [Event] objects.
  /// Use [events] to get all [Event] objects received in the past.
  Stream<List<Event>> get eventsSub => _eventStream;

  /// Subscribe to new notices.
  /// Use [notices] to get all notices received in the past.
  Stream<String> get noticeSub => _noticeStream;

  List<Event> get events => _eventMap.values.toList();

  /// Get all events up to this point in time (Map<String, Event>)
  Map<String, Event> get eventMap => _eventMap;

  /// Get all notices up to this point in time
  List<String> get notices => _notices;

  /// Get all registered [Relay] objects
  List<Relay> get relays => _relays;

  Future<void> dispose() async {
    for (var sub in _subs.values) {
      await sub.cancel();
    }
  }

  Future<void> init() async {
    _eventStream = _eventStreamController.stream.asBroadcastStream();
    _noticeStream = _noticeStreamController.stream.asBroadcastStream();

    _box = await Hive.openBox(prefBoxNameSettings);
    final rs = _box.get(prefRelayUrls, defaultValue: <Relay>[]);
    _relays.addAll(rs.cast<Relay>());

    if (_relays.isEmpty) {
      _relays.addAll(getStandardRelays());
      await _storeRelays();
    }

    for (final r in _relays) {
      _connectRelay(r);
    }
  }

  Future<void> toggleRelayActiveState(Relay r) async {
    if (!_relays.contains(r)) throw StateError('Relay not registered');

    await removeRelay(r);
    await addRelay(r.copyWith(active: !r.active));
  }

  Future<void> toggleRelayWriteState(Relay r) async {
    if (!_relays.contains(r)) throw StateError('Relay not registered');

    await removeRelay(r);
    await addRelay(r.copyWith(write: !r.write));
  }

  Future<void> toggleRelayReadState(Relay r) async {
    if (!_relays.contains(r)) throw StateError('Relay not registered');

    await removeRelay(r);
    await addRelay(r.copyWith(read: !r.read));
  }

  Future<void> addRelay(Relay r) async {
    _relays.add(r);
    if (r.active) _connectRelay(r);

    _relays.sort((a, b) {
      return a.url.compareTo(b.url);
    });

    await _storeRelays();
  }

  Future<void> removeRelay(dynamic r) async {
    if (r is Relay) {
      _relays.remove(r);
      await _disconnectRelay(r);
    } else if (r is String) {
      try {
        Uri.parse(r);
        final relay = _relays.firstWhere((Relay element) => r == element.url);
        await _disconnectRelay(relay);
        _relays.remove(relay);
      } catch (e) {
        debugPrint('Error while parsing the Uri: $r');
      }
    } else {
      throw ArgumentError(
        'Argument must either be a Relay instance or a String containing the valid Relay url',
      );
    }
    await _storeRelays();
  }

  void trySend(Event e) {
    for (var chan in _channels.values) {
      chan.sink.add(e.toJsonString());
    }
  }

  void trySendRaw(String data) {
    for (var chan in _channels.values) {
      chan.sink.add(data);
    }
  }

  void _connectRelay(Relay r) {
    if (!r.active) return;
    debugPrint('Connecting to ${r.url}');

    try {
      final chan = WebSocketChannel.connect(
        Uri.parse(r.url),
      );

      final sub = _subscribe(chan, r);

      _channels[r] = chan;
      _subs[r] = sub;
    } catch (e) {
      debugPrint('Error while connecting to ${r.url}: $e');
      rethrow;
    }
  }

  Future<void> _disconnectRelay(Relay r) async {
    if (r.active && _subs.containsKey(r)) {
      debugPrint('Disconnecting from ${r.url}');
      _channels.remove(r);
      final sub = _subs[r];
      await sub?.cancel();
      _subs.remove(r);
    }
  }

  StreamSubscription _subscribe(WebSocketChannel channel, Relay r) {
    return channel.stream.listen((event) async {
      var data;
      try {
        data = jsonDecode(event);
      } catch (err) {
        // do nothing
      }

      if (data == null) {
        try {
          data = event.data;
        } catch (err) {
          debugPrint('Error while parsing event: $event');
          debugPrint('Error: ${err.toString()}');
          debugPrint(r.url);
          return;
        }
      }

      if (data == null) return;

      if (data[0] == 'EOSE') {
        // EOSE -	used to notify clients all stored events have been sent
        return;
      }

      if (data.length > 1) {
        if (data[0] == 'NOTICE') {
          if (data.length < 2) return null;
          debugPrint('Message from relay ws://localhost:2700: ' + data[1]);
          _noticeStreamController.sink.add(data[1]);
          _notices.add(data[1]);
        }

        if (data[0] == 'EVENT') {
          if (data.length < 3) return null;
          final channel = int.tryParse(data[1]);
          final evt = Event.fromJson(data[2], channel: channel ?? 0);
          final verified = await evt.verify();

          final taggedEvents = evt.tags.whereType<EventTag>().toList();
          for (var t in taggedEvents) {
            if (_eventMap.containsKey(t.eventId) &&
                _eventMap[t.eventId] != null) {
              // We have a new event that is a reply to an existing old event,
              // Events might be loaded multiple times, so we must check if
              // the child is already registered
              if (!_eventMap[t.eventId]!.hasChild(evt)) {
                final updatedOldEvent =
                    _eventMap[t.eventId]!.copyWith(child: evt);

                // Update the event map with the updated object
                _eventMap[t.eventId] = updatedOldEvent;

                // Notify client that there are updates
                _addEventToCache(updatedOldEvent);
              }
              // Add the parent object to the new event
              evt.parents.add(_eventMap[t.eventId]!);
            }
          }

          if (!verified) {
            _eventStreamController.sink.addError(
              'Received unverifiable Event: ${evt.toJsonString()}',
            );
          }

          final evt2 = evt.copyWith(verified: verified);
          _addEventToCache(evt2);
          _eventMap[evt.id] = evt2;
        }
      }
    }, onError: (err) {
      if (err.toString().contains('errno = 111')) {
        debugPrint('Unable to connect to relay: ${r.url}');
        return;
      }

      debugPrint('Error while receiving data from relay: $err');
    });
  }

  void _addEventToCache(Event e) {
    _eventCache.add(e);
    _flushEvents();
  }

  Future<void> _flushEvents() async {
    if (_awaitingFlush) return;
    _awaitingFlush = true;

    await Future.delayed(Duration(milliseconds: _flushTime));
    _eventStreamController.sink.add(_eventCache);
    _eventCache = [];
    _awaitingFlush = false;
  }

  Future<void> _storeRelays() async {
    await _box.put(prefRelayUrls, _relays);
  }
}
