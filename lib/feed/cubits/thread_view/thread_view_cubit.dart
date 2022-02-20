import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/constants.dart';
import '../../../common/models/event.dart';
import '../../../common/models/subscription_filter.dart';
import '../../../common/models/tag.dart';
import '../../../common/relay_repository.dart';

part 'thread_view_state.dart';

class ThreadViewCubit extends Cubit<ThreadViewState> {
  final RelayRepository _repo;
  late final StreamSubscription _sub;
  final String _mainEventId;

  ThreadViewCubit(this._mainEventId, this._repo) : super(ThreadViewInitial()) {
    _initFilter();
    _initListener();
  }

  Future<void> dispose() async {
    await _sub.cancel();
  }

  void _initFilter() {
    final mainEvent = _repo.eventMap[_mainEventId];

    if (mainEvent != null) {
      final unknownIds = <String>[];
      final parentEvents = mainEvent.tags.whereType<EventTag>().toList();
      for (final aid in parentEvents) {
        final parentEvent = _repo.eventMap[aid];
        if (parentEvent == null) {
          unknownIds.add(aid.eventId);
        }
      }

      final f = SubscriptionFilter(
        eTagIds: [mainEvent.id], // To get the children
        eventIds: unknownIds, // to get parents
        eventKinds: [1],
      );

      _repo.trySendRaw(
        jsonEncode(['REQ', fluestrMainChannel.toString(), f.toJson()]),
      );

      emit(
        ThreadLoaded([...mainEvent.parents, mainEvent, ...mainEvent.children]
            .reversed
            .toList()),
      );
    }
  }

  void _initListener() {
    _sub = _repo.eventsSub.listen((events) {
      for (var event in events) {
        if (event.id == _mainEventId) {
          emit(
            ThreadLoaded(
              [...event.parents, event, ...event.children].reversed.toList(),
            ),
          );
          break;
        }
      }
    });
  }
}
