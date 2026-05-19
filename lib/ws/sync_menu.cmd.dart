import 'dart:async';
import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/presence_manager.dart';
import '../features/auth/application/session_socket.dart';
import 'ws_cmd.dart';

class SyncMenuCmd extends AuthenticatedWsCmd<SyncMenuRequest> {
  const SyncMenuCmd();

  @override
  FutureOr<void> executeAuthenticated(
    RequestContext context,
    UserChannel channel,
    GameSocket session,
    SyncMenuRequest message,
  ) async {
    final userId = session.session.user.userId;

    // re-trigger menu send
    await context.read<PresenceManager>().sendMenu(userId, message.n);
  }
}
