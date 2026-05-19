import 'dart:io';

import 'package:backend/features/auth/domain/session_repository.dart';
import 'package:backend/features/auth/domain/user_repository.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:backend/models/validation/email_password_ext.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
  return login(context);
}

/// Login a user
Future<Response> login(RequestContext context) async {
  final body = await parseJson(context.request);
  final emailCredential = EmailCredentialDto.fromJson(body);

  // Выбрасывает ApiException при неудаче
  emailCredential.onLoginValidated();

  final userRepo = context.read<UserRepository>();
  final sessionRepo = context.read<SessionRepository>();

  final user = await userRepo.loginUser(emailCredential);
  final session = await sessionRepo.getSession(userId: user.userId);

  final newSession = await ((session == null)
      ? sessionRepo.createSession(user)
      : sessionRepo.updateSession(session));

  return Response.json(
    body: TokensDto(
      accessToken: newSession.token,
      refreshToken: newSession.refreshToken,
    ).toJson(),
    statusCode: HttpStatus.accepted,
  );
}
