import 'package:equatable/equatable.dart';
import 'package:fluestr/utils.dart';
import 'package:isar/isar.dart';

part 'relay.g.dart';

@Collection(ignore: {'props'})
class Relay extends Equatable {
  late final Id? id = fastHash(url);
  final String url;
  final bool read;
  final bool write;
  final bool active;

  Relay({
    required this.url,
    this.read = false,
    this.write = false,
    this.active = false,
  });

  @override
  List<Object> get props => [url, read, write, active];

  Relay copyWith({
    String? url,
    bool? read,
    bool? write,
    bool? active,
  }) {
    return Relay(
      url: url ?? this.url,
      read: read ?? this.read,
      write: write ?? this.write,
      active: active ?? this.active,
    );
  }

  static Relay fromJson(String url, Map<String, bool> json) {
    if (!json.containsKey('read') || !json.containsKey('write')) {
      throw StateError('A relay JSON must have the read and write property');
    }
    return Relay(
      url: url,
      read: json['read']!,
      write: json['write']!,
      active: json['active'] ?? false,
    );
  }

  static List<Relay> fromJsonList(Map<String, dynamic> json) {
    return [for (final k in json.keys) Relay.fromJson(k, json[k])];
  }
}
