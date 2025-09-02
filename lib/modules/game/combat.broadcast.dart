import 'dart:async';

import 'package:backend/core/broadcast.dart';
import 'package:backend/core/inject.dart';
import 'package:backend/modules/game/game_bot.dart';
import 'package:backend/modules/game/session_channel.dart';
import 'package:backend/game/unit.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/modules/auth/session.dart';
import 'package:backend/modules/auth/session_repository.dart';
import 'package:backend/modules/auth/user_repository.dart';
import 'package:backend/modules/game/domain/active_sessions_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';
import 'package:synchronized/synchronized.dart';

@injectable
class CombatBroadcast extends Broadcast<ToClient> {
  late final _lock = Lock();
  final ActiveUsersRepository _onlineRep;
  final SessionRepository _sessionRep;
  final UserRepository _userRep;
  final UnitRepository _unitRep;
  CombatBroadcast(
    this._onlineRep,
    this._sessionRep,
    this._unitRep,
    this._userRep,
    @factoryParam int edictId,
    @factoryParam EdictDto edict,
  ) : blocId = BroadcastId(family: BroadcastFamily.combat, id: edictId),
      _edict = edict;

  @override
  late BroadcastId blocId;

  final EdictDto _edict;
  final combatants = <CombatantDto>[];
  final teams = <CombatantTeamDto>[];
  //
  CombatDto? combatDto;
  // final GameSession currentSession;
  Timer? _timer;

  void subscribeEdict() async {
    // final teams = List.generate(
    //   2,
    //   (index) => CombatantTeamDto(id: index, combatantIds: const <int>[]),
    // );
    for (var i = 0; i < _edict.members.length; i++) {
      final member = _edict.members[i];
      SessionChannel? sessionChannel = await _onlineRep.getSessionChannel(
        member.userId,
      );

      if (sessionChannel == null) {
        final gameSession = await _recoverySession(member.userId);
        if (gameSession == null) continue;
        final recoverSession = await _sessionRep.getSession(
          userId: member.userId,
        );
        if (recoverSession == null) continue;
        final bot = getIt<GameBot>();
        // await _onlineRep.startFromBot(bot, gameSession);
      }
      sessionChannel ??= await _onlineRep.getSessionChannel(member.userId);
      if (sessionChannel == null) {
        throw Exception('Missed session while start combat ');
      }
      final uCombatant = CombatantDto(
        id: i,
        teamId: 0,
        unit: sessionChannel.session.unit.toDto(),
        unitId: sessionChannel.session.unit.id,
        maxLife: 100,
        life: 100,
        damage: 11,
      );
      combatants.add(uCombatant);
    }
    if (combatants.isEmpty) {
      // удалить комнату
      return;
    }
    if (combatants.length == 1) {
      final sessionChannel = await _onlineRep.getSessionChannel(
        combatants.first.unitId,
      );
      // if (sessionChannel?.isBot ?? true) {
      //   // удалить комнату
      //   return;
      // }
      // сообщить пользователю что игра не может начаться
      sessionChannel!.sinkAdd(
        ToClient.combatError(
          error: WsCombatError.notEnoughPlayers,
        ).jsonBarrel(),
      );
      return;
    }
    // начинаем игру

    // subscribe(session);
    // session.shouldUnsubscribe[blocId] = () => unsubscribe(session);
  }

  FutureOr<GameSession?> _recoverySession(int userId) async {
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

  // void leaveCombat(SessionChannel session) {
  //   final userId = session.userId;
  //   final channel = channels[userId];
  //   channel?.onSubscriptionCancel(blocId);
  //   channel?.sinkAdd(ToClient.terminatedBroadcast(blocId).encoded());
  // }
}
