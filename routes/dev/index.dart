import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
    // return getTodos(context);
    case HttpMethod.post:
    // return postTodo(context);
    case HttpMethod.put:
    case HttpMethod.patch:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
      return Response.json(
        body: {'error': '👀 Looks like you are lost 🔦'},
        statusCode: HttpStatus.methodNotAllowed,
      );
  }
}
