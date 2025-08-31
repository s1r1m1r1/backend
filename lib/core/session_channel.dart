import 'dart:async';

import 'package:backend/modules/auth/session.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

typedef LateCallback = FutureOr<void> Function();

abstract class ISessionChannel {
  int get userId;
  void replaceChannel(WebSocketChannel channel);
  abstract final Map<BroadcastId, LateCallback> shouldUnsubscribe;
  void sinkAdd(String encodedJson);
  void onSubscriptionCancel(BroadcastId id);
  void dispose();
}

class SessionChannel extends ISessionChannel {
  SessionChannel._(this.session, this._channel);
  factory SessionChannel.fromChannel(
    GameSession session,
    WebSocketChannel channel,
  ) => SessionChannel._(session, channel);

  // factory SessionChannel.bot(this.session) =>SessionChannel(session.null);

  final GameSession session;

  @override
  int get userId => session.user.userId;

  WebSocketChannel? _channel;
  WebSocketChannel? get channel => _channel;

  @override
  final shouldUnsubscribe = <BroadcastId, LateCallback>{};

  DateTime? lastActiveTime;

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
  void onSubscriptionCancel(BroadcastId id) {
    shouldUnsubscribe.remove(id);
  }

  Iterable<BroadcastId> getJoinedBroads() {
    final keys = shouldUnsubscribe.keys.toList();
    return keys;
  }
}
