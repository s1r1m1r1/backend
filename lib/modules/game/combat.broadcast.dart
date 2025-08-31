import 'dart:async';

import 'package:backend/core/broadcast.dart';
import 'package:backend/core/session_channel.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/modules/auth/session_repository.dart';
import 'package:backend/modules/game/domain/active_sessions_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';
import 'package:synchronized/synchronized.dart';

@injectable
class CombatBroadcast extends Broadcast<ToClient> {
  final _lock = Lock();
  final ActiveUsersRepository _activeUsersRepository;
  final SessionRepository _sessionRepository;
  final UnitRepository _unitRepository;
  CombatBroadcast(
    this._activeUsersRepository,
    this._sessionRepository,
    this._unitRepository,
    @factoryParam int edictId,
    @factoryParam EdictDto edict,
  ) : blocId = BroadcastId(family: BroadcastFamily.combat, id: edictId),
      _edict = edict;

  @override
  late BroadcastId blocId;

  final EdictDto _edict;
  Timer? _timer;

  void subscribeEdict() async {
    for (final member in _edict.members) {
      final SessionChannel? session = _activeUsersRepository.getSessionChannel(
        member.userId,
      );
      if (session == null) {
        final unit = await _unitRepository.getSelectedUnit(member.userId);
        final session = _sessionRepository.getSession(userId: member.userId);
        // final gameSession = SessionChannel(session!, channel)
        // final session = (unit);
        // todo bot for unit
        continue;
      }
      subscribe(session);
      session.shouldUnsubscribe[blocId] = () => unsubscribe(session);
    }
  }

  // void leaveCombat(SessionChannel session) {
  //   final userId = session.userId;
  //   final channel = channels[userId];
  //   channel?.onSubscriptionCancel(blocId);
  //   channel?.sinkAdd(ToClient.terminatedBroadcast(blocId).encoded());
  // }
}
