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
    final UserId? userId = channel.userId;

    // 1. Быстрый выход, если канал не привязан к пользователю
    if (userId == null) {
      debugLog('[AckCmd] Rejected: channel has no userId');
      return;
    }

    // 2. Здесь userId гарантированно не-null. Запрашиваем сессию один раз.
    final session = context.read<OnlineRepository>().getSessionSINK(userId);

    // 3. Быстрый выход, если сессия в репозитории не найдена
    if (session == null) {
      debugLog('[AckCmd] Rejected: session not found for user $userId');
      return;
    }

    // 4. Основная логика: session и userId гарантированно валидны
    session.handleAck(message);
    session.lastActiveTime = DateTime.now();

    // Если есть pending-переход — коммитим подписку атомарно
    if (session.pendingTransitionRoom != null) {
      debugLog(
        '[AckCmd] committing transition → ${session.pendingTransitionRoom}',
      );
      session.commitPendingTransition();
    }

    final ackRequest = message.ts ?? DateTime.now().millisecondsSinceEpoch;

    debugLog(
      '[AckCmd] ack from $userId ' // Используем напрямую userId, так как он не null
      'n=${message.n} status=${message.status} '
      'ts=$ackRequest message=${message.message ?? ''}',
    );
  }
}
