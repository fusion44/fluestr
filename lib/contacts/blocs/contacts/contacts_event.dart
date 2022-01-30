part of 'contacts_bloc.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object> get props => [];
}

class _UpdateAllContacts extends ContactEvent {
  final Map<String, Contact> contacts;

  _UpdateAllContacts(this.contacts);
}

class _UpdateContact extends ContactEvent {
  final Contact contact;

  _UpdateContact(this.contact);
}
