import 'dart:async';

import 'package:fluestr/common/constants.dart';
import 'package:fluestr/common/models/contact.dart';
import 'package:fluestr/common/relay_repository.dart';

import '../../utils.dart';
import '../models/event.dart';
import '../models/nostr_kinds.dart';
import '../models/subscription_filter.dart';
import 'auto_timeout_fetch_request.dart';
import 'request_result.dart';

class FetchContactTextsRequest
    extends AutoTimeoutFetchRequest<RequestResult<List<Event>>> {
  // Options
  final Contact _contact;
  final bool useCache;

  final DateTime? since;
  final DateTime? until;
  final int? limit;

  RequestInfo? _reqInfo;

  FetchContactTextsRequest(
    super.repo,
    this._contact, {
    this.useCache = false,
    this.since,
    this.until,
    this.limit,
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

  Future<RequestResult<List<Event>>> fetch() async {
    if (isClosed) throw StateError('Request is already closed');

    if (useCache) {
      throw UnimplementedError('Cache not implemented yet');
      // TODO: implement me
    }

    final f = SubscriptionFilter(
      authors: [_contact.pubkey],
      eventKinds: [NostrKind.text],
      since: since,
      until: until,
      limit: limit,
    );

    final evtString = jsonify(['REQ', fluestrIdToken, f.toJson()]);
    _reqInfo = repo.query(evtString, false);
    final res = await _reqInfo!.future;

    return RequestResult(
      res.result,
      forced: res.forced,
      forceReason: res.forceReason,
      relays: res.relays,
    );
  }
}
