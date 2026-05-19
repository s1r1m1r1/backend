import 'dart:async';

import 'package:dart_frog/dart_frog.dart' hide Request;
import 'package:dto/dto.dart';

import '../features/auth/application/session_socket.dart';
import 'ack.cmd.dart';
import 'allocate_stats.cmd.dart';
import 'change_location.cmd.dart';
import 'change_unit_stats.cmd.dart';
import 'create_bots.cmd.dart';
import 'create_new_edict.cmd.dart';
import 'delete_letter.cmd.dart';
import 'disconnect.cmd.dart';
import 'edit_letter.cmd.dart';
import 'focus_combat_observer.cmd.dart';
import 'game_action.cmd.dart';
import 'get_unit_stats.cmd.dart';
import 'join_arena.cmd.dart';
import 'join_as_combat_observer.cmd.dart';
import 'join_battle_room.cmd.dart';
import 'join_edict.cmd.dart';
import 'join_letters.cmd.dart';
import 'leave_arena.cmd.dart';
import 'leave_edict.cmd.dart';
import 'new_letter.cmd.dart';
import 'ping.cmd.dart';
import 'remove_bots.cmd.dart';
import 'reset_combats.cmd.dart';
import 'reset_edicts.cmd.dart';
import 'sync_combat_state.cmd.dart';
import 'sync_joined_broads.cmd.dart';
import 'sync_menu.cmd.dart';
import 'sync_online_users.cmd.dart';
import 'with_token.cmd.dart';
import 'ws_cmd.dart';

class WsCmdExecutor {
  static FutureOr<void> execute(
    RequestContext context,
    UserChannel channel,
    WsRequest message,
  ) {
    final WsCmd command = switch (message) {
      // Auth commands
      AuthTs() => switch (message) {
        AckTs() => const AckCmd(),
        PingTs() => const PingCmd(),
        WithTokenTs() => const WithTokenCmd(),
        DisconnectTs() => const DisconnectCmd(),
      },

      // Menu commands
      MenuTs() => switch (message) {
        SyncMenuTs() => const SyncMenuCmd(),
        SyncOnlineUsers() => const SyncOnlineUsersCmd(),
        ChangeLocationTs() => const ChangeLocationCmd(),
      },

      // Unit commands
      UnitTs() => switch (message) {
        AllocateStatsTs() => const AllocateStatsCmd(),
        GetUnitStatsTs() => const GetUnitStatsCmd(),
      },

      // Letter commands
      LetterTs() => switch (message) {
        JoinLettersTs() => const JoinLettersCmd(),
        NewLetterTs() => const NewLetterCmd(),
        EditLetterTs() => const EditLetterCmd(),
        DeleteLetterTs() => const DeleteLetterCmd(),
      },

      // Arena commands
      ArenaTs() => switch (message) {
        JoinArenaTs() => const JoinArenaCmd(),
        LeaveArenaTs() => const LeaveArenaCmd(),
        CreateNewEdictTs() => const CreateNewEdictCmd(),
        JoinEdictTs() => const JoinEdictCmd(),
        LeaveEdictTs() => const LeaveEdictCmd(),
      },

      // Combat commands
      CombatTs() => switch (message) {
        JoinBattleRoomTs() => const JoinBattleRoomCmd(),
        LeaveBattleRoom() => throw UnimplementedError(
          'LeaveBattleRoom not implemented',
        ),
        JoinAsCombatObserverTs() => const JoinAsCombatObserverCmd(),
        FocusCombatObserverTs() => const FocusCombatObserverCmd(),
        GameActionTs() => const GameActionCmd(),
        SyncCombatStateTs() => const SyncCombatStateCmd(),
      },

      // Broadcast commands
      BroadcastTs() => switch (message) {
        SyncJoinedBroadsTs() => const SyncJoinedBroadsCmd(),
      },

      // Developer commands
      DeveloperTs() => switch (message) {
        ResetEdictsTs() => const ResetEdictsCmd(),
        ResetCombatsTs() => const ResetCombatsCmd(),
        CreateBotsTs() => const CreateBotsCmd(),
        RemoveBotsTs() => const RemoveBotsCmd(),
        ChangeUnitStatsTs() => const ChangeUnitStatsCmd(),
      },
    };

    return command.execute(context, channel, message);
  }
}
