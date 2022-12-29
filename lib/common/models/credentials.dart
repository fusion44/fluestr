import 'package:isar/isar.dart';

part 'credentials.g.dart';

@embedded
class Credentials {
  final String mnemonic;
  final String pubKey;
  final String privKey;

  Credentials({this.mnemonic = '', this.pubKey = '', this.privKey = ''});
}
