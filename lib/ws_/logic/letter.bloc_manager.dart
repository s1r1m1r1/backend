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
  final _map = <String, LetterBloc>{};

  @Deprecated('dev fix')
  LetterBloc? getBloc(String roomName) => _map[roomName];

  void createRoom(String name) {
    _map[name] = LetterBloc(name, _lettersRepository);
  }

  void subscribe(
    WebSocketChannel channel,
    Session session,
    WebSocketDisposer disposer,
    String roomName,
  ) {
    final bloc = _map[roomName];
    if (bloc == null) return;

    final hasAccess = bloc.hasAccess(session.user.role);
    if (hasAccess) {
      bloc.add(LetterEvent.subscribe(channel, disposer));
    }
  }

  void newLetter(
    WebSocketChannel channel,
    String roomId,
    Session session,
    CreateLetterDto letter,
  ) {
    final bloc = _map[roomId];
    if (bloc == null) return;

    final hasAccess = bloc.hasAccess(session.user.role);
    if (hasAccess) {
      bloc.add(LetterEvent.newLetter(channel, letter));
    }
  }

  void removeLetter(
    WebSocketChannel channel,
    Session session,
    String roomId,
    int letterId,
  ) {
    final bloc = _map[roomId];
    if (bloc == null) return;

    final hasAccess = bloc.hasAccess(session.user.role);
    if (hasAccess) {
      bloc.add(LetterEvent.removeLetter(channel, letterId));
    }
  }
}
