import 'dart:async';
import 'dart:io';

import 'package:backend/models/login_user_dto.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:backend/models/user.dart';
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
    stdout.writeln('login start');
    final body = await parseJson(context.request);

    stdout.writeln('login 1');
    final loginUser = LoginUserDto.validated(body);

    stdout.writeln('login 2');
    final userRepo = context.read<UserRepository>();

    stdout.writeln('login 3');
    final sessionRepo = context.read<SessionRepository>();

    stdout.writeln('login 4');
    final user = await userRepo.loginUser(loginUser);

    stdout.writeln('login 5');
    final session = await sessionRepo.createSession(user.userId);
    final userDto = UserDto.fromUser(user);
    stdout.writeln('login 6');
    return Response.json(body: {'token': session.token, 'user': userDto.toJson()}, statusCode: HttpStatus.created);
    // return _signAndSendToken(user);
  } catch (e, stack) {
    stdout.writeln('UserController UNKNOWN ERROR ${stack}');
    return Response.json(body: {'message': e.toString()}, statusCode: HttpStatus.internalServerError);
  }
}
