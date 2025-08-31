import 'package:backend/core/debug_log.dart';
import 'package:backend/core/session_channel.dart';
import 'package:backend/modules/game/domain/letters_repository.dart';
import 'package:backend/modules/game/letters.broad.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';

@module
abstract class LettersBroadManagerModule {
  @prod
  @lazySingleton
  LettersBroadManager prodLettersManager(LettersRepository rep) {
    final manager = LettersBroadManager(rep);
    manager.createRoom(1);
    return manager;
  }

  @test
  @dev
  @lazySingleton
  LettersBroadManager devLettersManager(LettersRepository rep) {
    final manager = LettersBroadManager(rep);
    manager.createRoom(2);
    return manager;
  }
}

class LettersBroadManager {
  LettersBroadManager(this._lettersRepository);
  final LettersRepository _lettersRepository;
  // main rooms
  final _rooms = <int, LettersBroad>{};

  LettersBroad? getBloc(int roomId) => _rooms[roomId];

  void createRoom(int roomId) {
    _rooms[roomId] = LettersBroad(_lettersRepository, roomId);
  }

  void subscribe(SessionChannel channel, int roomId) {
    final bloc = _rooms[roomId];
    if (bloc == null) return;

    final hasAccess = bloc.hasAccess(channel.session.user.role);
    if (hasAccess) {
      bloc.subscribeChannel(channel);
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
      bloc.newLetter(channel, letter);
    }
  }

  void removeLetter(SessionChannel channel, int roomId, int letterId) {
    final bloc = _rooms[roomId];
    if (bloc == null) return;

    final hasAccess = bloc.hasAccess(channel.session.user.role);
    if (hasAccess) {
      bloc.removeLetter(channel, letterId);
    }
  }
}
