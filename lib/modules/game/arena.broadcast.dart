import 'dart:async';

import 'package:backend/core/broadcast.dart';
import 'package:backend/core/session_channel.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';
import 'package:synchronized/synchronized.dart';

@module
abstract class ArenaBroadcastModule {
  @prod
  @lazySingleton
  ArenaBroadcast prodArena() => ArenaBroadcast(1);

  @test
  @dev
  @lazySingleton
  ArenaBroadcast devArena() => ArenaBroadcast(2);
}

class ArenaBroadcast extends Broadcast<ToClient> {
  final _lock = Lock();
  ArenaBroadcast(int roomId)
    : blocId = BroadcastId(family: BroadcastFamily.arena, id: roomId);

  @override
  late BroadcastId blocId;
  final _edictGroups = <int, EdictDto>{};
  final _edictTimer = <int, Timer>{};

  int _lastId = 0;

  void createEdict(SessionChannel channel) {
    _lock.synchronized(() async {
      final edictId = _lastId++;
      final battleStartIn = DateTime.now().add(const Duration(seconds: 5));
      final newEdict = EdictDto(
        id: edictId,
        createdAt: DateTime.now(),
        members: [UserMemberDto(channel.userId, channel.session.unit.name)],
        battleStartIn: battleStartIn,
        maxMembers: 2,
      );
      _edictGroups[edictId] = newEdict;
      broadcast(ToClient.activeEdicts(_edictGroups.values.toList()));
      _scheduleEdictBattle(edictId, battleStartIn);
    });
  }

  // timer schedule
  void _scheduleEdictBattle(int edictId, DateTime battleStartIn) {
    final timeUntilBattle = battleStartIn.difference(DateTime.now());

    // Schedule a one-off timer
    final timer = Timer(timeUntilBattle, () {
      _lock.synchronized(() async {
        _edictTimer.remove(edictId);
        final edict = _edictGroups[edictId];
        if (edict == null) return;
        final readyToStart = edict.members.length > 1;
        if (!readyToStart) {
          _edictGroups.remove(edictId);
          broadcast(ToClient.activeEdicts(_edictGroups.values.toList()));
          return;
        }
        if (edict.isFighting) return;
        _edictGroups[edictId] = edict.copyWith(isFighting: true);
      });
    });
    _edictTimer[edictId] = timer;
  }

  void subscribeChannel(SessionChannel channel) {
    final userId = channel.userId;
    final oldChannel = channels[userId];
    if (oldChannel != null) {
      oldChannel.onSubscriptionCancel(blocId);
    }
    subscribe(channel);
    channel.shouldUnsubscribe[blocId] = () => unsubscribe(channel);
    channel.sinkAdd(
      ToClient.broadcastInfo(channel.getJoinedBroads().toList()).encoded(),
    );
    // channel.sinkAdd();
  }

  void leaveArena(SessionChannel session) {
    final userId = session.userId;
    final channel = channels[userId];
    channel?.onSubscriptionCancel(blocId);
    channel?.sinkAdd(ToClient.terminatedBroadcast(blocId).encoded());
  }
}
