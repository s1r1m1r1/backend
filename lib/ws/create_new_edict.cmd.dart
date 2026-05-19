import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/application/arena_broadcast.dart';
import 'ws_cmd.dart';

class CreateNewEdictCmd extends AuthenticatedWsCmd<CreateNewEdictTs> {
  const CreateNewEdictCmd();

  @override
  void executeAuthenticated(
    RequestContext context,
    UserChannel channel,
    GameSocket session,
    CreateNewEdictTs message,
  ) {
    context.read<ArenaBroadcast>().createEdict(session, message.n);
  }
}
