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
import 'frontend_version.cmd.dart';
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
      AuthRequest() => switch (message) {
        AckRequest() => const AckCmd(),
        PingRequest() => const PingCmd(),
        WithTokenRequest() => const WithTokenCmd(),
        DisconnectRequest() => const DisconnectCmd(),
        FrontendVersionRequest() => const FrontendVersionCmd(),
      },

      // Menu commands
      MenuRequest() => switch (message) {
        SyncMenuRequest() => const SyncMenuCmd(),
        SyncOnlineUsers() => const SyncOnlineUsersCmd(),
        ChangeLocationRequest() => const ChangeLocationCmd(),
      },

      // Unit commands
      UnitRequest() => switch (message) {
        AllocateStatsRequest() => const AllocateStatsCmd(),
        GetUnitStatsRequest() => const GetUnitStatsCmd(),
      },

      // Letter commands
      LetterRequest() => switch (message) {
        JoinLettersRequest() => const JoinLettersCmd(),
        NewLetterRequest() => const NewLetterCmd(),
        EditLetterRequest() => const EditLetterCmd(),
        DeleteLetterRequest() => const DeleteLetterCmd(),
      },

      // Arena commands
      ArenaRequest() => switch (message) {
        JoinArenaRequest() => const JoinArenaCmd(),
        LeaveArenaRequest() => const LeaveArenaCmd(),
        CreateNewEdictRequest() => const CreateNewEdictCmd(),
        JoinEdictRequest() => const JoinEdictCmd(),
        LeaveEdictRequest() => const LeaveEdictCmd(),
      },

      // Combat commands
      CombatRequest() => switch (message) {
        JoinBattleRoomRequest() => const JoinBattleRoomCmd(),
        LeaveBattleRoom() => throw UnimplementedError(
          'LeaveBattleRoom not implemented',
        ),
        JoinAsCombatObserverRequest() => const JoinAsCombatObserverCmd(),
        FocusCombatObserverRequest() => const FocusCombatObserverCmd(),
        GameActionRequest() => const GameActionCmd(),
        SyncCombatStateRequest() => const SyncCombatStateCmd(),
      },

      // Broadcast commands
      BroadcastRequest() => switch (message) {
        SyncJoinedBroadsRequest() => const SyncJoinedBroadsCmd(),
      },

      // Developer commands
      DeveloperRequest() => switch (message) {
        ResetEdictsRequest() => const ResetEdictsCmd(),
        ResetCombatsRequest() => const ResetCombatsCmd(),
        CreateBotsRequest() => const CreateBotsCmd(),
        RemoveBotsRequest() => const RemoveBotsCmd(),
        ChangeUnitStatsRequest() => const ChangeUnitStatsCmd(),
      },
    };

    return command.execute(context, channel, message);
  }
}
