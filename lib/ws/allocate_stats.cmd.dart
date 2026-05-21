import 'dart:async';

import 'package:dart_frog/dart_frog.dart' hide Response;
import 'package:dto/dto.dart';
import 'package:game_dto/game_dto.dart';

import '../core/debug_log.dart';
import '../features/auth/application/online_repository_impl.dart';
import '../features/auth/application/session_socket.dart';
import '../features/game/domain/unit_repository.dart';
import 'ws_cmd.dart';

class AllocateStatsCmd implements WsCmd<AllocateStatsRequest> {
  const AllocateStatsCmd();

  @override
  FutureOr<void> execute(
    RequestContext context,
    UserChannel channel,
    AllocateStatsRequest message,
  ) async {
    final unitRep = context.read<UnitRepository>();

    const logPrefix = '[WS][AllocateStats]';

    // Validate request
    if (message.addAtk < 0 || message.addDef < 0 || message.addVitality < 0) {
      debugLog('$logPrefix Invalid allocation amounts from ${channel.userId}');
      return;
    }

    final totalSpent = message.addAtk + message.addDef + message.addVitality;
    if (totalSpent == 0) return;

    // Check if the unit belongs to the user
    final unit = await unitRep.getUnit(
      userId: channel.userId,
      characterId: message.unitId,
    );

    if (unit == null) {
      debugLog(
        '$logPrefix Unit ${message.unitId} not found or not owned by ${channel.userId}',
      );
      return;
    }

    if (unit.statPoints < totalSpent) {
      debugLog('$logPrefix Insufficient statPoints for Unit ${message.unitId}');
      return;
    }

    // Attempt allocation in DB
    await unitRep.allocateStats(
      message.unitId,
      message.addAtk,
      message.addDef,
      message.addVitality,
    );

    // Fetch updated unit
    final updatedUnit = await unitRep.getUnit(
      userId: channel.userId,
      characterId: message.unitId,
    );

    if (updatedUnit == null) return;

    // Fetch session from context to update the current unit if it matches
    final onlineRep = context.read<OnlineRepository>();
    final sessionChannel = onlineRep.getSessionUSERID(channel.userId);

    if (sessionChannel != null &&
        sessionChannel.session.unit.unitId == message.unitId) {
      sessionChannel.session.unit.atk = updatedUnit.atk;
      sessionChannel.session.unit.def = updatedUnit.def;
      sessionChannel.session.unit.hp = updatedUnit.hp;
      sessionChannel.session.unit.statPoints = updatedUnit.statPoints;
      // Note: vitality maps to hp in Unit, or we use dto.
    }

    // Broadcast updated units to client
    final allUnits = await unitRep.getListUnit(userId: channel.userId);
    channel.sinkAdd(
      WsResponse.unitsUpdate(
        n: message.n,
        dto: ListUnitDto(
          list: allUnits,
          selectedId: sessionChannel?.session.unit.unitId ?? message.unitId,
        ),
      ).toPacket(),
    );

    context.read<void Function(String)>().call(
      '$logPrefix Successfully allocated $totalSpent points for Unit ${message.unitId}',
    );
  }
}
