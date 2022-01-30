import '../../common/models/contact.dart';
import '../blocs/contacts/contacts_bloc.dart';
import '../widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ContactsBloc, ContactsState>(
      builder: (context, state) {
        if (state is ContactsUpdate) {
          return ListView.builder(
              itemCount: state.contacts.length,
              itemBuilder: (context, i) {
                return _buildContactsListItem(
                  theme,
                  state.contacts.values.elementAt(i),
                );
              });
        }
        return Container();
      },
    );
  }

  Widget _buildContactsListItem(ThemeData theme, Contact c) {
    Widget avatar;
    if (c.profile.picture.isNotEmpty) {
      avatar = ProfileAvatar(url: c.profile.picture);
    } else if (c.profile.name.isNotEmpty) {
      avatar = ProfileAvatar(name: c.profile.name);
    } else {
      avatar = ProfileAvatar(name: c.pubkey.substring(0, 3));
    }
    return ListTile(
      leading: avatar,
      title: Text(c.profile.name),
      subtitle: Text(c.pubkey, overflow: TextOverflow.ellipsis),
    );
  }
}
