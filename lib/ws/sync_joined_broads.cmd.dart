import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/presence_manager.dart';
import '../features/auth/application/session_socket.dart';
import 'ws_cmd.dart';

class SyncJoinedBroadsCmd extends WsCmd<SyncJoinedBroadsRequest> {
  const SyncJoinedBroadsCmd();
  @override
  void execute(
    RequestContext context,
    UserChannel channel,
    SyncJoinedBroadsRequest message,
  ) {
    context.read<PresenceManager>().infoJoinedBroads(channel, message.n);
  }
}
