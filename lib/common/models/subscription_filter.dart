import 'package:fluestr/common/models/nostr_kinds.dart';

class SubscriptionFilter {
  /// a list of event ids
  final List<String> eventIds;

  /// a list of kind numbers
  final List<NostrKind> eventKinds;

  /// a list of event ids that are referenced in an "e" tag
  final List<String> eTagIds; // #e

  /// a list of pubkeys that are referenced in a "p" tag
  final List<String> pTagIds; // #p

  /// a timestamp, events must be newer than this to pass
  final DateTime? since;

  /// a timestamp, events must be older than this to pass
  final DateTime? until;

  /// a list of pubkeys, the pubkey of an event must be one of these
  final List<String> authors;

  SubscriptionFilter({
    this.eventIds = const [],
    this.eventKinds = const [],
    this.eTagIds = const [],
    this.pTagIds = const [],
    this.since,
    this.until,
    this.authors = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'ids': eventIds.isEmpty ? null : eventIds,
      'kinds': eventKinds.isEmpty ? null : eventKinds.toIntList(),
      '#e': eTagIds.isEmpty ? null : eTagIds,
      '#p': pTagIds.isEmpty ? null : pTagIds,
      'since': since != null ? since!.millisecondsSinceEpoch / 1000 : null,
      'until': until != null ? until!.millisecondsSinceEpoch / 1000 : null,
      'authors': authors.isEmpty ? null : authors,
    };
  }
}
