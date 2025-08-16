// import 'package:backend/core/debug_log.dart';
// import 'package:backend/ws_/chat_room_repository.dart';
// import 'package:backend/ws_/command/_ws_cmd.dart';
// import 'package:backend/ws_/cubit/letter.bloc.dart';
// import 'package:backend/ws_/cubit/room_manager.dart';
// import 'package:backend/ws_/letters_repository.dart';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
// import 'package:sha_red/sha_red.dart';

// class NewLetterCommand implements WsCommand {
//   const NewLetterCommand();
//   @override
//   void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
//     final isValid = context.read<ChatRoomRepository>().isValid('room');
//     debugLog('New Letter Command');
//     // if (!isValid) return;
//     debugLog('New Letter Command 1');
//     final roomManager = context.read<LetterBlocManager>();
//     final bloc = roomManager.roomLetter['main'];
//     if (bloc == null) return;

//     debugLog('New Letter Command 2');
//     final dto = NewLetterPayload.fromJson(payload as Json);
//     bloc.add(LetterEvent.newLetter(channel, dto.letter));
//   }
// }
