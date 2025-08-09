import 'package:backend/web_socket/broadcast.dart';
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
    final emailCredential = EmailCredentialDto.fromJson(payload);
    final broadcast = context.read<Broadcast>();
    final userRepo = context.read<UserRepository>();
    userRepo.loginUser(emailCredential).then((i) {
      // broadcast.subscribe(roomId: roomId, userId: userId, channel: channel)
    }, onError: (er, st) {});

    // final encoded = jsonEncode(
    //   WsFromServer(
    //     roomId: 'counter',
    //     eventType: WsEventFromServer.counter,
    //     payload: CounterPayload(count).toJson(),
    //   ).toJson(),
    // );
  }
}
