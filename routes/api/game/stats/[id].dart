// ignore_for_file: file_names

import 'dart:io';

import 'package:backend/features/game/domain/unit_repository.dart';
import 'package:backend/models/validation/map_to_int.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_dto/game_dto.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.get) {
    return Response(
      statusCode: HttpStatus.methodNotAllowed,
      body: 'Method Not Allowed',
    );
  }

  final unitId = mapToInt(id);
  final uRepo = context.read<UnitRepository>();
  final stats = await uRepo.getUnitPublicInfo(UnitId(unitId.toString()));

  if (stats == null) {
    return Response(statusCode: HttpStatus.notFound);
  }

  return Response.json(body: stats.toJson());
}
