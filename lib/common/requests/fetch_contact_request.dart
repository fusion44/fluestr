import 'dart:async';
import 'dart:convert';

import 'package:fluestr/common/constants.dart';
import 'package:fluestr/common/relay_repository.dart';

import '../../utils.dart';
import '../models/contact.dart';
import '../models/nip19.dart';
import '../models/nostr_kinds.dart';
import '../models/profile.dart';
import '../models/subscription_filter.dart';
import 'auto_timeout_fetch_request.dart';
import 'request_result.dart';

class FetchContactRequest extends AutoTimeoutFetchRequest<Contact?> {
  // Options
  final Nip19KeySet key;
  final bool useCache;

  Contact? _contact;

  RequestInfo? _reqInfo;

  FetchContactRequest(
    super.relayRepo, {
    required this.key,
    this.useCache = false,
    super.timeoutDuration,
  }) {
    if (useCache) {
      // TODO: implement me
      throw UnimplementedError('Cache not implemented yet');
    }
  }

  @override
  void onTimeout() async {
    // If we timeout, we need to cancel the request on the relay repo
    if (_reqInfo == null) return;
    repo.forceCompleteRequest(_reqInfo!.id, timeoutErrorDescription);
  }

  Future<RequestResult<Contact?>> fetch() async {
    if (isClosed) throw StateError('Request is already closed');

    if (useCache) {
      throw UnimplementedError('Cache not implemented yet');
      // TODO: implement me
    }

    final f = SubscriptionFilter(
      authors: [key.pubKeyHex],
      eventKinds: [NostrKind.metadata, NostrKind.recommendRelay],
    );

    final evtString = jsonify(['REQ', fluestrIdToken, f.toJson()]);
    _reqInfo = repo.query(evtString);
    final res = await _reqInfo!.future;

    for (final e in res.result) {
      if (e.kind == NostrKind.metadata) {
        _contact = Contact(
          pubkey: e.pubkey,
          profile: Profile.fromJson(jsonDecode(e.content)),
        );

        continue;
      }
    }

    return RequestResult(
      _contact,
      forced: res.forced,
      forceReason: res.forceReason,
      relays: res.relays,
    );
  }
}
