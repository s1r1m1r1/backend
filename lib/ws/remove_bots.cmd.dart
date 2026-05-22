import 'dart:async';
import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/presence_manager.dart';
import '../features/auth/application/session_socket.dart';
import '../features/auth/application/system_orchestrator.dart';
import 'ws_cmd.dart';

class RemoveBotsCmd extends DeveloperWsCmd<RemoveBotsRequest> {
  const RemoveBotsCmd();

  @override
  FutureOr<void> executeDeveloper(
    RequestContext context,
    RegisteredUserChannel channel,
    GameSocket session,
    RemoveBotsRequest message,
  ) async {
    final orchestrator = context.read<SystemOrchestrator>();
    final presenceManager = context.read<PresenceManager>();

    // 1. Remove from online
    presenceManager.removeAllBots();

    // 2. Remove from DB
    await orchestrator.removeAllBotsFromDb();

    channel.sinkAdd(
      WsResponse.ack(
        n: message.n,
        status: 200,
        message: 'All ArenaBots removed from system and DB',
      ).toPacket(),
    );
  }
}
