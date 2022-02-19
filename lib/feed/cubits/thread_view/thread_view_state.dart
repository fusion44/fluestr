part of 'thread_view_cubit.dart';

abstract class ThreadViewState extends Equatable {
  const ThreadViewState();

  @override
  List<Object> get props => [];
}

class ThreadViewInitial extends ThreadViewState {}

class ThreadLoaded extends ThreadViewState {
  final List<Event> events;

  ThreadLoaded(this.events);

  ThreadLoaded copyWithNewEvents(List<Event> newEvents) =>
      ThreadLoaded([...events, ...newEvents]);

  @override
  List<Object> get props => events;
}
