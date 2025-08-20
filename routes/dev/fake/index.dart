import 'dart:async';
import 'dart:io';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/user/http_check_session_.dart';
import 'package:backend/user/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:sha_red/sha_red.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return getListFake(context);
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

FutureOr<Response> getListFake(RequestContext context) async {
  try {
    final record = await checkSession(context);
    final user = record.$1;
    if (user.role != Role.admin) {
      return Response.json(statusCode: HttpStatus.forbidden);
    }
    final unitRepo = context.read<UserRepository>();
    // final unitRepo = context.read<UnitRepository>();
    // final unit = await unitRepo.getSelectedUnit(record.$1.userId);
    // final dto = SessionDto(
    //   user: record.$1.toDto(),
    //   tokens: TokensDto(
    //     accessToken: record.$2.token,
    //     refreshToken: record.$2.refreshToken,
    //   ),
    //   unit: unit,
    // );
    // return Response.json(body: dto.toJson());
    return Response.json(statusCode: HttpStatus.ok);
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
