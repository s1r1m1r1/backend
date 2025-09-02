import 'dart:async';

import 'package:backend/modules/game/session_channel.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:backend/modules/auth/session.dart';
import 'package:injectable/injectable.dart';
import 'package:synchronized/synchronized.dart';

@module
abstract class ActiveSessionsModule {
  @lazySingleton
  ActiveUsersRepository activeUsersRepository() => ActiveUsersRepository();
}

class ActiveUsersRepository {
  //  userId
  final Map channel_idKV = <Sink, int>{};
  final id_sessionChannelKV = <int, SessionChannel>{};
  // final userid_tokenKV = <int, String>{};

  // final shouldUnsubscribeKV = <WebSocketChannel, WebSocketDisposer>{};

  final _lock = Lock();
  FutureOr<List<GameSession>> getListGameSessions() {
    return _lock.synchronizedSync(_getListGameSessions);
  }

  FutureOr<int?> getUserId(Sink sink) {
    return _lock.synchronizedSync(() => _getUserId(sink));
  }

  FutureOr<SessionChannel?> getSessionChannel(int userId) {
    return _lock.synchronizedSync(() => _getSessionChannel(userId));
  }

  FutureOr<SessionChannel?> sessionFromWSChannel(Sink sink) {
    return _lock.synchronizedSync(() => _sessionFromWSChannel(sink));
  }

  FutureOr<void> startFromChannel(SinkChannel channel, GameSession session) {
    return _lock.synchronizedSync(() => _startFromChannel(channel, session));
  }

  // 1) удалить сессию
  // вызывается при закрытии соединения
  // важно что disposer должен оставаться в Map чтобы завершить подписки корректно
  Future<int?> removeChannelID(Sink sink) {
    return _lock.synchronized(() => _removeChannelID(sink));
  }

  FutureOr<SessionChannel?> removeIDsession(int userId) {
    return _lock.synchronizedSync(() => _removeIDsession(userId));
  }

  //----------------------------------------------------------------------

  // список активных сессий
  List<GameSession> _getListGameSessions() {
    return id_sessionChannelKV.values.map((i) => i.session).toList();
  }

  int? _getUserId(Sink channel) {
    final userId = channel_idKV[channel];
    return userId;
  }

  SessionChannel? _getSessionChannel(int userId) {
    return id_sessionChannelKV[userId];
  }

  SessionChannel? _sessionFromWSChannel(Sink sink) {
    final userId = _getUserId(sink);
    if (userId == null) return null;
    return id_sessionChannelKV[userId];
  }

  void _startFromChannel(SinkChannel channel, GameSession session) {
    final sessionChannel = SessionChannel.fromChannel(session, channel);
    id_sessionChannelKV[session.user.userId] = sessionChannel;
    channel_idKV[channel] = sessionChannel.userId;
  }

  // // 1) удалить сессию
  // // вызывается при закрытии соединения
  // // важно что disposer должен оставаться в Map чтобы завершить подписки корректно
  int? _removeChannelID(Sink sink) {
    return channel_idKV.remove(sink);
  }

  SessionChannel? _removeIDsession(int userId) {
    return id_sessionChannelKV.remove(userId);
  }
}
