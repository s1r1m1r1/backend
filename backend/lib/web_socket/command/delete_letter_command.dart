// TODO Implement this library.
import 'package:backend/web_socket/letters_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import '_ws_command.dart';

class DeleteLetterCommand implements WsCommand {
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    context
        .read<LettersRepository>()
        .deleteLetter(payload)
        .then((letter) {
          // if (letter != null) {
          //   channel.sink.add(
          //     jsonEncode(WsFromServer(eventType: WsEventFromServer.letterCreated, payload: letter.toJson())),
          //   );
          // }
        })
        .catchError((err) {
          print('Something went wrong: $err');
        });
  }
}
