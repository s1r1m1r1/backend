import 'dart:async';
import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/application/combat_supervisor.dart';
import 'ws_cmd.dart';

class JoinBattleRoomCmd extends AuthenticatedWsCmd<JoinBattleRoomRequest> {
  const JoinBattleRoomCmd();

  @override
  Future<void> executeAuthenticated(
    RequestContext context,
    RegisteredUserChannel channel,
    GameSocket session,
    JoinBattleRoomRequest message,
  ) async {
    await context.read<CombatSupervisor>().combatReady(
      session,
      message.combatRoomId,
      message.n,
    );
  }
}
