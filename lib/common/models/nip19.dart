import 'dart:convert';
import 'dart:typed_data' as typed;

import 'package:fluestr/common/models/bech32.dart';
import 'package:hex/hex.dart';

class Nip19KeySet {
  final String relay;
  late final String pubKeyHex;
  late final String pubKeyBech32;

  Nip19KeySet(String pubKey, {this.relay = ''}) {
    if (pubKey.startsWith('npub1')) {
      pubKeyBech32 = pubKey;
      pubKeyHex = _decodePublicKey(pubKey);

      return;
    }

    pubKeyHex = pubKey;
    pubKeyBech32 = _encodePublicKey(pubKey, relay);
  }

  String _decodePublicKey(String pubKey) {
    final res = Bech32().decode(pubKey);
    if (res.words.length < 32) {
      throw FormatException(
        'failed to decode public key bech32. Data is less than 32 bytes',
      );
    }

    final bits8 = _convertBits(res.words, 5, 8, false);

    return HEX.encode(bits8);
  }

  @override
  String toString() =>
      'Nip19{pubKeyHex: $pubKeyHex, pubKeyBech32: $pubKeyBech32}';

  String _encodePublicKey(String publicKeyHex, String relay) {
    var b = HEX.decode(publicKeyHex);
    if (b.isEmpty) {
      throw FormatException('failed to decode public key hex');
    }

    var tlv;
    if (relay.isNotEmpty) {
      tlv = typed.Uint8List(64);
      var relayBytes = utf8.encode(relay);
      var length = relayBytes.length;
      if (length >= 65536) {
        throw FormatException('Relay URL is too large');
      }

      var offset = 0;
      tlv[offset] = 1;
      offset += 2;
      tlv[offset] = length;
      offset += 2;
      tlv.setRange(offset, offset + length, relayBytes);
    }

    if (tlv != null) b = [...b, ...tlv];

    var bits5 = _convertBits(b, 8, 5, true);

    final b32 = Bech32();

    return b32.encode('npub', bits5);
  }

  typed.Uint8List _convertBits(
      List<int> data, int fromBits, int toBits, bool pad) {
    if (fromBits < 1 || fromBits > 8 || toBits < 1 || toBits > 8) {
      throw FormatException('only bit groups between 1 and 8 allowed');
    }

    // The final bytes, each byte encoding toBits bits.
    var regrouped = <int>[];

    // Keep track of the next byte we create and how many bits we have
    // added to it out of the toBits goal.
    var nextByte = 0;
    var filledBits = 0;

    for (var b in data) {
      // Discard unused bits.
      b = b << (8 - fromBits);

      // How many bits remaining to extract from the input data.
      var remFromBits = fromBits;
      while (remFromBits > 0) {
        // How many bits remaining to be added to the next byte.
        var remToBits = toBits - filledBits;

        // The number of bytes to next extract is the minimum of
        // remFromBits and remToBits.
        var toExtract = remFromBits;
        if (remToBits < toExtract) {
          toExtract = remToBits;
        }

        // Add the next bits to nextByte, shifting the already
        // added bits to the left.
        nextByte = (nextByte << toExtract) | (b >> (8 - toExtract));

        // Discard the bits we just extracted and get ready for
        // next iteration and mask to a valid byte value.
        b = (b << toExtract) & 0xff;
        remFromBits -= toExtract;
        filledBits += toExtract;

        // If the nextByte is completely filled, we add it to
        // our regrouped bytes and start on the next byte.
        if (filledBits == toBits) {
          regrouped.add(nextByte);
          filledBits = 0;
          nextByte = 0;
        }
      }
    }

    // We pad any unfinished group if specified.
    if (pad && filledBits > 0) {
      nextByte = nextByte << (toBits - filledBits);
      regrouped.add(nextByte);
      filledBits = 0;
      nextByte = 0;
    }

    // Any incomplete group must be <= 4 bits, and all zeroes.
    if (filledBits > 0 && (filledBits > 4 || nextByte != 0)) {
      throw FormatException('invalid incomplete group');
    }

    return typed.Uint8List.fromList(regrouped);
  }
}
