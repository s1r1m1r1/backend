import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import '../../../core/debug_log.dart';
import '../../../core/log_colors.dart';
import '../../../core/new_api_exceptions.dart';
import '../../../session/session_repository.dart';
import '../../broadcast.dart';
import '../_ws_cmd.dart';

class WithRefreshCMD implements WsCommand {
  const WithRefreshCMD();
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    final broadcast = context.read<Broadcast>();
    final sessionRepo = context.read<SessionRepository>();

    final dto = RefreshTokenDto.fromJson(payload);
    sessionRepo
        .getSession(token: dto.value)
        .then((session) {
          if (session == null) {
            throw ApiException.unauthorized(message: 'Session not found');
          }
          final isTokenValid = sessionRepo.validateRefreshToken(session);
          if (!isTokenValid) {
            throw ApiException.unauthorized(message: 'Session is token valid');
          }
          broadcast.subscribe(roomId: 'main', session: session, channel: channel).then((_) {
            final onlineMembers = jsonEncode(
              WsFromServer(
                eventType: WsEventFromServer.onlineUsers,
                payload: OnlineUsersPayload(
                  members: broadcast.activeUsersList.map((i) => 'userId: ${i.userId}').toList(),
                ),
              ).toJson(OnlineUsersPayload.toJsonF),
            );
            broadcast.broadcast('main', onlineMembers).then((_) {
              final payload = JoinedServerPayload(
                'main',
                tokens: TokensDto(
                  AccessTokenDto(session.token),
                  RefreshTokenDto(session.refreshToken),
                ),
              );
              final dto = WsFromServer(
                eventType: WsEventFromServer.joinedServer,
                payload: payload,
              ).toJson(JoinedServerPayload.toJsonF);
              final encoded = jsonEncode(dto);
              channel.sink.add(encoded);
            });
          });
        })
        .onError((er, st) {
          if (er is ApiException && er.statusCode == 401) {
            debugLog('$yellow${er.message}$reset');
            channel.sink.add(
              jsonEncode(
                WsFromServer(eventType: WsEventFromServer.refreshTokenExpired).toJsonEvent(),
              ),
            );
            return;
          }
          debugLog("WithRefreshCMD error $er");
        });
  }
}
