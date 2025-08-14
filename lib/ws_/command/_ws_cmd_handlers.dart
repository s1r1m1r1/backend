// This map is defined outside the stream listener, usually at the top of the file or in a separate file.
import 'package:backend/ws_/command/auth/login_cmd.dart';
import 'package:backend/ws_/command/auth/with_refresh_cmd.dart';
import 'package:backend/ws_/command/auth/with_token_cmd.dart';
import 'package:backend/ws_/command/join_main_cmd.dart';
import 'package:sha_red/sha_red.dart';

import 'package:backend/ws_/command/_ws_cmd.dart';
import 'package:backend/ws_/command/join_admin_cmd.dart';
import 'package:backend/ws_/command/increment_counter_cmd.dart';
import 'package:backend/ws_/command/decrement_counter_cmd.dart';
import 'package:backend/ws_/command/new_letter_cmd.dart';
import 'package:backend/ws_/command/delete_letter_cmd.dart';
import 'package:backend/ws_/command/join_letters_cmd.dart';
import 'package:backend/ws_/command/join_counter_cmd.dart';
import 'package:backend/ws_/command/unimplemented_cmd.dart';

const wsCommandHandlers = <WsEventToServer, WsCommand>{
  // WsEventToServer.joinAdmin: JoinAdminCommand(),
  WsEventToServer.incrementCounter: IncrementCounterCommand(),
  WsEventToServer.decrementCounter: DecrementCounterCommand(),
  // WsEventToServer.newLetter: NewLetterCommand(),
  // WsEventToServer.deleteLetter: DeleteLetterCommand(),
  // WsEventToServer.joinLetters: JoinLettersCommand(),
  // WsEventToServer.joinCounter: JoinCounterCommand(),
  WsEventToServer.leaveRoom: LeaveRoomCommand(),
  WsEventToServer.listRooms: ListRoomsCommand(),
  WsEventToServer.sendLetterToRoom: SendLetterToRoomCommand(),
  WsEventToServer.fetchRoomHistory: FetchRoomHistoryCommand(),
  // WsEventToServer.joinMain: JoinMainCommand(),
  WsEventToServer.withToken: WithTokenCMD(),
  WsEventToServer.withRefresh: WithRefreshCMD(),
  WsEventToServer.login: LoginCMD(),
  // WsEventToServer.signup: SignupCMD(),

  // ... and so on
};

typedef FromJsonT<T> = T Function(Json json);

const wsEventToServerParser = <WsEventToServer, FromJsonT>{
  WsEventToServer.signup: EmailCredentialDto.fromJson,
  WsEventToServer.login: EmailCredentialDto.fromJson,
  WsEventToServer.withToken: AccessTokenDto.fromJson,
  WsEventToServer.withRefresh: AccessTokenDto.fromJson,
  // WsEventToServer.decrementCounter: DecrementCounterCommand(),
  // WsEventToServer.incrementCounter: DecrementCounterCommand(),
  // WsEventToServer.joinAdmin: JoinAdminCommand(),
  // WsEventToServer.newLetter: NewLetterCommand(),
  // WsEventToServer.deleteLetter: DeleteLetterCommand(),
  // WsEventToServer.joinLetters: JoinLettersCommand(),
  // WsEventToServer.joinCounter: JoinCounterCommand(),
  // WsEventToServer.leaveRoom: LeaveRoomCommand(),
  // WsEventToServer.listRooms: ListRoomsCommand(),
  // WsEventToServer.sendLetterToRoom: SendLetterToRoomCommand(),
  // WsEventToServer.fetchRoomHistory: FetchRoomHistoryCommand(),
  // WsEventToServer.joinMain: JoinMainCommand(),
};
