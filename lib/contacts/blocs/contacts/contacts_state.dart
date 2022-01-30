part of 'contacts_bloc.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsUpdate extends ContactsState {
  final Map<String, Contact> contacts;

  ContactsUpdate(this.contacts);

  @override
  List<Object> get props => [for (var p in contacts.values) ...p.props];

  ContactsUpdate copyWith(Contact newContact) {
    final newMap = Map<String, Contact>.from(contacts);
    newMap[newContact.pubkey] = newContact;

    return ContactsUpdate(newMap);
  }
}
