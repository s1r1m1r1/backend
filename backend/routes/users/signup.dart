import 'dart:async' show FutureOr;
import 'dart:io';

import 'package:backend/exceptions/new_api_exceptions.dart';
import 'package:backend/models/create_user_dto.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:backend/models/user.dart';
import 'package:backend/services/jwt_service.dart';
import 'package:backend/session/session_repository.dart';
import 'package:backend/user/controller/user_controller.dart';
import 'package:backend/user/repository/user_repository.dart';
import 'package:dart_frog/dart_frog.dart' as frog;
import 'package:dart_frog/dart_frog.dart';

FutureOr<frog.Response> onRequest(frog.RequestContext context) {
  return switch (context.request.method) {
    frog.HttpMethod.post => signup(context),
    _ => Future.value(frog.Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

FutureOr<Response> signup(RequestContext context) async {
  try {
    final body = await parseJson(context.request);
    final createUser = CreateUserDto.validated(body);
    final userRepository = context.read<UserRepository>();

    final user = await userRepository.createUser(createUser);

    final sessionRepository = context.read<SessionRepository>();
    final session = await sessionRepository.createSession(user.userId);
    final userDto = UserDto.fromUser(user);
    return Response.json(body: {'token': session.token, 'user': userDto.toJson()}, statusCode: HttpStatus.created);
  } on ApiException catch (e, stack) {
    stdout.writeln('signup  ApiException ${e.errors} ${stack}');
    return Response.json(body: {'message': e.message, 'errors': e.errors}, statusCode: e.statusCode);
  } catch (e, stack) {
    stdout.writeln('signup UNKNOWN ERROR ${stack}');
    return Response.json(
      body: {'message': 'An unexpected error occurred. Please try again later'},
      statusCode: HttpStatus.internalServerError,
    );
  }
}

Response _signAndSendToken(JWTService jwtService, User user, [int? httpStatus]) {
  final token = jwtService.sign(user.toJson());
  final userDto = UserDto.fromUser(user);
  return Response.json(body: {'token': token, 'user': userDto.toJson()}, statusCode: HttpStatus.created);
}
