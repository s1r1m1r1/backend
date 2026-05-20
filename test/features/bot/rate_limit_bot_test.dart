import 'package:backend/core/rate_limiter.dart';
import 'package:backend/core/rate_limit_tier_mapping.dart';
import 'package:dto/dto.dart';
import 'package:test/test.dart';

/// Helper: creates a [RateLimiter] with controllable clock.
///
/// Each call to [advance] moves time forward by [increment].
/// The clock starts at 2026-01-01 and advances by [increment] on each tick.
({RateLimiter limiter, void Function() advance}) _makeLimiter({
  Duration increment = const Duration(milliseconds: 100),
}) {
  var callCount = 0;
  final epoch = DateTime(2026, 1, 1);
  final limiter = RateLimiter(
    clock: () {
      final idx = callCount;
      callCount++;
      return epoch.add(increment * idx);
    },
  );
  return (
    limiter: limiter,
    advance: () {
      // Use a non-unlimited tier so the clock is actually consumed.
      // RateLimitTier.none returns early without calling _clock().
      limiter.isRateLimitedByTier(const UserId('_tick'), RateLimitTier.relaxed);
    },
  );
}

/// Simulates the rate-limiting check that [AuthenticatedWsCmd.execute]
/// performs for a given request: looks up the tier via [rateLimitTier],
/// checks [RateLimiter.isRateLimitedByTier], and if limited, records
/// the violation.
bool _simulateCommand(RateLimiter limiter, UserId userId, WsRequest request) {
  final tier = request.rateLimitTier;
  if (limiter.isRateLimitedByTier(userId, tier)) {
    limiter.recordViolation(userId);
    return true; // blocked
  }
  return false; // allowed
}

