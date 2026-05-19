import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';
import '../features/auth/application/session_socket.dart';
import '../features/chat/application/letters_broad_manager.dart';
import 'ws_cmd.dart';

class JoinLettersCmd extends AuthenticatedWsCmd<JoinLettersTs> {
  const JoinLettersCmd();

  @override
  void executeAuthenticated(
    RequestContext context,
    UserChannel channel,
    GameSocket session,
    JoinLettersTs message,
  ) {
    context.read<LettersBroadManager>().subscribe(session, message.n);
  }
}
