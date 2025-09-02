import 'dart:async';

import 'package:backend/core/broadcast.dart';
import 'package:backend/core/debug_log.dart';
import 'package:backend/core/inject.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/modules/game/domain/ws_bot_repository.dart';
import 'package:backend/modules/game/game_bot.dart';
import 'package:backend/modules/game/session_channel.dart';
import 'package:backend/game/unit.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/modules/auth/session.dart';
import 'package:backend/modules/auth/session_repository.dart';
import 'package:backend/modules/game/domain/active_sessions_repository.dart';
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

  FutureOr<void> join(SinkChannel channel, String token) async {
    _lock.synchronized(() async {
      await _join(channel, token).timeout(
        _timeoutDuration,
        onTimeout: () {
          addError('timeout', StackTrace.current);
          channel.sinkAdd(
            ToClient.statusError(error: WsServerError.timeout).jsonBarrel(),
          );
        },
      );
    });
  }

  Future<void> _join(SinkChannel channel, String token) async {
    try {
      final session = await _sessionRepository.getSession(token: token);
      if (session == null) {
        channel.sinkAdd(
          ToClient.authError(
            error: WsAuthError.tokenSessionNotFound,
          ).jsonBarrel(),
        );
        return;
      }

      final isValid = _sessionRepository.validateToken(session);
      if (!isValid) {
        channel.sinkAdd(
          ToClient.authError(error: WsAuthError.expiredToken).jsonBarrel(),
        );
        return;
      }
      final SessionChannel? sessionChannel = await _activeUsersRepository
          .getSessionChannel(session.user.userId);
      if (sessionChannel != null &&
          sessionChannel.sink is SinkChannel &&
          (sessionChannel.sink as SinkChannel).channel != channel) {
        final previousChannel = (sessionChannel.sink as SinkChannel).channel;
        // заменить канал в сессии на новый , это позволит передать подписки
        // на новый канал
        sessionChannel.replaceSink(channel);
        // сообщить что сессия была прервана другой сессией
        previousChannel.sink.add(
          ToClient.authError(
            error: WsAuthError.stoppedByAnotherSession,
          ).encoded(),
        );
        // сообщить что сессия прервала другую сессию
        channel.sinkAdd(
          ToClient.authError(
            error: WsAuthError.continueAsNewSession,
          ).jsonBarrel(),
        );
      }

      final unit = await _unitRepository.getSelectedUnit(session.user.userId);
      if (unit == null) {
        channel.sinkAdd(
          ToClient.statusError(error: WsServerError.unitNotFound).jsonBarrel(),
        );
        return;
      }
      final gameSession = GameSession.fromSession(session, Unit.fromDto(unit));
      _activeUsersRepository.startFromChannel(channel, gameSession);
      final newSessionChannel = await _activeUsersRepository.getSessionChannel(
        gameSession.user.userId,
      );
      if (newSessionChannel == null) return;
      subscribe(newSessionChannel);
      newSessionChannel.shouldUnsubscribe[blocId] = () =>
          unsubscribe(newSessionChannel);
      newSessionChannel.sinkAdd(gameSession.sessionDTO(blocId.id).jsonBarrel());
      newSessionChannel.sinkAdd(
        ToClient.broadcastInfo(
          newSessionChannel.getJoinedBroads().toList(),
        ).jsonBarrel(),
      );

      await _onlineBroadcast();
    } on Object catch (e, s) {
      addError(e, s);
      channel.sinkAdd(
        ToClient.statusError(
          error: WsServerError.authenticationFailed,
        ).jsonBarrel(),
      );
    }
  }

  void infoJoinedBroads(SinkChannel channel) {
    _lock.synchronized(() async {
      try {
        debugLog('$green ActiveUsersBloc$reset infoJoinedBroads');
        final userId = channel.userId;
        if (userId == -1) return;

        debugLog('$green ActiveUsersBloc$reset infoJoinedBroads 2');
        final sessionChannel = await _activeUsersRepository.getSessionChannel(
          userId,
        );
        final boards = sessionChannel?.getJoinedBroads().toList();
        channel.sinkAdd(ToClient.broadcastInfo(boards ?? []).jsonBarrel());
      } catch (e, s) {
        addError(e, s);
      }
    });
  }

  void replaceByBot(Sink sink) {
    _lock.synchronized(() async {
      try {
        final userId = sink.userId;
        if (userId == -1) {
          addError(Exception('user id is -1'), StackTrace.current);
          return;
        }
        final session = await _activeUsersRepository.getSessionChannel(userId);
        if (session == null) {
          addError(Exception('session is null $userId'), StackTrace.current);
          return;
        }
        debugLog('$green ActiveUsersBloc$reset replaceByBot 1');
        debugLog('$green ActiveUsersBloc$reset replaceByBot 2');
        final bot = DisconnectBot();
        bot.start();
        session.replaceSink(SinkBot(getIt<BotRepository>(), bot, userId));

        debugLog('$green ActiveUsersBloc$reset replaceByBot 3');
        await _onlineBroadcast();
        // _activeUsersRepository.
      } catch (e, s) {
        addError(e, s);
      }
    });
  }

  void removeUser(Sink channel) {
    _lock.synchronized(() async {
      try {
        final userId = channel.userId;
        if (userId == -1) {
          addError(Exception('userId is -1'), StackTrace.current);
          return;
        }

        final sessionChannel = await _activeUsersRepository.getSessionChannel(
          userId,
        );
        if (sessionChannel == null) {
          addError(Exception('session is null $userId'), StackTrace.current);
          return;
        }
        await sessionChannel.dispose();
        await _activeUsersRepository.removeIDsession(userId);
        channel.sinkAdd(ToClient.terminatedAllBroadcast().jsonBarrel());
        _onlineBroadcast();
      } catch (e, s) {
        addError(e, s);
      }
    });
  }

  FutureOr<void> _onlineBroadcast() async {
    final list = await _activeUsersRepository.getListGameSessions();
    final members = list
        .map(
          (i) => OnlineMemberDto(
            i.session.unit.id,
            i.session.unit.name,
            i.sink is! SinkChannel,
          ),
        )
        .toList();
    broadcast(
      ToClient.onlineUsers(
        OnlineMemberPayload(roomId: blocId.id, members: members),
      ),
    );
  }
}
