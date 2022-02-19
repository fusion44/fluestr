import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../contacts/blocs/contacts/contacts_bloc.dart';
import '../../contacts/widgets/profile_avatar.dart';
import '../models/contact.dart';
import '../models/event.dart';
import 'code_element_builder.dart';

class TextEvent extends StatelessWidget {
  final Event _event;
  final Contact? contact;
  final Function(String)? onTap;

  const TextEvent(this._event, {Key? key, this.contact, this.onTap})
      : super(key: key);

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
        return _wrapWithInkWell(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 4.0),
              _buildInfoColumn(con),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildName(theme, con),
                        SizedBox(width: 8.0),
                        if (_event.numParents > 0 || _event.numChildren > 0)
                          _buildReplyIndicator(theme),
                        Expanded(child: _buildDate(theme, _event.createdAtDt)),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    MarkdownBody(
                      data: _event.content,
                      selectable: kIsWeb ? true : false,
                      builders: {'code': CodeElementBuilder()},
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoColumn(Contact con) {
    if (_event.numParents > 0 && _event.numChildren > 0) {
      return Column(
        children: [
          _buildAvatar(con),
          Row(children: [
            Icon(Icons.reply),
            SizedBox(width: 3.0),
            Text('${_event.numChildren}'),
          ]),
        ],
      );
    } else if (_event.numParents > 0 && _event.numChildren == 0) {
      return Column(
        children: [
          _buildAvatar(con),
          Row(children: [
            Icon(Icons.reply),
            SizedBox(width: 3.0),
            Text('${_event.numChildren}'),
          ]),
        ],
      );
    } else if (_event.numParents == 0 && _event.numChildren > 0) {
      return Column(
        children: [
          _buildAvatar(con),
          Row(children: [
            Icon(Icons.reply),
            SizedBox(width: 3.0),
            Text('${_event.numChildren}'),
          ]),
        ],
      );
    } else {
      return _buildAvatar(con);
    }
  }

  Widget _wrapWithInkWell(Widget child) => onTap == null
      ? child
      : InkWell(
          onTap: () => onTap!(_event.id),
          child: child,
        );

  Widget _buildName(ThemeData theme, Contact con) {
    var name = '';
    if (con.profile.name.isNotEmpty) {
      name = con.profile.name;
    }

    return Tooltip(
      message: _event.pubkey,
      child: Text(
        name +
            ' (' +
            _event.pubkey.replaceRange(3, _event.pubkey.length - 4, '...') +
            ')',
        style: theme.textTheme.labelLarge!.copyWith(
          color: Colors.blueGrey[200],
          fontWeight: FontWeight.bold,
        ),
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
      style: theme.textTheme.caption!.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.right,
    );
  }

  Widget _buildReplyIndicator(ThemeData theme) {
    return Text(
      'P: ${_event.numParents} / C: ${_event.numChildren}',
      style: TextStyle(color: Colors.blueAccent),
    );
  }
}
