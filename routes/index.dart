import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Handler onRequest = (RequestContext context) async {
  return Response.json(
    body: {'error': '👀 Looks like you are lost 🔦'},
    statusCode: HttpStatus.methodNotAllowed,
  );
};
