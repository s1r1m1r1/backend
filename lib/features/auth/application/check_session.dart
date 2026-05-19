import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../core/api_exceptions.dart';
import '../../../core/debug_log.dart';
import '../../../models/user.dart';
import '../domain/session.dart';
import '../domain/session_repository.dart';
import '../domain/user_repository.dart';

typedef UserRecord = ({User user, Session session});

Future<UserRecord> checkSession(RequestContext context) async {
  final request = context.request;
  final authHeader = request.headers[HttpHeaders.authorizationHeader] ?? '';
  final token = authHeader.replaceFirst('Bearer ', '');
  debugLog('token: $token');
  if (token.isEmpty) {
    debugLog('token is null');
    throw const ApiException.unauthorized(
      message: 'Session token must not be empty',
    );
  }
  final sessionRepository = context.read<SessionRepository>();
  final session = await sessionRepository.getSession(token: token);
  if (session == null) {
    throw const ApiException.unauthorized(
      message: 'Session by token not found',
    );
  }
  final isTokenValid = sessionRepository.validateToken(session);
  if (!isTokenValid) {
    throw const ApiException.unauthorized(message: 'Token is expired');
  }

  final user = await context.read<UserRepository>().getUser(
    userId: session.user.userId,
  );
  if (user == null) {
    throw const ApiException.unauthorized(message: 'User by token not found');
  }
  // Attach userId to context for downstream handlers
  return (user: user, session: session);
}
