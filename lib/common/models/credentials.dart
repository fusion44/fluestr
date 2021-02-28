import 'package:hive/hive.dart';

part 'credentials.g.dart';

@HiveType(typeId: 1)
class Credentials {
  @HiveField(0)
  final String mnemonic;

  @HiveField(1)
  final String pubKey;

  @HiveField(2)
  final String privKey;

  Credentials(this.mnemonic, this.pubKey, this.privKey);
}
