part of 'feed_list_cubit.dart';

abstract class FeedListState extends Equatable {
  const FeedListState();

  @override
  List<Object> get props => [];
}

class FeedListInitial extends FeedListState {}

class FeedListLoaded extends FeedListState {
  final List<Event> events;

  FeedListLoaded(this.events);

  @override
  List<Object> get props => [events.length];
}
