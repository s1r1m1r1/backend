import 'dart:async';

import 'package:backend/core/debug_log.dart';
import 'package:backend/modules/game/active_users.broadcast.dart';
import 'package:backend/modules/game/session_channel.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';

@lazySingleton
class BotRepository {
  final ActiveUsersBroad _onlineBroadcast;
  BotRepository(this._onlineBroadcast);
  FutureOr<void> add(SinkBot botSink, ToServer toServer) {
    try {
      debugLog('BotRepository add: $toServer');
      switch (toServer) {
        case WithTokenTS():
        case GetJoinedBroadsTS():
        case CreateNewEdictTS():
        case JoinEdictTS():
        case LeaveEdictTS():
        case NewLetterTS():
        case DeleteLetterTS():
        case JoinLettersTS():
        case JoinArenaTS():
        case LeaveArenaTS():
        case CreateBattleRoomTS():
          break;
        case JoinBattleRoomTS():
        case LeaveBattleRoom():
          break;
        case DisconnectTS():
          _onlineBroadcast.removeUser(botSink);
          // _activeUsersRepository.remo
          break;
      }
    } catch (e) {
      print(e);
    }
  }
}
