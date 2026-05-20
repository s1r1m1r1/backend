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
    final session = context.read<OnlineRepository>().getSessionSINK(
      channel.userId,
    );
    if (session == null) {
      await channel.close(
        WebSocketCloseCode.sessionNotFound.code,
        WebSocketCloseCode.sessionNotFound.message,
      );
      return;
    }
    session.lastActiveTime = DateTime.now();

    // Per-tier rate limiting via centralized RateLimiter.
    final rateLimiter = context.read<RateLimiter>();
    final tier = message.rateLimitTier;
    if (rateLimiter.isRateLimitedByTier(channel.userId, tier)) {
      final penalty = rateLimiter.recordViolation(channel.userId);
      final errorResponse = WsResponse.rateLimitError(
        n: 'rate_limit_${penalty.name}',
        error: RateLimitErrorResponse(
          type: 'rate_limit_exceeded',
          message: 'Превышен лимит запросов. Пожалуйста, подождите.',
          retryAfterMs: 1000,
          penaltyLevel: penalty.value,
          currentViolationCount: rateLimiter.getViolationCount(channel.userId),
          commandType: message.runtimeType.toString(),
          muteRemainingMs: rateLimiter.getMuteRemainingMs(channel.userId),
        ),
      );
      channel.sinkAdd(EncodedPacket(errorResponse, errorResponse.n));
      return;
    }

    return executeAuthenticated(context, channel, session, message);
  }

  FutureOr<void> executeAuthenticated(
    RequestContext context,
    UserChannel channel,
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
    UserChannel channel,
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
    UserChannel channel,
    GameSocket session,
    T message,
  );
}
