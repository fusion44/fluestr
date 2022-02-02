import '../models/contact.dart';
import '../models/event.dart';
import '../../contacts/blocs/contacts/contacts_bloc.dart';
import '../../contacts/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class TextEvent extends StatelessWidget {
  final Event _event;
  final Contact? contact;

  const TextEvent(this._event, {Key? key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (contact != null) {
      return _buildLayout(theme, contact!);
    } else {
      return BlocBuilder<ContactsBloc, ContactsState>(
        buildWhen: (previous, current) {
          if (current is ContactsInitial ||
              previous is ContactsInitial && current is ContactsUpdate) {
            return true;
          } else if (previous is ContactsUpdate && current is ContactsUpdate) {
            final p = previous.contacts[_event.pubkey];
            final c = current.contacts[_event.pubkey];
            return p != c;
          }
          return false;
        },
        builder: (context, state) {
          Contact? _con;
          if (state is ContactsUpdate) _con = state.contacts[_event.pubkey];
          return _buildLayout(theme, _con ?? Contact.empty());
        },
      );
    }
  }

  LayoutBuilder _buildLayout(ThemeData theme, Contact con) {
    return LayoutBuilder(
      builder: (context, c) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 4.0),
            _buildAvatar(con),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      _buildName(theme, con),
                      Spacer(),
                      _buildDate(theme, _event.createdAtDt),
                    ],
                  ),
                  Text(_event.content),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildName(ThemeData theme, Contact con) {
    var name = '';
    if (con.profile.name.isNotEmpty) {
      name = con.profile.name;
    }

    return Expanded(
      child: Text(
        name +
            ' (' +
            _event.pubkey.replaceRange(3, _event.pubkey.length - 4, '...') +
            ')',
        style: theme.textTheme.caption,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildAvatar(Contact contact) {
    if (contact.profile.picture.isNotEmpty) {
      return ProfileAvatar(url: contact.profile.picture);
    } else if (contact.profile.name.isNotEmpty) {
      return ProfileAvatar(name: contact.profile.name);
    } else {
      return ProfileAvatar(name: _event.pubkey);
    }
  }

  Widget _buildDate(ThemeData theme, DateTime createdAtDt) {
    return Text(
      timeago.format(createdAtDt),
      style: theme.textTheme.caption,
      textAlign: TextAlign.right,
    );
  }
}
