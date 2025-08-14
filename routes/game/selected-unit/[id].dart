import 'dart:async';
import 'dart:io';

import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/user/http_check_session_.dart';
import 'package:backend/models/validation/map_to_int.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.put:
    case HttpMethod.patch:
    case HttpMethod.post:
      return setSelectedUnit(context, id);
    case HttpMethod.delete:
    case HttpMethod.get:
    case HttpMethod.head:
    case HttpMethod.options:
      return Response.json(
        body: {'error': '👀 Looks like you are lost 🔦'},
        statusCode: HttpStatus.methodNotAllowed,
      );
  }
}

FutureOr<Response> setSelectedUnit(RequestContext context, String id) async {
  try {
    final record = await checkSession(context);
    final user = record.$1;
    final unitRepo = context.read<UnitRepository>();
    final unitId = mapToInt(id);
    stdout.writeln('TodoController update start');
    await unitRepo.setSelectedUnit(userid: user.userId, unitId: unitId);
    return Response.json();
  } on ApiException catch (e, stack) {
    stdout.writeln('TodoController err: ${stack}');
    return Response.json(
      body: {'message': e.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  } on Object catch (e, stackTrace) {
    stdout.writeln('TodoController UNKNOWN ERROR ${stackTrace}');
    return Response.json(
      body: {'message': e.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  }
}
