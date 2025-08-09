// ignore_for_file: unused_field

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/db_client/dao/room_dao.dart';
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
