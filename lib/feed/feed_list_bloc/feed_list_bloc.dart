import 'dart:async';

import 'package:equatable/equatable.dart';
import '../../common/constants.dart';
import '../../common/models/event.dart';
import '../../common/relay_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'feed_list_event.dart';
part 'feed_list_state.dart';

class FeedListBloc extends Bloc<FeedListBaseEvent, FeedListState> {
  final RelayRepository _repo;
  late final StreamSubscription _sub;

  Future<void> dispose() async {
    await _sub.cancel();
  }

  FeedListBloc(this._repo) : super(FeedListInitial()) {
    on<_AddEvent>((event, emit) {
      if (state is FeedListLoaded) {
        final s = state as FeedListLoaded;
        final n = s.copyWithNewEvents([event.event]);
        emit(n);
      } else {
        emit(FeedListLoaded([event.event]));
      }
    });

    on<_UpdateState>((event, emit) {
      emit(
        FeedListLoaded([
          ...event.events
              .where((element) => element.channel == fluestrMainChannel)
        ]),
      );
    });

    if (_repo.events.isNotEmpty) {
      add(_UpdateState(_repo.events));
    }

    _sub = _repo.eventsSub
        .where((event) => event.channel == fluestrMainChannel)
        .listen((event) {
      if (state is FeedListLoaded) {
        final s = state as FeedListLoaded;
        if (s.events.contains(event)) return;
      }

      add(_AddEvent(event));
    });
  }
}
