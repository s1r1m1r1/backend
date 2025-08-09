// This map is defined outside the stream listener, usually at the top of the file or in a separate file.
import 'package:backend/web_socket/command/join_main_cmd.dart';
import 'package:sha_red/sha_red.dart';

import '_ws_cmd.dart';
import 'join_admin_cmd.dart';
import 'increment_counter_cmd.dart';
import 'decrement_counter_cmd.dart';
import 'new_letter_cmd.dart';
import 'delete_letter_cmd.dart';
import 'join_letters_cmd.dart';
import 'join_counter_cmd.dart';
import 'unimplemented_cmd.dart';

const wsCommandHandlers = <WsEventToServer, WsCommand>{
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
  WsEventToServer.joinMain: JoinMainCommand(),
  // ... and so on
};
