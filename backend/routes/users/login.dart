import 'dart:async';
import 'dart:io';

import 'package:backend/models/login_user_dto.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:backend/session/session_repository.dart';
import 'package:backend/user/repository/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => login(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

/// Login a user
FutureOr<Response> login(RequestContext context) async {
  try {
    final parsedBody = await parseJson(context.request);
    stdout.writeln('login parsedBody start');
    final userRepo = context.read<UserRepository>();
    final sessionRepo = context.read<SessionRepository>();

    stdout.writeln('login parsedBody right');
    final loginUserDto = LoginUserDto.validated(parsedBody);
    stdout.writeln('login loginUserDto success');
    final user = await userRepo.loginUser(loginUserDto);
    final session = await sessionRepo.createSession(user.userId);
    return Response.json(body: {'token': session.token, 'user': user.toJson()}, statusCode: HttpStatus.created);
    // return _signAndSendToken(user);
  } catch (e, stack) {
    stdout.writeln('UserController UNKNOWN ERROR ${stack}');
    return Response.json(body: {'message': e.toString()}, statusCode: HttpStatus.internalServerError);
  }
}
