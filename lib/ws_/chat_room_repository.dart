// ignore_for_file: unused_field

import 'package:backend/db_client/db_client.dart';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';

class ChatRoomRepository {
  // RoomDao get _dao => _db.roomDao;
  final _chatRoom = <String>[];
  ChatRoomRepository(this._db);
  final DbClient _db;

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
