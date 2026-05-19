import 'dart:async';

import 'package:dto/dto.dart';
import 'package:injectable/injectable.dart';

import '../../../core/debug_log.dart';
import '../../../core/utils/noun_gen.dart';
import '../../../db_client/dao/unit_dao.dart';
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
  );
  final PresenceManager _onlineBroadcast;
  final ArenaBroadcast _arenaBroadcast;
  final CombatSupervisor _combatSupervisor;
  final UnitRepository _unitRepository;
  final UnitDao _unitDao;
  final LettersBroadManager _lettersBroadManager;

  /// ловим сообщения бота и отправляем в нужный broadcast
  Future<void> add(SinkBot botSink, WsRequest toServer) async {
    // Filter: process only messages tagged with [BotTs]
    if (toServer is! BotTs) return;

    try {
      debugLog('[BotRepository] add: $toServer for userId=${botSink.userId}');
      final gameSocket = _onlineBroadcast.getGameSocket(botSink.userId);
      debugLog(
        '[BotRepository] gameSocket=${gameSocket != null ? "found" : "NULL"}',
      );
      switch (toServer) {
        case JoinArenaTs():
          if (gameSocket == null) break;
          _arenaBroadcast.subscribeChannel(gameSocket, NouN.next().v);
        case JoinEdictTs():
          if (gameSocket == null) break;
          await _arenaBroadcast.joinEdict(
            gameSocket,
            toServer.edictId,
            NouN.next().v,
          );
        case CreateNewEdictTs():
          if (gameSocket != null) {
            _arenaBroadcast.createEdict(gameSocket, toServer.n);
          }
        case LeaveEdictTs():
          if (gameSocket != null) {
            _arenaBroadcast.leaveEdict(gameSocket, toServer.n);
          }
        case LeaveArenaTs():
          if (gameSocket != null) {
            _arenaBroadcast.leaveArena(gameSocket, toServer.n);
          }
        case WithTokenTs():
        case SyncJoinedBroadsTs():
        case SyncOnlineUsers():
          _onlineBroadcast.syncOnlineUsers(botSink, toServer.n);
        case JoinLettersTs():
          if (gameSocket != null) {
            _lettersBroadManager.subscribe(gameSocket, toServer.n);
          }
        case NewLetterTs():
          if (gameSocket != null) {
            _lettersBroadManager.newLetter(gameSocket, toServer);
          }
        case EditLetterTs():
          if (gameSocket != null) {
            _lettersBroadManager.editLetter(gameSocket, toServer);
          }
        case DeleteLetterTs():
          if (gameSocket != null) {
            _lettersBroadManager.removeLetter(gameSocket, toServer);
          }
        case ResetEdictsTs():
          // Global arena reset — not tied to a specific bot user
          _arenaBroadcast.reset();
        case ResetCombatsTs():
          // Global combat supervisor teardown — not tied to a specific bot user
          await _combatSupervisor.dispose();
        case DisconnectTs(:final n):
          debugLog('[BotRepository] BOT DisconnectTs $n');
          _onlineBroadcast.removeUser(botSink, n);
        case GameActionTs():
          debugLog(
            '[BotRepository] GameActionTs: combatRoomId=${toServer.combatRoomId}, action=${toServer.action}',
          );
          if (gameSocket != null) {
            debugLog(
              '[BotRepository] forwarding to combatSupervisor.gameAction',
            );
            await _combatSupervisor.gameAction(gameSocket, toServer);
            debugLog('[BotRepository] combatSupervisor.gameAction completed');
          } else {
            debugLog(
              '[BotRepository] ERROR: gameSocket is null for GameActionTs',
            );
          }
        case JoinBattleRoomTs():
          if (gameSocket != null) {
            await _combatSupervisor.combatReady(
              gameSocket,
              toServer.combatRoomId,
              toServer.n,
            );
          }
        case JoinAsCombatObserverTs():
        case LeaveBattleRoom():
        case FocusCombatObserverTs():
        case CreateBotsTs():
        case RemoveBotsTs():
        case AckTs():
          if (gameSocket != null) {
            gameSocket.handleAck(toServer as AckTs);
            if (gameSocket.pendingTransitionRoom != null) {
              gameSocket.commitPendingTransition();
            }
          }
          break;
        case SyncMenuTs():
          break;
        case ChangeLocationTs():
          break;
        case PingTs():
          break;
        case AllocateStatsTs():
          await _unitRepository.allocateStats(
            toServer.unitId,
            toServer.addAtk,
            toServer.addDef,
            toServer.addVitality,
          );
        case ChangeUnitStatsTs():
          await _unitDao.setStats(
            unitId: toServer.unitId ?? botSink.unitId as int,
            wins: toServer.wins,
            losses: toServer.losses,
            coins: toServer.coins,
            exp: toServer.exp,
          );
        case SyncCombatStateTs():
          break;
        case GetUnitStatsTs():
          break;
      }
    } catch (e, s) {
      debugLog('[BotRepository] ERROR: $e$s');
    }
  }
}
