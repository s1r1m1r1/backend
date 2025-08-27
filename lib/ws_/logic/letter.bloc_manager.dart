import 'package:backend/core/debug_log.dart';
import 'package:backend/core/session_channel.dart';
import 'package:backend/ws_/logic/letter.bloc.dart';
import 'package:backend/ws_/letters_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';

@lazySingleton
class LetterBlocManager {
  LetterBlocManager(this._lettersRepository);
  final LettersRepository _lettersRepository;
  // main rooms
  final _rooms = <int, LetterBloc>{};

  LetterBloc? getBloc(int roomId) => _rooms[roomId];

  void createRoom(int roomId) {
    _rooms[roomId] = LetterBloc(_lettersRepository)
      ..add(LetterEvent.setRoom(roomId));
  }

  void subscribe(SessionChannel channel, int roomId) {
    final bloc = _rooms[roomId];
    if (bloc == null) return;

    final hasAccess = bloc.hasAccess(channel.session.user.role);
    if (hasAccess) {
      bloc.add(LetterEvent.subscribe(channel));
    }
  }

  void newLetter(SessionChannel channel, CreateLetterDto letter) {
    final bloc = _rooms[letter.roomId];
    if (bloc == null) {
      debugLog('not found bloc');
      return;
    }

    final hasAccess = bloc.hasAccess(channel.session.user.role);
    if (hasAccess) {
      bloc.add(LetterEvent.newLetter(channel, letter));
    }
  }

  void removeLetter(SessionChannel channel, int roomId, int letterId) {
    final bloc = _rooms[roomId];
    if (bloc == null) return;

    final hasAccess = bloc.hasAccess(channel.session.user.role);
    if (hasAccess) {
      bloc.add(LetterEvent.removeLetter(channel, letterId));
    }
  }
}
