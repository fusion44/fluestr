import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/constants.dart';
import '../../../common/models/contact.dart';
import '../../../common/models/event.dart';
import '../../../common/relay_repository.dart';

part 'feed_list_state.dart';

class FeedListCubit extends Cubit<FeedListState> {
  final RelayRepository _repo;
  final Map<String, Contact> _contacts;
  late final StreamSubscription _sub;

  FeedListCubit(this._repo, this._contacts) : super(FeedListInitial()) {
    _sub = _repo.eventsSub.map<List<Event>>((events) {
      return [
        for (var e in events)
          if (e.channel == fluestrMainChannel) e
      ];
    }).map<List<Event>>((events) {
      return [
        for (var e in events)
          if (_isFollowingContact(e)) e
      ];
    }).listen((events) {
      final s = state;
      if (s is FeedListInitial) {
        emit(FeedListLoaded(_repo.events.reversed.toList()));
      } else if (s is FeedListLoaded) {
        var evts =
            events.where((element) => !s.events.any((e) => element.id == e.id));
        emit(FeedListLoaded([...evts, ...s.events]));
      }
    }, onError: (e) => print(e));

    if (_repo.events.isNotEmpty) {
      final l = _repo.events.where((element) => _isFollowingContact(element));
      emit(FeedListLoaded(l.toList().reversed.toList()));
    }
  }

  Future<void> dispose() async {
    await _sub.cancel();
  }

  bool _isFollowingContact(Event e) {
    if (_contacts.containsKey(e.pubkey) &&
        _contacts[e.pubkey] != null &&
        _contacts[e.pubkey]!.following) {
      return true;
    }

    return false;
  }
}
