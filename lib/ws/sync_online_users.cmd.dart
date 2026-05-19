import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/presence_manager.dart';
import '../features/auth/application/session_socket.dart';
import 'ws_cmd.dart';

class SyncOnlineUsersCmd extends WsCmd<SyncOnlineUsers> {
  const SyncOnlineUsersCmd();
  @override
  void execute(
    RequestContext context,
    UserChannel channel,
    SyncOnlineUsers message,
  ) {
    context.read<PresenceManager>().syncOnlineUsers(channel, message.n);
  }
}
