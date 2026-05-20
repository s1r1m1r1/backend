import 'package:backend/core/rate_limit_tier_mapping.dart';
import 'package:backend/core/rate_limiter.dart';
import 'package:dto/dto.dart';
import 'package:test/test.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Creates a [RateLimiter] with a controllable clock.
  /// The clock starts at [epoch] and advances by [increment] on each call.
  ({RateLimiter limiter, void Function() advance}) _makeLimiter({
    Duration increment = const Duration(milliseconds: 100),
  }) {
    var callCount = 0;
    final epoch = DateTime(2026, 1, 1);
    final states = <int, DateTime>{};
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
        // Burn one clock tick by calling with a throwaway user
        limiter.isRateLimited(const UserId('_tick'));
      },
    );
  }

  UserId uid(String id) => UserId(id);

  // ---------------------------------------------------------------------------
  // 1. Basic isRateLimited()
  // ---------------------------------------------------------------------------
  group('isRateLimited — basic functionality', () {
    test('first message is not rate limited', () {
      final limiter = _makeLimiter().limiter;
      expect(limiter.isRateLimited(uid('1')), isFalse);
    });

    test('5 messages within 1 second are allowed (burst limit = 5)', () {
      final limiter = _makeLimiter().limiter;
      for (var i = 0; i < 5; i++) {
        expect(
          limiter.isRateLimited(uid('1')),
          isFalse,
          reason: 'Message ${i + 1} should be allowed',
        );
      }
    });

    test('6th message within 1 second is blocked (burst exceeded)', () {
      final limiter = _makeLimiter().limiter;
      for (var i = 0; i < 5; i++) {
        limiter.isRateLimited(uid('1'));
      }
      expect(limiter.isRateLimited(uid('1')), isTrue);
    });

    test(
      '30 messages within 10 seconds are allowed (sustained limit = 30)',
      () {
        // Use 300ms spacing → 30 messages = 9s total, within 10s window
        final limiter = _makeLimiter(
          increment: const Duration(milliseconds: 300),
        ).limiter;
        for (var i = 0; i < 30; i++) {
          expect(
            limiter.isRateLimited(uid('1')),
            isFalse,
            reason: 'Message ${i + 1} should be allowed',
          );
        }
      },
    );

    test('31st message within 10 seconds is blocked (sustained exceeded)', () {
      final limiter = _makeLimiter(
        increment: const Duration(milliseconds: 300),
      ).limiter;
      for (var i = 0; i < 30; i++) {
        limiter.isRateLimited(uid('1'));
      }
      expect(limiter.isRateLimited(uid('1')), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // 2. Sliding window
  // ---------------------------------------------------------------------------
  group('isRateLimited — sliding window', () {
    test('after 1+ second pause burst window clears — can send again', () {
      final result = _makeLimiter();
      final limiter = result.limiter;
      final advance = result.advance;

      // Fill burst window (5 messages)
      for (var i = 0; i < 5; i++) {
        limiter.isRateLimited(uid('1'));
      }
      expect(limiter.isRateLimited(uid('1')), isTrue);

      // Advance time by >1 second (each tick = 100ms, so 11 ticks = 1.1s)
      for (var i = 0; i < 11; i++) {
        advance();
      }

      // Now user 1's burst window should have cleared
      expect(limiter.isRateLimited(uid('1')), isFalse);
    });

    test('after 10+ second pause sustained window clears', () {
      final result = _makeLimiter();
      final limiter = result.limiter;
      final advance = result.advance;

      // Fill sustained window: send 31 messages at 100ms intervals = 3.1s
      // Sustained window is 10s, so 30 msgs in 3s is within limit.
      // 31st msg at 3.1s is blocked by sustained.
      for (var i = 0; i < 30; i++) {
        limiter.isRateLimited(uid('1'));
      }
      expect(limiter.isRateLimited(uid('1')), isTrue); // 31st blocked

      // Burn 100 ticks (10s) to clear sustained window
      for (var i = 0; i < 100; i++) {
        advance();
      }

      // Sustained window should have cleared for user 1
      expect(limiter.isRateLimited(uid('1')), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // 3. Multiple users
  // ---------------------------------------------------------------------------
  group('isRateLimited — multiple users', () {
    test('rate limits are independent per UserId', () {
      final limiter = _makeLimiter().limiter;

      // Fill burst for user 1
      for (var i = 0; i < 5; i++) {
        limiter.isRateLimited(uid('1'));
      }
      expect(limiter.isRateLimited(uid('1')), isTrue);

      // User 2 should not be affected
      expect(limiter.isRateLimited(uid('2')), isFalse);
    });

    test('blocking one user does not affect another', () {
      final limiter = _makeLimiter().limiter;

      // Fill burst for both users
      for (var i = 0; i < 5; i++) {
        limiter.isRateLimited(uid('1'));
        limiter.isRateLimited(uid('2'));
      }

      expect(limiter.isRateLimited(uid('1')), isTrue);
      expect(limiter.isRateLimited(uid('2')), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // 4. isRateLimitedByTier()
  // ---------------------------------------------------------------------------
  group('isRateLimitedByTier', () {
    test('RateLimitTier.none always returns false', () {
      final limiter = _makeLimiter().limiter;
      for (var i = 0; i < 100; i++) {
        expect(
          limiter.isRateLimitedByTier(uid('1'), RateLimitTier.none),
          isFalse,
        );
      }
    });

    test('RateLimitTier.relaxed (10/30s) blocks after 10 messages', () {
      final limiter = _makeLimiter().limiter;
      for (var i = 0; i < 10; i++) {
        expect(
          limiter.isRateLimitedByTier(uid('1'), RateLimitTier.relaxed),
          isFalse,
          reason: 'Message ${i + 1} should be allowed',
        );
      }
      expect(
        limiter.isRateLimitedByTier(uid('1'), RateLimitTier.relaxed),
        isTrue,
      );
    });

    test('RateLimitTier.strict (3/5s) blocks after 3 messages', () {
      final limiter = _makeLimiter().limiter;
      for (var i = 0; i < 3; i++) {
        expect(
          limiter.isRateLimitedByTier(uid('1'), RateLimitTier.strict),
          isFalse,
          reason: 'Message ${i + 1} should be allowed',
        );
      }
      expect(
        limiter.isRateLimitedByTier(uid('1'), RateLimitTier.strict),
        isTrue,
      );
    });

    test('RateLimitTier.critical (5/1s) blocks after 5 messages', () {
      final limiter = _makeLimiter().limiter;
      for (var i = 0; i < 5; i++) {
        expect(
          limiter.isRateLimitedByTier(uid('1'), RateLimitTier.critical),
          isFalse,
          reason: 'Message ${i + 1} should be allowed',
        );
      }
      expect(
        limiter.isRateLimitedByTier(uid('1'), RateLimitTier.critical),
        isTrue,
      );
    });

    test('RateLimitTier.admin (1/5s) blocks after 1 message', () {
      final limiter = _makeLimiter().limiter;
      expect(
        limiter.isRateLimitedByTier(uid('1'), RateLimitTier.admin),
        isFalse,
      );
      expect(
        limiter.isRateLimitedByTier(uid('1'), RateLimitTier.admin),
        isTrue,
      );
    });

    test('tier windows are independent of each other', () {
      final limiter = _makeLimiter().limiter;

      // Fill critical tier (5/1s) for user 1
      for (var i = 0; i < 5; i++) {
        limiter.isRateLimitedByTier(uid('1'), RateLimitTier.critical);
      }
      expect(
        limiter.isRateLimitedByTier(uid('1'), RateLimitTier.critical),
        isTrue,
      );

      // Relaxed tier should still be available
      expect(
        limiter.isRateLimitedByTier(uid('1'), RateLimitTier.relaxed),
        isFalse,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // 5. RateLimitTierMapping
  // ---------------------------------------------------------------------------
  group('RateLimitTierMapping', () {
    test('PingRequest maps to none', () {
      const req = WsRequest.ping(n: '1');
      expect(req.rateLimitTier, RateLimitTier.none);
    });

    test('AckRequest maps to none', () {
      const req = WsRequest.ack(n: '1');
      expect(req.rateLimitTier, RateLimitTier.none);
    });

    test('NewLetterRequest maps to relaxed', () {
      const req = WsRequest.newLetter(n: '1', content: 'hi');
      expect(req.rateLimitTier, RateLimitTier.relaxed);
    });

    test('EditLetterRequest maps to normal', () {
      const req = WsRequest.editLetter(n: '1', letterId: 1, content: 'hi');
      expect(req.rateLimitTier, RateLimitTier.normal);
    });

    test('DeleteLetterRequest maps to normal', () {
      const req = WsRequest.deleteLetter(n: '1', letterId: [1]);
      expect(req.rateLimitTier, RateLimitTier.normal);
    });

    test('JoinArenaRequest maps to strict', () {
      const req = WsRequest.joinArena(n: '1');
      expect(req.rateLimitTier, RateLimitTier.strict);
    });

    test('LeaveArenaRequest maps to strict', () {
      const req = WsRequest.leaveArena(n: '1');
      expect(req.rateLimitTier, RateLimitTier.strict);
    });

    test('JoinBattleRoomRequest maps to strict', () {
      const req = WsRequest.joinBattleRoom(n: '1', combatRoomId: 'room1');
      expect(req.rateLimitTier, RateLimitTier.strict);
    });

    test('ChangeLocationRequest maps to strict', () {
      const req = WsRequest.changeLocation(
        n: '1',
        location: GameLocation.arena,
      );
      expect(req.rateLimitTier, RateLimitTier.strict);
    });

    test('GameActionRequest maps to critical', () {
      final req = WsRequest.gameAction(
        n: '1',
        combatRoomId: 'room1',
        action: const GameActionDto.attack(combatantId: 1, enemyCombatantId: 2),
      );
      expect(req.rateLimitTier, RateLimitTier.critical);
    });

    test('AllocateStatsRequest maps to critical', () {
      const req = WsRequest.allocateStats(
        n: '1',
        unitId: 1,
        addAtk: 1,
        addDef: 1,
        addVitality: 1,
      );
      expect(req.rateLimitTier, RateLimitTier.critical);
    });

    test('SyncCombatStateRequest maps to sync', () {
      const req = WsRequest.syncCombatState(n: '1', combatRoomId: 'room1');
      expect(req.rateLimitTier, RateLimitTier.sync);
    });

    test('SyncJoinedBroadsRequest maps to sync', () {
      const req = WsRequest.syncJoinedBroads(n: '1');
      expect(req.rateLimitTier, RateLimitTier.sync);
    });

    test('SyncMenuRequest maps to sync', () {
      const req = WsRequest.syncMenu(n: '1');
      expect(req.rateLimitTier, RateLimitTier.sync);
    });

    test('SyncOnlineUsers maps to sync', () {
      const req = WsRequest.syncOnlineUsers(n: '1');
      expect(req.rateLimitTier, RateLimitTier.sync);
    });

    test('CreateBotsRequest maps to admin', () {
      const req = WsRequest.createBots(n: '1');
      expect(req.rateLimitTier, RateLimitTier.admin);
    });

    test('ResetCombatsRequest maps to admin', () {
      const req = WsRequest.resetCombats(n: '1');
      expect(req.rateLimitTier, RateLimitTier.admin);
    });

    test('ResetEdictsRequest maps to admin', () {
      const req = WsRequest.resetEdicts(n: '1');
      expect(req.rateLimitTier, RateLimitTier.admin);
    });

    test(
      'unknown type defaults to normal (DisconnectRequest is explicit, use WithTokenRequest)',
      () {
        // WithTokenRequest is not in the mapping, so it defaults to normal
        const req = WsRequest.withToken(n: '1', token: 'abc');
        expect(req.rateLimitTier, RateLimitTier.normal);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // 6. Stale entry cleanup
  // ---------------------------------------------------------------------------
  group('stale entry cleanup', () {
    test('user inactive for 5+ minutes is removed from state', () {
      final result = _makeLimiter();
      final limiter = result.limiter;
      final advance = result.advance;

      // User 1 sends a message at t=0
      limiter.isRateLimited(uid('1'));

      // Advance time by 6 minutes (360s = 3600 ticks at 100ms)
      for (var i = 0; i < 3600; i++) {
        advance();
      }

      // After 6 minutes of inactivity, user 1's state should be stale.
      // User 1 should be able to send 5 messages again (burst limit)
      // because their state was purged.
      for (var i = 0; i < 5; i++) {
        expect(
          limiter.isRateLimited(uid('1')),
          isFalse,
          reason:
              'After stale cleanup, user 1 message ${i + 1} should be allowed',
        );
      }
      // 6th should be blocked (new state, fresh burst window)
      expect(limiter.isRateLimited(uid('1')), isTrue);
    });

    test('after cleanup user can send without previous limits', () {
      final result = _makeLimiter();
      final limiter = result.limiter;
      final advance = result.advance;

      // Fill burst for user 1
      for (var i = 0; i < 5; i++) {
        limiter.isRateLimited(uid('1'));
      }
      expect(limiter.isRateLimited(uid('1')), isTrue); // blocked

      // Advance 6 minutes
      for (var i = 0; i < 3600; i++) {
        advance();
      }

      // User 1 should now have a fresh state (old one purged as stale)
      // Send 5 more messages — should all go through
      for (var i = 0; i < 5; i++) {
        expect(
          limiter.isRateLimited(uid('1')),
          isFalse,
          reason: 'Message ${i + 1} after cleanup should be allowed',
        );
      }
    });
  });
}
