import 'dart:convert';

import 'package:backend/ws_/letters_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import 'package:backend/ws_/broadcast.dart';
import 'package:backend/ws_/chat_room_repository.dart';
import 'package:backend/ws_/command/_ws_cmd.dart';

class DeleteLetterCommand implements WsCommand {
  const DeleteLetterCommand();
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    final isValid = context.read<ChatRoomRepository>().isValid('roomId');
    if (!isValid) return;
    final broadcast = context.read<Broadcast>();

    context
        .read<LettersRepository>()
        .deleteLetter(payload)
        .then((deleted) {
          if (deleted.isNotEmpty) {
            final encoded = jsonEncode(
              WsFromServer(eventType: WsEventFromServer.letterCreated, payload: deleted),
            );
            broadcast.broadcast('room', encoded);
          }
        })
        .catchError((err) {
          print('Something went wrong: $err');
        });
  }
}
