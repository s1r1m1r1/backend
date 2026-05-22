import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/application/combat_supervisor.dart';
import 'ws_cmd.dart';

class ResetCombatsCmd extends DeveloperWsCmd<ResetCombatsRequest> {
  const ResetCombatsCmd();

  @override
  void executeDeveloper(
    RequestContext context,
    RegisteredUserChannel channel,
    GameSocket session,
    ResetCombatsRequest message,
  ) {
    context.read<CombatSupervisor>().reset();
    channel.sinkAdd(
      WsResponse.ack(
        n: message.n,
        status: 200,
        message: 'Combats reset',
      ).toPacket(),
    );
  }
}
