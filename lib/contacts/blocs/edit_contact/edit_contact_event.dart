part of 'edit_contact_bloc.dart';

abstract class EditContactEvent extends Equatable {
  const EditContactEvent();

  @override
  List<Object> get props => [];
}

class ToggleFollowStatus extends EditContactEvent {
  const ToggleFollowStatus();
}
