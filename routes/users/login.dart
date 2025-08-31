import 'dart:async';
import 'dart:io';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:backend/models/validation/email_password_ext.dart';
import 'package:backend/modules/auth/session_repository.dart';
import 'package:backend/modules/auth/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:sha_red/sha_red.dart';
import 'package:stack_trace/stack_trace.dart';

FutureOr<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => login(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

/// Login a user
FutureOr<Response> login(RequestContext context) async {
  try {
    final body = await parseJson(context.request);
    final emailCredential = EmailCredentialDto.fromJson(body);
    emailCredential.onLoginValidated();
    final userRepo = context.read<UserRepository>();
    final sessionRepo = context.read<SessionRepository>();

    final user = await userRepo.loginUser(emailCredential);
    final session = await sessionRepo.getSession(userId: user.userId);
    debugLog('$yellow Login $reset session ${session != null}');

    final newSession = await ((session == null)
        ? sessionRepo.createSession(user)
        : sessionRepo.updateSession(session));

    stdout.writeln(
      '$magenta login return ${newSession.token} , ${newSession.refreshToken} $reset',
    );
    return Response.json(
      body: TokensDto(
        accessToken: newSession.token,
        refreshToken: newSession.refreshToken,
      ).toJson(),
      statusCode: HttpStatus.accepted,
    );
    // return _signAndSendToken(user);
  } on ApiException catch (e, stack) {
    stdout.writeln('login  ApiException ${e.errors} ${Chain.forTrace(stack)}');
    return Response.json(
      body: {'message': e.message, 'errors': e.errors},
      statusCode: e.statusCode,
    );
  } catch (e, stack) {
    stdout.writeln('login UNKNOWN ERROR ${Chain.forTrace(stack)}');
    return Response.json(
      body: {'message': 'An unexpected error occurred. Please try again later'},
      statusCode: HttpStatus.internalServerError,
    );
  }
}
