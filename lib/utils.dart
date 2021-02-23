import 'dart:math';
import 'dart:typed_data';

Uint8List randomBytes32() {
  final rand = Random.secure();
  final bytes = Uint8List(32);
  for (var i = 0; i < 32; i++) {
    bytes[i] = rand.nextInt(256);
  }
  return bytes;
}
