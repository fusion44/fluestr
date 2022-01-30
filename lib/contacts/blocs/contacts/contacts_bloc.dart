import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/models/contact.dart';
import '../../../common/contacts_repository.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactEvent, ContactsState> {
  final ContactsRepository _repo;

  ContactsBloc(this._repo) : super(ContactsInitial()) {
    if (_repo.contacts.isNotEmpty) add(_UpdateAllContacts(_repo.contacts));
    on<_UpdateAllContacts>((event, emit) {
      emit(ContactsUpdate(Map.from(event.contacts)));
    });

    _repo.contactsStream.listen((contact) {
      add(_UpdateContact(contact));
    });
    on<_UpdateContact>((event, emit) {
      if (state is ContactsUpdate) {
        final s = state as ContactsUpdate;
        emit(s.copyWith(event.contact));
      } else {
        emit(ContactsUpdate({event.contact.pubkey: event.contact}));
      }
    });
  }
}
