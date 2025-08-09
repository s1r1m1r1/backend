import 'dart:async';
import 'dart:io';

import '../../lib/config/ws_config_repository.dart';
import '../../lib/models/user.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return getConfig(context);
    case HttpMethod.post:
    case HttpMethod.put:
    case HttpMethod.patch:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
      return Response.json(body: {'error': '👀 Looks like you are lost 🔦'}, statusCode: HttpStatus.methodNotAllowed);
  }
}

FutureOr<Response> getConfig(RequestContext context) async {
  try {
    final user = context.read<User>();

    final configRepo = context.read<WsConfigRepository>();

    final config = await configRepo.getConfig(user.role);

    return Response.json(body: config.toJson());
  } catch (e) {
    stdout.writeln('getConfig err $e');
    return Response.json(body: {'error': '👀 Looks like you are lost 🔦'}, statusCode: HttpStatus.methodNotAllowed);
  }
}
