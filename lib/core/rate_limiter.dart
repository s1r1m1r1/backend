import 'dart:async';

import 'package:dto/dto.dart';
import 'package:injectable/injectable.dart';

// ---------------------------------------------------------------------------
// Token Bucket rate limiter with penalty escalation
// ---------------------------------------------------------------------------
// Two-layer design:
//   1. Token bucket — smooth rate limiting, allows bursts up to capacity
//   2. Penalty tracker — escalates on repeated violations (warning → mute → close)
//
// All methods are synchronous — Dart's single-threaded event loop guarantees
// atomicity for non-async map operations.
// ---------------------------------------------------------------------------

class _Bucket {
  _Bucket({required this.tokens, required this.lastRefill});

  double tokens;
  DateTime lastRefill;

  void refill(RateLimitTier tier, DateTime now) {
    final elapsed = now.difference(lastRefill).inMilliseconds / 1000.0;
    tokens = (tokens + elapsed * tier.refillRate).clamp(0.0, tier.capacity);
    lastRefill = now;
  }
}

class _PenaltyState {
  _PenaltyState();

  int count = 0;
  DateTime? mutedUntil;
  DateTime? lastViolation;

  PenaltyLevel get level => switch (count) {
    0 || 1 => PenaltyLevel.warning,
    2 => PenaltyLevel.mute5s,
    3 => PenaltyLevel.mute30s,
    _ => PenaltyLevel.close,
  };

  bool isMuted(DateTime now) => mutedUntil != null && now.isBefore(mutedUntil!);

  int? remainingMuteMs(DateTime now) {
    if (mutedUntil == null) return null;
    final ms = mutedUntil!.difference(now).inMilliseconds;
    return ms > 0 ? ms : null;
  }

  PenaltyLevel record(DateTime now) {
    if (lastViolation != null &&
        now.difference(lastViolation!) > const Duration(minutes: 5)) {
      count = 0;
      mutedUntil = null;
    }
    lastViolation = now;
    count++;

    if (count == 2) {
      mutedUntil = now.add(const Duration(seconds: 5));
    } else if (count == 3) {
      mutedUntil = now.add(const Duration(seconds: 30));
    }

    return level;
  }
}

@lazySingleton
class RateLimiter {
  RateLimiter() : _now = DateTime.now;
  RateLimiter.withClock(this._now);

  final Map<UserId, Map<int, _Bucket>> _buckets = {};
  final Map<UserId, _PenaltyState> _penalties = {};
  final DateTime Function() _now;

  // —— Public API ——

  /// Check if request is allowed. Consumes tokens if available.
  /// [tokenCost] defaults to 1.0, but can be higher for heavy requests.
  /// Returns true if rate limited (blocked).
  bool isRateLimitedByTier(
    UserId userId,
    RateLimitTier tier, {
    double tokenCost = 1.0,
  }) {
    if (tier.isUnlimited) return false;

    final now = _now();

    // Check mute first
    final penalty = _penalties[userId];
    if (penalty != null && penalty.isMuted(now)) return true;

    // Token bucket
    final userBuckets = _buckets.putIfAbsent(userId, () => {});
    final bucket = userBuckets.putIfAbsent(
      tier.index,
      () => _Bucket(tokens: tier.capacity, lastRefill: now),
    );
    bucket.refill(tier, now);

    if (bucket.tokens >= tokenCost) {
      bucket.tokens -= tokenCost;
      return false;
    }

    // No token — record penalty
    _penalties.putIfAbsent(userId, () => _PenaltyState()).record(now);
    return true;
  }

  /// Legacy: check burst + sustained tiers
  bool isRateLimited(UserId userId) =>
      isRateLimitedByTier(userId, RateLimitTier.burst) ||
      isRateLimitedByTier(userId, RateLimitTier.sustained);

  /// Record a violation manually (e.g. from ws_cmd). Returns penalty level.
  PenaltyLevel recordViolation(UserId userId) =>
      _penalties.putIfAbsent(userId, () => _PenaltyState()).record(_now());

  /// Current penalty level for user
  PenaltyLevel getPenaltyLevel(UserId userId) =>
      _penalties[userId]?.level ?? PenaltyLevel.warning;

  /// Current violation count
  int getViolationCount(UserId userId) => _penalties[userId]?.count ?? 0;

  /// Whether user is currently muted
  bool isMuted(UserId userId) {
    final p = _penalties[userId];
    return p != null && p.isMuted(_now());
  }

  /// Remaining mute duration in ms, null if not muted
  int? getMuteRemainingMs(UserId userId) =>
      _penalties[userId]?.remainingMuteMs(_now());

  /// Milliseconds until next token available, null if allowed now
  int? nextRefillMs(UserId userId, RateLimitTier tier) {
    final bucket = _buckets[userId]?[tier.index];
    if (bucket == null || bucket.tokens >= 1.0) return null;
    final needed = 1.0 - bucket.tokens;
    return ((needed / tier.refillRate) * 1000).ceil() + 100;
  }

  // —— Cleanup ——

  Timer? _cleanupTimer;

  void startCleanupTimer() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _cleanup(),
    );
  }

  void stopCleanupTimer() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  void _cleanup() {
    final now = _now();
    _buckets.removeWhere((_, tiers) {
      tiers.removeWhere(
        (_, b) => now.difference(b.lastRefill) > const Duration(minutes: 5),
      );
      return tiers.isEmpty;
    });
    _penalties.removeWhere(
      (_, p) =>
          p.lastViolation != null &&
          now.difference(p.lastViolation!) > const Duration(minutes: 5),
    );
  }
}

// ---------------------------------------------------------------------------
// Tier → Token Bucket params
// ---------------------------------------------------------------------------

extension _TierParams on RateLimitTier {
  double get capacity => maxMessages.toDouble();
  double get refillRate => maxMessages / windowSeconds;
}
