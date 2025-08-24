import 'package:backend/core/debug_log.dart';
import 'package:backend/user/session.dart';
import 'package:backend/ws_/logic/letter.bloc.dart';
import 'package:backend/ws_/letters_repository.dart';
import 'package:backend/ws_/model/web_socket_disposer.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';

@lazySingleton
class LetterBlocManager {
  LetterBlocManager(this._lettersRepository);
  final LettersRepository _lettersRepository;
  // main rooms
  final _map = <int, LetterBloc>{};

  LetterBloc? getBloc(int roomId) => _map[roomId];

  void createRoom(int roomId) {
    _map[roomId] = LetterBloc(_lettersRepository)
      ..add(LetterEvent.setRoom(roomId));
  }

  void subscribe(
    WebSocketChannel channel,
    Session session,
    WebSocketDisposer disposer,
    int roomId,
  ) {
    final bloc = _map[roomId];
    if (bloc == null) return;

    final hasAccess = bloc.hasAccess(session.user.role);
    if (hasAccess) {
      bloc.add(LetterEvent.subscribe(channel, disposer));
    }
  }

  void newLetter(
    WebSocketChannel channel,
    GameSession session,
    CreateLetterDto letter,
  ) {
    final bloc = _map[letter.roomId];
    if (bloc == null) {
      debugLog('not found bloc');
      return;
    }

    final hasAccess = bloc.hasAccess(session.user.role);
    if (hasAccess) {
      bloc.add(LetterEvent.newLetter(channel, session, letter));
    }
  }

  void removeLetter(
    WebSocketChannel channel,
    GameSession session,
    int roomId,
    int letterId,
  ) {
    final bloc = _map[roomId];
    if (bloc == null) return;

    final hasAccess = bloc.hasAccess(session.user.role);
    if (hasAccess) {
      bloc.add(LetterEvent.removeLetter(channel, session, letterId));
    }
  }
}
