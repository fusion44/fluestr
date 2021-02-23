import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'models/message_item.dart';

class ChatPeerListTile extends StatelessWidget {
  final String pubKey;
  final Color color;
  final String alias;
  final MessageItem lastMessage;
  final Function(String) onTap;

  const ChatPeerListTile(
    this.pubKey,
    this.lastMessage, {
    this.color = Colors.black,
    this.alias = '',
    this.onTap,
    Key key,
  }) : super(key: key);

  void _onTap(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ListTile(
      onTap: () => _onTap(context),
      leading: CircleAvatar(backgroundColor: color),
      title: Text(alias, overflow: TextOverflow.ellipsis),
      subtitle: Text(lastMessage.text, overflow: TextOverflow.ellipsis),
      trailing: Text(
        timeago.format(lastMessage.date, locale: 'en_short'),
        style: theme.textTheme.caption,
      ),
    );
  }
}
