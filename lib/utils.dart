import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:isar/isar.dart';

import 'common/models/preferences.dart';
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
    Relay(url: 'wss://nostr-relay.wlvs.space'),
    Relay(url: 'wss://nostr.bitcoiner.social'),
    Relay(url: 'wss://nostr-pub.semisol.dev'),
    Relay(url: 'wss://nostr.drss.io'),
    Relay(url: 'wss://relay.damus.io'),
    Relay(url: 'wss://nostr.openchain.fr'),
    Relay(url: 'wss://nostr.delo.software'),
    Relay(url: 'wss://relay.nostr.info'),
    Relay(url: 'wss://nostr-relay.untethr.me'),
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

// https://isar.dev/recipes/string_ids.html
Id fastHash(String pubkey) {
  var hash = 0xcbf29ce484222325;

  var i = 0;
  while (i < pubkey.length) {
    final codeUnit = pubkey.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }

  return hash;
}

Isar getIsar() {
  final isar = Isar.getInstance();
  if (isar == null) throw StateError('Isar instance not initialized');
  return isar;
}

Future<Preferences> getPreferences() async {
  final i = getIsar();
  var prefs = await i.preferences.where().findFirst();

  if (prefs == null) {
    prefs = Preferences.empty();
    await i.writeTxn(() async => await i.preferences.put(prefs!));
  }

  return prefs;
}

Future<Preferences> setPreferences(Preferences prefs) async {
  final i = getIsar();
  await i.writeTxn(() async => await i.preferences.put(prefs));
  return prefs;
}

Preferences setPreferencesSync(Preferences prefs) {
  final i = getIsar();
  i.writeTxnSync(() => i.preferences.putSync(prefs));
  return prefs;
}
