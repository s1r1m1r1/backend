import 'package:backend/game/unit_repository.dart';
import 'package:backend/user/session_repository.dart';
import 'package:backend/ws_/logic/active_users/active_users.broad.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ActiveUsersBroadManager {
  ActiveUsersBroadManager(this._unitRepository, this._sessionRepository);
  final UnitRepository _unitRepository;
  final SessionRepository _sessionRepository;

  // main rooms
  final _rooms = <int, ActiveUsersBroad>{};
  int? _defaultRoom;

  ActiveUsersBroad getBloc([int? roomId]) => _rooms[roomId ?? _defaultRoom]!;

  void createRoom(int roomId) {
    _defaultRoom ??= roomId;
    _rooms[roomId] = ActiveUsersBroad(
      _unitRepository,
      _sessionRepository,
      roomId,
    );
  }

  // void subscribe(SessionChannel channel, int roomId) {
  //   final bloc = _rooms[roomId];
  //   if (bloc == null) return;

  //   bloc.subscribeChannel(channel);
  // }

  void join(WebSocketChannel channel, String token) {
    getBloc().join(channel, token);
  }

  void removeUser(WebSocketChannel channel) {
    getBloc().removeUser(channel);
  }
}
