import 'dart:async';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/ws_/logic/active_users/active_users_bloc.dart';
import 'package:backend/ws_/logic/letter.bloc_manager.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    final activeUsersBloc = context.read<ActiveUsersBloc>();

    channel.stream.listen(
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
              activeUsersBloc.add(
                ActiveUsersEvent.join(channel: channel, token: token),
              );
              break;

            case NewLetterTS(:final letter):
              final blocManager = context.read<LetterBlocManager>();
              final session = activeUsersBloc.sessionFromWSChannel(channel);
              if (session == null) {
                channel.sink.add(
                  ToClient.statusError(
                    error: WsServerError.unauthorized,
                  ).encoded(),
                );

                debugLog('$red [WebSocket]newLetter unauthorized: $reset');
                return;
              }

              debugLog('$red [WebSocket]newLetter go: $reset');
              blocManager.newLetter(session, letter);
            case DeleteLetterTS(:final letterId, :final roomId):
              final blocManager = context.read<LetterBlocManager>();
              final session = activeUsersBloc.sessionFromWSChannel(channel);
              if (session == null) {
                channel.sink.add(
                  ToClient.statusError(
                    error: WsServerError.unauthorized,
                  ).encoded(),
                );
                return;
              }

              blocManager.removeLetter(session, roomId, letterId);
            case JoinLettersTS(:final roomId):
              final letterBlocManager = context.read<LetterBlocManager>();
              final session = activeUsersBloc.sessionFromWSChannel(channel);
              if (session == null) {
                channel.sink.add(
                  ToClient.statusError(
                    error: WsServerError.unauthorized,
                  ).encoded(),
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
          }
        } catch (e, s) {
          debugLog('$red [WebSocket] Error: $e $s $reset');
        }
      },
      onDone: () async {
        activeUsersBloc.add(ActiveUsersEvent.removeUser(channel));
      },

      cancelOnError: true,
    );
  }, pingInterval: const Duration(seconds: 30));
  // Set a ping interval to detect inactive connections.
  // The server will send a ping every 30 seconds.
  // If the client doesn't respond with a pong, the connection is closed.
  return handler(context);
}
