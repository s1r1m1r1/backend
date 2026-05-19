import 'dart:async';
import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/online_repository_impl.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/application/arena_broadcast.dart';
import 'ws_cmd.dart';

class LeaveArenaCmd extends AuthenticatedWsCmd<LeaveArenaRequest> {
  const LeaveArenaCmd();

  @override
  FutureOr<void> execute(
    RequestContext context,
    UserChannel channel,
    LeaveArenaRequest message,
  ) async {
    final session = context.read<OnlineRepository>().getSessionSINK(
      channel.userId,
    );
    if (session == null) {
      await channel.close(
        WebSocketCloseCode.forbidden.code,
        WebSocketCloseCode.forbidden.message,
      );
      return;
    }
    context.read<ArenaBroadcast>().leaveArena(session, message.n);
  }

  @override
  void executeAuthenticated(
    RequestContext context,
    UserChannel channel,
    GameSocket session,
    LeaveArenaRequest message,
  ) {}
}
