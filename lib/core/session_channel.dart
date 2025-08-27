import 'dart:async';

import 'package:backend/user/session.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

typedef LateCallback = FutureOr<void> Function();

class SessionChannel {
  SessionChannel(this.session, WebSocketChannel channel)
    : lastActiveTime = DateTime.now(),
      _channel = channel;

  final GameSession session;
  int get userId => session.user.userId;
  WebSocketChannel? _channel;
  WebSocketChannel? get channel => _channel;
  final shouldUnsubscribe = <LateCallback>[];

  DateTime lastActiveTime;

  void replaceChannel(WebSocketChannel channel) {
    _channel = channel;
  }

  void sinkAdd(ToClient toClient) {
    _channel?.sink.add(toClient.encoded());
  }

  void dispose() {
    for (final callback in shouldUnsubscribe) {
      callback.call();
    }
    shouldUnsubscribe.clear();
  }

  @override
  int get hashCode => userId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionChannel &&
          runtimeType == other.runtimeType &&
          userId == other.userId;
}
