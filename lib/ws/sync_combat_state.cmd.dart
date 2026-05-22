import 'dart:async';
import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/application/combat_supervisor.dart';
import 'ws_cmd.dart';

class SyncCombatStateCmd extends AuthenticatedWsCmd<SyncCombatStateRequest> {
  const SyncCombatStateCmd();

  @override
  Future<void> executeAuthenticated(
    RequestContext context,
    RegisteredUserChannel channel,
    GameSocket session,
    SyncCombatStateRequest message,
  ) async {
    await context.read<CombatSupervisor>().syncCombatState(session, message);
  }
}
