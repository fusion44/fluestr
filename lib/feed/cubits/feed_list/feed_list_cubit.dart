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
    _sub = _repo.eventsSub
        .where((event) => event.channel == fluestrMainChannel)
        .where((event) => _isFollowingContact(event))
        .listen((event) {
      final s = state;
      if (s is FeedListInitial) {
        emit(FeedListLoaded(_repo.events.reversed.toList()));
      } else if (s is FeedListLoaded) {
        if (!s.events.any((e) => event.id == e.id)) {
          emit(FeedListLoaded([event, ...s.events]));
        }
      }
    });
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
