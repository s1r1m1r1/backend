import 'dart:async';
import 'dart:io';

import 'package:backend/user/controller/user_controller.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) {
  final userController = context.read<UserController>();
  return switch (context.request.method) {
    HttpMethod.post => userController.login(context.request),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}
