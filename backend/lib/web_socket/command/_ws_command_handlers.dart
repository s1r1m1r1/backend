// This map is defined outside the stream listener, usually at the top of the file or in a separate file.
import 'package:sha_red/sha_red.dart';

import '_ws_command.dart';
import 'join_admin_command.dart';
import 'increment_counter_command.dart';
import 'decrement_counter_command.dart';
import 'new_letter_command.dart';
import 'delete_letter_command.dart';
import 'join_letters_command.dart';
import 'join_counter_command.dart';
import 'leave_room_command.dart';
import 'unimplemented_command.dart';

final wsCommandHandlers = <WsEventToServer, WsCommand>{
  WsEventToServer.joinAdmin: JoinAdminCommand(),
  WsEventToServer.incrementCounter: IncrementCounterCommand(),
  WsEventToServer.decrementCounter: DecrementCounterCommand(),
  WsEventToServer.newLetter: NewLetterCommand(),
  WsEventToServer.deleteLetter: DeleteLetterCommand(),
  WsEventToServer.joinLetters: JoinLettersCommand(),
  WsEventToServer.joinCounter: JoinCounterCommand(),
  WsEventToServer.leaveRoom: LeaveRoomCommand(),
  WsEventToServer.listRooms: ListRoomsCommand(),
  WsEventToServer.sendLetterToRoom: SendLetterToRoomCommand(),
  WsEventToServer.fetchRoomHistory: FetchRoomHistoryCommand(),
  // ... and so on
};
