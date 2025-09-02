import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';

@lazySingleton
class BotRepository {
  FutureOr<void> add(ToServer toServer) {
    try {
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
      }
    } catch (e) {
      print(e);
    }
  }
}
