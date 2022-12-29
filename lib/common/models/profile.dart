import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'profile.g.dart';

@Embedded(ignore: {'props'})
class Profile extends Equatable {
  final String name;
  final String picture;
  final String about;
  final String nip05;

  Profile({
    this.name = '',
    this.picture = '',
    this.about = '',
    this.nip05 = '',
  });

  @override
  List<Object> get props => [name, picture, about, nip05];

  Profile.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        picture = json['picture'] ?? '',
        about = json['about'] ?? '',
        nip05 = json['nip05'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'picture': picture,
      'about': about,
      'nip05': nip05,
    };
  }
}
