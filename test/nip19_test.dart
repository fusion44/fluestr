import 'package:fluestr/common/models/nip19.dart';
import 'package:flutter_test/flutter_test.dart';

final pubKeyHex =
    '4d6a9aeb5279a45ae3b972f1c7c08acb82e10b30a397d738c5cf84251df92902';
final pubKeyBech32 =
    'npub1f44f466j0xj94caewtcu0sy2ewpwzzes5wtawwx9e7zz280e9ypqxh24q6';

void main() {
  group('NIP19 Keys', () {
    test('hex to bech32', () {
      final set = Nip19KeySet(pubKeyHex);
      expect(set.pubKeyBech32, equals(pubKeyBech32));
    });

    test('Convert bech32 to hex', () {
      final set = Nip19KeySet(pubKeyBech32);
      expect(set.pubKeyHex, equals(pubKeyHex));
    });
  });
}
