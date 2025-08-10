import 'dart:convert';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/new_api_exceptions.dart';

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
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
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
          (user) {
            sessionRepo.createSession(user.userId).then((session) {
              final payload = TokensDto(
                AccessTokenDto(session.token),
                RefreshTokenDto(session.refreshToken),
              ).toJson();
              final dto = WsFromServer(
                roomId: roomId,
                eventType: WsEventFromServer.loggedIn,
                payload: payload,
              );
              final encoded = jsonEncode(dto);
              broadcast.subscribe(roomId: roomId, session: session, channel: channel);
              channel.sink.add(encoded);
            });
          },
          onError: (er, st) {
            if (er is ApiException) {
              channel.sink.add(
                jsonEncode(
                  WsFromServer(
                    roomId: roomId,
                    eventType: WsEventFromServer.unauthenticated,
                    payload: er.toString(),
                  ),
                ),
              );
              return;
            }
            debugLog("UnKnown error $er");
            channel.sink.add(
              jsonEncode(
                WsFromServer(
                  roomId: roomId,
                  eventType: WsEventFromServer.unauthenticated,
                  payload: er.toString(),
                ),
              ),
            );
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
