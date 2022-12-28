import 'dart:async';

import 'package:flutter/material.dart';

import '../relay_repository.dart';

const String timeoutErrorDescription =
    'Request timed out on one or more relays';

class AutoTimeoutFetchRequest<T> {
  final RelayRepository repo;
  final Duration timeoutDuration;

  // // Async nature of the requests require a completer
  // // which will be called once all tasks are done
  // final Completer<T> completer = Completer();
  bool _isClosed = false;

  AutoTimeoutFetchRequest(
    this.repo, {
    this.timeoutDuration = const Duration(seconds: 5),
  }) {
    _startTimeout();
  }

  bool get isClosed => _isClosed;

  void onTimeout() async {}

  @mustCallSuper
  Future<void> close() async {
    _isClosed = true;
  }

  void _startTimeout() async {
    await Future.delayed(timeoutDuration);
    if (!_isClosed) onTimeout();
  }
}
