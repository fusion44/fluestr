import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import '../../utils.dart';
import 'profile.dart';

part 'contact.g.dart';

@Collection(ignore: {'props'})
class Contact extends Equatable {
  late final Id id = fastHash(pubkey);
  final String pubkey;
  final Profile profile;
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
        profile = Profile(),
        following = false;

  Map<String, dynamic> toJson() {
    return {
      'pubkey': pubkey,
      'profile': profile.toJson(),
      'following': following,
    };
  }
}
