import 'dart:async';
import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/application/combat_supervisor.dart';
import 'ws_cmd.dart';

class GameActionCmd extends AuthenticatedWsCmd<GameActionTs> {
  const GameActionCmd();

  @override
  Future<void> executeAuthenticated(
    RequestContext context,
    UserChannel channel,
    GameSocket session,
    GameActionTs message,
  ) async {
    await context.read<CombatSupervisor>().gameAction(session, message);
  }
}
