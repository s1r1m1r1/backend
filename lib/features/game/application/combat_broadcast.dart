// ignore_for_file: unnecessary_brace_in_string_interpolations

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dto/dto.dart';
import 'package:game_dto/game_dto.dart';
import 'package:synchronized/synchronized.dart';

import '../../../core/broadcast.dart';
import '../../../core/debug_log.dart';
import '../../../core/k_debug_mode.dart';
import '../../auth/application/online_repository_impl.dart';
import '../../auth/application/session_socket.dart';
import '../../auth/domain/session.dart';
import '../../auth/domain/session_repository.dart';
import '../../auth/domain/user_repository.dart';
import '../domain/combat.dart';
import '../domain/combatant.dart';
import '../domain/edict.dart';
import '../domain/level_system.dart';
import '../domain/unit.dart';
import '../domain/unit_repository.dart';

class CombatBroadcast extends Broadcast<CombatResponse> {
  CombatBroadcast(
    this._onlineRep,
    this._sessionRep,
    this._unitRep,
    this._userRep,
    this._edict,
  ) : broadcastId = BroadcastId(_edict.id);
  final _lock = Lock();
  final OnlineRepository _onlineRep;
  final SessionRepository _sessionRep;
  final UserRepository _userRep;
  final UnitRepository _unitRep;
  int _nonceCount = 0;
  Noun _nextNoun() => Noun('combat_${_nonceCount++}');

  final _eventHistory = <CombatEventResponse>[];

  @override
  late BroadcastId broadcastId;

  void Function()? onCombatEnd;

  final Edict _edict;
  final combat = Combat.initial();
  List<Combatant> get combatants => combat.combatants;
  // final GameSession currentSession;
  Timer? _timer;
  int? _currentTurnEndAt;

  void _broadcastEvent(List<CombatEventDto> events, {Noun? n}) {
    final eventId = _eventHistory.length;
    final tc =
        WsResponse.combatEvent(
              n: n ?? _nextNoun(),
              broadcastId: broadcastId as String,
              events: events,
              turnEndAt: _currentTurnEndAt,
              id: eventId,
            )
            as CombatEventResponse;
    _eventHistory.add(tc);
    broadcast(tc as CombatResponse);
  }

  void _startTurnTimer() {
    _timer?.cancel();
    _currentTurnEndAt = DateTime.now().millisecondsSinceEpoch + 20000;
    _timer = Timer(const Duration(seconds: 20), () {
      debugLog('[CombatBroadcast] Turn timeout for ${combat.currentCombatant}');
      _onTurnTimeout();
    });
  }

