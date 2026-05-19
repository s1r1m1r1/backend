import 'package:dto/dto.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants.dart';
import '../../../core/debug_log.dart';
import '../../auth/application/session_socket.dart';
import '../domain/letters_repository.dart';
import 'letters_broad.dart';

@lazySingleton
class LettersBroadManager {
  LettersBroadManager(this._lettersRepository);
  final LettersRepository _lettersRepository;
  // main rooms
  final _rooms = <Role, LettersBroad>{};

  // LettersBroad? getBloc(BroadcastId roomId) => _rooms[roomId];

  @postConstruct
  void createRooms() {
    _rooms[Role.develop] = LettersBroad(
      _lettersRepository,
      BroadcastId(BroadcastKeys.developLetters),
    );
    _rooms[Role.user] = LettersBroad(
      _lettersRepository,
      BroadcastId(BroadcastKeys.publicLetters),
    );
  }

  void subscribe(GameSocket socket, String n) {
    final role = socket.session.user.role;
    final bloc = _rooms[role];
    if (bloc == null) return;
    bloc.subscribeChannel(socket, n);
  }

  void newLetter(GameSocket socket, NewLetterRequest message) {
    final role = socket.session.user.role;
    final bloc = _rooms[role];
    if (bloc == null) {
      debugLog('not found bloc');
      return;
    }
    bloc.newLetter(socket, message.content, message.n);
  }

  void removeLetter(GameSocket socket, DeleteLetterRequest message) {
    final role = socket.session.user.role;
    final broadcast = _rooms[role];
    if (broadcast == null) return;
    // проверить может ли пользователь удалить сообщение
    // final hasAccess = bloc.hasAccess(socket.session.user.role);
    broadcast.removeLetters(socket, message.letterId, message.n);
  }

  void editLetter(GameSocket socket, EditLetterRequest message) {
    final role = socket.session.user.role;
    final bloc = _rooms[role];
    if (bloc == null) return;
    bloc.editLetter(socket, message.letterId, message.content, message.n);
  }
}
