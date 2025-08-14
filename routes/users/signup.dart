import 'dart:async' show FutureOr;
import 'dart:io';

import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/models/validation/email_password_ext.dart';
import 'package:backend/user/session_repository.dart';
import 'package:backend/user/user_repository.dart';
import 'package:dart_frog/dart_frog.dart' as frog;
import 'package:dart_frog/dart_frog.dart';
import 'package:sha_red/sha_red.dart';
import 'package:stack_trace/stack_trace.dart';

FutureOr<frog.Response> onRequest(frog.RequestContext context) {
  return switch (context.request.method) {
    frog.HttpMethod.post => signup(context),
    _ => Future.value(frog.Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

FutureOr<Response> signup(RequestContext context) async {
  try {
    final body = await parseJson(context.request);
    stdout.writeln('$magenta signup 1$reset');
    final emailCredential = EmailCredentialDto.fromJson(body);
    emailCredential.onCreateValidated();

    stdout.writeln('$magenta signup 2$reset');
    final userRepository = context.read<UserRepository>();

    stdout.writeln('$magenta signup 3$reset');
    final user = await userRepository.createUser(emailCredential);

    stdout.writeln('$magenta signup 4$reset');
    final sessionRepository = context.read<SessionRepository>();
    final session = await sessionRepository.createSession(user);

    stdout.writeln('$magenta signup return ${session.token} ${session.refreshToken} $reset');
    return Response.json(
      body: TokensDto(
        AccessTokenDto(session.token),
        RefreshTokenDto(session.refreshToken),
      ).toJson(),
      statusCode: HttpStatus.created,
    );
  } on ApiException catch (e, stack) {
    stdout.writeln('$red signup err $reset ${stack}');
    return Response.json(
      body: {'message': e.message, 'errors': e.errors},
      statusCode: e.statusCode,
    );
  } catch (e, stack) {
    stdout.writeln('$magenta signup UNKNOWN ERROR $reset ${Chain.forTrace(stack)}');
    return Response.json(
      body: {'message': 'An unexpected error occurred. Please try again later'},
      statusCode: HttpStatus.internalServerError,
    );
  }
}
