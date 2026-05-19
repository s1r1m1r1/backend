import 'dart:async';

import 'package:dto/dto.dart';
import 'package:injectable/injectable.dart';
import 'package:synchronized/synchronized.dart';

import '../../../core/broadcast.dart';
import '../../../core/debug_log.dart';
import '../../auth/application/session_socket.dart';
import '../domain/edict.dart';
import 'combat_supervisor.dart';

@lazySingleton
class ArenaBroadcast extends Broadcast<WsResponse> {
  ArenaBroadcast(this._combatManager) : broadcastId = BroadcastId('arena-2');
  final _lock = Lock();
  final CombatSupervisor _combatManager;
  int _nonceCount = 0;
  String get _nextN => 'arena_${_nonceCount++}';

  @override
  late BroadcastId broadcastId;
  final _edictGroups = <Edict>[];
  final _edictTimer = <String, Timer>{};

  int _lastId = 0;

  void createEdict(GameSocket socket, String n) {
    _lock.synchronized(() async {
      final hasEdict = _edictGroups.any(
        (i) => i.members.any((i) => i.userId == socket.userId),
      );
      if (hasEdict) {
        debugLog('createEdict Has edict\n\n');
        socket.sinkAdd(
          WsResponse.arenaError(
            n: n,
            error: WsArenaError.hasAnotherEdict,
          ).toPacket(),
        );
        return;
      }

      final edictId = 'edict${_lastId++}';
      final battleStartIn = DateTime.now().add(const Duration(seconds: 1));
      final newEdict = Edict(
        id: edictId,
        createdAt: DateTime.now(),
        members: [(userId: socket.userId, unitName: socket.session.unit.name)],
        startIn: battleStartIn,
        maxMembers: 3,
        isFighting: false,
      );
      _edictGroups.add(newEdict);
      _scheduleEdictBattle(edictId, battleStartIn);
      _broadcastEdicts();
    });
  }

  // timer schedule
  void _scheduleEdictBattle(String edictId, DateTime battleStartIn) {
    final timeUntilBattle = battleStartIn.difference(DateTime.now());

    // Schedule a one-off timer
    final timer = Timer(timeUntilBattle, () {
      _lock.synchronized(() async {
        _edictTimer.remove(edictId);
        final edictIndex = _edictGroups.indexWhere((i) => i.id == edictId);

        if (edictIndex == -1) {
          addError(Exception('stop edict not found  -1'), StackTrace.current);
          return;
        }

        final edict = _edictGroups[edictIndex];
        final readyToStart = edict.members.length > 1;
        if (readyToStart) {
          await _combatManager.createRoom(edict);
        }
        _edictGroups.removeAt(edictIndex);
        _broadcastEdicts();
      });
    });
    _edictTimer[edictId] = timer;
  }

  void subscribeChannel(GameSocket socket, String n) {
    final userId = socket.userId;
    final oldChannel = channels[userId];
    if (oldChannel != null) {
      debugLog('oldChannel cancel');
      oldChannel.onSubscriptionCancel(broadcastId);
    }
    subscribe(socket);
    socket.shouldUnsubscribe[broadcastId] = () => unsubscribe(socket);
    socket.sinkAdd(
      WsResponse.location(n: _nextN, location: GameLocation.arena).toPacket(),
    );
    socket.sinkAdd(
      WsResponse.activeEdicts(
        n: n,
        edicts: [
          ..._edictGroups.map(
            (i) => EdictDto(
              id: i.id,
              members: i.members
                  .map((m) => UserMemberDto(m.userId.id, m.unitName))
                  .toList(),
              maxMembers: i.maxMembers,
              createdAt: i.createdAt,
              startIn: i.startIn,
            ),
          ),
        ],
        // .toList(),
      ).toPacket(),
    );
  }

  void leaveArena(GameSocket socket, String n) {
    final userId = socket.userId;
    final channel = channels[userId];
    channel?.sinkAdd(
      WsResponse.location(n: n, location: GameLocation.menu).toPacket(),
    );
    channel?.sinkAdd(
      WsResponse.terminatedBroadcast(n: n, broad: broadcastId).toPacket(),
    );
  }

  Future<void> joinEdict(GameSocket socket, String edictId, String n) {
    return _lock.synchronized(() async {
      debugLog('joinEdict $edictId 1');
      final hasEdict = _edictGroups.any(
        (i) => i.members.any((i) => i.userId == socket.userId),
      );
      if (hasEdict) {
        debugLog('joinEdict $edictId 2');
        socket.sinkAdd(
          WsResponse.arenaError(
            n: n,
            error: WsArenaError.hasAnotherEdict,
          ).toPacket(),
        );
        return;
      }
      final edictIndex = _edictGroups.indexWhere((i) => i.id == edictId);
      if (edictIndex == -1) {
        socket.sinkAdd(
          WsResponse.arenaError(
            n: n,
            error: WsArenaError.notFoundEdict,
          ).toPacket(),
        );
        return;
      }
      final edict = _edictGroups[edictIndex];
      if (edict.members.length >= edict.maxMembers) {
        socket.sinkAdd(
          WsResponse.arenaError(n: n, error: WsArenaError.fullEdict).toPacket(),
        );
        return;
      }

      edict.members.add((
        userId: socket.userId,
        unitName: socket.session.unit.name,
      ));

      _broadcastEdicts();
    });
  }

  void leaveEdict(GameSocket session, String n) {
    _lock.synchronized(() async {
      final userId = session.userId;
      final index = _edictGroups.indexWhere(
        (i) => i.members.any((i) => i.userId == userId),
      );
      if (index == -1) return;
      final edict = _edictGroups[index];
      edict.members.removeWhere((i) => i.userId == userId);
      if (edict.members.isEmpty) {
        _edictGroups.removeAt(index);
      }
      _broadcastEdicts();
    });
  }

  void _broadcastEdicts() {
    broadcast(
      WsResponse.activeEdicts(
        n: _nextN,
        edicts: _edictGroups
            .map(
              (i) => EdictDto(
                id: i.id,
                members: i.members
                    .map((m) => UserMemberDto(m.userId.id, m.unitName))
                    .toList(),
                maxMembers: i.maxMembers,
                createdAt: i.createdAt,
                startIn: i.startIn,
              ),
            )
            .toList(),
      ),
    );
  }

  void reset() {
    _lock.synchronized(() async {
      for (final timer in _edictTimer.values) {
        timer.cancel();
      }
      _edictTimer.clear();
      _edictGroups.clear();
      _broadcastEdicts();
    });
  }

  @override
  Future<void> dispose() async {
    reset();
    await super.dispose();
  }
}
