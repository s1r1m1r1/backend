import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';

import '../db_client/dao/unit_dao.dart';
import '../features/auth/application/session_socket.dart';
import 'ws_cmd.dart';

class ChangeUnitStatsCmd extends DeveloperWsCmd<ChangeUnitStatsTs> {
  const ChangeUnitStatsCmd();

  @override
  FutureOr<void> executeDeveloper(
    RequestContext context,
    UserChannel channel,
    GameSocket session,
    ChangeUnitStatsTs message,
  ) async {
    final unitDao = context.read<UnitDao>();

    // Если unitId не передан, используем текущий из канала/сессии
    final targetUnitId = message.unitId ?? channel.unitId;

    if (targetUnitId == null) {
      channel.sinkAdd(
        WsResponse.ack(
          n: message.n,
          status: 400,
          message: 'No unitId specified and no active unit in session',
        ).toPacket(),
      );
      return;
    }

    await unitDao.setStats(
      unitId: targetUnitId,
      wins: message.wins,
      losses: message.losses,
      coins: message.coins,
      exp: message.exp,
    );

    channel.sinkAdd(
      WsResponse.ack(
        n: message.n,
        status: 200,
        message: 'Stats updated for unit $targetUnitId',
      ).toPacket(),
    );
  }
}
