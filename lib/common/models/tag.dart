class Tag {
  final String type;
  final String eventId;
  final String? content;

  Tag(this.type, this.eventId, this.content);

  static Tag fromJson(v) => Tag(v[0], v[1], v.length > 2 ? v[2] : '');

  Map<String, String> toJson() => {
        'type': type,
        'event_id': eventId,
        'content': content ?? '',
      };
}
