import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

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
