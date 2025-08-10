import 'package:sha_red/sha_red.dart';

import '../../../core/debug_log.dart';
import '../../../session/session_repository.dart';
import '../../broadcast.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import '../_ws_cmd.dart';

// email token

class WithTokenCMD implements WsCommand {
  const WithTokenCMD();
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    final broadcast = context.read<Broadcast>();
    final sessionRepo = context.read<SessionRepository>();
    if (payload != Map<String, dynamic>) {
      debugLog("WithTokenCMD payload is not Map<String, dynamic>");
      return;
    }
    final dto = AccessTokenDto.fromJson(payload);

    sessionRepo
        .getSession(token: dto.value)
        .then((session) {
          if (session == null) {
            return;
          }
          final isTokenValid = sessionRepo.validateToken(session);
          if (!isTokenValid) {
            return;
          }
          broadcast.subscribe(roomId: roomId, session: session, channel: channel);
        })
        .onError((er, st) {
          debugLog("WithTokenCMD error $er");
        });
  }
}
