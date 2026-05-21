import 'dart:async';

import 'package:backend/core/debug_log.dart';
import 'package:backend/features/auth/application/session_socket.dart';
import 'package:backend/features/auth/application/system_orchestrator.dart';
import 'package:backend/ws/ws_cmd_executor.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:dto/dto.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((webSocketChannel, protocol) {
    // start with not authenticated userId -1
    final channel = UserChannel(webSocketChannel, UserId.none, UnitId.none);
    webSocketChannel.stream.listen(
      (message) async {
        if (message is! String) {
          return;
        }

        final freezed = WsRequest.decoded(message);
        try {
          if (freezed is! AckRequest) {
            debugLog('ON MESSAGE: ${freezed.runtimeType} ${freezed.n}');
          }
          await WsCmdExecutor.execute(context, channel, freezed);
        } on TimeoutException catch (e) {
          debugLog(
            '[WebSocket] Timeout processing ${freezed.runtimeType} '
            'n=${freezed.n} for user ${channel.userId}: $e',
          );
        } catch (e, s) {
          debugLog('[WebSocket] Error: $e $s');
        }
      },
      onDone: () async {
        try {
          context.read<SystemOrchestrator>().onUserClose(channel);
        } catch (e, s) {
          debugLog('[WebSocket] Error: $e $s');
        }
      },
      cancelOnError: true,
    );
  }, pingInterval: const Duration(seconds: 40));
  return handler(context);
}
