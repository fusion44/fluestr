part of 'relays_bloc.dart';

abstract class RelayEvent extends Equatable {
  const RelayEvent();

  @override
  List<Object> get props => [];
}

class LoadRelays extends RelayEvent {}

class AddRelay extends RelayEvent {
  final Relay relay;

  AddRelay(this.relay);
}

class RemoveRelay extends RelayEvent {
  final Relay relay;

  RemoveRelay(this.relay);
}

class ToggleRelayActiveState extends RelayEvent {
  final Relay relay;

  ToggleRelayActiveState(this.relay);
}

class ToggleRelayReadState extends RelayEvent {
  final Relay relay;

  ToggleRelayReadState(this.relay);
}

class ToggleRelayWriteState extends RelayEvent {
  final Relay relay;

  ToggleRelayWriteState(this.relay);
}
