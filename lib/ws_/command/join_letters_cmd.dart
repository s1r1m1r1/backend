import 'dart:io';

import 'package:backend/core/debug_log.dart';
import 'package:backend/ws_/cubit/room_manager.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import '_ws_cmd.dart';

class JoinLettersCommand implements WsCommand {
  const JoinLettersCommand();
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) async {
    debugLog('Join Letters Command 1 ${payload.runtimeType} ${payload}');
    final roomId = LetterRoomPayload.fromJson(payload as Json);

    debugLog('Join Letters Command 2');
    final roomManager = context.read<RoomManager>();
    final letterCubit = roomManager.roomLetter['main'];
    if (letterCubit == null) return;

    debugLog('Join Letters Command 3');
    letterCubit.subscribe(channel);
    final encoded = letterCubit.lettersJSON();
    channel.sink.add(encoded);

    debugLog('Join Letters Command 4');
    // final body = WsFromServer(
    //     roomId: roomId,
    //     eventType: WsEventFromServer.joinedLetters,
    //     payload: LettersPayload(letters).toJson(),
    //   );
    // final encoded = jsonEncode(
    //   body.toJson(LettersPayload.toJson),
    // );
    // channel.sink.add(encoded);
  }
}

// TODO Implement this library.
