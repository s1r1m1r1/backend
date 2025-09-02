import 'dart:async';

import 'package:backend/modules/game/session_channel.dart';
import 'package:backend/modules/auth/session.dart';
import 'package:injectable/injectable.dart';
import 'package:synchronized/synchronized.dart';

@module
abstract class ActiveSessionsModule {
  @lazySingleton
  ActiveUsersRepository activeUsersRepository() => ActiveUsersRepository();
}

class ActiveUsersRepository {
  final id_sessionChannelKV = <int, SessionChannel>{};
  // final userid_tokenKV = <int, String>{};

  // final shouldUnsubscribeKV = <WebSocketChannel, WebSocketDisposer>{};

  final _lock = Lock();
  FutureOr<List<SessionChannel>> getListGameSessions() {
    return _lock.synchronizedSync(_getList);
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

  FutureOr<SessionChannel?> removeIDsession(int userId) {
    return _lock.synchronizedSync(() => _removeIDsession(userId));
  }

  //----------------------------------------------------------------------

  // список активных сессий
  List<SessionChannel> _getList() {
    return id_sessionChannelKV.values.toList();
  }

  SessionChannel? _getSessionChannel(int userId) {
    return id_sessionChannelKV[userId];
  }

  SessionChannel? _sessionFromWSChannel(Sink sink) {
    final userId = sink.userId;
    if (userId == -1) return null;
    return id_sessionChannelKV[userId];
  }

  void _startFromChannel(SinkChannel channel, GameSession session) {
    channel.userId = session.user.userId;
    final sessionChannel = SessionChannel(session, channel);
    id_sessionChannelKV[session.user.userId] = sessionChannel;
  }

  // // 1) удалить сессию
  // // вызывается при закрытии соединения
  // // важно что disposer должен оставаться в Map чтобы завершить подписки корректно

  SessionChannel? _removeIDsession(int userId) {
    return id_sessionChannelKV.remove(userId);
  }
}
