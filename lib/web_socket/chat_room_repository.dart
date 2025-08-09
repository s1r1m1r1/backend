// ignore_for_file: unused_field

import '../core/debug_log.dart';
import '../core/log_colors.dart';
import '../db_client/dao/room_dao.dart';
import 'package:injectable/injectable.dart';

import '../inject/inject.dart';

@LazySingleton(scope: BackendScope.name)
class ChatRoomRepository {
  final RoomDao _dao;
  final _chatRoom = <String>[];
  ChatRoomRepository(this._dao);

  void add(String roomId) {
    debugLog('$green CounterRepository:putCounter $roomId $reset');
    if (!_chatRoom.contains(roomId)) {
      _chatRoom.add(roomId);
    }
  }

  bool isValid(String roomId) {
    return _chatRoom.contains(roomId);
  }
}
