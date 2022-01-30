import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'profile.g.dart';

@HiveType(typeId: 3)
class Profile extends Equatable {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String picture;

  @HiveField(2)
  final String about;

  @HiveField(3)
  final String nip05;

  Profile(this.name, this.picture, this.about, [this.nip05 = '']);

  @override
  List<Object> get props => [name, picture, about, nip05];

  Profile.empty([String pubkey = ''])
      : name = '',
        picture = '',
        about = '',
        nip05 = '';

  Profile.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        picture = json['picture'] ?? '',
        about = json['about'] ?? '',
        nip05 = json['nip05'] ?? '';
}
