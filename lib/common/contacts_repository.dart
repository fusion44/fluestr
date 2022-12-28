import 'dart:async';
import 'dart:convert';

import 'package:fluestr/common/models/nostr_kinds.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants.dart';
import 'models/contact.dart';
import 'models/event.dart';
import 'models/nip19.dart';
import 'models/profile.dart';
import 'models/subscription_filter.dart';
import 'relay_repository.dart';
import 'requests/fetch_contact_request.dart';
import 'requests/request_result.dart';

class ContactsRepository {
  final RelayRepository _relayRepo;
  final _contactsStreamController = StreamController<Contact>();
  late final Stream<Contact> _contactsStream;
  final Map<String, Contact> _contacts = {};
  late final StreamSubscription<List<Event>> _sub;
  bool _initialized = false;

  bool get initialized => _initialized;

  Future<void> init() async {
    final box = await Hive.openBox(prefBoxNameSettings);

    List<Contact> contacts = box.get(
      prefFollowedContacts,
      defaultValue: <Contact>[],
    ).cast<Contact>();

    for (final c in contacts) {
      _contacts[c.pubkey] = c;
    }

    if (contacts.isNotEmpty) {
      final f = SubscriptionFilter(
        authors:
            contacts.where((e) => e.following).map((e) => e.pubkey).toList(),
        eventKinds: [
          NostrKind.metadata,
          NostrKind.text,
          NostrKind.recommendRelay,
        ],
      );

      _relayRepo.trySendRaw(
        jsonEncode(['REQ', fluestrMainChannel.toString(), f.toJson()]),
      );
    }
    _initialized = true;
  }

  void dispose() async {
    await _sub.cancel();
  }

  ContactsRepository(this._relayRepo) {
    _contactsStream = _contactsStreamController.stream.asBroadcastStream();
    final l = _relayRepo.events.where(
      (element) => element.kind == NostrKind.metadata,
    );
    _handleProfileEvents(l);

    _sub = _relayRepo.eventsSub.map<List<Event>>((events) {
      final newList = <Event>[];
      for (var e in events) {
        if (e.kind == NostrKind.metadata && e.channel == fluestrMainChannel) {
          newList.add(e);
        }
      }
      return newList;
    }).listen((events) {
      _handleProfileEvents(events);
    }, onError: (e) => debugPrint(e));
  }

  /// Get all contacts received up to this point in time
  Map<String, Contact> get contacts => _contacts;

  /// Subscribe to new or updated [Contact] objects.
  /// Use [contacts] to get all [Profiles] objects received in the past.
  Stream<Contact> get contactsStream => _contactsStream;

  Future<RequestResult<Contact?>> fetchContact(
    Nip19KeySet key, [
    bool useCache = false,
  ]) async {
    final req = FetchContactRequest(_relayRepo, key: key, useCache: useCache);
    final res = await req.fetch();
    final contact = res.result;

    if (contact == null) return RequestResult<Contact?>(null);

    unawaited(req.close());

    return res.copyWith(
      result: contact.copyWith(
        following: _contacts.keys.contains(contact.pubkey),
      ),
    );
  }

  Future<Contact> followContact(Contact contact) async {
    final box = await Hive.openBox(prefBoxNameSettings);
    final newContact = contact.copyWith(following: true);

    _contacts[contact.pubkey] = newContact;
    _contactsStreamController.sink.add(newContact);
    await box.put(prefFollowedContacts, _contacts.values.toList());
    return newContact;
  }

  Future<Contact> unfollowContact(Contact contact) async {
    final box = await Hive.openBox(prefBoxNameSettings);
    final newContact = contact.copyWith(following: false);

    _contacts.remove(contact.pubkey);
    _contactsStreamController.sink.add(newContact);
    await box.put(prefFollowedContacts, _contacts.values.toList());
    return newContact;
  }

  void _handleProfileEvents(Iterable<Event> events) {
    for (var e in events) {
      final p = Profile.fromJson(jsonDecode(e.content));
      var c;
      if (_contacts.containsKey(e.pubkey)) {
        c = _contacts[e.pubkey]!.copyWith(profile: p);
      } else {
        c = Contact(pubkey: e.pubkey, profile: p);
      }
      _contacts[e.pubkey] = c;
      _contactsStreamController.sink.add(c);
    }
  }
}
