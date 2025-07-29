import 'dart:io';

import 'package:backend/session/session_repository.dart';
import 'package:backend/user2/session_repository.dart';
import 'package:backend/user2/user_repository2.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _authenticationUser(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _authenticationUser(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final username = body['username'] as String?;
  final password = body['password'] as String?;

  final userRepository = context.read<UserRepository2>();
  final sessionRepository = context.read<SessionRepository>();

  if (username != null && password != null) {
    final user = await userRepository.userFromCredentials(username, password);

    if (user == null) {
      return Response(statusCode: HttpStatus.unauthorized);
    } else {
      final session = await sessionRepository.createSession(user.id);
      return Response.json(body: {'token': session.token});
    }
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}
