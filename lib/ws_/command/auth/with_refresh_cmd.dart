import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import '../../../core/debug_log.dart';
import '../../../session/session_repository.dart';
import '../../broadcast.dart';
import '../_ws_cmd.dart';

class WithRefreshCMD implements WsCommand {
  const WithRefreshCMD();
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    // final token = RefreshTokenDto.fromJson(payload);
    final broadcast = context.read<Broadcast>();
    final sessionRepo = context.read<SessionRepository>();
    if (payload is! Json) {
      debugLog("WithRefreshCMD payload is not Json");
      return;
    }
    final dto = RefreshTokenDto.fromJson(payload);
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
          debugLog("WithRefreshCMD error $er");
        });
  }
}
