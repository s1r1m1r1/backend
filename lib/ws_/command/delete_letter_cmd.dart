import 'package:backend/core/debug_log.dart';
import 'package:backend/ws_/cubit/room_manager.dart';
import 'package:backend/ws_/letters_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import 'package:backend/ws_/command/_ws_cmd.dart';

class DeleteLetterCommand implements WsCommand {
  const DeleteLetterCommand();
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    // final isValid = context.read<ChatRoomRepository>().isValid('roomId');
    // if (!isValid) return;
    debugLog('Delete Letter Command 1');
    final dto = IdLetterPayload.fromJson(payload as Json);
    final roomId = dto.roomId;
    final roomManager = context.read<RoomManager>();
    final letterCubit = roomManager.roomLetter['main'];
    if (letterCubit == null) return;

    debugLog('Delete Letter Command 2');
    context
        .read<LettersRepository>()
        .deleteLetter(dto.letterId)
        .then((deleted) {
          debugLog('Delete Letter Command 3 ${deleted}');
          letterCubit.removeLetter(deleted);
        })
        .catchError((err) {
          print('Something went wrong: $err');
        });
  }
}
