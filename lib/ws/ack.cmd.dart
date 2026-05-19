import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../core/debug_log.dart';
import '../features/auth/application/online_repository_impl.dart';
import '../features/auth/application/session_socket.dart';
import 'ws_cmd.dart';

class AckCmd extends WsCmd<AckRequest> {
  const AckCmd();

  @override
  void execute(
    RequestContext context,
    UserChannel channel,
    AckRequest message,
  ) {
    final userId = channel.userId;
    final socketId = userId; // UserId реализует SocketId

    final session = context.read<OnlineRepository>().getSessionSINK(userId);
    if (session != null) {
      session.handleAck(message);
      session.lastActiveTime = DateTime.now();

      // Если есть pending-переход — коммитим подписку атомарно
      if (session.pendingTransitionRoom != null) {
        debugLog(
          '[AckCmd] committing transition → ${session.pendingTransitionRoom}',
        );
        session.commitPendingTransition();
      }
    }

    final ackRequest = message.ts ?? DateTime.now().millisecondsSinceEpoch;

    debugLog(
      '[AckCmd] ack from $socketId '
      'n=${message.n} status=${message.status} '
      'ts=$ackRequest message=${message.message ?? ''}',
    );
  }
}
