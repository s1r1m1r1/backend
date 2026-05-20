import 'dart:async';

import 'package:dto/dto.dart';
import 'package:injectable/injectable.dart';

/// Holds rate-limiting state for a single user.
class UserRateState {
  final List<DateTime> burstTimestamps = [];
  final List<DateTime> sustainedTimestamps = [];
  DateTime lastActivity = DateTime.now();

  /// Per-tier timestamps: key = RateLimitTier.index.
  final Map<int, List<DateTime>> tierTimestamps = {};

  /// Number of consecutive violations (for penalty escalation).
  int violationCount = 0;

  /// When the user is muted until (null = not muted).
  DateTime? mutedUntil;

  /// Timestamp of the last violation (for TTL reset).
  DateTime? lastViolationAt;
}

/// Centralized rate limiter service with sliding-window burst + sustained checks.
///
/// Two sliding windows are checked:
/// - **Burst**: max 5 messages per 1 second — prevents sudden spikes.
/// - **Sustained**: max 30 messages per 10 seconds — prevents continuous flood.
///
/// Stale entries (no activity for >5 minutes) are purged periodically.
@lazySingleton
class RateLimiter {
  final Map<UserId, UserRateState> _states = {};

  final DateTime Function() _clock;

  RateLimiter({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  static const _burstLimit = 5;
  static const _burstWindow = Duration(seconds: 1);
  static const _sustainedLimit = 30;
  static const _sustainedWindow = Duration(seconds: 10);
  static const _staleThreshold = Duration(minutes: 5);

  /// Violation TTL — if no violation occurs within this window,
  /// the violation counter resets to 0 (P2.2).
  static const _violationTtl = Duration(minutes: 5);

  /// Mute durations for each penalty escalation level.
  static const _mute5s = Duration(seconds: 5);
  static const _mute30s = Duration(seconds: 30);

  Timer? _cleanupTimer;

  /// Starts the periodic cleanup timer (every 60 seconds).
  void startCleanupTimer() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _purgeStaleEntries();
    });
  }

  /// Stops the cleanup timer. Call on app shutdown.
  void stopCleanupTimer() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  /// Returns `true` if the user has exceeded either the burst or sustained rate limit.
  bool isRateLimited(UserId userId) {
    final now = _clock();
    final state = _states.putIfAbsent(userId, () => UserRateState());
    state.lastActivity = now;

    // Purge old timestamps outside the sustained window (covers both windows).
    final cutoffSustained = now.subtract(_sustainedWindow);
    state.sustainedTimestamps.removeWhere((t) => t.isBefore(cutoffSustained));

    final cutoffBurst = now.subtract(_burstWindow);
    state.burstTimestamps.removeWhere((t) => t.isBefore(cutoffBurst));

    // Check burst limit (short window).
    if (state.burstTimestamps.length >= _burstLimit) {
      return true;
    }

    // Check sustained limit (long window).
    if (state.sustainedTimestamps.length >= _sustainedLimit) {
      return true;
    }

    // Record the message in both windows.
    state.burstTimestamps.add(now);
    state.sustainedTimestamps.add(now);
    return false;
  }

  /// Returns `true` if the user has exceeded the rate limit for the given [tier].
  ///
  /// For [RateLimitTier.none] (ping/ack) always returns `false`.
  /// Uses a per-tier sliding window with the tier's own
  /// [RateLimitTier.maxMessages] and [RateLimitTier.windowDuration].
  bool isRateLimitedByTier(UserId userId, RateLimitTier tier) {
    if (tier.isUnlimited) return false;

    final now = _clock();
    final state = _states.putIfAbsent(userId, () => UserRateState());
    state.lastActivity = now;

    final timestamps = state.tierTimestamps.putIfAbsent(
      tier.index,
      () => <DateTime>[],
    );

    // Purge timestamps outside this tier's window.
    final cutoff = now.subtract(tier.windowDuration);
    timestamps.removeWhere((t) => t.isBefore(cutoff));

    // Check tier limit.
    if (timestamps.length >= tier.maxMessages) {
      return true;
    }

    // Record the message.
    timestamps.add(now);
    return false;
  }

  /// Records a rate-limit violation and returns the [PenaltyLevel].
  ///
  /// Escalation logic (P2.1):
  /// - 1st violation → [PenaltyLevel.warning]
  /// - 2nd violation → [PenaltyLevel.mute5s]
  /// - 3rd violation → [PenaltyLevel.mute30s]
  /// - 4th+ violation → [PenaltyLevel.close]
  ///
  /// If the time since the last violation exceeds [_violationTtl] (5 minutes),
  /// the counter resets to 0 before recording (P2.2).
  PenaltyLevel recordViolation(UserId userId) {
    final now = _clock();
    final state = _states.putIfAbsent(userId, () => UserRateState());
    state.lastActivity = now;

    // P2.2: TTL reset — if >5 min since last violation, reset counter.
    final lastViolation = state.lastViolationAt;
    if (lastViolation != null &&
        now.difference(lastViolation) > _violationTtl) {
      state.violationCount = 0;
      state.mutedUntil = null;
    }

    // Increment counter and update timestamp.
    state.violationCount++;
    state.lastViolationAt = now;

    // Determine penalty level.
    final PenaltyLevel penalty;
    if (state.violationCount <= 1) {
      penalty = PenaltyLevel.warning;
    } else if (state.violationCount == 2) {
      penalty = PenaltyLevel.mute5s;
      state.mutedUntil = now.add(_mute5s);
    } else if (state.violationCount == 3) {
      penalty = PenaltyLevel.mute30s;
      state.mutedUntil = now.add(_mute30s);
    } else {
      penalty = PenaltyLevel.close;
    }

    return penalty;
  }

  /// Returns `true` if the user is currently muted.
  ///
  /// When `true`, all messages from the user should be silently ignored.
  bool isMuted(UserId userId) {
    final state = _states[userId];
    if (state == null) return false;
    final mutedUntil = state.mutedUntil;
    if (mutedUntil == null) return false;
    return _clock().isBefore(mutedUntil);
  }

  /// Returns the current [PenaltyLevel] for a user without recording a new violation.
  ///
  /// Useful for including the current status in error responses (P2.3).
  PenaltyLevel getPenaltyLevel(UserId userId) {
    final state = _states[userId];
    if (state == null) return PenaltyLevel.warning;
    final count = state.violationCount;
    if (count <= 0) return PenaltyLevel.warning;
    if (count == 1) return PenaltyLevel.warning;
    if (count == 2) return PenaltyLevel.mute5s;
    if (count == 3) return PenaltyLevel.mute30s;
    return PenaltyLevel.close;
  }

  /// Returns the current violation count for a user.
  int getViolationCount(UserId userId) {
    return _states[userId]?.violationCount ?? 0;
  }

  /// Returns the remaining mute duration in milliseconds, or `null` if not muted.
  int? getMuteRemainingMs(UserId userId) {
    final state = _states[userId];
    if (state == null) return null;
    final mutedUntil = state.mutedUntil;
    if (mutedUntil == null) return null;
    final remaining = mutedUntil.difference(_clock());
    if (remaining.isNegative) return null;
    return remaining.inMilliseconds;
  }

  /// Removes entries with no activity for more than 5 minutes.
  void _purgeStaleEntries() {
    final now = _clock();
    final toRemove = <UserId>[];
    for (final entry in _states.entries) {
      if (now.difference(entry.value.lastActivity) > _staleThreshold) {
        toRemove.add(entry.key);
      }
    }
    for (final userId in toRemove) {
      _states.remove(userId);
    }
  }
}
