import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../common/models/relay.dart';
import '../../../common/relay_repository.dart';

part 'relays_event.dart';
part 'relays_state.dart';

class RelayBloc extends Bloc<RelayEvent, RelaysState> {
  final RelayRepository _repo;
  RelayBloc(this._repo) : super(RelaysInitial()) {
    on<LoadRelays>((event, emit) {
      emit(RelaysLoadedState([..._repo.relays]));
    });

    on<AddRelay>((event, emit) async {
      try {
        await _repo.addRelay(event.relay);
        emit(RelaysLoadedState([..._repo.relays]));
      } catch (e) {
        emit(RelaysErrorState(e.toString()));
      }
    });

    on<RemoveRelay>((event, emit) async {
      try {
        await _repo.removeRelay(event.relay);
        emit(RelaysLoadedState([..._repo.relays]));
      } catch (e) {
        emit(RelaysErrorState(e.toString()));
      }
    });

    on<ToggleRelayActiveState>((event, emit) async {
      try {
        await _repo.toggleRelayActiveState(event.relay);
        emit(RelaysLoadedState([..._repo.relays]));
      } catch (e) {
        emit(RelaysErrorState(e.toString()));
      }
    });

    on<ToggleRelayReadState>((event, emit) async {
      try {
        await _repo.toggleRelayReadState(event.relay);
        emit(RelaysLoadedState([..._repo.relays]));
      } catch (e) {
        emit(RelaysErrorState(e.toString()));
      }
    });

    on<ToggleRelayWriteState>((event, emit) async {
      try {
        await _repo.toggleRelayWriteState(event.relay);
        emit(RelaysLoadedState([..._repo.relays]));
      } catch (e) {
        emit(RelaysErrorState(e.toString()));
      }
    });
  }
}
