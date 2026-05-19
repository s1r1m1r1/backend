import 'dart:async';

import 'package:dart_frog/dart_frog.dart' hide Request;
import 'package:dto/dto.dart';

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
