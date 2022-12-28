import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/contacts_repository.dart';
import '../../../common/models/contact.dart';

part 'edit_contact_event.dart';
part 'edit_contact_state.dart';

class EditContactBloc extends Bloc<EditContactEvent, EditContactState> {
  final ContactsRepository _repo;
  Contact _contact;

  EditContactBloc(this._repo, this._contact)
      : super(EditContactUpdate(_contact)) {
    on<ToggleFollowStatus>((event, emit) async {
      if (_contact.following) {
        _contact = await _repo.unfollowContact(_contact);
      } else {
        _contact = await _repo.followContact(_contact);
      }

      emit(EditContactUpdate(_contact));
    });
  }
}
