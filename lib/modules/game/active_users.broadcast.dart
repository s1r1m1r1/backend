import 'dart:async';

import 'package:backend/core/broadcast.dart';
import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/core/session_channel.dart';
import 'package:backend/game/unit.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/modules/auth/session.dart';
import 'package:backend/modules/auth/session_repository.dart';
import 'package:backend/modules/game/domain/active_sessions_repository.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';
import 'package:synchronized/synchronized.dart';

const _timeoutDuration = Duration(milliseconds: 250);

@module
abstract class ActiveUsersBroadcastModule {
  @prod
  @lazySingleton
  ActiveUsersBroad prodBroadcast(
    ActiveUsersRepository activeUsersRepository,
    UnitRepository unitRepository,
    SessionRepository sessionRepository,
  ) => ActiveUsersBroad(
    activeUsersRepository,
    unitRepository,
    sessionRepository,
    1,
  );

  @test
  @dev
  @lazySingleton
  ActiveUsersBroad devBroadcast(
    ActiveUsersRepository activeUsersRepository,
    UnitRepository unitRepository,
    SessionRepository sessionRepository,
  ) => ActiveUsersBroad(
    activeUsersRepository,
    unitRepository,
    sessionRepository,
    2,
  );
}

class ActiveUsersBroad extends Broadcast<ToClient> {
  final UnitRepository _unitRepository;
  final SessionRepository _sessionRepository;
  final ActiveUsersRepository _activeUsersRepository;
  final _lock = Lock();

  @override
  late BroadcastId blocId;

  ActiveUsersBroad(
    this._activeUsersRepository,
    this._unitRepository,
    this._sessionRepository,
    int id,
  ) : blocId = BroadcastId(family: BroadcastFamily.activeUsers, id: id);

  FutureOr<void> join(WebSocketChannel channel, String token) async {
    _lock.synchronized(() async {
      await _join(channel, token).timeout(
        _timeoutDuration,
        onTimeout: () {
          addError('timeout', StackTrace.current);
          channel.sink.add(ToClient.statusError(error: WsServerError.timeout));
        },
      );
    });
  }

  Future<void> _join(WebSocketChannel channel, String token) async {
    try {
      final session = await _sessionRepository.getSession(token: token);
      debugLog('$green ActiveUsersBloc$reset result session: $session');
      if (session == null) {
        channel.sink.add(
          ToClient.authError(error: WsAuthError.tokenSessionNotFound).encoded(),
        );
        return;
      }

      debugLog('$green ActiveUsersBloc$reset 2');
      final isValid = _sessionRepository.validateToken(session);
      if (!isValid) {
        channel.sink.add(
          ToClient.authError(error: WsAuthError.expiredToken).encoded(),
        );
        return;
      }
      debugLog('$green ActiveUsersBloc$reset 3');
      final SessionChannel? sessionChannel = _activeUsersRepository
          .getSessionChannel(session.user.userId);
      debugLog('$green ActiveUsersBloc$reset 4');
      if (sessionChannel != null && sessionChannel.channel != channel) {
        final previousChannel = sessionChannel.channel;
        // заменить канал в сессии на новый , это позволит передать подписки
        // на новый канал
        sessionChannel.replaceChannel(channel);
        // сообщить что сессия была прервана другой сессией
        previousChannel?.sink.add(
          ToClient.authError(
            error: WsAuthError.stoppedByAnotherSession,
          ).encoded(),
        );
        // сообщить что сессия прервала другую сессию
        channel.sink.add(
          ToClient.authError(error: WsAuthError.continueAsNewSession).encoded(),
        );
        debugLog('$green ActiveUsersBloc$reset 5');
      }

      debugLog('$green ActiveUsersBloc$reset 6');
      final unit = await _unitRepository.getSelectedUnit(session.user.userId);
      if (unit == null) {
        channel.sink.add(
          ToClient.statusError(error: WsServerError.unitNotFound).encoded(),
        );
        return;
      }
      debugLog('$green ActiveUsersBloc$reset 7');
      final gameSession = GameSession.fromSession(session, Unit.fromDto(unit));
      _activeUsersRepository.addSession(channel, gameSession);
      final newSessionChannel = _activeUsersRepository.getSessionChannel(
        gameSession.user.userId,
      );
      if (newSessionChannel == null) return;
      subscribe(newSessionChannel);
      newSessionChannel.shouldUnsubscribe[blocId] = () =>
          unsubscribe(newSessionChannel);
      debugLog('$green ActiveUsersBloc$reset 8');
      newSessionChannel.sinkAdd(gameSession.sessionDTO(blocId.id).encoded());
      newSessionChannel.sinkAdd(
        ToClient.broadcastInfo(
          newSessionChannel.getJoinedBroads().toList(),
        ).encoded(),
      );

      _onlineBroadcast();

      debugLog('$green ActiveUsersBloc$reset 9');
    } on Object catch (e, s) {
      addError(e, s);
      channel.sink.add(
        ToClient.statusError(error: WsServerError.authenticationFailed),
      );
    }
  }

  void infoJoinedBroads(WebSocketChannel channel) {
    _lock.synchronized(() async {
      try {
        debugLog('$green ActiveUsersBloc$reset infoJoinedBroads');
        final userId = _activeUsersRepository.getUserId(channel);
        if (userId == null) return;

        debugLog('$green ActiveUsersBloc$reset infoJoinedBroads 2');
        final sessionChannel = _activeUsersRepository.getSessionChannel(userId);
        final boards = sessionChannel?.getJoinedBroads().toList();
        channel.sink.add(ToClient.broadcastInfo(boards ?? []).encoded());
      } catch (e, s) {
        addError(e, s);
      }
    });
  }

  void removeUser(WebSocketChannel channel) {
    _lock.synchronized(() async {
      try {
        final userId = _activeUsersRepository.getUserId(channel);
        if (userId == null) return;
        final sessionChannel = _activeUsersRepository.getSessionChannel(userId);
        sessionChannel?.dispose();
        _activeUsersRepository.removeChannelID(channel);
        _activeUsersRepository.removeIDsession(userId);
        channel.sink.add(ToClient.terminatedAllBroadcast().encoded());
        _onlineBroadcast();
      } catch (e, s) {
        addError(e, s);
      }
    });
  }

  void _onlineBroadcast() {
    broadcast(
      ToClient.onlineUsers(
        OnlineMemberPayload(
          roomId: blocId.id,
          members: _activeUsersRepository
              .getListGameSessions()
              .map((i) => OnlineMemberDto(i.unit.id, i.unit.name))
              .toList(),
        ),
      ),
    );
  }
}
