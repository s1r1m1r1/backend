import 'dart:async';
import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/online_repository_impl.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/application/arena_broadcast.dart';
import 'ws_cmd.dart';

class ChangeLocationCmd extends AuthenticatedWsCmd<ChangeLocationTs> {
  const ChangeLocationCmd();

  @override
  FutureOr<void> execute(
    RequestContext context,
    UserChannel channel,
    ChangeLocationTs message,
  ) async {
    final session = context.read<OnlineRepository>().getSessionSINK(
      channel.userId,
    );
    if (session == null) {
      return;
    }

    if (message.location == GameLocation.menu) {
      context.read<ArenaBroadcast>().leaveArena(session, message.n);
    } else if (message.location == GameLocation.arena) {
      context.read<ArenaBroadcast>().subscribeChannel(session, message.n);
    }

    // Send the location change back to the client
    session.sinkAdd(
      WsResponse.location(
        n: message.n,
        location: message.location,
        roomId: null,
      ).toPacket(),
    );
  }

  @override
  void executeAuthenticated(
    RequestContext context,
    UserChannel channel,
    GameSocket session,
    ChangeLocationTs message,
  ) {}
}
