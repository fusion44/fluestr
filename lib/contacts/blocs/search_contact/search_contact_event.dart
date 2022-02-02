part of 'search_contact_bloc.dart';

abstract class SearchContactBaseEvent extends Equatable {
  const SearchContactBaseEvent();

  @override
  List<Object> get props => [];
}

class SearchContactByPubKey extends SearchContactBaseEvent {
  final String pubkey;

  SearchContactByPubKey(this.pubkey);
}

class _FireCountdown extends SearchContactBaseEvent {}
