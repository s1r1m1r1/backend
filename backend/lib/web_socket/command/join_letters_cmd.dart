import 'dart:convert';
import 'dart:io';

import 'package:backend/web_socket/broadcast.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import '../../core/log_colors.dart';
import '../../models/user.dart';
import '../letters_repository.dart';
import '_ws_cmd.dart';

class JoinLettersCommand implements WsCommand {
  const JoinLettersCommand();
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) async {
    final broadcast = context.read<Broadcast>();
    final letterRepo = context.read<LettersRepository>();
    if (payload != String) return;
    final user = context.read<User>();

    stdout.writeln("$green Join topicId $reset");
    final session = broadcast.getSession(channel);
    if (session == null) return;
    broadcast.subscribe(roomId: roomId, session: session, channel: channel);
    final letters = await letterRepo.fetchAllLetters();
    final encoded = jsonEncode(
      WsFromServer(
        roomId: roomId,
        eventType: WsEventFromServer.joinedLetters,
        payload: LettersPayload(letters).toJson(),
      ).toJson(),
    );
    channel.sink.add(encoded);
  }
}

// TODO Implement this library.
