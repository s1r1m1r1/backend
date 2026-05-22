import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/application/arena_broadcast.dart';
import 'ws_cmd.dart';

class ChangeLocationCmd extends AuthenticatedWsCmd<ChangeLocationRequest> {
  const ChangeLocationCmd();

  @override
  void executeAuthenticated(
    RequestContext context,
    RegisteredUserChannel channel,
    GameSocket session,
    ChangeLocationRequest message,
  ) {
    final arenaBroadcast = context.read<ArenaBroadcast>();

    if (message.location == GameLocation.menu) {
      arenaBroadcast.leaveArena(session, message.n);
    } else if (message.location == GameLocation.arena) {
      arenaBroadcast.subscribeChannel(session, message.n);
    }

    session.sinkAdd(
      WsResponse.location(
        n: message.n,
        location: message.location,
        roomId: null,
      ).toPacket(),
    );
  }
}
