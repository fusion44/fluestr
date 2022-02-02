import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../common/models/contact.dart';
import '../../../common/models/event.dart';
import '../../../common/models/profile.dart';

import '../../../common/models/subscription_filter.dart';
import '../../../common/relay_repository.dart';

part 'search_contact_event.dart';
part 'search_contact_state.dart';

const int _channel = 1337;

class SearchContactBloc
    extends Bloc<SearchContactBaseEvent, SearchContactState> {
  final RelayRepository _relayRepository;
  String _currentSearch = "";
  Contact? _contact;
  List<Event> _events = [];
  bool _fetchingFeed = false;
  bool _countDownRunning = false;

  SearchContactBloc(this._relayRepository) : super(SearchContactInitial()) {
    _relayRepository.eventsSub.where((e) {
      return e.channel == _channel;
    }).listen((e) {
      if (e.kind == 0 && _currentSearch == e.pubkey && !_fetchingFeed) {
        _contact = Contact(
          pubkey: e.pubkey,
          profile: Profile.fromJson(jsonDecode(e.content)),
        );
        final f = SubscriptionFilter(
          authors: [e.pubkey],
          eventKinds: [0, 1, 2],
        );

        _fetchingFeed = true;
        _relayRepository.trySendRaw(
          jsonEncode(['REQ', _channel.toString(), f.toJson()]),
        );
      } else if (e.kind == 1 && _currentSearch == e.pubkey && _fetchingFeed) {
        if (_contact == null) throw StateError('Contact must not be null');
        if (!_countDownRunning) add(_FireCountdown());
        _events.add(e);
      }
    });

    on<_FireCountdown>((event, emit) async {
      // After finding a contact and its profile we do fetch the events
      // for this pubkey. They'll arrive in rapid succession. To avoid
      // redrawing the UI constantly we'll cache for a few milliseconds
      // and emit a new state every xxx milliseconds
      if (_countDownRunning || _contact == null) return;
      _countDownRunning = true;
      await Future.delayed(Duration(milliseconds: 500));
      emit(ContactInfoFoundState(_contact!, [..._events]));
      _countDownRunning = false;
    });

    on<SearchContactByPubKey>((event, emit) {
      if (_currentSearch == event.pubkey) {
        return;
      }

      final f = SubscriptionFilter(
        authors: [event.pubkey],
        eventKinds: [0, 2],
      );

      _currentSearch = event.pubkey;
      _relayRepository.trySendRaw(
        jsonEncode(['REQ', _channel.toString(), f.toJson()]),
      );
    });
  }
}
