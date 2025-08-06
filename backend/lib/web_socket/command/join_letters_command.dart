import 'dart:convert';
import 'dart:io';

import 'package:backend/web_socket/broadcast.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import '../../core/log_colors.dart';
import '../letters_repository.dart';
import '_ws_command.dart';

class JoinLettersCommand implements WsCommand {
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) async {
    final broadcast = context.read<Broadcast>();
    stdout.writeln("$green Join 1 $reset");
    if (payload != String) return;
    stdout.writeln("$green Join 2 $reset");
    final topicId = payload;

    stdout.writeln("$green Join topicId $reset");
    broadcast.subscribe(topicId, channel);
    final letters = await context.read<LettersRepository>().fetchAllLetters();
    channel.sink.add(
      jsonEncode(
        WsFromServer(
          roomId: topicId,
          eventType: WsEventFromServer.joinedLetters,
          payload: LettersPayload(letters).toJson(),
        ).toJson(),
      ),
    );
  }
}

// TODO Implement this library.
