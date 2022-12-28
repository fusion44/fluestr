part of 'search_contact_bloc.dart';

abstract class SearchContactState extends Equatable {
  const SearchContactState();

  @override
  List<Object> get props => [];
}

class SearchContactInitial extends SearchContactState {}

class SearchingContactState extends SearchContactState {
  final Nip19KeySet pubKey;

  SearchingContactState(this.pubKey);
}

class ContactInfoFoundState extends SearchContactState {
  final Contact contact;
  final RequestResult<Contact?> contactResult;
  final RequestResult<List<Event>> textResult;
  final bool fetchingEvents;

  ContactInfoFoundState({
    required this.contact,
    required this.contactResult,
    required this.textResult,
    this.fetchingEvents = true,
  });

  @override
  List<Object> get props =>
      [contact, textResult, textResult.result.length, fetchingEvents];

  @override
  String toString() =>
      'ContactInfoFoundState{contact: $contact, events: ${textResult.result.length}, fetchingEvents: $fetchingEvents}';
}

class ContactInfoNotFoundState extends SearchContactState {
  final Nip19KeySet pubKey;

  ContactInfoNotFoundState(this.pubKey);
}

class FindContactInfoErrorState extends SearchContactState {
  final Nip19KeySet pubKey;
  final String error;

  FindContactInfoErrorState(this.pubKey, this.error);
}
