import 'dart:async';

import 'package:backend/modules/auth/session.dart';
import 'package:backend/modules/game/game_bot.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sha_red/sha_red.dart';

typedef LateCallback = FutureOr<void> Function();

abstract class ISessionChannel<S extends ToClient> {
  int get userId;
  void replaceSink(Sink sink);
  abstract final Map<BroadcastId, LateCallback> shouldUnsubscribe;
  void sinkAdd(JsonBarrel<S> encodedJson);
  void onSubscriptionCancel(BroadcastId id);
  void dispose();
}

class SessionChannel extends ISessionChannel {
  SessionChannel._(this.session, this._sink);
  factory SessionChannel.fromChannel(GameSession session, SinkChannel sink) =>
      SessionChannel._(session, sink);
  factory SessionChannel.bot(GameSession session, SinkBot sink) =>
      SessionChannel._(session, sink);

  final GameSession session;

  @override
  int get userId => session.user.userId;

  Sink _sink;
  Sink get sink => _sink;

  @override
  final shouldUnsubscribe = <BroadcastId, LateCallback>{};

  DateTime? lastActiveTime;

  void replaceSink(Sink sink) {
    _sink = sink;
  }

  @override
  void sinkAdd(JsonBarrel<ToClient> jsonBarrel) {
    _sink.sinkAdd(jsonBarrel);
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
//-------------------------------------------------------------

abstract class Sink<T extends ToClient> {
  void sinkAdd(JsonBarrel<T> barrel);
}

@immutable
class SinkChannel extends Sink<ToClient> {
  final WebSocketChannel _channel;
  WebSocketChannel get channel => _channel;
  SinkChannel(this._channel);

  @override
  void sinkAdd(JsonBarrel<ToClient> barrel) {
    _channel.sink.add(barrel.json);
  }

  @override
  bool operator ==(Object other) =>
      other is SinkChannel && other._channel == _channel;

  @override
  int get hashCode => _channel.hashCode;
}

@immutable
class SinkBot extends Sink<ToClient> {
  final GameBot _bot;
  SinkBot(this._bot);

  @override
  void sinkAdd(JsonBarrel<ToClient> barrel) {
    _bot.add(barrel.data);
  }
}
