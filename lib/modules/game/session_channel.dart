import 'dart:async';

import 'package:backend/modules/auth/session.dart';
import 'package:backend/modules/game/domain/ws_bot_repository.dart';
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
  Future<void> dispose();
}

class SessionChannel extends ISessionChannel {
  SessionChannel(this.session, this._sink);

  final GameSession session;

  @override
  int get userId => session.user.userId;

  Sink _sink;
  Sink get sink => _sink;

  @override
  final shouldUnsubscribe = <BroadcastId, LateCallback>{};

  DateTime? lastActiveTime;

  void replaceSink(Sink sink) {
    // передать userId в sink
    sink.userId = userId;
    // сбросить ботов , и userId
    _sink.dispose();
    // заменить sink
    _sink = sink;
  }

  @override
  void sinkAdd(JsonBarrel<ToClient> jsonBarrel) {
    _sink.sinkAdd(jsonBarrel);
  }

  @override
  Future<void> dispose() async {
    final copy = Map.of(shouldUnsubscribe);
    await Future.forEach(copy.entries, (entry) async {
      await entry.value.call();
      shouldUnsubscribe.remove(entry.key);
    });

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
  abstract int userId;
  void sinkAdd(JsonBarrel<T> barrel);
  void dispose();
}

class SinkChannel extends Sink<ToClient> {
  final WebSocketChannel _channel;
  int userId;
  WebSocketChannel get channel => _channel;
  SinkChannel(this._channel, this.userId);

  @override
  void sinkAdd(JsonBarrel<ToClient> barrel) {
    _channel.sink.add(barrel.json);
  }

  @override
  bool operator ==(Object other) =>
      other is SinkChannel && other._channel == _channel;

  @override
  int get hashCode => _channel.hashCode;

  @override
  void dispose() {
    userId = -1;
  }
}

class SinkBot extends Sink<ToClient> {
  final Bot<ToClient, ToServer> _bot;
  final BotRepository _botRepository;
  SinkBot(this._botRepository, this._bot, this.userId) {
    _bot.botCallback = (ToServer toServer) =>
        _botRepository.add(this, toServer);
  }

  int userId;

  @override
  void sinkAdd(JsonBarrel<ToClient> barrel) {
    _bot.add(barrel.data);
  }

  @override
  void dispose() {
    userId = -1;
    _bot.dispose();
  }
}
