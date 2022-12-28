import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluestr/common/models/nip19.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/contacts_repository.dart';
import '../../../common/models/contact.dart';
import '../../../common/models/event.dart';

import '../../../common/relay_repository.dart';
import '../../../common/requests/fetch_contact_texts_request.dart';
import '../../../common/requests/request_result.dart';

part 'search_contact_event.dart';
part 'search_contact_state.dart';

class SearchContactBloc
    extends Bloc<SearchContactBaseEvent, SearchContactState> {
  final RelayRepository _relayRepo;

  final ContactsRepository _contactsRepo;

  SearchContactBloc(this._relayRepo, this._contactsRepo)
      : super(SearchContactInitial()) {
    on<SearchContactByPubKey>(_startSearch);
  }

  void _startSearch(
      SearchContactByPubKey event, Emitter<SearchContactState> emit) async {
    final k = Nip19KeySet(event.pubkey);

    emit(SearchingContactState(k));

    final cRes = await _contactsRepo.fetchContact(k);
    final contact = cRes.result;

    if (contact == null) {
      emit(ContactInfoNotFoundState(k));
      return;
    }

    emit(
      ContactInfoFoundState(
        contact: contact,
        contactResult: cRes,
        textResult: RequestResult<List<Event>>([]),
      ),
    );

    // TODO: this should probably be a fetch by a text event repository
    final req = FetchContactTextsRequest(_relayRepo, contact, limit: 15);
    final tRes = await req.fetch();
    final sorted = List.of(tRes.result)
      ..sort((a, b) => a.createdAtDt.compareTo(b.createdAtDt));

    emit(
      ContactInfoFoundState(
        contact: contact,
        contactResult: cRes,
        textResult: tRes.copyWith(result: sorted.reversed.toList()),
        fetchingEvents: false,
      ),
    );
  }
}
