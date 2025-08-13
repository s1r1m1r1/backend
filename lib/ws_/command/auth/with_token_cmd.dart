import 'dart:convert';

import 'package:backend/core/log_colors.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:sha_red/sha_red.dart';

import '../../../core/debug_log.dart';
import '../../../user/session_repository.dart';
import '../../broadcast.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import '../_ws_cmd.dart';

// email token

class WithTokenCMD implements WsCommand {
  const WithTokenCMD();
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    final broadcast = context.read<Broadcast>();
    final sessionRepo = context.read<SessionRepository>();
    final dto = AccessTokenDto.fromJson(payload);

    sessionRepo
        .getSession(token: dto.value)
        .then((session) {
          if (session == null) {
            throw ApiException.unauthorized(message: 'Session not found');
          }
          final isTokenValid = sessionRepo.validateToken(session);
          if (!isTokenValid) {
            throw ApiException.unauthorized(message: 'Token expired');
          }
          broadcast.subscribe(roomId: 'main', session: session, channel: channel).then((_) {
            final onlineMembers = jsonEncode(
              WsFromServer(
                eventType: WsEventFromServer.onlineUsers,
                payload: OnlineUsersPayload(
                  members: broadcast.activeUsersList.map((i) => 'nnn: ${i.userId}').toList(),
                ),
              ).toJson(OnlineUsersPayload.toJsonF),
            );
            broadcast.broadcast('main', onlineMembers).then((_) {
              final answer = WsFromServer(
                eventType: WsEventFromServer.joinedServer,
                payload: JoinedServerPayload('main'),
              ).toJson(JoinedServerPayload.toJsonF);
              final encoded = jsonEncode(answer);
              channel.sink.add(encoded);
            });
          });
        })
        .onError((er, st) {
          if (er is ApiException && er.statusCode == 401) {
            debugLog('$yellow${er.message}$reset');
            channel.sink.add(
              jsonEncode(WsFromServer(eventType: WsEventFromServer.tokenExpired).toJsonEvent()),
            );
            return;
          }
          debugLog("UnKnown error $er");
          channel.sink.add(
            jsonEncode(
              WsFromServer(
                eventType: WsEventFromServer.unauthenticated,
                payload: WsErrorPayload(errorCode: 500),
              ).toJson(WsErrorPayload.toJsonF),
            ),
          );
        });
  }
}
