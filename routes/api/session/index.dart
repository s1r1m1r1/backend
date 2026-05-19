import 'dart:io' show HttpStatus;

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return Response.json(
    body: {'error': '👀 Looks like you are lost 🔦'},
    statusCode: HttpStatus.methodNotAllowed,
  );
}
