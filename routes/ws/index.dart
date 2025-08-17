import 'dart:async';

import 'package:backend/core/debug_log.dart';
import 'package:backend/user/ws_active_sessions.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/ws_/command/auth/login_cmd.dart';
import 'package:backend/ws_/command/auth/with_refresh_cmd.dart';
import 'package:backend/ws_/command/auth/with_token_cmd.dart';
import 'package:backend/ws_/logic/active_users.bloc.dart';
import 'package:backend/ws_/logic/letter.bloc_manager.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    debugLog('$green ON Request 1 $protocol $reset');
    final activeSessions = context.read<WsActiveSessions>();
    final activeUsersCubit = context.read<ActiveUsersBloc>();

    channel.stream.listen(
      (message) async {
        debugLog('$green ON MESSAGE: $reset');
        // try {
        if (message is! String) {
          debugLog('$red [WebSocket] Message is not a string. $reset');
          // channel.sink.add('Invalid message');
          return;
        }

        try {
          final freezed = ToServer.decoded(message);
          switch (freezed) {
            case Login_TS(:final dto):
              LoginCMD().execute(context, channel, dto);
            case Signup_TS():
              break;
            case WithToken_TS(:final token):
              WithTokenCMD().execute(context, channel, token);
            case WithRefresh_TS(:final refresh):
              WithRefreshCMD().execute(context, channel, refresh);
            case NewLetter_TS(:final letter, :final roomId):
              final blocManager = context.read<LetterBlocManager>();
              blocManager.newLetter(channel, 'main' /*dto.roomId*/, letter);
            case DeleteLetter_TS(:final roomId, :final letterId):
              final blocManager = context.read<LetterBlocManager>();
              blocManager.removeLetter(
                channel,
                'main' /*dto.roomId*/,
                letterId,
              );
            case JoinLetters_TS(:final roomId):
              final letterBlocManager = context.read<LetterBlocManager>();
              letterBlocManager.subscribe(channel, 'main' /*room.roomId*/);
          }
        } catch (e, s) {
          debugLog('$red [WebSocket] Error: $e $s $reset');
        }

        // } catch (e) {
        //   debugLog('$red [WebSocket] Error: $e $reset');
        // }
      },
      onDone: () async {
        final session = activeSessions.getSession(channel);
        final disposer = activeSessions.getDisposer(channel);
        if (disposer != null) {
          disposer.dispose();
        }
        if (session != null) {
          activeUsersCubit.add(ActiveUsersEvent.removeUser(session));
        }
        channel.sink.close();
      },

      cancelOnError: true,
    );
  }, pingInterval: const Duration(seconds: 30));
  // Set a ping interval to detect inactive connections.
  // The server will send a ping every 30 seconds.
  // If the client doesn't respond with a pong, the connection is closed.
  return handler(context);
}
