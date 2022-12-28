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

  /// maximum number of events to be returned in the initial query
  final int? limit;

  SubscriptionFilter({
    this.eventIds = const [],
    this.eventKinds = const [],
    this.eTagIds = const [],
    this.pTagIds = const [],
    this.since,
    this.until,
    this.authors = const [],
    this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      if (eventIds.isNotEmpty) 'ids': eventIds,
      if (eventKinds.isNotEmpty) 'kinds': eventKinds.toIntList(),
      if (eTagIds.isNotEmpty) '#e': eTagIds,
      if (pTagIds.isNotEmpty) '#p': pTagIds,
      if (since != null) 'since': since!.millisecondsSinceEpoch / 1000,
      if (until != null) 'until': until!.millisecondsSinceEpoch / 1000,
      if (authors.isNotEmpty) 'authors': authors,
      if (limit != null) 'limit': limit,
    };
  }
}
