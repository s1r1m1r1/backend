import 'dart:io';

import 'package:backend/session/session_repository.dart';
import 'package:dart_frog/dart_frog.dart';

import '../session/session.dart';

Handler sessionMiddleware(Handler handler) {
  return (context) async {
    final request = context.request;
    final authHeader = request.headers[HttpHeaders.authorizationHeader] ?? '';
    final token = authHeader.replaceFirst('Bearer ', '');
    if (token.isEmpty) {
      return Response.json(body: {'message': 'Session token must not be empty'}, statusCode: HttpStatus.unauthorized);
    }
    final sessionRepository = context.read<SessionRepository>();
    final session = await sessionRepository.getSession(token: token);
    if (session == null) {
      return Response.json(body: {'message': 'Invalid or expired session token'}, statusCode: HttpStatus.unauthorized);
    }
    // Attach userId to context for downstream handlers
    final updatedContext = context.provide<Session>(() => session);
    return handler(updatedContext);
  };
}
