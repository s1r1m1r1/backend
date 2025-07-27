import 'dart:io';

import 'package:backend/request_handler/not_allowed_request_handler.dart';
import 'package:dart_frog/dart_frog.dart';

Handler onRequest = (RequestContext context) async {
  return Response.json(body: {'error': '👀 Looks like you are lost 🔦'}, statusCode: HttpStatus.methodNotAllowed);
};
