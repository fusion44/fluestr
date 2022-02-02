import '../models/contact.dart';
import '../../contacts/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';

class ContactListItem extends StatelessWidget {
  final Contact _contact;

  const ContactListItem(this._contact, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget avatar;
    if (_contact.profile.picture.isNotEmpty) {
      avatar = ProfileAvatar(url: _contact.profile.picture);
    } else if (_contact.profile.name.isNotEmpty) {
      avatar = ProfileAvatar(name: _contact.profile.name);
    } else {
      avatar = ProfileAvatar(name: _contact.pubkey.substring(0, 3));
    }
    return ListTile(
      leading: avatar,
      title: Text(_contact.profile.name),
      subtitle: Text(_contact.pubkey, overflow: TextOverflow.ellipsis),
    );
  }
}
