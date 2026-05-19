import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/application/arena_broadcast.dart';
import 'ws_cmd.dart';

class LeaveEdictCmd extends AuthenticatedWsCmd<LeaveEdictRequest> {
  const LeaveEdictCmd();

  @override
  void executeAuthenticated(
    RequestContext context,
    UserChannel channel,
    GameSocket session,
    LeaveEdictRequest message,
  ) {
    context.read<ArenaBroadcast>().leaveEdict(session, message.n);
  }
}
