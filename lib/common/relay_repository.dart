import 'dart:async';
import 'dart:convert';

import 'constants.dart';
import 'models/event.dart';
import 'models/relay.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../utils.dart';

class RelayRepository {
  final List<Relay> _relays = [];
  final Map<Relay, WebSocketChannel> _channels = {};
  final Map<Relay, StreamSubscription> _subs = {};

  final _eventStreamController = StreamController<Event>();
  late final Stream<Event> _eventStream;
  final List<Event> _events = [];

  final _noticeStreamController = StreamController<String>();
  late final Stream<String> _noticeStream;
  final List<String> _notices = [];

  late final Box _box;

  /// Subscribe to new [Event] objects.
  /// Use [events] to get all [Event] objects received in the past.
  Stream<Event> get eventsSub => _eventStream;

  /// Subscribe to new notices.
  /// Use [notices] to get all notices received in the past.
  Stream<String> get noticeSub => _noticeStream;

  /// Get all events up to this point in time
  List<Event> get events => _events;

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

    final chan = WebSocketChannel.connect(
      Uri.parse(r.url),
    );

    final sub = _subscribe(chan);

    _channels[r] = chan;
    _subs[r] = sub;
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

  StreamSubscription _subscribe(WebSocketChannel channel) {
    return channel.stream.listen((event) async {
      var data;
      try {
        data = jsonDecode(event);
      } catch (err) {
        data = event.data;
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

          if (!verified) {
            _eventStreamController.sink.addError(
              'Received unverifiable Event: ${evt.toJsonString()}',
            );
          }
          _eventStreamController.sink.add(evt.copyWith(verified: verified));
          _events.add(evt);
        }
      }
    });
  }

  Future<void> _storeRelays() async {
    await _box.put(prefRelayUrls, _relays);
  }
}
