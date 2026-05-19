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
  return signup(context);
}

Future<Response> signup(RequestContext context) async {
  final body = await parseJson(context.request);
  final emailCredential = EmailCredentialDto.fromJson(body);

  // Выбрасывает ApiException при неудаче
  emailCredential.onCreateValidated();

  final userRepository = context.read<UserRepository>();
  final user = await userRepository.createUser(emailCredential);

  final sessionRepository = context.read<SessionRepository>();
  final session = await sessionRepository.createSession(user);

  return Response.json(
    body: TokensDto(
      accessToken: session.token,
      refreshToken: session.refreshToken,
    ).toJson(),
    statusCode: HttpStatus.accepted,
  );
}
