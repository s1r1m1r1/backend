import 'package:backend/core/rate_limiter.dart';
import 'package:backend/core/rate_limit_tier_mapping.dart';
import 'package:dto/dto.dart';
import 'package:test/test.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

int _clockMs = 0;

DateTime _fakeClock() =>
    DateTime(2026).add(Duration(milliseconds: _clockMs));

void _advance(int ms) => _clockMs += ms;

void _resetClock() => _clockMs = 0;

RateLimiter _limiter() {
  _resetClock();
  return RateLimiter.withClock(_fakeClock);
}

UserId _uid(String id) => UserId(id);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('Token Bucket — basic', () {
    test('first request always passes', () {
      final l = _limiter();
      expect(l.isRateLimitedByTier(_uid('u1'), RateLimitTier.relaxed), isFalse);
    });

    test('allows burst up to capacity', () {
      final l = _limiter();
      for (var i = 0; i < 10; i++) {
        expect(l.isRateLimitedByTier(_uid('u1'), RateLimitTier.relaxed),
            isFalse, reason: 'request $i');
      }
      // 11th blocked
      expect(l.isRateLimitedByTier(_uid('u1'), RateLimitTier.relaxed), isTrue);
    });

    test('blocks after capacity exceeded', () {
      final l = _limiter();
      for (var i = 0; i < 3; i++) {
        l.isRateLimitedByTier(_uid('u1'), RateLimitTier.strict);
      }
      expect(l.isRateLimitedByTier(_uid('u1'), RateLimitTier.strict), isTrue);
    });

    test('refills over time', () {
      final l = _limiter();
      // Exhaust relaxed (10/30s)
      for (var i = 0; i < 10; i++) {
        l.isRateLimitedByTier(_uid('u1'), RateLimitTier.relaxed);
      }
      expect(l.isRateLimitedByTier(_uid('u1'), RateLimitTier.relaxed), isTrue);

      // Advance 30s — bucket refills
      _advance(30000);
      expect(l.isRateLimitedByTier(_uid('u1'), RateLimitTier.relaxed), isFalse);
    });

    test('none tier never limits', () {
      final l = _limiter();
      for (var i = 0; i < 1000; i++) {
        expect(l.isRateLimitedByTier(_uid('u1'), RateLimitTier.none), isFalse);
      }
    });
  });

  group('Token Bucket — per-user isolation', () {
    test('users are independent', () {
      final l = _limiter();
      for (var i = 0; i < 10; i++) {
        l.isRateLimitedByTier(_uid('a'), RateLimitTier.relaxed);
      }
      expect(l.isRateLimitedByTier(_uid('a'), RateLimitTier.relaxed), isTrue);
      expect(l.isRateLimitedByTier(_uid('b'), RateLimitTier.relaxed), isFalse);
    });
  });

  group('Token Bucket — per-tier isolation', () {
    test('exhausting one tier does not affect another', () {
      final l = _limiter();
      // Exhaust strict (3/5s)
      for (var i = 0; i < 3; i++) {
        l.isRateLimitedByTier(_uid('u1'), RateLimitTier.strict);
      }
      expect(l.isRateLimitedByTier(_uid('u1'), RateLimitTier.strict), isTrue);
      // Relaxed (10/30s) still available
      expect(l.isRateLimitedByTier(_uid('u1'), RateLimitTier.relaxed), isFalse);
    });
  });

  group('Penalty escalation', () {
    test('1st violation → warning', () {
      final l = _limiter();
      expect(l.recordViolation(_uid('u1')), PenaltyLevel.warning);
      expect(l.getViolationCount(_uid('u1')), 1);
      expect(l.getPenaltyLevel(_uid('u1')), PenaltyLevel.warning);
    });

    test('2nd violation → mute5s', () {
      final l = _limiter();
      l.recordViolation(_uid('u1'));
      expect(l.recordViolation(_uid('u1')), PenaltyLevel.mute5s);
      expect(l.getViolationCount(_uid('u1')), 2);
      expect(l.isMuted(_uid('u1')), isTrue);
      expect(l.getMuteRemainingMs(_uid('u1')), greaterThan(0));
    });

    test('3rd violation → mute30s', () {
      final l = _limiter();
      l.recordViolation(_uid('u1'));
      l.recordViolation(_uid('u1'));
      expect(l.recordViolation(_uid('u1')), PenaltyLevel.mute30s);
      expect(l.getViolationCount(_uid('u1')), 3);
      expect(l.isMuted(_uid('u1')), isTrue);
    });

    test('4th violation → close', () {
      final l = _limiter();
      for (var i = 0; i < 3; i++) l.recordViolation(_uid('u1'));
      expect(l.recordViolation(_uid('u1')), PenaltyLevel.close);
      expect(l.getViolationCount(_uid('u1')), 4);
    });

    test('5th+ stays at close', () {
      final l = _limiter();
      for (var i = 0; i < 5; i++) l.recordViolation(_uid('u1'));
      expect(l.getPenaltyLevel(_uid('u1')), PenaltyLevel.close);
      expect(l.getViolationCount(_uid('u1')), 5);
    });

    test('mute5s expires after 5s', () {
      final l = _limiter();
      l.recordViolation(_uid('u1'));
      l.recordViolation(_uid('u1'));
      expect(l.isMuted(_uid('u1')), isTrue);

      _advance(6000);
      expect(l.isMuted(_uid('u1')), isFalse);
      expect(l.getMuteRemainingMs(_uid('u1')), isNull);
    });

    test('mute30s expires after 30s', () {
      final l = _limiter();
      for (var i = 0; i < 3; i++) l.recordViolation(_uid('u1'));
      expect(l.isMuted(_uid('u1')), isTrue);

      _advance(31000);
      expect(l.isMuted(_uid('u1')), isFalse);
    });

    test('violation count resets after 5min TTL', () {
      final l = _limiter();
      l.recordViolation(_uid('u1'));
      l.recordViolation(_uid('u1'));
      expect(l.getViolationCount(_uid('u1')), 2);

      _advance(6 * 60 * 1000); // 6 min
      expect(l.recordViolation(_uid('u1')), PenaltyLevel.warning);
      expect(l.getViolationCount(_uid('u1')), 1);
    });

    test('count does NOT reset before 5min', () {
      final l = _limiter();
      l.recordViolation(_uid('u1'));
      l.recordViolation(_uid('u1'));

      _advance(4 * 60 * 1000); // 4 min
      expect(l.recordViolation(_uid('u1')), PenaltyLevel.mute30s);
      expect(l.getViolationCount(_uid('u1')), 3);
    });

    test('per-user penalty isolation', () {
      final l = _limiter();
      for (var i = 0; i < 3; i++) l.recordViolation(_uid('a'));

      expect(l.getPenaltyLevel(_uid('b')), PenaltyLevel.warning);
      expect(l.getViolationCount(_uid('b')), 0);
      expect(l.isMuted(_uid('b')), isFalse);
    });
  });

  group('Rate limit triggers penalty', () {
    test('exhausting tier records violation automatically', () {
      final l = _limiter();
      for (var i = 0; i < 10; i++) {
        l.isRateLimitedByTier(_uid('u1'), RateLimitTier.relaxed);
      }
      // 11th triggers penalty
      l.isRateLimitedByTier(_uid('u1'), RateLimitTier.relaxed);
      expect(l.getViolationCount(_uid('u1')), 1);
      expect(l.getPenaltyLevel(_uid('u1')), PenaltyLevel.warning);
    });
  });

  group('isRateLimited (legacy)', () {
    test('checks burst and sustained tiers', () {
      final l = _limiter();
      // Exhaust burst (5/1s)
      for (var i = 0; i < 5; i++) {
        l.isRateLimitedByTier(_uid('u1'), RateLimitTier.burst);
      }
      expect(l.isRateLimited(_uid('u1')), isTrue);
    });
  });

  group('RateLimitTierMapping', () {
    test('ping → none', () {
      expect(const WsRequest.ping(n: '1').rateLimitTier, RateLimitTier.none);
    });
    test('ack → none', () {
      expect(const WsRequest.ack(n: '1').rateLimitTier, RateLimitTier.none);
    });
    test('newLetter → relaxed', () {
      expect(const WsRequest.newLetter(n: '1', content: 'x').rateLimitTier,
          RateLimitTier.relaxed);
    });
    test('gameAction → critical', () {
      final req = WsRequest.gameAction(
        n: '1',
        combatRoomId: 'r',
        action: const GameActionDto.attack(
            combatantId: UnitId('1'), enemyCombatantId: UnitId('2')),
      );
      expect(req.rateLimitTier, RateLimitTier.critical);
    });
    test('joinArena → strict', () {
      expect(
          const WsRequest.joinArena(n: '1').rateLimitTier, RateLimitTier.strict);
    });
    test('unknown → normal', () {
      expect(const WsRequest.editLetter(n: '1', letterId: 1, content: 'y')
          .rateLimitTier, RateLimitTier.normal);
    });
  });

  group('nextRefillMs', () {
    test('null when tokens available', () {
      final l = _limiter();
      expect(l.nextRefillMs(_uid('u1'), RateLimitTier.relaxed), isNull);
    });

    test('returns ms when bucket exhausted', () {
      final l = _limiter();
      for (var i = 0; i < 10; i++) {
        l.isRateLimitedByTier(_uid('u1'), RateLimitTier.relaxed);
      }
      final ms = l.nextRefillMs(_uid('u1'), RateLimitTier.relaxed);
      expect(ms, isNotNull);
      expect(ms!, greaterThan(0));
    });
  });
}
