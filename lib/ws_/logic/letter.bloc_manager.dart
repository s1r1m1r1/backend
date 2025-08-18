import 'package:backend/user/active_sessions_repository.dart';
import 'package:backend/ws_/logic/letter.bloc.dart';
import 'package:backend/ws_/letters_repository.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';

@lazySingleton
class LetterBlocManager {
  LetterBlocManager(this._lettersRepository, this._activeSessions);
  final LettersRepository _lettersRepository;
  final ActiveSessionsRepository _activeSessions;
  final _map = <String, LetterBloc>{};

  @Deprecated('dev fix')
  LetterBloc? getBloc(String roomName) => _map[roomName];

  void createRoom(String name) {
    _map[name] = LetterBloc(name, _lettersRepository, _activeSessions);
  }

  void subscribe(WebSocketChannel channel, String roomName) {
    final session = _activeSessions.getSession(channel);
    if (session == null) return;

    final bloc = _map[roomName];
    if (bloc == null) return;

    final hasAccess = bloc.hasAccess(session.user.role);
    if (hasAccess) {
      bloc.add(LetterEvent.subscribe(channel));
    }
  }

  void newLetter(
    WebSocketChannel channel,
    String roomId,
    CreateLetterDto letter,
  ) {
    final session = _activeSessions.getSession(channel);
    if (session == null) {
      return;
    }

    final bloc = _map[roomId];
    if (bloc == null) return;

    final hasAccess = bloc.hasAccess(session.user.role);
    if (hasAccess) {
      bloc.add(LetterEvent.newLetter(channel, letter));
    }
  }

  void removeLetter(WebSocketChannel channel, String roomId, int letterId) {
    final session = _activeSessions.getSession(channel);
    if (session == null) {
      return;
    }

    final bloc = _map[roomId];
    if (bloc == null) return;

    final hasAccess = bloc.hasAccess(session.user.role);
    if (hasAccess) {
      bloc.add(LetterEvent.removeLetter(channel, letterId));
    }
  }
}
