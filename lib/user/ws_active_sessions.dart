import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import 'package:backend/user/session.dart';

typedef WsActiveSessions = Map<WebSocketChannel, GameSession>;

final wsActiveSession = <WebSocketChannel, GameSession>{};
