import 'dart:async';
import 'dart:io';

import 'package:backend/core/log_colors.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/models/login_user_dto.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:backend/models/user.dart';
import 'package:backend/session/session_repository.dart';
import 'package:backend/user/user_repository.dart';
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
    stdout.writeln('$magenta login 1$reset');
    final loginUser = LoginUserDto.validated(body);

    stdout.writeln('$magenta login 2$reset');
    final userRepo = context.read<UserRepository>();

    stdout.writeln('$magenta login 3$reset');
    final sessionRepo = context.read<SessionRepository>();

    stdout.writeln('$magenta login 4$reset');
    final user = await userRepo.loginUser(loginUser);

    stdout.writeln('$magenta login 5$reset');
    final session = await sessionRepo.createSession(user.userId);
    stdout.writeln('$magenta login return ${session.token} , ${session.refreshToken} $reset');
    return Response.json(
      body: TokenDto(accessToken: session.token, refreshToken: session.refreshToken).toJson(),

      statusCode: HttpStatus.accepted,
    );
    // return _signAndSendToken(user);
  } on ApiException catch (e, stack) {
    stdout.writeln('login  ApiException ${e.errors} ${Chain.forTrace(stack)}');
    return Response.json(body: {'message': e.message, 'errors': e.errors}, statusCode: e.statusCode);
  } catch (e, stack) {
    stdout.writeln('login UNKNOWN ERROR ${Chain.forTrace(stack)}');
    return Response.json(
      body: {'message': 'An unexpected error occurred. Please try again later'},
      statusCode: HttpStatus.internalServerError,
    );
  }
}
