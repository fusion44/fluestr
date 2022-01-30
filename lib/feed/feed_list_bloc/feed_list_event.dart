part of 'feed_list_bloc.dart';

@immutable
abstract class FeedListBaseEvent {}

class _AddEvent extends FeedListBaseEvent {
  final Event event;

  _AddEvent(this.event);
}

class _UpdateState extends FeedListBaseEvent {
  final List<Event> events;

  _UpdateState(this.events);
}
