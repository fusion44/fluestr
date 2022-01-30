part of 'feed_list_bloc.dart';

@immutable
abstract class FeedListState extends Equatable {
  @override
  List<Object> get props => [];
}

class FeedListInitial extends FeedListState {}

class FeedListLoaded extends FeedListState {
  final List<Event> events;

  FeedListLoaded(this.events);

  FeedListLoaded copyWithNewEvents(List<Event> newEvents) =>
      FeedListLoaded([...events, ...newEvents]);

  @override
  List<Object> get props => [events.length];
}
