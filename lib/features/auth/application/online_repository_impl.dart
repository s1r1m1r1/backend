import 'dart:async';
import 'package:dto/dto.dart';
import 'package:injectable/injectable.dart';

import '../domain/session.dart';
import 'session_socket.dart';

@lazySingleton
class OnlineRepository {
  OnlineRepository() {
    _cleanupTimer = Timer.periodic(
      _cleanupInterval,
      (_) => _cleanupInactiveSessions(),
    );
  }
  final _sockets = <UserId, GameSocket>{};
  Timer? _cleanupTimer;
  final Duration _cleanupInterval = const Duration(seconds: 30);
  final Duration _inactivityThreshold = const Duration(seconds: 60);

  void _cleanupInactiveSessions() {
    final now = DateTime.now();
    final toRemove = <UserId>[];

    _sockets.forEach((userId, socket) {
      if (socket.lastActiveTime != null &&
          now.difference(socket.lastActiveTime!) > _inactivityThreshold) {
        toRemove.add(userId);
      }
    });

    for (final userId in toRemove) {
      final socket = _sockets.remove(userId);
      socket?.dispose();
    }
  }

  //----------------------------------------------------------------------

  // список активных сессий
  List<GameSocket> getList() {
    return _sockets.values.toList();
  }

  GameSocket? getSessionUSERID(UserId userId) {
    return _sockets[userId];
  }

  GameSocket? getSessionSINK(UserId userId) {
    return _sockets[userId];
  }

  GameSocket startFromChannel(UserChannel channel, GameSession session) {
    channel.userId = session.user.userId;
    channel.unitId = session.unit.unitId;
    final socket = GameSocket.fromChannel(session, channel);
    socket.lastActiveTime = DateTime.now();
    _sockets[socket.userId] = socket;
    return socket;
  }

  GameSocket startFromBot(SinkBot bot, GameSession session) {
    bot.userId = session.user.userId;
    final socket = GameSocket.fromBot(session, bot);
    socket.lastActiveTime = DateTime.now();
    _sockets[socket.userId] = socket;
    return socket;
  }

  // // 1) удалить сессию
  // // вызывается при закрытии соединения
  // // важно что disposer должен оставаться в Map чтобы завершить подписки корректно

  GameSocket? removeIDsession(UserId userId) {
    return _sockets.remove(userId);
  }

  void dispose() {
    _cleanupTimer?.cancel();
  }
}
