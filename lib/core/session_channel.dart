import 'dart:async';

import 'package:backend/core/bloc_id.dart';
import 'package:backend/user/session.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

typedef LateCallback = FutureOr<void> Function();

abstract class ISessionChannel {
  int get userId;
  void replaceChannel(WebSocketChannel channel);
  abstract final Map<BlocId, LateCallback> shouldUnsubscribe;
  void sinkAdd(String encodedJson);
  void onSubscriptionCancel(BlocId id);
  void dispose();
}

class SessionChannel extends ISessionChannel {
  SessionChannel(this.session, WebSocketChannel channel)
    : lastActiveTime = DateTime.now(),
      _channel = channel;

  final GameSession session;
  @override
  int get userId => session.user.userId;
  WebSocketChannel? _channel;
  WebSocketChannel? get channel => _channel;
  @override
  final shouldUnsubscribe = <BlocId, LateCallback>{};

  DateTime lastActiveTime;

  void replaceChannel(WebSocketChannel channel) {
    _channel = channel;
  }

  @override
  void sinkAdd(String encodedJson) {
    _channel?.sink.add(encodedJson);
  }

  @override
  void dispose() {
    for (final entry in shouldUnsubscribe.entries) {
      entry.value.call();
      shouldUnsubscribe.remove(entry.key);
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

  @override
  void onSubscriptionCancel(BlocId id) {
    shouldUnsubscribe.remove(id);
  }
}
