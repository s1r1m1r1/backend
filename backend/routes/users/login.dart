import 'dart:async';
import 'dart:io';

import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/models/login_user_dto.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:backend/models/user.dart';
import 'package:backend/session/session_repository.dart';
import 'package:backend/user/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shared/shared.dart';

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

    final loginUser = LoginUserDto.validated(body);

    final userRepo = context.read<UserRepository>();

    final sessionRepo = context.read<SessionRepository>();

    final user = await userRepo.loginUser(loginUser);

    final session = await sessionRepo.createSession(user.userId);
    return Response.json(
      body: TokenDto(accessToken: session.token, refreshToken: session.refreshToken).toJson(),

      statusCode: HttpStatus.accepted,
    );
    // return _signAndSendToken(user);
  } on ApiException catch (e, stack) {
    stdout.writeln('login  ApiException ${e.errors} ${stack}');
    return Response.json(body: {'message': e.message, 'errors': e.errors}, statusCode: e.statusCode);
  } catch (e, stack) {
    stdout.writeln('login UNKNOWN ERROR ${stack}');
    return Response.json(
      body: {'message': 'An unexpected error occurred. Please try again later'},
      statusCode: HttpStatus.internalServerError,
    );
  }
}
