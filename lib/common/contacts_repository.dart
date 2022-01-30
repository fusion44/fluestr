import 'dart:convert';

import 'models/event.dart';
import 'dart:async';

import 'relay_repository.dart';

import 'models/contact.dart';
import 'models/profile.dart';

class ContactsRepository {
  final RelayRepository _relayRepo;
  final _contactsStreamController = StreamController<Contact>();
  late final Stream<Contact> _contactsStream;
  final Map<String, Contact> _contacts = {};
  late final StreamSubscription<Event> _sub;

  void dispose() async {
    await _sub.cancel();
  }

  ContactsRepository(this._relayRepo) {
    _contactsStream = _contactsStreamController.stream.asBroadcastStream();
    final l = _relayRepo.events.where((element) => element.kind == 0);
    for (var event in l) {
      _handleProfileEvent(event);
    }

    _sub = _relayRepo.eventsSub.where((event) {
      return event.kind == 0;
    }).listen((event) {
      _handleProfileEvent(event);
    });
  }

  /// Get all contacts received up to this point in time
  Map<String, Contact> get contacts => _contacts;

  /// Subscribe to new or updated [Contact] objects.
  /// Use [contacts] to get all [Profiles] objects received in the past.
  Stream<Contact> get contactsStream => _contactsStream;

  void _handleProfileEvent(Event event) {
    final p = Profile.fromJson(jsonDecode(event.content));
    var c;
    if (_contacts.containsKey(event.pubkey)) {
      c = _contacts[event.pubkey]!.copyWith(profile: p);
    } else {
      c = Contact(pubkey: event.pubkey, profile: p);
    }
    _contacts[event.pubkey] = c;
    _contactsStreamController.sink.add(c);
  }
}
