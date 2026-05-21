import 'package:dto/dto.dart';

import 'rate_limiter.dart';

/// Maps each WsRequest subtype to its [RateLimitTier].
///
/// Used by the centralized [RateLimiter] to apply per-command-type quotas.
/// Commands not listed here default to [RateLimitTier.normal].
extension RateLimitTierMapping on WsRequest {
  /// Returns the [RateLimitTier] for this request type.
  RateLimitTier get rateLimitTier {
    // Light messages (marked with LightRequest) - no rate limiting
    if (this is LightRequest) {
      return RateLimitTier.none;
    }

    return switch (this) {
      // --- No limit (keep-alive) ---
      PingRequest() => RateLimitTier.none,
      AckRequest() => RateLimitTier.none,

      // --- Relaxed: new_letter — 10 / 30s ---
      NewLetterRequest() => RateLimitTier.relaxed,

      // --- Normal: edit_letter, delete_letter — 15 / 30s ---
      EditLetterRequest() => RateLimitTier.normal,
      DeleteLetterRequest() => RateLimitTier.normal,

      // --- Strict: 3 / 5s ---
      JoinArenaRequest() => RateLimitTier.strict,
      LeaveArenaRequest() => RateLimitTier.strict,
      JoinBattleRoomRequest() => RateLimitTier.strict,
      ChangeLocationRequest() => RateLimitTier.strict,

      // --- Critical: game_action, allocate_stats — 5 / 1s ---
      GameActionRequest() => RateLimitTier.critical,
      AllocateStatsRequest() => RateLimitTier.critical,

      // --- Sync: sync_* — 2 / 3s ---
      SyncCombatStateRequest() => RateLimitTier.sync,
      SyncJoinedBroadsRequest() => RateLimitTier.sync,
      SyncMenuRequest() => RateLimitTier.sync,
      SyncOnlineUsers() => RateLimitTier.sync,

      // --- Admin: create_bots, reset_* — 1 / 5s ---
      CreateBotsRequest() => RateLimitTier.admin,
      ResetCombatsRequest() => RateLimitTier.admin,
      ResetEdictsRequest() => RateLimitTier.admin,

      // --- Default: treat as normal ---
      _ => RateLimitTier.normal,
    };
  }
}
