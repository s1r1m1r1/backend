import 'dart:convert';

import 'package:backend/web_socket/broadcast.dart';
import 'package:backend/web_socket/chat_room_repository.dart';
import 'package:backend/web_socket/command/_ws_command.dart';
import 'package:backend/web_socket/letters_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

class NewLetterCommand implements WsCommand {
  const NewLetterCommand();
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    final isValid = context.read<ChatRoomRepository>().isValid(roomId);
    if (!isValid) return;
    final broadcast = context.read<Broadcast>();

    context
        .read<LettersRepository>()
        .createLetter(payload)
        .then((letter) {
          if (letter != null) {
            final encoded = jsonEncode(
              WsFromServer(roomId: roomId, eventType: WsEventFromServer.letterCreated, payload: letter.toJson()),
            );
            broadcast.broadcast(roomId, encoded);
          }
        })
        .catchError((err) {
          print('Something went wrong: $err');
        });
  }
}
