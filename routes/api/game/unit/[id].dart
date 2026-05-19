import 'dart:io';
import 'package:backend/features/auth/application/check_session.dart';
import 'package:backend/features/game/domain/unit_repository.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:backend/models/validation/map_to_int.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_dto/game_dto.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return getUnit(context, id);
    case HttpMethod.put:
    case HttpMethod.patch:
      return updateUnit(context, id);
    case HttpMethod.delete:
      return deleteUnit(context, id);
    default:
      return Response.json(
        body: {'error': '👀 Looks like you are lost 🔦'},
        statusCode: HttpStatus.methodNotAllowed,
      );
  }
}

Future<Response> getUnit(RequestContext context, String id) async {
  final record = await context.read<Future<UserRecord>>();
  final user = record.user;
  final characterRepo = context.read<UnitRepository>();
  final characterId = mapToInt(id);

  final dto = await characterRepo.getUnit(
    userId: user.userId,
    characterId: characterId,
  );

  if (dto == null) {
    return Response(statusCode: HttpStatus.notFound);
  }

  return Response.json(body: dto.toJson());
}

Future<Response> updateUnit(RequestContext context, String id) async {
  final record = await context.read<Future<UserRecord>>();
  final user = record.user;
  final characterRepo = context.read<UnitRepository>();

  final parsedBody = await parseJson(context.request);
  final characterId = mapToInt(id);
  final dto = UpdateUnitDto.fromJson(parsedBody);

  if (characterId != dto.id) {
    return Response(statusCode: HttpStatus.notFound);
  }

  final updated = await characterRepo.updateUnit(user.userId, dto);
  if (updated == null) {
    return Response(statusCode: HttpStatus.notFound);
  }

  return Response.json(body: updated.toJson());
}

Future<Response> deleteUnit(RequestContext context, String id) async {
  final record = await context.read<Future<UserRecord>>();
  final user = record.user;
  final uRepo = context.read<UnitRepository>();
  final characterId = mapToInt(id);

  final res = await uRepo.deleteUnit(
    userId: user.userId,
    characterId: characterId,
  );

  if (!res) {
    return Response(statusCode: HttpStatus.notFound);
  }

  return Response.json();
}