  Future<void> _onTurnTimeout() async {
    await _lock.synchronized(() async {
      combat.nextCombatant();
      _startTurnTimer();
      _broadcastEvent([
        CombatEventDto.turn(
          currentTurn: combat.currentCombatant!,
          unitOrder: combat.unitOrder,
          turnEndAt: _currentTurnEndAt,
        ),
      ]);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> combatReady(GameSocket socket, Noun n) async {
    await _lock.synchronized(() async {
      final index = combatants.indexWhere((i) => i.userId == socket.userId);
      if (index == -1) {
        warn('combatReady not found $n ${socket.userId}');
        socket.sinkAdd(
          WsResponse.combatError(
            n: n,
            broadcastId: broadcastId,
            error: WsCombatError.missedSocket,
          ).toPacket(),
        );
        return;
      }

      final Combatant combatant = combatants[index];
      combatant.ready = true;
      final readyCount = combatants.fold(0, (p, c) => p + (c.ready ? 1 : 0));
      final allReady = readyCount == combatants.length;

      debugLog(
        '[CombatBroadcast] combatReady $readyCount/${combatants.length}'
        ' allReady=$allReady round=${combat.round}',
      );

      if (combat.round == 0) {
        // Инициализируем порядок ходов (только при первом вызове)
        if (combat.unitOrder.isEmpty) {
          combat.initTurn();
        }

        if (allReady) {
          // Все подключились — отправляем StartBattleResponse всем
          _startTurnTimer();
          broadcast(
            WsResponse.startBattle(
                  n: n,
                  broadcastId: broadcastId,
                  membs: combatants.map((i) => i.toDto()).toList(),
                  unitOrder: combat.unitOrder,
                  ready: readyCount,
                  currentTurn: combat.currentCombatant!,
                  turnEndAt: _currentTurnEndAt,
                  id: -1, // Initial state before any events
                )
                as CombatResponse,
          );
        } else {
          // Ещё не все — отправляем только подключившемуся (lobby-state)
          socket.sinkAdd(
            WsResponse.startBattle(
              n: n,
              broadcastId: broadcastId,
              membs: combatants.map((i) => i.toDto()).toList(),
              unitOrder: combat.unitOrder,
              ready: readyCount,
              currentTurn: combat.currentCombatant!,
              id: -1,
            ).toPacket(),
          );
        }
      } else {
        // Бой идёт — reconnect: отправляем текущий стейт только подключившемуся
        socket.sinkAdd(
          WsResponse.combatState(
            n: n,
            broadcastId: broadcastId as String,
            round: combat.round,
            currentTurn: combat.currentCombatant!,
            membs: combatants.map((i) => i.toDto(includeBase: true)).toList(),
            unitOrder: combat.unitOrder,
            turnEndAt: _currentTurnEndAt,
            id: _eventHistory.length - 1,
          ).toPacket(),
        );
      }
    });
  }

  Future<void> syncCombatState(GameSocket socket, Noun n) async {
    await _lock.synchronized(() async {
      socket.sinkAdd(
        WsResponse.combatState(
          n: n,
          broadcastId: broadcastId as String,
          round: combat.round,
          currentTurn: combat.currentCombatant!,
          membs: combatants.map((i) => i.toDto(includeBase: true)).toList(),
          unitOrder: combat.unitOrder,
          turnEndAt: _currentTurnEndAt,
          id: _eventHistory.length - 1,
        ).toPacket(),
      );
    });
  }

  Future<void> gameAction(GameSocket socket, GameActionRequest ts) async {
    await _lock.synchronized(() async {
      // 1/ проверить может ли пользователь делать действие или нет
      final unitId = socket.session.unit.unitId;
      debugLog(
        '[CombatBroadcast] gameAction from socket userId=${socket.userId}, unitId=$unitId',
      );
      final unitIdx = combatants.indexWhere((i) => i.unitId == unitId);
      debugLog(
        '[CombatBroadcast] gameAction: unitIdx=$unitIdx, combatants=${combatants.map((c) => '${c.userId}->${c.unitId}').toList()}',
      );
      if (unitIdx == -1) {
        debugLog(
          '[CombatBroadcast] gameAction: combatant NOT FOUND for unitId=$unitId',
        );
        socket.sinkAdd(
          WsResponse.combatError(
            broadcastId: broadcastId,
            n: ts.n,
            error: .actionNoPermitted,
          ).toPacket(),
        );
        return;
      }
      // 2/ проверка очередности , только на своем ходу
      final combatant = combatants[unitIdx];
      final currentCombatant = combat.currentCombatant;
      debugLog(
        '[CombatBroadcast] gameAction: combatant.unitId=${combatant.unitId}, currentCombatant=$currentCombatant',
      );
      if (combatant.unitId != currentCombatant) {
        debugLog('[CombatBroadcast] gameAction: NOT YOUR TURN');
        socket.sinkAdd(
          WsResponse.combatError(
            n: ts.n,
            broadcastId: broadcastId,
            error: .notYourTurn,
          ).toPacket(),
        );
        return;
      }
      debugLog('[CombatBroadcast] gameAction: processing attack');

      /// 3 проверка допустимости ,воспроизвести действие GameActionDto
      final action = ts.action;
      switch (action) {
        case AttackGA(:final combatantId, :final enemyCombatantId):
          final enemyCombatant = combatants.firstWhereOrNull(
            (i) => i.unitId == enemyCombatantId,
          );
          final attackerCombatant = combatants.firstWhereOrNull(
            (i) => i.unitId == combatantId,
          );
          // 3a/ проверка существования бойцов и принадлежности атакующего бойца текущему игроку
          if (enemyCombatant == null ||
              attackerCombatant == null ||
              attackerCombatant != combatant) {
            socket.sinkAdd(
              WsResponse.combatError(
                n: ts.n,
                broadcastId: broadcastId,
                error: WsCombatError.wrongAction,
              ).toPacket(),
            );
            return;
          }
          if (combatant.mutableUnit.hp <= 0) {
            socket.sinkAdd(
              WsResponse.combatError(
                n: ts.n,
                broadcastId: broadcastId,
                error: .wrongAction,
              ).toPacket(),
            );
            return;
          }
          final List<CombatEventDto> events = [];
          final damage = combatant.mutableUnit.atk;
          enemyCombatant.mutableUnit.hp -= damage;

          events.add(
            CombatEventDto.attack(
              attackerId: combatant.unitId,
              targetId: enemyCombatant.unitId,
              damage: damage,
              targetHp: enemyCombatant.mutableUnit.hp,
            ),
          );

          if (enemyCombatant.mutableUnit.hp <= 0) {
            enemyCombatant.mutableUnit.hp = 0;
            combat.unitOrder.remove(enemyCombatant.unitId);
            events.add(CombatEventDto.death(unitId: enemyCombatant.unitId));
          }

          log(
            '[COMBAT][$broadcastId] Round ${combat.round} | Turn ${combatant.unitId}\n'
            '  - ${combatant.mutableUnit.name} attacks ${enemyCombatant.mutableUnit.name}\n'
            '  - Damage: $damage | Enemy HP: ${enemyCombatant.mutableUnit.hp}',
          );

          // Remove the acting combatant from the queue via domain logic
          // (removed redundant manual removeAt(0) here as it is handled by nextCombatant)
          // Clean up any dead combatants that may now be at the front of the queue
          while (combat.unitOrder.isNotEmpty) {
            final nextId = combat.unitOrder.first;
            final nextCombatant = combatants.firstWhereOrNull(
              (c) => c.unitId == nextId,
            );
            if (nextCombatant == null || nextCombatant.mutableUnit.hp <= 0) {
              combat.unitOrder.removeAt(0);
              events.add(.death(unitId: nextId));
              continue;
            }
            break;
          }
          // If the queue is empty, start a new round with alive combatants
          if (combat.unitOrder.isEmpty) {
            combat.round++;
            combat.unitOrder.addAll(
              combatants
                  .where((i) => i.mutableUnit.hp > 0)
                  .map((i) => i.unitId)
                  .toList(),
            );
            events.add(.round(round: combat.round));
          }

          // 3c/ проверка условий победы
          final aliveCombatants = combatants
              .where((i) => i.mutableUnit.hp > 0)
              .toList();
          if (aliveCombatants.length == 1) {
            final winner = aliveCombatants.first;
            final winnerTeamId = winner.teamId;
            log('Team $winnerTeamId wins!');

            // Update stats and rewards
            for (final combatant in combatants) {
              final isWinner = combatant.teamId == winnerTeamId;
              if (isWinner) {
                // Determine who the loser was for calculation purposes
                final loser = combatants.firstWhere((c) => c != combatant);
                final levelSystemResult = LevelSystem.calculateWinnerReward(
                  UnitProfileDto(
                    unit: combatant.mutableUnit.toDto(),
                    stats: combatant.stats,
                  ),
                  loser.mutableUnit.toDto(),
                );

                combatant.mutableUnit.wins += 1;
                combatant.mutableUnit.coins += 10;
                combatant.mutableUnit.exp = levelSystemResult.newExp;
                combatant.mutableUnit.level = levelSystemResult.newLevel;
                combatant.mutableUnit.statPoints =
                    levelSystemResult.newStatPoints;

                final socket = _onlineRep.getSessionUSERID(combatant.userId);
                if (socket != null) {
                  socket.session.unit.wins += 1;
                  socket.session.unit.coins += 10;
                  socket.session.unit.exp = levelSystemResult.newExp;
                  socket.session.unit.level = levelSystemResult.newLevel;
                  socket.session.unit.statPoints =
                      levelSystemResult.newStatPoints;
                }

                await _unitRep.updateStats(
                  unitId: combatant.unitId,
                  winDelta: 1,
                  coinDelta: 10,
                  expDelta: levelSystemResult.addedExp,
                  newLevel: levelSystemResult.newLevel,
                  newStatPoints: levelSystemResult.newStatPoints,
                );
                unawaited(_notifyUnitsUpdate(combatant.userId));
                log(
                  '  - Reward: ${combatant.mutableUnit.name} (Winner) +10 coins, +${levelSystemResult.addedExp} exp',
                );
              } else {
                // Provide 10% of base reward for losing, but do not process level ups for simplicity right now
                const loserExp = 10;
                combatant.mutableUnit.losses += 1;
                combatant.mutableUnit.exp += loserExp;

                final socket = _onlineRep.getSessionUSERID(combatant.userId);
                if (socket != null) {
                  socket.session.unit.losses += 1;
                  socket.session.unit.exp += loserExp;
                }

                await _unitRep.updateStats(
                  unitId: combatant.unitId,
                  lossDelta: 1,
                  expDelta: loserExp,
                );
                unawaited(_notifyUnitsUpdate(combatant.userId));
                log(
                  '  - Reward: ${combatant.mutableUnit.name} (Loser) +$loserExp exp',
                );
              }
            }

            broadcast(
              WsResponse.location(n: _nextNoun(), location: GameLocation.arena)
                  as CombatResponse,
            );
            broadcast(
              WsResponse.combatWin(
                    n: ts.n,
                    broadcastId: broadcastId,
                    winnerTeamId: winnerTeamId,
                  )
                  as CombatResponse,
            );

            for (final combatant in combatants) {
              final socket = _onlineRep.getSessionUSERID(combatant.userId);
              if (socket != null && socket.isBot) {
                socket.sinkAdd(
                  WsResponse.location(
                    n: _nextNoun(),
                    location: GameLocation.arena,
                  ).toPacket(),
                );
                socket.sinkAdd(
                  WsResponse.combatWin(
                    n: ts.n,
                    broadcastId: broadcastId,
                    winnerTeamId: winnerTeamId,
                  ).toPacket(),
                );
              }
            }
            onCombatEnd?.call();
            return;
          }

          // передать ход следующему
          combat.nextCombatant();
          _startTurnTimer();

          events.add(
            CombatEventDto.turn(
              currentTurn: combat.currentCombatant!,
              unitOrder: combat.unitOrder,
              turnEndAt: _currentTurnEndAt,
            ),
          );

          // 4/ todo обновить стейт
          debugLog(
            'channels -- ${channels.entries.map((entry) => entry.key.toString()).join(', ')}',
          );

          // 5/ оповестить через дельту
          _broadcastEvent(events, n: ts.n);

          break;
        case HealGA():
          break;
      }
    });
    // 4/ если действие прошло проверку выполнить в game-loop
  }

  Future<void> subscribeEdict() async {
    debugLog('subscribeEdict start');
    for (var i = 0; i < _edict.members.length; i++) {
      final userId = _edict.members[i].userId;
      final socket = await _socketOrBot(userId);
      if (socket == null) continue;

      final isAlreadyCombatant = combat.combatants.any(
        (i) => i.userId == userId,
      );
      if (isAlreadyCombatant) continue;

      final stats = await _unitRep.getUnitPublicInfo(
        socket.session.unit.unitId,
      );

      final uCombatant = Combatant(
        unitId: socket.session.unit.unitId,
        userId: socket.userId,
        teamId: TeamId(socket.session.unit.unitId),
        isBot: socket.isBot,
        baseUnit: socket.session.unit.toDto(),
        stats:
            stats ?? const UnitStatsDto(wins: 0, losses: 0, coins: 0, exp: 0),
      );
      combat.combatants.add(uCombatant);
    }

    if (combatants.length == 1) {
      final socket = _onlineRep.getSessionUSERID(combatants.first.userId);
      // сообщить игроку что в комнате недостаточно игроков
      socket?.sinkAdd(
        WsResponse.combatError(
          n: _nextNoun(),
          broadcastId: broadcastId,
          error: .notEnoughPlayers,
        ).toPacket(),
      );
      // удалить комнату
      onCombatEnd?.call();
      return;
    }
    if (combatants.every((i) => i.isBot) && !kDebugMode) {
      _gameStoppedByError(.everyBot);
      // удалить комнату
      onCombatEnd?.call();
      return;
    }
    // начинаем игру
    _startCombat();
  }

  void _startCombat() async {
    WsCombatError? error;
    for (var i = 0; i < combatants.length; i++) {
      final combatant = combatants[i];
      combatant.teamId = TeamId(combatant.unitId.value);
      final socket = await _socketOrBot(combatant.userId);
      if (socket == null) {
        error = WsCombatError.missedSocket;
        continue;
      }

      final units = await _unitRep.getListUnit(userId: socket.userId);
      final selectedId = socket.session.unit.unitId;
      final menuN = Noun('combat_menu_${_nonceCount++}');
      socket.sinkAdd(
        WsResponse.menu(
          n: menuN,
          user: socket.session.user.toDto(),
          units: ListUnitDto(selectedId: selectedId, list: units),
        ).toPacket(),
      );

      // Регистрируем pending-переход: подписка произойдёт атомарно по AckRequest
      socket.setPendingTransition(broadcastId, (s) {
        if (!channels.containsKey(s.userId)) {
          subscribe(s);
          s.shouldUnsubscribe[broadcastId] = () => unsubscribe(s);
        }
      });
    }

    if (error != null) {
      _gameStoppedByError(error);
      return;
    }

    for (final combatant in combatants) {
      final socket = await _socketOrBot(combatant.userId);
      if (socket == null) continue;

      socket.sinkAdd(
        WsResponse.location(
          n: _nextNoun(),
          location: .game,
          roomId: broadcastId,
        ).toPacket(),
      );

      final combatStarted = WsResponse.combatStarted(
        n: _nextNoun(),
        combatRoom: broadcastId,
      );
      // sendWithAck регистрирует ожидание AckRequest по nonce
      socket
          .sendWithAck(combatStarted as RequiredAckResponse)
          .then((_) {
            debugLog(
              '[CombatBroadcast] ACK received for combatStarted → ${socket.userId}',
            );
          })
          .catchError((Object e) {
            debugLog('[CombatBroadcast] combatStarted ACK timeout/error: $e');
          });
    }
  }

  void _gameStoppedByError(WsCombatError error) {
    for (var i = 0; i < combatants.length; i++) {
      final userId = combatants[i].userId;
      final socket = _onlineRep.getSessionUSERID(userId);
      socket?.sinkAdd(
        WsResponse.location(n: _nextNoun(), location: .arena).toPacket(),
      );
      socket?.sinkAdd(
        WsResponse.combatError(
          n: _nextNoun(),
          broadcastId: broadcastId,
          error: error,
        ).toPacket(),
      );
    }
    onCombatEnd?.call();
  }

  Future<GameSocket?> _socketOrBot(UserId userId) async {
    var socket = _onlineRep.getSessionUSERID(userId);
    socket ??= await _recoverySocketAsBot(userId);

    return socket;
  }

  Future<GameSocket?> _recoverySocketAsBot(UserId userId) async {
    final gameSession = await _recoverySocket(userId);
    if (gameSession == null) return null;
    // final bot = SinkBot(_botRepository, GameBot(), gameSession.user.userId);
    // final sessionChannel = _onlineRep.startFromBot(bot, gameSession);
    // return sessionChannel;
    return null;
  }

  Future<GameSession?> _recoverySocket(UserId userId) async {
    final recoverSession = await _sessionRep.getSession(userId: userId);
    final unitDto = await _unitRep.getSelectedUnit(userId);
    if (unitDto == null) return null;
    if (recoverSession == null) {
      final user = await _userRep.getUser(userId: userId);
      if (user == null) return null;
      return GameSession(user: user, unit: Unit.fromDto(unitDto));
    }
    return GameSession(user: recoverSession.user, unit: Unit.fromDto(unitDto));
  }

  Future<void> _notifyUnitsUpdate(UserId userId) async {
    final socket = _onlineRep.getSessionUSERID(userId);
    if (socket == null) return;
    final units = await _unitRep.getListUnit(userId: userId);
    final selected = await _unitRep.getSelectedUnit(userId);
    socket.sinkAdd(
      WsResponse.unitsUpdate(
        n: _nextNoun(),
        dto: ListUnitDto(selectedId: selected?.id, list: units),
      ).toPacket(),
    );
  }
}
