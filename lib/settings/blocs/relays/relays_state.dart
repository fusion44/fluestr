part of 'relays_bloc.dart';

abstract class RelaysState extends Equatable {
  const RelaysState();

  @override
  List<Object> get props => [];
}

class RelaysInitial extends RelaysState {}

class RelaysLoadedState extends RelaysState {
  final List<Relay> relays;

  RelaysLoadedState(this.relays);

  @override
  List<Object> get props => relays;
}

class RelaysErrorState extends RelaysState {
  final String error;

  RelaysErrorState(this.error);

  @override
  List<Object> get props => [error];
}
