import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'common/models/relay.dart';

Uint8List randomBytes32() {
  final rand = Random.secure();
  final bytes = Uint8List(32);
  for (var i = 0; i < 32; i++) {
    bytes[i] = rand.nextInt(256);
  }
  return bytes;
}

/// Translates a string with the given [key] and the [translationParams].
String tr(BuildContext context, String key,
    {Map<String, String> translationParams = const {}}) {
  return FlutterI18n.translate(
    context,
    key,
    translationParams: translationParams,
  );
}

List<Relay> getStandardRelays() {
  return [
    Relay('wss://nostr-relay.wlvs.space', true, true, false),
    Relay('wss://nostr.bitcoiner.social', true, true, false),
    Relay('wss://nostr-pub.semisol.dev', true, true, false),
    Relay('wss://nostr.drss.io', true, true, false),
    Relay('wss://relay.damus.io', true, true, false),
    Relay('wss://nostr.openchain.fr', true, true, false),
    Relay('wss://nostr.delo.software', true, true, false),
    Relay('wss://relay.nostr.info', true, true, false),
    Relay('wss://nostr-relay.untethr.me', true, true, false),
  ];
}

String jsonify(Object data, [bool prettyPrint = false]) {
  if (prettyPrint) {
    try {
      var encoder = JsonEncoder.withIndent('  ');
      var prettyprint = encoder.convert(data);
      return prettyprint;
    } catch (e) {
      rethrow;
    }
  }

  return jsonEncode(data);
}
