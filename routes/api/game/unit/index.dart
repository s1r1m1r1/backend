import 'dart:io';

import 'package:backend/features/auth/application/check_session.dart';
import 'package:backend/features/game/domain/unit_repository.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_dto/game_dto.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return postUnit(context);
    default:
      return Response.json(
        body: {'error': '👀 Looks like you are lost 🔦'},
        statusCode: HttpStatus.methodNotAllowed,
      );
  }
}

Future<Response> postUnit(RequestContext context) async {
  final userRecord = await context.read<Future<UserRecord>>();
  final user = userRecord.user;
  final uRepo = context.read<UnitRepository>();

  final json = await parseJson(context.request);
  final requestDto = CreateUnitDto.fromJson(json);

  final result = await uRepo.createUnit(user.userId, requestDto);
  final selected = await uRepo.setSelectedUnit(
    userid: user.userId,
    unitId: result.id,
  );

  final list = await uRepo.getListUnit(userId: user.userId);
  final responseDto = ListUnitDto(selectedId: selected.id, list: list);

  return Response.json(body: responseDto.toJson());
}
