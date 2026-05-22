import 'dart:async';
import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/online_repository_impl.dart';
import '../features/auth/application/session_socket.dart';
import 'ws_cmd.dart';

class PingCmd extends WsCmd<PingRequest> {
  const PingCmd();

  @override
  FutureOr<void> execute(
    RequestContext context,
    UserChannel channel,
    PingRequest message,
  ) {
    if (channel.unitId == null) return null;
    // Optionally update lastActiveTime if session exists
    final session = context.read<OnlineRepository>().getSessionSINK(
      channel.userId!,
    );
    session?.lastActiveTime = DateTime.now();

    // Always respond with pong to keep the connection alive
    channel.sinkAdd(
      WsResponse.pong(
        n: message.n,
        ts: DateTime.now().millisecondsSinceEpoch,
      ).toPacket(),
    );
  }
}
