import '../models/relay.dart';

class RequestResult<T> {
  final T result;
  final String? id;
  final bool forced;
  final String? forceReason;
  final Map<Relay, bool> relays;
  final bool complete;

  RequestResult(
    this.result, {
    this.id,
    this.forced = false,
    this.forceReason,
    this.relays = const {},
    this.complete = false,
  });

  RequestResult<T> copyWith({
    T? result,
    bool? forced,
    String? forceReason,
    Map<Relay, bool>? relays,
  }) {
    return RequestResult(
      result ?? this.result,
      forced: forced ?? this.forced,
      forceReason: forceReason ?? this.forceReason,
      relays: relays ?? this.relays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'forced': forced,
      'forceReason': forceReason,
      'relays': relays.map((k, v) => MapEntry(k.url, v)),
    };
  }
}
