import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/application/combat_supervisor.dart';
import 'ws_cmd.dart';

class FocusCombatObserverCmd
    extends DeveloperWsCmd<FocusCombatObserverRequest> {
  const FocusCombatObserverCmd();

  @override
  void executeDeveloper(
    RequestContext context,
    RegisteredUserChannel channel,
    GameSocket session,
    FocusCombatObserverRequest message,
  ) {
    context.read<CombatSupervisor>().focusObserver(session, message.room);
  }
}
