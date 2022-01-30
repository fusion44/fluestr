import 'dart:convert';

import 'package:bip340/bip340.dart' as bip340;
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:hex/hex.dart';

import '../../utils.dart';
import 'tag.dart';

class Event extends Equatable {
  final int channel;
  final String relay;
  final String id;
  final String pubkey;
  final int createdAt;
  final DateTime createdAtDt;
  final int kind;
  final List<Tag> tags;
  final String content;
  final String sig;
  final bool verified;

  Event({
    required this.channel,
    required this.relay,
    required this.id,
    required this.pubkey,
    required this.createdAt,
    required this.createdAtDt,
    required this.kind,
    required this.tags,
    required this.content,
    required this.sig,
    this.verified = false,
  });

  Event.empty()
      : channel = 0,
        relay = '',
        id = '',
        pubkey = '',
        createdAt = DateTime.now().millisecond,
        createdAtDt = DateTime.now(),
        kind = -1,
        tags = const [],
        content = '',
        sig = '',
        verified = false;

  @override
  List<Object> get props => [
        channel,
        id,
        relay,
        pubkey,
        createdAt,
        kind,
        ...tags,
        content,
        sig,
      ];

  static Event fromJson(
    Map<String, dynamic> json, {
    String relay = '',
    int channel = 0,
  }) {
    final tags = <Tag>[];
    if (json['tags'] != null) {
      json['tags'].forEach((v) {
        tags.add(Tag.fromJson(v));
      });
    }

    return Event(
      channel: channel,
      relay: relay,
      id: json['id'],
      pubkey: json['pubkey'],
      createdAt: json['created_at'],
      createdAtDt:
          DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000),
      kind: json['kind'],
      tags: tags,
      content: json['content'],
      sig: json['sig'],
    );
  }

  Event copyWith({
    int? channel,
    String? relay,
    String? id,
    String? pubkey,
    int? createdAt,
    int? kind,
    List<Tag>? tags,
    String? content,
    String? sig,
    bool? verified,
  }) {
    return Event(
      channel: channel ?? this.channel,
      relay: relay ?? this.relay,
      id: id ?? this.id,
      pubkey: pubkey ?? this.pubkey,
      createdAt: createdAt ?? this.createdAt,
      createdAtDt: createdAt != null
          ? DateTime.fromMillisecondsSinceEpoch(createdAt * 1000)
          : createdAtDt,
      kind: kind ?? this.kind,
      tags: tags ?? this.tags,
      content: content ?? this.content,
      sig: sig ?? this.sig,
      verified: verified ?? this.verified,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['pubkey'] = pubkey;
    data['created_at'] = createdAt;
    data['kind'] = kind;
    data['tags'] = tags.map((v) => v.toJson()).toList();
    data['content'] = content;
    data['sig'] = sig;
    return data;
  }

  String toJsonString() {
    return json.encode(toMap());
  }

  Future<Event> signWith(String key) async {
    final eventHash = await _hashHEX();
    final sig = bip340.sign(key, eventHash, HEX.encode(randomBytes32()));
    // final sig = bip340.sign(key, eventHash, HEX.encode(_notSoRandomByteList()));
    return copyWith(id: eventHash, sig: sig);
  }

  Future<bool> verify() async {
    final eventHash = await _hashHEX();
    return bip340.verify(pubkey, eventHash, sig);
  }

  String _serialize() {
    final s = json.encode([
      0,
      pubkey,
      createdAt,
      kind,
      tags,
      content,
    ]); //.replaceAll(RegExp(r'\s+'), '');
    return s;
  }

  Future<String> _hashHEX() async {
    final bytes = utf8.encode(_serialize());
    final eventHash = sha256.convert(bytes);
    final h = HEX.encode(eventHash.bytes);
    return h;
  }
}
