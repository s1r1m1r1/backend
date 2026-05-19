import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/chat/application/letters_broad_manager.dart';
import 'ws_cmd.dart';

class NewLetterCmd extends AuthenticatedWsCmd<NewLetterTs> {
  const NewLetterCmd();

  @override
  void executeAuthenticated(
    RequestContext context,
    UserChannel channel,
    GameSocket session,
    NewLetterTs message,
  ) {
    context.read<LettersBroadManager>().newLetter(session, message);
  }
}
