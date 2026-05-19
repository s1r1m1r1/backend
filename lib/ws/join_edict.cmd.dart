import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/application/arena_broadcast.dart';
import 'ws_cmd.dart';

class JoinEdictCmd extends AuthenticatedWsCmd<JoinEdictTs> {
  const JoinEdictCmd();

  @override
  void executeAuthenticated(
    RequestContext context,
    UserChannel channel,
    GameSocket session,
    JoinEdictTs message,
  ) {
    context.read<ArenaBroadcast>().joinEdict(
      session,
      message.edictId,
      message.n,
    );
  }
}
