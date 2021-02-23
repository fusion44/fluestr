import 'dart:convert';

import 'package:bip340/bip340.dart' as bip340;
import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';

import '../../utils.dart';
import 'tag.dart';

class Event {
  final String relay;
  final String id;
  final String pubkey;
  final int createdAt;
  final int kind;
  final List<Tag> tags;
  final String content;
  final String sig;

  Event({
    this.relay,
    this.id,
    this.pubkey,
    this.createdAt,
    this.kind,
    this.tags,
    this.content,
    this.sig,
  });

  static Event fromJson(Map<String, dynamic> json, [String relay = '']) {
    final tags = <Tag>[];
    if (json['tags'] != null) {
      json['tags'].forEach((v) {
        tags.add(Tag.fromJson(v));
      });
    }

    return Event(
      relay: relay,
      id: json['id'],
      pubkey: json['pubkey'],
      createdAt: json['created_at'],
      kind: json['kind'],
      tags: tags,
      content: json['content'],
      sig: json['sig'],
    );
  }

  Event copyWith({
    String relay,
    String id,
    String pubkey,
    int createdAt,
    int kind,
    List<Tag> tags,
    String content,
    String sig,
  }) {
    return Event(
      relay: relay ?? this.relay,
      id: id ?? this.id,
      pubkey: pubkey ?? this.pubkey,
      createdAt: createdAt ?? this.createdAt,
      kind: kind ?? this.kind,
      tags: tags ?? this.tags,
      content: content ?? this.content,
      sig: sig ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['pubkey'] = pubkey;
    data['created_at'] = createdAt;
    data['kind'] = kind;
    if (tags != null) {
      data['tags'] = tags.map((v) => v.toJson()).toList();
    }
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
      tags ?? [],
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
