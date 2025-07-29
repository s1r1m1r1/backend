import 'dart:async' show FutureOr;
import 'dart:io';

import 'package:backend/exceptions/new_api_exceptions.dart';
import 'package:backend/models/create_user_dto.dart';
import 'package:backend/models/user.dart';
import 'package:backend/services/jwt_service.dart';
import 'package:backend/user/controller/user_controller.dart';
import 'package:backend/user/repository/user_repository.dart';
import 'package:dart_frog/dart_frog.dart' as frog;
import 'package:dart_frog/dart_frog.dart';

FutureOr<frog.Response> onRequest(frog.RequestContext context) {
  final userController = context.read<UserController>();

  return switch (context.request.method) {
    frog.HttpMethod.post => userController.store(context.request),
    _ => Future.value(frog.Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

FutureOr<Response> signup(RequestContext context) async {
  stdout.writeln('store store ');

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final createTodoDto = CreateUserDto.validated(body);
    final userRepository = context.read<UserRepository>();
    final jwtService = context.read<JWTService>();
    // final sessionRepository = context.read<SessionRepository>();
    final user = await userRepository.createUser(createTodoDto);
    stdout.writeln('store res right');
    return _signAndSendToken(jwtService, user, HttpStatus.created);
  } on ApiException catch (e) {
    // stdout.writeln('UserController  ${e.errors}');
    return Response.json(body: {'message': e.message, 'errors': e.errors}, statusCode: e.statusCode);
  } catch (e, stack) {
    stdout.writeln('UserController UNKNOWN ERROR ${stack}');
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
