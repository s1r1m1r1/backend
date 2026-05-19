import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../core/debug_log.dart';
import '../features/auth/application/presence_manager.dart';
import '../features/auth/application/session_socket.dart';
import 'ws_cmd.dart';

class DisconnectCmd extends WsCmd<DisconnectTs> {
  const DisconnectCmd();
  @override
  void execute(
    RequestContext context,
    UserChannel channel,
    DisconnectTs message,
  ) {
    debugLog('[WebSocket] Disconnect: replace by BOT');
    context.read<PresenceManager>().removeUser(channel, message.n);
  }
}
