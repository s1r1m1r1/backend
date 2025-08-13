import 'dart:async';
import 'dart:io';

import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/middlewares/session_middleware_.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:backend/models/validation/map_to_int.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:sha_red/sha_red.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return getUnit(context, id);
    case HttpMethod.put:
    case HttpMethod.patch:
      return updateUnit(context, id);
    case HttpMethod.delete:
      return deleteUnit(context, id);
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.post:
      return Response.json(
        body: {'error': '👀 Looks like you are lost 🔦'},
        statusCode: HttpStatus.methodNotAllowed,
      );
  }
}

FutureOr<Response> getUnit(RequestContext context, String id) async {
  try {
    final record = await checkSession(context);
    final user = record.$1;
    final characterRepo = context.read<UnitRepository>();
    final characterId = mapToInt(id);
    final dto = await characterRepo.getUnit(userId: user.userId, characterId: characterId);
    if (dto != null) return Response.json(body: dto.toJson());
    return Response(statusCode: HttpStatus.notFound);
  } on ApiException catch (e, stack) {
    stdout.writeln('store errors${e.errors} ${stack}');
    return Response.json(
      body: {'message': e.toString(), "errors": e.errors},
      statusCode: HttpStatus.internalServerError,
    );
  } on Object catch (e) {
    stdout.writeln('store UNEXPECTED ERROR');
    return Response.json(
      body: {'message': e.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  }
}

FutureOr<Response> updateUnit(RequestContext context, String id) async {
  try {
    final record = await checkSession(context);
    final user = record.$1;
    final characterRepo = context.read<UnitRepository>();
    final parsedBody = await parseJson(context.request);
    final characterId = mapToInt(id);
    final dto = UpdateUnitDto.fromJson(parsedBody);
    if (characterId != dto.id) return Response(statusCode: HttpStatus.notFound);
    stdout.writeln('TodoController update start');
    final updated = await characterRepo.updateUnit(user.userId, dto);
    if (updated == null) return Response(statusCode: HttpStatus.notFound);
    return Response.json(body: updated.toJson());
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

FutureOr<Response> deleteUnit(RequestContext context, String id) async {
  stdout.writeln('delete character');
  try {
    final record = await checkSession(context);
    final user = record.$1;
    final uRepo = context.read<UnitRepository>();
    final characterId = mapToInt(id);

    final res = await uRepo.deleteUnit(userId: user.userId, characterId: characterId);
    if (res == 0) {
      return Response(statusCode: HttpStatus.notFound);
    }
    return Response.json();
  } on Object catch (e) {
    stdout.writeln('store UNEXPECTED ERROR');
    return Response.json(
      body: {'message': e.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  }
}
