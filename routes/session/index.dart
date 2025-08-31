import 'dart:async';
import 'dart:io' show HttpStatus;

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/modules/auth/http_check_session_.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:sha_red/sha_red.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return await getSession(context);
    case HttpMethod.post:
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

FutureOr<Response> getSession(RequestContext context) async {
  try {
    final record = await checkSession(context);
    final unitRepo = context.read<UnitRepository>();
    final unit = await unitRepo.getSelectedUnit(record.$1.userId);
    final dto = SessionDto(user: record.$1.toDto(), unit: unit);
    return Response.json(body: dto.toJson());
  } on ApiException catch (e, stack) {
    debugLog('$yellow geListUnit $reset ${e.statusCode} ${stack}');
    return Response.json(
      body: {'message': e.toString()},
      statusCode: e.statusCode,
    );
  } on Object catch (e, stack) {
    debugLog('$yellow getListUnit $reset UNKNOWN ERROR ${stack}');
    return Response.json(
      body: {'message': e.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  }
}
