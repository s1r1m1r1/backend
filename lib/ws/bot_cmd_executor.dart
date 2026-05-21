import 'package:dto/dto.dart';
import 'package:injectable/injectable.dart';

import '../core/rate_limit_tier_mapping.dart';
import '../core/rate_limiter.dart';

/// Executor for bot commands with integrated rate limiting.
///
/// Provides rate limit checking for bot commands before they are processed
/// by [BotRepository]. Tracks penalty levels and can disable broken bots
/// that consistently violate rate limits.
@lazySingleton
class BotCmdExecutor {
  BotCmdExecutor(this._rateLimiter);

  final RateLimiter _rateLimiter;

  /// Tracks bots that have been disabled due to repeated rate limit violations.
  final _disabledBots = <UserId>{};

  /// Tracks consecutive rate limit violations per bot.
  final _violationCounts = <UserId, int>{};

  /// Threshold for disabling a bot (5 consecutive violations).
  static const _disableThreshold = 5;

  /// Checks if a bot command is allowed under rate limiting.
  ///
  /// Returns `true` if the command should be BLOCKED (rate limited).
  /// Returns `false` if the command is allowed to proceed.
  bool isCommandBlocked(UserId userId, WsRequest message) {
    // Check if bot is already disabled
    if (_disabledBots.contains(userId)) {
      return true;
    }

    // Get rate limit tier for this command
    final tier = message.rateLimitTier;

    // Skip check for unlimited tiers
    if (tier.isUnlimited) {
      _resetViolations(userId);
      return false;
    }

    // Calculate token cost: HeavyRequest = 10 tokens, Regular = 1 token
    final tokenCost = message is HeavyRequest ? 10.0 : 1.0;

    // Check rate limit with appropriate token cost
    final isLimited = _rateLimiter.isRateLimitedByTier(
      userId,
      tier,
      tokenCost: tokenCost,
    );

    if (isLimited) {
      _recordViolation(userId);
      return true; // Block the command
    } else {
      _resetViolations(userId);
      return false; // Allow the command
    }
  }

  void _recordViolation(UserId userId) {
    final count = (_violationCounts[userId] ?? 0) + 1;
    _violationCounts[userId] = count;

    // Note: RateLimiter already records violation in isRateLimitedByTier()
    // We only track consecutive violations for auto-disabling bots

    if (count >= _disableThreshold) {
      _disabledBots.add(userId);
      _violationCounts.remove(userId);
    }
  }

  void _resetViolations(UserId userId) {
    _violationCounts.remove(userId);
  }

  /// Check if a bot is disabled.
  bool isBotDisabled(UserId userId) => _disabledBots.contains(userId);

  /// Re-enable a disabled bot (for testing or manual recovery).
  void enableBot(UserId userId) {
    _disabledBots.remove(userId);
    _violationCounts.remove(userId);
  }

  /// Get violation count for a bot.
  int getViolationCount(UserId userId) => _violationCounts[userId] ?? 0;

  /// Get penalty level for a bot from RateLimiter.
  PenaltyLevel getPenaltyLevel(UserId userId) {
    return _rateLimiter.getPenaltyLevel(userId);
  }

  /// Get remaining mute time in milliseconds, if any.
  int? getMuteRemainingMs(UserId userId) {
    return _rateLimiter.getMuteRemainingMs(userId);
  }
}
