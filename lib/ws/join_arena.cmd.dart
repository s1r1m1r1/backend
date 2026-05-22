import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/application/arena_broadcast.dart';
import 'ws_cmd.dart';

class JoinArenaCmd extends AuthenticatedWsCmd<JoinArenaRequest> {
  const JoinArenaCmd();

  @override
  void executeAuthenticated(
    RequestContext context,
    RegisteredUserChannel channel,
    GameSocket session,
    JoinArenaRequest message,
  ) {
    context.read<ArenaBroadcast>().subscribeChannel(session, message.n);
  }
}
