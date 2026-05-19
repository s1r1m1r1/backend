import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/application/combat_supervisor.dart';
import 'ws_cmd.dart';

class JoinAsCombatObserverCmd
    extends AuthenticatedWsCmd<JoinAsCombatObserverTs> {
  const JoinAsCombatObserverCmd();

  @override
  void executeAuthenticated(
    RequestContext context,
    UserChannel channel,
    GameSocket session,
    JoinAsCombatObserverTs message,
  ) {
    context.read<CombatSupervisor>().subscribeObserver(session);
  }
}
