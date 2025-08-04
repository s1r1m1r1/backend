import 'dart:async';
import 'dart:io';

import 'package:backend/config/ws_config_repository.dart';
import 'package:backend/models/user.dart';
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
    stdout.writeln('getConfig 1');
    final user = context.read<User>();

    stdout.writeln('getConfig 2');
    final configRepo = context.read<WsConfigRepository>();

    stdout.writeln('getConfig 3');
    final config = await configRepo.getConfig(user.role);

    stdout.writeln('getConfig 4');
    return Response.json(body: config.toJson());
  } catch (e) {
    stdout.writeln('getConfig err $e');
    return Response.json(body: {'error': '👀 Looks like you are lost 🔦'}, statusCode: HttpStatus.methodNotAllowed);
  }
}
