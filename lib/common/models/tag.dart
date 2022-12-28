enum TagType { event, profile, unknown }

String _tagTypeAbbrev(TagType tt) {
  switch (tt) {
    case TagType.event:
      return 'e';
    case TagType.profile:
      return 'p';
    default:
      return '';
  }
}

abstract class Tag {
  final TagType type;

  Tag(this.type);

  factory Tag.fromJson(List<dynamic> json) {
    if (json.isNotEmpty) {
      if (json[0] == 'e') {
        return EventTag.fromJson(json);
      } else if (json[0] == 'p') {
        return ProfileTag.fromJson(json);
      } else {
        return UnknownTag();
      }
    } else {
      throw StateError('Invalid JSON: $json');
    }
  }

  List<dynamic> toJson() => [_tagTypeAbbrev(type)];
}

class EventTag extends Tag {
  final String eventId;
  final String recommendedRelayUrl;

  EventTag({
    required this.eventId,
    this.recommendedRelayUrl = '',
  }) : super(TagType.event);

  EventTag.fromJson(List<dynamic> v)
      : eventId = v[1],
        recommendedRelayUrl = v.length > 2 ? v[2] : '',
        super(TagType.event);

  @override
  List<dynamic> toJson() =>
      [_tagTypeAbbrev(type), eventId, recommendedRelayUrl];

  @override
  String toString() =>
      'EventTag{eventId: $eventId, recommendedRelayUrl: $recommendedRelayUrl}';
}

class ProfileTag extends Tag {
  final String profileId;
  final String recommendedRelayUrl;
  final String petName;

  ProfileTag({
    required this.profileId,
    this.recommendedRelayUrl = '',
    this.petName = '',
  }) : super(TagType.profile);

  ProfileTag.fromJson(List v)
      : profileId = v[1],
        recommendedRelayUrl = v.length > 2 ? v[2] : '',
        petName = v.length > 3 ? v[3] : '',
        super(TagType.profile);

  @override
  List<dynamic> toJson() =>
      [_tagTypeAbbrev(type), profileId, recommendedRelayUrl, petName];
}

class UnknownTag extends Tag {
  UnknownTag() : super(TagType.unknown);
}
