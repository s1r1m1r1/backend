import 'package:dart_frog/dart_frog.dart' hide Request;
import 'package:dto/dto.dart';
import '../core/debug_log.dart';
import '../features/auth/application/session_socket.dart';
import 'ws_cmd.dart';

class NoopCmd extends WsCmd<WsRequest> {
  const NoopCmd();
  @override
  void execute(RequestContext context, UserChannel channel, WsRequest message) {
    debugLog('[WebSocket] NoopCmd');
  }
}
