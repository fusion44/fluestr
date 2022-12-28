import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'profile.dart';

part 'contact.g.dart';

@HiveType(typeId: 4)
class Contact extends Equatable {
  @HiveField(0)
  final String pubkey;

  @HiveField(1)
  final Profile profile;

  @HiveField(2)
  final bool following;

  Contact({
    required this.pubkey,
    required this.profile,
    this.following = false,
  });

  @override
  List<Object> get props => [pubkey, ...profile.props, following];

  Contact copyWith({Profile? profile, bool? following}) {
    return Contact(
      pubkey: pubkey,
      profile: profile ?? this.profile,
      following: following ?? this.following,
    );
  }

  Contact.empty([String pubkey = ''])
      : pubkey = pubkey,
        profile = Profile.empty(),
        following = false;

  Map<String, dynamic> toJson() {
    return {
      'pubkey': pubkey,
      'profile': profile.toJson(),
      'following': following,
    };
  }
}
