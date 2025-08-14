import 'package:backend/core/debug_log.dart';
import 'package:backend/ws_/chat_room_repository.dart';
import 'package:backend/ws_/command/_ws_cmd.dart';
import 'package:backend/ws_/cubit/room_manager.dart';
import 'package:backend/ws_/letters_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

class NewLetterCommand implements WsCommand {
  const NewLetterCommand();
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    final isValid = context.read<ChatRoomRepository>().isValid('room');
    debugLog('New Letter Command');
    // if (!isValid) return;
    debugLog('New Letter Command 1');
    final roomManager = context.read<RoomManager>();
    final cubit = roomManager.roomLetter['main'];
    if (cubit == null) return;

    debugLog('New Letter Command 2');
    final dto = NewLetterPayload.fromJson(payload as Json);

    context
        .read<LettersRepository>()
        .createLetter(dto.letter)
        .then((letter) {
          if (letter != null) {
            debugLog('New Letter Command 3');
            cubit.addLetter(letter);
          }
        })
        .catchError((err) {
          print('Something went wrong: $err');
        });
  }
}
