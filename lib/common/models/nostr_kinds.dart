// https://github.com/nostr-protocol/nips#event-kinds

import 'package:flutter/foundation.dart';

enum NostrKind {
  unknown(-1),
  metadata(0),
  text(1),
  recommendRelay(2),
  contacts(3),
  encryptedDirectMessages(4),
  eventDeletion(5),
  reaction(7),
  channelCreation(40),
  channelMetadata(41),
  channelMessage(42),
  channelHideMessage(43),
  channelMuteUser(44);
  // 45    - 49	    Public Chat Reserved
  // 10000 - 19999  Replaceable Events Reserved
  // 20000 - 29999	Ephemeral Events Reserved

  const NostrKind(this.value);
  final int value;

  static NostrKind fromValue(num value) {
    switch (value) {
      case 0:
        return NostrKind.metadata;
      case 1:
        return NostrKind.text;
      case 2:
        return NostrKind.recommendRelay;
      case 3:
        return NostrKind.contacts;
      case 4:
        return NostrKind.encryptedDirectMessages;
      case 5:
        return NostrKind.eventDeletion;
      case 7:
        return NostrKind.reaction;
      case 40:
        return NostrKind.channelCreation;
      case 41:
        return NostrKind.channelMetadata;
      case 42:
        return NostrKind.channelMessage;
      case 43:
        return NostrKind.channelHideMessage;
      case 44:
        return NostrKind.channelMuteUser;
      default:
        debugPrint('Unknown NostrKind: $value');
        return NostrKind.unknown;
    }
  }
}

extension KindsListExtensions on List<NostrKind> {
  List<int> toIntList() => [for (final k in this) k.value];
}
