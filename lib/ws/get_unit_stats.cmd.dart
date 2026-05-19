import 'dart:async';
import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import 'package:game_dto/game_dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/domain/unit_repository.dart';
import 'ws_cmd.dart';

class GetUnitStatsCmd extends AuthenticatedWsCmd<GetUnitStatsTs> {
  const GetUnitStatsCmd();

  @override
  FutureOr<void> executeAuthenticated(
    RequestContext context,
    UserChannel channel,
    GameSocket session,
    GetUnitStatsTs message,
  ) async {
    final unitRepository = context.read<UnitRepository>();

    final targetUnitId = message.unitId != null
        ? UnitId(message.unitId!)
        : session.session.unit.unitId;

    final stats = await unitRepository.getUnitPublicInfo(targetUnitId);

    if (stats == null) {
      channel.sinkAdd(
        WsResponse.ack(
          n: message.n,
          status: 404,
          message: 'Unit stats not found',
        ).toPacket(),
      );
      return;
    }

    channel.sinkAdd(
      WsResponse.ack(
        n: message.n,
        status: 200,
        payload: stats.toJson(),
      ).toPacket(),
    );
  }
}