void main() {
  // ---------------------------------------------------------------------------
  // 1. SpamBot — burst detection via relaxed-tier (NewLetterRequest)
  // ---------------------------------------------------------------------------
  group('SpamBot — burst detection', () {
    test('first 10 NewLetterRequests pass (relaxed tier = 10/30s)', () {
      final (limiter: limiter, advance: _) = _makeLimiter();
      const userId = UserId('spam_bot');

      for (var i = 0; i < 10; i++) {
        final req = WsRequest.newLetter(n: 'msg_$i', content: 'hello $i');
        final blocked = _simulateCommand(limiter, userId, req);
        expect(blocked, isFalse, reason: 'request $i should pass');
      }
    });

    test('11th NewLetterRequest is blocked (relaxed tier exceeded)', () {
      final (limiter: limiter, advance: _) = _makeLimiter();
      const userId = UserId('spam_bot');

      for (var i = 0; i < 10; i++) {
        final req = WsRequest.newLetter(n: 'msg_$i', content: 'hello $i');
        _simulateCommand(limiter, userId, req);
      }

      final blocked = _simulateCommand(
        limiter,
        userId,
        WsRequest.newLetter(n: 'msg_10', content: 'blocked'),
      );
      expect(blocked, isTrue, reason: '11th request should be blocked');
    });

    test('RateLimitErrorResponse fields are populated after violation', () {
      final (limiter: limiter, advance: _) = _makeLimiter();
      const userId = UserId('spam_bot');

      // Exhaust the tier limit (relaxed = 10/30s).
      for (var i = 0; i < 10; i++) {
        final req = WsRequest.newLetter(n: 'msg_$i', content: 'hello $i');
        _simulateCommand(limiter, userId, req);
      }

      // Trigger the violation (11th request).
      final req = WsRequest.newLetter(n: 'msg_10', content: 'blocked');
      _simulateCommand(limiter, userId, req);

      expect(limiter.getViolationCount(userId), equals(1));
      expect(limiter.getPenaltyLevel(userId), equals(PenaltyLevel.warning));
    });
  });

  // ---------------------------------------------------------------------------
  // 2. SlowBot — sustained detection (relaxed tier over longer window)
  // ---------------------------------------------------------------------------
  group('SlowBot — sustained detection', () {
    test('10 NewLetterRequests pass within 30s window (relaxed = 10/30s)', () {
      // 200ms between requests → 10 requests = 1800ms < 30s window
      final (limiter: limiter, advance: advance) = _makeLimiter(
        increment: const Duration(milliseconds: 200),
      );
      const userId = UserId('slow_bot');

      for (var i = 0; i < 10; i++) {
        final req = WsRequest.newLetter(n: 'slow_$i', content: 'msg $i');
        final blocked = _simulateCommand(limiter, userId, req);
        expect(blocked, isFalse, reason: 'request $i should pass');
        advance();
      }
    });

    test('11th NewLetterRequest blocked (relaxed tier = 10/30s exceeded)', () {
      final (limiter: limiter, advance: advance) = _makeLimiter(
        increment: const Duration(milliseconds: 200),
      );
      const userId = UserId('slow_bot');

      for (var i = 0; i < 10; i++) {
        final req = WsRequest.newLetter(n: 'slow_$i', content: 'msg $i');
        _simulateCommand(limiter, userId, req);
        advance();
      }

      final blocked = _simulateCommand(
        limiter,
        userId,
        WsRequest.newLetter(n: 'slow_10', content: 'blocked'),
      );
      expect(blocked, isTrue, reason: '11th request should be blocked');
    });
  });

  // ---------------------------------------------------------------------------
  // 3. Mixed commands — per-tier isolation
  // ---------------------------------------------------------------------------
  group('Mixed commands — per-tier isolation', () {
    test(
      'JoinArenaRequest blocked at 4th (strict = 3/5s) but PingRequest always passes',
      () {
        final (limiter: limiter, advance: advance) = _makeLimiter();
        const userId = UserId('mixed_bot');

        // Send 3 JoinArenaRequests — should pass (strict = 3/5s)
        for (var i = 0; i < 3; i++) {
          final req = WsRequest.joinArena(n: 'join_$i');
          final blocked = _simulateCommand(limiter, userId, req);
          expect(blocked, isFalse, reason: 'join $i should pass');
          advance();
        }

        // 4th JoinArenaRequest — blocked
        final blockedJoin = _simulateCommand(
          limiter,
          userId,
          WsRequest.joinArena(n: 'join_3'),
        );
        expect(blockedJoin, isTrue, reason: '4th join should be blocked');

        // But PingRequest (none tier) always passes
        for (var i = 0; i < 20; i++) {
          final ping = WsRequest.ping(n: 'ping_$i');
          final blocked = _simulateCommand(limiter, userId, ping);
          expect(blocked, isFalse, reason: 'ping should never be blocked');
        }
      },
    );

    test(
      'GameActionRequest blocked at 6th (critical = 5/1s) but AckRequest passes',
      () {
        final (limiter: limiter, advance: advance) = _makeLimiter();
        const userId = UserId('action_bot');

        // 5 game actions — pass (critical = 5/1s)
        for (var i = 0; i < 5; i++) {
          final req = WsRequest.gameAction(
            n: 'action_$i',
            combatRoomId: 'room1',
            action: const GameActionDto.attack(
              combatantId: 1,
              enemyCombatantId: 2,
            ),
          );
          final blocked = _simulateCommand(limiter, userId, req);
          expect(blocked, isFalse, reason: 'action $i should pass');
          advance();
        }

        // 6th game action — blocked
        final blocked = _simulateCommand(
          limiter,
          userId,
          WsRequest.gameAction(
            n: 'action_5',
            combatRoomId: 'room1',
            action: const GameActionDto.attack(
              combatantId: 1,
              enemyCombatantId: 2,
            ),
          ),
        );
        expect(blocked, isTrue, reason: '6th action should be blocked');

        // AckRequest (none tier) always passes
        final ackBlocked = _simulateCommand(
          limiter,
          userId,
          WsRequest.ack(n: 'ack_0'),
        );
        expect(ackBlocked, isFalse, reason: 'ack should never be blocked');
      },
    );

    test(
      'different tiers are independent — exhausting one does not affect another',
      () {
        final (limiter: limiter, advance: advance) = _makeLimiter();
        const userId = UserId('tier_bot');

        // Exhaust strict tier (3/5s) with JoinArenaRequest
        for (var i = 0; i < 3; i++) {
          _simulateCommand(limiter, userId, WsRequest.joinArena(n: 'arena_$i'));
          advance();
        }
        // 4th is blocked
        expect(
          _simulateCommand(limiter, userId, WsRequest.joinArena(n: 'arena_3')),
          isTrue,
        );

        // But relaxed tier (10/30s) is untouched — NewLetterRequest still passes
        for (var i = 0; i < 10; i++) {
          final blocked = _simulateCommand(
            limiter,
            userId,
            WsRequest.newLetter(n: 'letter_$i', content: 'hi'),
          );
          expect(blocked, isFalse, reason: 'letter $i should pass');
        }
      },
    );
  });

  // ---------------------------------------------------------------------------
  // 4. Window recovery
  // ---------------------------------------------------------------------------
  group('Window recovery', () {
    test(
      'after strict tier burst exhaustion, waiting 6s allows new requests',
      () {
        // 100ms per tick; need to advance past 5s window
        final (limiter: limiter, advance: advance) = _makeLimiter(
          increment: const Duration(milliseconds: 100),
        );
        const userId = UserId('recovery_bot');

        // Exhaust strict tier (3/5s)
        for (var i = 0; i < 3; i++) {
          final blocked = _simulateCommand(
            limiter,
            userId,
            WsRequest.joinArena(n: 'join_$i'),
          );
          expect(blocked, isFalse);
          advance();
        }
        // 4th blocked
        expect(
          _simulateCommand(limiter, userId, WsRequest.joinArena(n: 'join_3')),
          isTrue,
        );

        // Advance 6 seconds (60 ticks × 100ms)
        for (var i = 0; i < 60; i++) {
          advance();
        }

        // Now strict tier window has slid — new requests pass
        final blocked = _simulateCommand(
          limiter,
          userId,
          WsRequest.joinArena(n: 'join_after_wait'),
        );
        expect(blocked, isFalse, reason: 'should pass after window recovery');
      },
    );

    test('after critical tier exhaustion, waiting 2s allows new requests', () {
      final (limiter: limiter, advance: advance) = _makeLimiter(
        increment: const Duration(milliseconds: 100),
      );
      const userId = UserId('critical_recovery_bot');

      // Exhaust critical tier (5/1s)
      for (var i = 0; i < 5; i++) {
        final blocked = _simulateCommand(
          limiter,
          userId,
          WsRequest.gameAction(
            n: 'a_$i',
            combatRoomId: 'r1',
            action: const GameActionDto.attack(
              combatantId: 1,
              enemyCombatantId: 2,
            ),
          ),
        );
        expect(blocked, isFalse);
        advance();
      }
      // 6th blocked
      expect(
        _simulateCommand(
          limiter,
          userId,
          WsRequest.gameAction(
            n: 'a_5',
            combatRoomId: 'r1',
            action: const GameActionDto.attack(
              combatantId: 1,
              enemyCombatantId: 2,
            ),
          ),
        ),
        isTrue,
      );

      // Advance 2 seconds (20 ticks × 100ms) — past 1s window
      for (var i = 0; i < 20; i++) {
        advance();
      }

      // Critical tier window has slid
      final blocked = _simulateCommand(
        limiter,
        userId,
        WsRequest.gameAction(
          n: 'a_after_wait',
          combatRoomId: 'r1',
          action: const GameActionDto.attack(
            combatantId: 1,
            enemyCombatantId: 2,
          ),
        ),
      );
      expect(blocked, isFalse, reason: 'should pass after 1s window recovery');
    });
  });

  // ---------------------------------------------------------------------------
  // 5. Multiple bots — per-user isolation
  // ---------------------------------------------------------------------------
  group('Multiple bots — per-user isolation', () {
    test('blocking bot1 does not affect bot2', () {
      final (limiter: limiter, advance: advance) = _makeLimiter();
      const bot1 = UserId('bot_alpha');
      const bot2 = UserId('bot_beta');

      // Bot1 exhausts strict tier (3/5s)
      for (var i = 0; i < 3; i++) {
        _simulateCommand(limiter, bot1, WsRequest.joinArena(n: 'b1_$i'));
        advance();
      }
      // Bot1 blocked
      expect(
        _simulateCommand(limiter, bot1, WsRequest.joinArena(n: 'b1_blocked')),
        isTrue,
      );

      // Bot2 can still send JoinArenaRequest (independent limits)
      for (var i = 0; i < 3; i++) {
        final blocked = _simulateCommand(
          limiter,
          bot2,
          WsRequest.joinArena(n: 'b2_$i'),
        );
        expect(blocked, isFalse, reason: 'bot2 request $i should pass');
        advance();
      }
    });

    test('violation counts are independent per user', () {
      final (limiter: limiter, advance: advance) = _makeLimiter(
        increment: const Duration(milliseconds: 50),
      );
      const bot1 = UserId('violation_alpha');
      const bot2 = UserId('violation_beta');

      // Bot1: exhaust relaxed tier (10/30s) once → 1 violation
      for (var i = 0; i < 10; i++) {
        _simulateCommand(
          limiter,
          bot1,
          WsRequest.newLetter(n: 'r0_$i', content: 'hi'),
        );
        advance();
      }
      // 11th triggers 1 violation
      _simulateCommand(
        limiter,
        bot1,
        WsRequest.newLetter(n: 'r0_block', content: 'blocked'),
      );
      advance();

      // Bot2: no violations
      _simulateCommand(
        limiter,
        bot2,
        WsRequest.newLetter(n: 'b2_ok', content: 'fine'),
      );

      expect(limiter.getViolationCount(bot1), equals(1));
      expect(limiter.getPenaltyLevel(bot1), equals(PenaltyLevel.warning));
      expect(limiter.getViolationCount(bot2), equals(0));
      expect(limiter.getPenaltyLevel(bot2), equals(PenaltyLevel.warning));
    });

    test('mute on bot1 does not mute bot2', () {
      final (limiter: limiter, advance: advance) = _makeLimiter(
        increment: const Duration(milliseconds: 50),
      );
      const bot1 = UserId('muted_bot');
      const bot2 = UserId('free_bot');

      // Bot1: trigger 2 violations → mute5s
      // First violation: exhaust relaxed (10/30s), 11th blocked
      for (var i = 0; i < 10; i++) {
        _simulateCommand(
          limiter,
          bot1,
          WsRequest.newLetter(n: 'm0_$i', content: 'spam'),
        );
        advance();
      }
      _simulateCommand(
        limiter,
        bot1,
        WsRequest.newLetter(n: 'm0_block', content: 'blocked'),
      );
      advance();

      // Second violation: use a different tier. Exhaust strict (3/5s).
      for (var i = 0; i < 3; i++) {
        _simulateCommand(limiter, bot1, WsRequest.joinArena(n: 's_$i'));
        advance();
      }
      _simulateCommand(limiter, bot1, WsRequest.joinArena(n: 's_block'));
      advance();

      expect(limiter.getViolationCount(bot1), equals(2));
      expect(limiter.getPenaltyLevel(bot1), equals(PenaltyLevel.mute5s));
      expect(limiter.isMuted(bot1), isTrue);
      expect(limiter.isMuted(bot2), isFalse);

      // Bot2 can still send
      final blocked = _simulateCommand(
        limiter,
        bot2,
        WsRequest.newLetter(n: 'free', content: 'hello'),
      );
      expect(blocked, isFalse);
    });
  });
}
