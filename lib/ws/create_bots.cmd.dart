import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';

import '../features/auth/application/session_socket.dart';
import '../features/auth/application/system_orchestrator.dart';
import 'ws_cmd.dart';

class CreateBotsCmd extends DeveloperWsCmd<CreateBotsRequest> {
  const CreateBotsCmd();

  @override
  void executeDeveloper(
    RequestContext context,
    RegisteredUserChannel channel,
    GameSocket session,
    CreateBotsRequest message,
  ) {
    context.read<SystemOrchestrator>().createBots();
    channel.sinkAdd(
      WsResponse.ack(
        n: message.n,
        status: 200,
        message: 'All ArenaBots created',
      ).toPacket(),
    );
  }
}
