import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/chat/application/letters_broad_manager.dart';
import 'ws_cmd.dart';

class EditLetterCmd extends AuthenticatedWsCmd<EditLetterTs> {
  const EditLetterCmd();

  @override
  void executeAuthenticated(
    RequestContext context,
    UserChannel channel,
    GameSocket session,
    EditLetterTs message,
  ) {
    context.read<LettersBroadManager>().editLetter(session, message);
  }
}
