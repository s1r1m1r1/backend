import 'dart:async';

import 'package:dto/dto.dart';
import 'package:injectable/injectable.dart';

import '../../../core/debug_log.dart';
import '../../../core/utils/next_noun.dart';
import '../../../db_client/dao/unit_dao.dart';
import '../../../ws/bot_cmd_executor.dart';
import '../../auth/application/presence_manager.dart';
import '../../auth/application/session_socket.dart';
import '../../chat/application/letters_broad_manager.dart';
import '../../game/application/arena_broadcast.dart';
import '../../game/application/combat_supervisor.dart';
import '../../game/domain/unit_repository.dart';

@lazySingleton
class BotRepository {
  BotRepository(
    this._onlineBroadcast,
    this._arenaBroadcast,
    this._combatSupervisor,
    this._unitRepository,
    this._unitDao,
    this._lettersBroadManager,
    this._botCmdExecutor,
  );
  final PresenceManager _onlineBroadcast;
  final ArenaBroadcast _arenaBroadcast;
  final CombatSupervisor _combatSupervisor;
  final UnitRepository _unitRepository;
  final UnitDao _unitDao;
  final LettersBroadManager _lettersBroadManager;
  final BotCmdExecutor _botCmdExecutor;

  /// ловим сообщения бота и отправляем в нужный broadcast
  Future<void> add(SinkBot botSink, WsRequest toServer) async {
    // Filter: process only messages tagged with [BotRequest]
    if (toServer is! BotRequest) return;

    // Check rate limiting via BotCmdExecutor
    if (_botCmdExecutor.isCommandBlocked(botSink.userId, toServer)) {
      debugLog(
        '[BotRepository] Command blocked by rate limiter: $toServer for userId=${botSink.userId}',
      );
      return;
    }

    try {
      debugLog('[BotRepository] add: $toServer for userId=${botSink.userId}');
      final gameSocket = _onlineBroadcast.getGameSocket(botSink.userId);
      debugLog(
        '[BotRepository] gameSocket=${gameSocket != null ? "found" : "NULL"}',
      );
      switch (toServer) {
        case JoinArenaRequest():
          if (gameSocket == null) break;
          _arenaBroadcast.subscribeChannel(gameSocket, nextNoun());
        case JoinEdictRequest():
          if (gameSocket == null) break;
          await _arenaBroadcast.joinEdict(
            gameSocket,
            toServer.edictId,
            nextNoun(),
          );
        case CreateNewEdictRequest():
          if (gameSocket != null) {
            _arenaBroadcast.createEdict(gameSocket, toServer.n);
          }
        case LeaveEdictRequest():
          if (gameSocket != null) {
            _arenaBroadcast.leaveEdict(gameSocket, toServer.n);
          }
        case LeaveArenaRequest():
          if (gameSocket != null) {
            _arenaBroadcast.leaveArena(gameSocket, toServer.n);
          }
        case WithTokenRequest(:final n):
        case SyncJoinedBroadsRequest(:final n):
        case SyncOnlineUsers(:final n):
          _onlineBroadcast.syncOnlineUsers(botSink, n);
        case JoinLettersRequest():
          if (gameSocket != null) {
            _lettersBroadManager.subscribe(gameSocket, toServer.n);
          }
        case NewLetterRequest():
          if (gameSocket != null) {
            _lettersBroadManager.newLetter(gameSocket, toServer);
          }
        case EditLetterRequest():
          if (gameSocket != null) {
            _lettersBroadManager.editLetter(gameSocket, toServer);
          }
        case DeleteLetterRequest():
          if (gameSocket != null) {
            _lettersBroadManager.removeLetter(gameSocket, toServer);
          }
        case ResetEdictsRequest():
          // Global arena reset — not tied to a specific bot user
          _arenaBroadcast.reset();
        case ResetCombatsRequest():
          // Global combat supervisor teardown — not tied to a specific bot user
          await _combatSupervisor.dispose();
        case DisconnectRequest(:final n):
          debugLog('[BotRepository] BOT DisconnectRequest $n');
          _onlineBroadcast.removeUser(botSink, n);
        case GameActionRequest():
          debugLog(
            '[BotRepository] GameActionRequest: combatRoomId=${toServer.combatRoomId}, action=${toServer.action}',
          );
          if (gameSocket != null) {
            debugLog(
              '[BotRepository] forwarding to combatSupervisor.gameAction',
            );
            await _combatSupervisor.gameAction(gameSocket, toServer);
            debugLog('[BotRepository] combatSupervisor.gameAction completed');
          } else {
            debugLog(
              '[BotRepository] ERROR: gameSocket is null for GameActionRequest',
            );
          }
        case JoinBattleRoomRequest():
          if (gameSocket != null) {
            await _combatSupervisor.combatReady(
              gameSocket,
              toServer.combatRoomId,
              toServer.n,
            );
          }
        case JoinAsCombatObserverRequest():
        case LeaveBattleRoom():
        case FocusCombatObserverRequest():
        case CreateBotsRequest():
        case RemoveBotsRequest():
        case AckRequest():
          if (gameSocket != null) {
            gameSocket.handleAck(toServer as AckRequest);
            if (gameSocket.pendingTransitionRoom != null) {
              gameSocket.commitPendingTransition();
            }
          }
          break;
        case SyncMenuRequest():
          break;
        case ChangeLocationRequest():
          break;
        case PingRequest():
          break;
        case AllocateStatsRequest():
          await _unitRepository.allocateStats(
            toServer.unitId,
            toServer.addAtk,
            toServer.addDef,
            toServer.addVitality,
          );
        case ChangeUnitStatsRequest():
          await _unitDao.setStats(
            unitId: toServer.unitId ?? botSink.unitId,
            wins: toServer.wins,
            losses: toServer.losses,
            coins: toServer.coins,
            exp: toServer.exp,
          );
        case SyncCombatStateRequest():
          break;
        case GetUnitStatsRequest():
          break;
      }
    } catch (e, s) {
      debugLog('[BotRepository] ERROR: $e$s');
    }
  }

  /// Check if a bot is disabled due to rate limit violations.
  bool isBotDisabled(UserId userId) => _botCmdExecutor.isBotDisabled(userId);

  /// Re-enable a disabled bot (for testing or manual recovery).
  void enableBot(UserId userId) => _botCmdExecutor.enableBot(userId);

  /// Get penalty level for a bot.
  PenaltyLevel getBotPenaltyLevel(UserId userId) =>
      _botCmdExecutor.getPenaltyLevel(userId);

  /// Get remaining mute time for a bot in milliseconds.
  int? getBotMuteRemainingMs(UserId userId) =>
      _botCmdExecutor.getMuteRemainingMs(userId);
}
