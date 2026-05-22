import 'dart:async';

import 'package:dart_frog/dart_frog.dart' hide Request;
import 'package:dto/dto.dart';

import '../core/rate_limit_tier_mapping.dart';
import '../core/rate_limiter.dart';
import '../features/auth/application/online_repository_impl.dart';
import '../features/auth/application/session_socket.dart';

abstract class WsCmd<T extends WsRequest> {
  const WsCmd();
  FutureOr<void> execute(
    RequestContext context,
    UserChannel channel,
    T message,
  );
}

abstract class AuthenticatedWsCmd<T extends WsRequest> extends WsCmd<T> {
  const AuthenticatedWsCmd();

  @override
  FutureOr<void> execute(
    RequestContext context,
    UserChannel channel,
    T message,
  ) async {
    final userId = channel.userId;
    // 1. Сначала пытаемся получить сессию, если userId существует
    final session = userId != null
        ? context.read<OnlineRepository>().getSessionSINK(userId)
        : null;
    // 2. Если userId нет ИЛИ сессия не найдена — закрываем канал и выходим
    if (session == null) {
      await channel.close(
        WebSocketCloseCode.sessionNotFound.code,
        WebSocketCloseCode.sessionNotFound.message,
      );
      return; // Важно: останавливаем дальнейшее выполнение метода!
    }
    final unitId = session.unitId;
    session.lastActiveTime = DateTime.now();

    // Per-tier rate limiting via centralized RateLimiter.
    final rateLimiter = context.read<RateLimiter>();
    final tier = message.rateLimitTier;
    if (rateLimiter.isRateLimitedByTier(userId!, tier)) {
      final penalty = rateLimiter.recordViolation(userId);
      final errorResponse = WsResponse.rateLimitError(
        n: Noun('rate_limit_${penalty.name}'),
        error: RateLimitErrorResponse(
          type: 'rate_limit_exceeded',
          message: 'Превышен лимит запросов. Пожалуйста, подождите.',
          retryAfterMs: 1000,
          penaltyLevel: penalty.value,
          currentViolationCount: rateLimiter.getViolationCount(userId),
          commandType: message.runtimeType.toString(),
          muteRemainingMs: rateLimiter.getMuteRemainingMs(userId),
        ),
      );
      channel.sinkAdd(errorResponse.toPacket());
      return;
    }

    return executeAuthenticated(
      context,
      RegisteredUserChannel(channel, userId, unitId),
      session,
      message,
    );
  }

  FutureOr<void> executeAuthenticated(
    RequestContext context,
    RegisteredUserChannel channel,
    GameSocket session,
    T message,
  );
}

abstract class DeveloperWsCmd<T extends WsRequest>
    extends AuthenticatedWsCmd<T> {
  const DeveloperWsCmd();

  @override
  FutureOr<void> executeAuthenticated(
    RequestContext context,
    RegisteredUserChannel channel,
    GameSocket session,
    T message,
  ) async {
    if (session.session.user.role != Role.develop) {
      await channel.close(
        WebSocketCloseCode.forbidden.code,
        WebSocketCloseCode.forbidden.message,
      );
      return;
    }
    return executeDeveloper(context, channel, session, message);
  }

  FutureOr<void> executeDeveloper(
    RequestContext context,
    RegisteredUserChannel channel,
    GameSocket session,
    T message,
  );
}
