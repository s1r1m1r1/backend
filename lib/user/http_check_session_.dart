import 'dart:io';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/user/session.dart';
import 'package:backend/user/session_repository.dart';
import 'package:dart_frog/dart_frog.dart';

import 'package:backend/models/user.dart';
import 'package:backend/user/user_repository.dart';

import '../core/log_colors.dart';

Future<(User, Session)> checkSession(RequestContext context) async {
  final request = context.request;
  final authHeader = request.headers[HttpHeaders.authorizationHeader] ?? '';
  final token = authHeader.replaceFirst('Bearer ', '');
  debugLog("$magenta token: $token $reset");
  if (token.isEmpty) {
    debugLog("token is null");
    throw ApiException.unauthorized(message: 'Session token must not be empty');
  }
  final sessionRepository = context.read<SessionRepository>();
  final session = await sessionRepository.getSession(token: token);
  if (session == null) {
    throw ApiException.unauthorized(message: 'Session by token not found');
  }
  final isTokenValid = sessionRepository.validateToken(session);
  if (!isTokenValid) {
    throw ApiException.unauthorized(message: 'Token is expired');
  }

  final user = await context.read<UserRepository>().getUser(userId: session.user.userId);
  if (user == null) {
    throw ApiException.unauthorized(message: 'User by token not found');
  }
  // Attach userId to context for downstream handlers
  return (user, session);
}

typedef AddToContext = RequestContext Function(RequestContext context);
