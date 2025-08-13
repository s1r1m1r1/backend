import 'dart:async';
import 'dart:io';

import 'package:backend/core/log_colors.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/middlewares/session_middleware_.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:sha_red/sha_red.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return getListUnit(context);
    case HttpMethod.post:
      return postUnit(context);
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

FutureOr<Response> getListUnit(RequestContext context) async {
  try {
    final record = await checkSession(context);
    final user = record.$1;
    final uRepo = context.read<UnitRepository>();
    stdout.writeln('TodoController index start');
    final list = await uRepo.getListUnit(userId: user.userId);
    final selected = await uRepo.getSelectedUnit(user.userId);
    final dto = ListUnitDto(selectedId: selected?.id ?? -1, list: list);
    return Response.json(body: dto.toJson());
  } on ApiException catch (e, stack) {
    stdout.writeln('$yellow geListUnit $reset ${e.statusCode} ${stack}');
    return Response.json(body: {'message': e.toString()}, statusCode: e.statusCode);
  } on Object catch (e, stack) {
    stdout.writeln('$yellow getListUnit $reset UNKNOWN ERROR ${stack}');
    return Response.json(
      body: {'message': e.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  }
}

FutureOr<Response> postUnit(RequestContext context) async {
  try {
    final record = await checkSession(context);
    final user = record.$1;
    final uRepo = context.read<UnitRepository>();
    final json = await parseJson(context.request);
    final dto = CreateUnitDto.fromJson(json);
    final result = await uRepo.createUnit(user.userId, dto);
    await uRepo.setSelectedUnit(userid: user.userId, unitId: result.id);
    return Response.json(body: result.toJson());
  } on ApiException catch (e, stack) {
    stdout.writeln('$yellow postUnit $reset ${e.statusCode} ${stack}');
    return Response.json(
      body: {'message': e.toString(), "errors": e.errors},
      statusCode: e.statusCode,
    );
  } on Object catch (e, stack) {
    stdout.writeln('$yellow postUnit $reset UNKNOWN ERROR ${stack}');
    return Response.json(
      body: {'message': e.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  }
}
