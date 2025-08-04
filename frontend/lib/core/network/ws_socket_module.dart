import 'package:injectable/injectable.dart';
import 'package:web_socket_client/web_socket_client.dart';

import 'network_constants.dart';

@module
abstract class WsSocketModule {
  @lazySingleton
  WebSocket get wsWithToken => WebSocket(Uri.parse(WebSocketConst.baseUrl));
}
