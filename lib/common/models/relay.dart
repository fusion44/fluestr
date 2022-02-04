import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'relay.g.dart';

@HiveType(typeId: 2)
class Relay extends Equatable {
  @HiveField(0)
  final String url;

  @HiveField(1)
  final bool read;

  @HiveField(2)
  final bool write;

  @HiveField(3)
  final bool active;

  Relay(this.url, this.read, this.write, [this.active = false]);

  Relay copyWith({
    String? url,
    bool? read,
    bool? write,
    bool? active,
  }) {
    return Relay(
      url ?? this.url,
      read ?? this.read,
      write ?? this.write,
      active ?? this.active,
    );
  }

  static Relay fromJson(String url, Map<String, bool> json) {
    if (!json.containsKey('read') || !json.containsKey('write')) {
      throw StateError('A relay JSON must have the read and write property');
    }
    return Relay(url, json['read']!, json['write']!, json['active'] ?? false);
  }

  static List<Relay> fromJsonList(Map<String, dynamic> json) {
    return [for (final k in json.keys) Relay.fromJson(k, json[k])];
  }

  @override
  List<Object?> get props => [url, read, write, active];
}
