import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/chat/application/letters_broad_manager.dart';
import 'ws_cmd.dart';

class DeleteLetterCmd extends AuthenticatedWsCmd<DeleteLetterRequest> {
  const DeleteLetterCmd();

  @override
  void executeAuthenticated(
    RequestContext context,
    RegisteredUserChannel channel,
    GameSocket session,
    DeleteLetterRequest message,
  ) {
    context.read<LettersBroadManager>().removeLetter(session, message);
  }
}
