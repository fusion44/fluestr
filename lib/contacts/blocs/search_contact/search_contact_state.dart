part of 'search_contact_bloc.dart';

abstract class SearchContactState extends Equatable {
  const SearchContactState();

  @override
  List<Object> get props => [];
}

class SearchContactInitial extends SearchContactState {}

class ContactInfoFoundState extends SearchContactState {
  final Contact contact;
  final List<Event> events;

  ContactInfoFoundState(this.contact, this.events);
}
