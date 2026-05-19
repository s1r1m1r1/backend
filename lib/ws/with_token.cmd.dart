import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/presence_manager.dart';
import '../features/auth/application/session_socket.dart';
import 'ws_cmd.dart';

class WithTokenCmd extends WsCmd<WithTokenTs> {
  const WithTokenCmd();
  @override
  Future<void> execute(
    RequestContext context,
    UserChannel channel,
    WithTokenTs message,
  ) async {
    await context.read<PresenceManager>().join(
      channel,
      message.token,
      message.n,
    );
  }
}
