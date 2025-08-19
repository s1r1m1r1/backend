import 'dart:async';

typedef LateCallback = FutureOr<void> Function();

class WebSocketDisposer {
  WebSocketDisposer();

  final shouldUnsubscribe = <LateCallback>[];

  void dispose() {
    for (final callback in shouldUnsubscribe) {
      callback.call();
    }
  }
}
