import 'dart:async' show FutureOr;

import 'package:backend/request_handler/not_allowed_request_handler.dart';
import 'package:backend/user/controller/user_controller.dart';
import 'package:dart_frog/dart_frog.dart' as frog;

FutureOr<frog.Response> onRequest(frog.RequestContext context) {
  final userController = context.read<UserController>();
  if (context.request.method != frog.HttpMethod.post) {
    return notAllowedRequestHandler(context);
  }

  return userController.store(context.request);
}
