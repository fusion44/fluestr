import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/contacts_repository.dart';
import '../../../common/models/contact.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactEvent, ContactsState> {
  final ContactsRepository _contactsRepo;

  ContactsBloc(this._contactsRepo) : super(ContactsInitial()) {
    on<FollowContact>((event, emit) async {
      if (!event.contact.following) {
        _contactsRepo.followContact(event.contact);
      }
    });

    on<_UpdateAllContacts>((event, emit) {
      emit(ContactsUpdate(Map.from(event.contacts)));
    });

    if (_contactsRepo.contacts.isNotEmpty) {
      add(_UpdateAllContacts(_contactsRepo.contacts));
    }

    _contactsRepo.contactsStream.listen((contact) {
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
