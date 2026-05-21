import 'dart:async';

import 'package:dto/dto.dart';
import 'package:game_dto/game_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:synchronized/synchronized.dart';

import '../../../core/broadcast.dart';
import '../../../core/debug_log.dart';
import '../../../core/utils/next_noun.dart';
import '../../game/domain/unit.dart';
import '../../game/domain/unit_repository.dart';
import '../domain/session.dart';
import '../domain/session_repository.dart';
import 'online_repository_impl.dart';
import 'session_socket.dart';

const _timeoutDuration = Duration(seconds: 3);

abstract class PresenceManager {
  FutureOr<void> join(UserChannel channel, Token token, Noun n);
  void infoJoinedBroads(UserChannel channel, Noun n);
  void removeUser(Sink channel, Noun n);
  void syncOnlineUsers(Sink channel, Noun n);
  Future<void> joinBot(SinkBot bot, GameSession session);
  GameSocket? getGameSocket(UserId userId);
  Future<void> syncUnits(UserId userId);
  Future<void> sendMenu(UserId userId, Noun n);
  void removeAllBots();
  // BotRepository get botRepository;
  BroadcastId get broadcastId;
}

@LazySingleton(as: PresenceManager)
class PresenceManagerImpl extends BroadcastThrottle<WsResponse>
    implements PresenceManager {
  PresenceManagerImpl(
    this._onlineRep,
    this._unitRepository,
    this._sessionRepository,
  ) : broadcastId = BroadcastId('online') {
    initBroadcast();
  }
  final UnitRepository _unitRepository;
  final SessionRepository _sessionRepository;
  final OnlineRepository _onlineRep;
  // late final BotRepository _botRepository;
  // @override
  // BotRepository get botRepository => _botRepository;
  final _lock = Lock();
  int _nonce = 0;
  Noun _nextNoun() => Noun('online_${_nonce++}');

  @override
  late BroadcastId broadcastId;

  @override
  FutureOr<void> join(UserChannel channel, Token token, Noun n) async {
    try {
      await _join(channel, token, n).timeout(
        _timeoutDuration,
        onTimeout: () {
          addError('timeout', StackTrace.current);
          unawaited(
            channel.close(
              WebSocketCloseCode.timeout.code,
              WebSocketCloseCode.timeout.message,
            ),
          );
        },
      );
    } catch (e, s) {
      addError(e, s);
      await channel.close(
        WebSocketCloseCode.forbidden.code,
        WebSocketCloseCode.forbidden.message,
      );
    }
  }

  Future<void> _join(UserChannel userChannel, String token, Noun n) async {
    debugLog('PresenceManager: _join start n=$n');
    // 1. Data Loading Phase (Unlocked, prevents bottlenecking other auth attempts)
    final session = await _sessionRepository.getSession(token: token);
    final isValid = session != null
        ? _sessionRepository.validateToken(session)
        : false;

    if (!isValid) {
      debugLog('PresenceManager: token invalid');
      await userChannel.close(
        WebSocketCloseCode.tokenExpired.code,
        WebSocketCloseCode.tokenExpired.message,
      );
      return;
    }

    debugLog('PresenceManager: fetching unit for user ${session.user.userId}');
    final unit = await _unitRepository.getSelectedUnit(session.user.userId);
    if (unit == null) {
      debugLog('PresenceManager: unit NOT FOUND for user');
      await userChannel.close(
        WebSocketCloseCode.unitNotFound.code,
        WebSocketCloseCode.unitNotFound.message,
      );
      return;
    }
    debugLog('PresenceManager: unit found: ${unit.name}');
    final gameSession = GameSession.fromSession(session, Unit.fromDto(unit));

    // 2. Presence Registration Phase (Locked, sequential state mutation)
    debugLog('PresenceManager: waiting for lock...');
    await _lock.synchronized(() async {
      debugLog('PresenceManager: entering registerPresenceLocked');
      await _registerPresenceLocked(userChannel, gameSession, n);
    });
    debugLog('PresenceManager: _join sequence completed');
  }

  Future<void> _registerPresenceLocked(
    UserChannel userChannel,
    GameSession gameSession,
    Noun n,
  ) async {
    final socket = _onlineRep.getSessionUSERID(gameSession.user.userId);
    if (socket != null) {
      if (socket.userSink?.channel != userChannel.channel) {
        final prev = socket.userSink?.channel;
        debugLog(
          'replace channel in session ${socket.userSink?.userId} ${userChannel.userId}',
        );
        socket.replaceSink(userChannel);
        if (prev != null) {
          await prev.sink.close(
            WebSocketCloseCode.sessionConflict.code,
            WebSocketCloseCode.sessionConflict.message,
          );
        }
      }
    } else {
      _onlineRep.startFromChannel(userChannel, gameSession);
    }
    final newSessionChannel = _onlineRep.getSessionUSERID(
      gameSession.user.userId,
    );
    if (newSessionChannel == null) return;

    subscribe(newSessionChannel);
    newSessionChannel.shouldUnsubscribe[broadcastId] = () =>
        unsubscribe(newSessionChannel);

    newSessionChannel.sinkAdd(WsResponse.ack(n: n).toPacket());

    final units = await _unitRepository.getListUnit(
      userId: gameSession.user.userId,
    );
    final selectedId = gameSession.unit.unitId;

    newSessionChannel.sinkAdd(
      WsResponse.menu(
        n: nextNoun(),
        user: gameSession.user.toDto(),
        units: ListUnitDto(selectedId: selectedId, list: units),
      ).toPacket(),
    );

    newSessionChannel.sinkAdd(
      WsResponse.location(
        n: n,
        location: newSessionChannel.location,
        roomId: newSessionChannel.activeRoomId != null
            ? BroadcastId(newSessionChannel.activeRoomId!)
            : null,
      ).toPacket(),
    );
    newSessionChannel.sinkAdd(
      WsResponse.broadcastInfo(
        n: _nextNoun(),
        broadcasts: newSessionChannel.joinedBroadsInfo(),
      ).toPacket(),
    );

    _broadcastOnlineUsers();
  }

  @override
  void infoJoinedBroads(UserChannel channel, Noun n) {
    try {
      debugLog('ActiveUsersBloc infoJoinedBroads');
      final userId = channel.userId;
      if (userId == UserId.none) return;

      debugLog('ActiveUsersBloc infoJoinedBroads 2');
      final sessionChannel = _onlineRep.getSessionUSERID(userId);
      final boards = sessionChannel?.joinedBroadsInfo();
      if (boards == null) {
        debugLog('ActiveUsersBloc infoJoinedBroads is null');
        return;
      }
      channel.sinkAdd(
        WsResponse.broadcastInfo(n: n, broadcasts: boards).toPacket(),
      );
    } catch (e, s) {
      addError(e, s);
    }
  }

  @override
  void removeUser(Sink channel, Noun n) {
    debugLog('ActiveUsersBloc removeUser');
    _lock.synchronized(() async {
      try {
        final userId = channel.userId;
        if (userId == UserId.none) {
          addError(Exception('userId is none'), StackTrace.current);
          return;
        }

        final sessionChannel = _onlineRep.getSessionUSERID(userId);
        if (sessionChannel == null) {
          addError(Exception('session is null $userId'), StackTrace.current);
          return;
        }
        await sessionChannel.dispose();
        _onlineRep.removeIDsession(userId);
        channel.sinkAdd(WsResponse.terminatedAllBroadcast(n: n).toPacket());
        _broadcastOnlineUsers();
      } catch (e, s) {
        addError(e, s);
      }
    });
  }

  @override
  void syncOnlineUsers(Sink channel, Noun n) {
    final toClient = _getOnlineUsers(n);
    channel.sinkAdd(toClient.toPacket());
  }

  void joinOnlineUsers(UserChannel channel) {
    try {
      // проверить channel , должен быть зарегистрирован
      final toClient = _getOnlineUsers(_nextNoun());
      channel.sinkAdd(toClient.toPacket());
      // _broadcastOnlineUsers();
    } catch (e, s) {
      addError(e, s);
    }
  }

  void _broadcastOnlineUsers() {
    final toClient = _getOnlineUsers(_nextNoun());
    broadcast(toClient);
  }

  WsResponse _getOnlineUsers(Noun n) {
    final List<GameSocket> list = _onlineRep.getList();
    final members = list
        .map(
          (i) => OnlineMemberDto(
            i.session.unit.unitId,
            i.session.unit.name,
            i.isBot,
            wins: i.session.unit.wins,
            losses: i.session.unit.losses,
            coins: i.session.unit.coins,
            exp: i.session.unit.exp,
          ),
        )
        .toList();
    return WsResponse.onlineUsers(n: n, members: members);
  }

  @override
  GameSocket? getGameSocket(UserId userId) {
    return _onlineRep.getSessionUSERID(userId);
  }

  @override
  Future<void> syncUnits(UserId userId) async {
    final socket = _onlineRep.getSessionUSERID(userId);
    if (socket == null) return;

    final units = await _unitRepository.getListUnit(userId: userId);
    final selected = await _unitRepository.getSelectedUnit(userId);

    socket.sinkAdd(
      WsResponse.unitsUpdate(
        n: _nextNoun(),
        dto: ListUnitDto(selectedId: selected?.id ?? UnitId.none, list: units),
      ).toPacket(),
    );
  }

  @override
  Future<void> sendMenu(UserId userId, Noun n) async {
    final socket = _onlineRep.getSessionUSERID(userId);
    if (socket == null) return;

    final units = await _unitRepository.getListUnit(userId: userId);
    final selected = await _unitRepository.getSelectedUnit(userId);

    socket.sinkAdd(
      WsResponse.menu(
        n: n,
        user: socket.session.user.toDto(),
        units: ListUnitDto(
          selectedId: selected?.id ?? UnitId.none,
          list: units,
        ),
      ).toPacket(),
    );
  }

  @override
  Future<void> joinBot(SinkBot bot, GameSession session) async {
    final userId = session.user.userId;
    debugLog('[BotJoin] START — userId=$userId, unitId=${session.unit.unitId}');
    try {
      _onlineRep.startFromBot(bot, session);
      final channel = _onlineRep.getSessionUSERID(userId);
      if (channel == null) {
        debugLog('[BotJoin] ERROR — channel is null for userId=$userId');
        return;
      }
      debugLog('[BotJoin] Channel created for userId=$userId');
      subscribe(channel);
      channel.shouldUnsubscribe[broadcastId] = () => unsubscribe(channel);
      debugLog('[BotJoin] Calling bot.init() for userId=$userId');
      await bot.init();
      debugLog('[BotJoin] bot.init() completed for userId=$userId');
      _broadcastOnlineUsers();
      debugLog('[BotJoin] DONE — userId=$userId is online');
    } catch (e, st) {
      debugLog('[BotJoin] ERROR — userId=$userId: $e\n$st');
    }
  }

  @override
  void removeAllBots() {
    debugLog('PresenceManager: removeAllBots START');
    _lock.synchronized(() async {
      try {
        final allSockets = _onlineRep.getList();
        final botSockets = allSockets.where((s) => s.isBot).toList();
        debugLog(
          'PresenceManager: found ${botSockets.length} online bots to remove',
        );

        for (final socket in botSockets) {
          debugLog('PresenceManager: removing bot userId=${socket.userId}');
          await socket.dispose();
          _onlineRep.removeIDsession(socket.userId);
        }

        _broadcastOnlineUsers();
        debugLog('PresenceManager: removeAllBots DONE');
      } catch (e, s) {
        addError(e, s);
      }
    });
  }
}
