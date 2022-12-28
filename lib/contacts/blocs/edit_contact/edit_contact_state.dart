part of 'edit_contact_bloc.dart';

abstract class EditContactState extends Equatable {
  const EditContactState();

  @override
  List<Object> get props => [];
}

class EditContactUpdate extends EditContactState {
  final Contact contact;

  EditContactUpdate(this.contact);

  @override
  List<Object> get props => [
        contact.following,
        contact.profile.about,
        contact.profile.name,
        contact.profile.picture,
        contact.profile.nip05,
        contact.pubkey,
      ];
}
