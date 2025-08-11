import 'dart:convert';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/new_api_exceptions.dart';

import '../../../core/log_colors.dart';
import '../../../session/session_repository.dart';
import '../../broadcast.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import '../../../user/user_repository.dart';
import '../_ws_cmd.dart';

// email pswd

class LoginCMD implements WsCommand {
  const LoginCMD();
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    debugLog("LoginCMD START\n\n");

    final broadcast = context.read<Broadcast>();
    final userRepo = context.read<UserRepository>();
    final sessionRepo = context.read<SessionRepository>();
    if (payload is! Map<String, dynamic>) {
      debugLog("LoginCMD payload is not Map<String, dynamic>");

      return;
    }
    final dto = EmailCredentialDto.fromJson(payload);
    userRepo
        .loginUser(dto)
        .then(
          (user) async {
            sessionRepo.createSession(user.userId).then((session) {
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
            });
          },
          onError: (er, st) {
            if (er is ApiException && er.statusCode == 401) {
              debugLog('$yellow${er.message}$reset');
              channel.sink.add(
                jsonEncode(WsFromServer(eventType: WsEventFromServer.tokenExpired).toJsonEvent()),
              );
              return;
            }
            debugLog("UnKnown error $er");
          },
        );

    // final encoded = jsonEncode(
    //   WsFromServer(
    //     roomId: 'counter',
    //     eventType: WsEventFromServer.counter,
    //     payload: CounterPayload(count).toJson(),
    //   ).toJson(),
    // );
  }
}
