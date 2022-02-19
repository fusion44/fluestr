import 'dart:convert';

import 'package:bip340/bip340.dart' as bip340;
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:hex/hex.dart';

import '../../utils.dart';
import 'credentials.dart';
import 'tag.dart';

class Event extends Equatable {
  final int channel;
  final String relay;
  final String id;
  final String pubkey;
  final DateTime createdAtDt;
  final int kind;
  final List<Tag> tags;
  final String content;
  final String sig;
  final bool verified;
  final List<Event> _parents = [];
  final List<Event> _children = [];

  int get numParents => _parents.length;
  int get numChildren => _children.length;

  List<Event> get parents => _parents;
  List<Event> get children => _children;

  int get createdAt => DateTime.now().millisecondsSinceEpoch ~/ 1000;

  Event({
    required this.pubkey,
    required this.createdAtDt,
    required this.kind,
    this.channel = 0,
    this.relay = '',
    this.id = '',
    this.tags = const [],
    this.content = '',
    this.sig = '',
    this.verified = false,
    List<Event>? parents,
    List<Event>? children,
  }) {
    if (parents != null && parents.isNotEmpty) _parents.addAll(parents);
    if (children != null && children.isNotEmpty) _children.addAll(children);
  }

  Event.empty()
      : channel = 0,
        relay = '',
        id = '',
        pubkey = '',
        createdAtDt = DateTime.now(),
        kind = -1,
        tags = const [],
        content = '',
        sig = '',
        verified = false;

  static Future<Event> kind1(
    Credentials creds,
    String content, {
    List<EventTag> tags = const [],
    DateTime? createdAt,
  }) async {
    final e = Event(
      pubkey: creds.pubKey,
      tags: tags,
      createdAtDt: createdAt ?? DateTime.now(),
      kind: 1,
      content: content,
    );
    return await e.signWith(creds.privKey);
  }

  /// Event to publish a the a contact list to relays
  /// https://github.com/fiatjaf/nostr/blob/master/nips/02.md
  Event.kind3(String pubKey, List<ProfileTag> tags)
      : pubkey = pubKey,
        tags = tags,
        createdAtDt = DateTime.now(),
        id = '',
        kind = 3,
        content = '',
        channel = 0,
        relay = '',
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
        ...parents,
        ...children,
      ];

  static Event fromJson(
    Map<String, dynamic> json, {
    String relay = '',
    int channel = 0,
  }) {
    final tags = <Tag>[];
    if (json['tags'] != null && json['tags'].isNotEmpty) {
      json['tags'].forEach((v) {
        tags.add(Tag.fromJson(v));
      });
    }

    return Event(
        channel: channel,
        relay: relay,
        id: json['id'],
        pubkey: json['pubkey'],
        createdAtDt:
            DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000),
        kind: json['kind'],
        tags: tags,
        content: json['content'],
        sig: json['sig']);
  }

  bool hasChild(Event a) {
    for (var b in _children) {
      if (a.id == b.id) return true;
    }

    return false;
  }

  bool hasParent(Event a) {
    for (var b in _children) {
      if (a.id == b.id) return true;
    }
    return false;
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
    Event? parent,
    Event? child,
  }) {
    return Event(
      channel: channel ?? this.channel,
      relay: relay ?? this.relay,
      id: id ?? this.id,
      pubkey: pubkey ?? this.pubkey,
      createdAtDt: createdAt != null
          ? DateTime.fromMillisecondsSinceEpoch(createdAt * 1000)
          : createdAtDt,
      kind: kind ?? this.kind,
      tags: tags ?? this.tags,
      content: content ?? this.content,
      sig: sig ?? this.sig,
      verified: verified ?? this.verified,
      parents: parent != null ? [...parents, parent] : [...parents],
      children: child != null ? [...children, child] : [...children],
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
    return copyWith(id: eventHash, sig: sig, verified: await verify());
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

  String _hashHEX() {
    final bytes = utf8.encode(_serialize());
    final eventHash = sha256.convert(bytes);
    final h = HEX.encode(eventHash.bytes);
    return h;
  }
}
