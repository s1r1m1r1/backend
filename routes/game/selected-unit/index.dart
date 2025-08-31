import 'dart:async';
import 'dart:io';

import 'package:backend/core/log_colors.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/modules/auth/http_check_session_.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return getSelectedUnit(context);
    case HttpMethod.put:
    case HttpMethod.patch:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.post:
      return Response.json(
        body: {'error': '👀 Looks like you are lost 🔦'},
        statusCode: HttpStatus.methodNotAllowed,
      );
  }
}

FutureOr<Response> getSelectedUnit(RequestContext context) async {
  try {
    final record = await checkSession(context);
    final user = record.$1;
    final characterRepo = context.read<UnitRepository>();
    stdout.writeln('TodoController index start');
    final dto = await characterRepo.getSelectedUnit(user.userId);
    if (dto == null) return Response.json(statusCode: HttpStatus.notFound);
    return Response.json(body: dto.toJson());
  } on ApiException catch (e, stack) {
    stdout.writeln('$yellow geListUnit $reset ${e.statusCode} ${stack}');
    return Response.json(
      body: {'message': e.toString()},
      statusCode: e.statusCode,
    );
  } on Object catch (e, stack) {
    stdout.writeln('$yellow getListUnit $reset UNKNOWN ERROR ${stack}');
    return Response.json(
      body: {'message': e.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  }
}
