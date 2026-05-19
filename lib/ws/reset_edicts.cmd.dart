import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/application/arena_broadcast.dart';
import 'ws_cmd.dart';

class ResetEdictsCmd extends DeveloperWsCmd<ResetEdictsTs> {
  const ResetEdictsCmd();

  @override
  void executeDeveloper(
    RequestContext context,
    UserChannel channel,
    GameSocket session,
    ResetEdictsTs message,
  ) {
    context.read<ArenaBroadcast>().reset();
    channel.sinkAdd(
      WsResponse.ack(
        n: message.n,
        status: 200,
        message: 'Combats reset',
      ).toPacket(),
    );
  }
}
