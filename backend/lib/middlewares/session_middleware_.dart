import 'dart:io';

import 'package:backend/core/debug_log.dart';
import 'package:backend/session/session.dart';
import 'package:backend/session/session_repository.dart';
import 'package:dart_frog/dart_frog.dart';

import '../models/user.dart';
import '../user/user_repository.dart';

Handler sessionMiddleware(Handler handler, {List<AddToContext> addToContext = const <AddToContext>[]}) {
  return (context) async {
    final request = context.request;
    final authHeader = request.headers[HttpHeaders.authorizationHeader] ?? '';
    final token = authHeader.replaceFirst('Bearer ', '');
    if (token.isEmpty) {
      debugLog("token is null");
      return Response.json(body: {'message': 'Session token must not be empty'}, statusCode: HttpStatus.unauthorized);
    }
    final sessionRepository = context.read<SessionRepository>();
    final session = await sessionRepository.getSession(token: token);
    if (session == null) {
      return Response.json(body: {'message': 'Invalid or expired session token'}, statusCode: HttpStatus.unauthorized);
    }
    final isTokenValid = sessionRepository.validateToken(session);
    if (!isTokenValid) {
      return Response.json(body: {'message': 'Invalid or expired session token'}, statusCode: HttpStatus.unauthorized);
    }

    final user = await context.read<UserRepository>().getUser(userId: session.userId);
    if (user == null) {
      return Response.json(body: {'message': 'User not found'}, statusCode: HttpStatus.unauthorized);
    }
    // Attach userId to context for downstream handlers
    var updatedContext = context.provide<Session>(() => session);
    updatedContext = updatedContext.provide<User>(() => user);
    addToContext.forEach((addToContext) {
      updatedContext = addToContext(updatedContext);
    });
    debugLog('sessionMiddleware user ${user.email}');
    return handler(updatedContext);
  };
}

typedef AddToContext = RequestContext Function(RequestContext context);
