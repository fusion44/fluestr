part of 'contacts_bloc.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object> get props => [];
}

class FollowContact extends ContactEvent {
  final Contact contact;

  const FollowContact(this.contact);
}

class _UpdateAllContacts extends ContactEvent {
  final Map<String, Contact> contacts;

  const _UpdateAllContacts(this.contacts);
}

class _UpdateContact extends ContactEvent {
  final Contact contact;

  const _UpdateContact(this.contact);
}
