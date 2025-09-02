import 'dart:async';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/inject.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/modules/game/arena.broadcast.dart';
import 'package:backend/modules/game/active_users.broadcast.dart';
import 'package:backend/modules/game/domain/active_sessions_repository.dart';
import 'package:backend/modules/game/letters.broad_manager.dart';
import 'package:backend/modules/game/session_channel.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((webSocketChannel, protocol) {
    final activeUsersBloc = getIt<ActiveUsersBroad>();
    final activeUsersRepository = getIt<ActiveUsersRepository>();
    final arenaBroadcast = getIt<ArenaBroadcast>();
    // start with not authenticated userId -1
    final channel = SinkChannel(webSocketChannel, -1);
    webSocketChannel.stream.listen(
      (message) async {
        debugLog('$green ON MESSAGE: $reset');
        if (message is! String) {
          return;
        }

        try {
          final freezed = ToServer.decoded(message);
          debugLog('$green ON MESSAGE: $freezed $reset');
          debugLog('$green ON MESSAGE: ${freezed.runtimeType} $reset');
          switch (freezed) {
            case WithTokenTS(:final token):
              // 1. Authenticate the token
              activeUsersBloc.join(channel, token);
              break;

            case NewLetterTS(:final letter):
              final blocManager = context.read<LettersBroadManager>();
              final session = await activeUsersRepository.sessionFromWSChannel(
                channel,
              );
              if (session == null) {
                channel.sinkAdd(
                  ToClient.statusError(
                    error: WsServerError.unauthorized,
                  ).jsonBarrel(),
                );

                debugLog('$red [WebSocket]newLetter unauthorized: $reset');
                return;
              }

              blocManager.newLetter(session, letter);

            case DeleteLetterTS(:final letterId, :final roomId):
              final blocManager = context.read<LettersBroadManager>();
              final session = await activeUsersRepository.sessionFromWSChannel(
                channel,
              );
              if (session == null) {
                channel.sinkAdd(
                  ToClient.statusError(
                    error: WsServerError.unauthorized,
                  ).jsonBarrel(),
                );
                return;
              }

              blocManager.removeLetter(session, roomId, letterId);
            case JoinLettersTS(:final roomId):
              final letterBlocManager = context.read<LettersBroadManager>();
              final session = await activeUsersRepository.sessionFromWSChannel(
                channel,
              );
              if (session == null) {
                channel.sinkAdd(
                  ToClient.statusError(
                    error: WsServerError.unauthorized,
                  ).jsonBarrel(),
                );
                return;
              }
              letterBlocManager.subscribe(session, roomId);
            case CreateBattleRoomTS():
              break;
            case JoinBattleRoomTS():
              break;
            case LeaveBattleRoom():
              break;
            case GetJoinedBroadsTS():
              activeUsersBloc.infoJoinedBroads(channel);
            case CreateNewEdictTS():
              final session = await activeUsersRepository.sessionFromWSChannel(
                channel,
              );
              if (session == null) {
                channel.sinkAdd(
                  ToClient.statusError(
                    error: WsServerError.unauthorized,
                  ).jsonBarrel(),
                );
                return;
              }
              arenaBroadcast.createEdict(session);
              break;
            case JoinEdictTS():
              final session = await activeUsersRepository.sessionFromWSChannel(
                channel,
              );
              if (session == null) {
                channel.sinkAdd(
                  ToClient.statusError(
                    error: WsServerError.unauthorized,
                  ).jsonBarrel(),
                );
                return;
              }
              arenaBroadcast.createEdict(session);
            case LeaveEdictTS():
              final session = await activeUsersRepository.sessionFromWSChannel(
                channel,
              );
              if (session == null) {
                channel.sinkAdd(
                  ToClient.statusError(
                    error: WsServerError.unauthorized,
                  ).jsonBarrel(),
                );
                return;
              }
              arenaBroadcast.createEdict(session);
            case JoinArenaTS():
              final session = await activeUsersRepository.sessionFromWSChannel(
                channel,
              );
              if (session == null) {
                channel.sinkAdd(
                  ToClient.statusError(
                    error: WsServerError.unauthorized,
                  ).jsonBarrel(),
                );
                return;
              }
              arenaBroadcast.subscribeChannel(session);
            case LeaveArenaTS():
              final session = await activeUsersRepository.sessionFromWSChannel(
                channel,
              );
              if (session == null) {
                channel.sinkAdd(
                  ToClient.statusError(
                    error: WsServerError.unauthorized,
                  ).jsonBarrel(),
                );
                return;
              }
              arenaBroadcast.leaveArena(session);
            case DisconnectTS():
              activeUsersBloc.replaceByBot(channel);
          }
        } catch (e, s) {
          debugLog('$red [WebSocket] Error: $e $s $reset');
        }
      },
      onDone: () async {
        debugLog('$red [WebSocket] onDone:$reset');
        activeUsersBloc.replaceByBot(channel);
      },

      cancelOnError: true,
    );
  }, pingInterval: const Duration(seconds: 30));
  // Set a ping interval to detect inactive connections.
  // The server will send a ping every 30 seconds.
  // If the client doesn't respond with a pong, the connection is closed.
  return handler(context);
}
