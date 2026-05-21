import 'package:backend/ws/bot_cmd_executor.dart';
import 'package:backend/core/rate_limiter.dart';
import 'package:dto/dto.dart';
import 'package:test/test.dart';

void main() {
  late BotCmdExecutor executor;

  setUp(() {
    executor = BotCmdExecutor(RateLimiter());
  });

  group('BotCmdExecutor - Rate Limit Checking', () {
    test('1.1: Command allowed for unlimited tier (PingRequest)', () {
      const userId = UserId('user1');
      final command = PingRequest(n: 'test');

      final isBlocked = executor.isCommandBlocked(userId, command);

      expect(isBlocked, isFalse);
    });

    test('1.2: Commands allowed within rate limit', () {
      const userId = UserId('user1');
      // relaxed tier: 100/30s - send 10 requests
      for (var i = 0; i < 10; i++) {
        final command = NewLetterRequest(n: 'test', content: 'message $i');
        final isBlocked = executor.isCommandBlocked(userId, command);
        expect(isBlocked, isFalse, reason: 'Request $i should be allowed');
      }
    });

    test('1.3: Command blocked when rate limit exceeded', () {
      const userId = UserId('user1');
      // relaxed tier: 100 tokens capacity, HeavyRequest costs 10 tokens
      // Need 11 requests to exceed (11 * 10 = 110 > 100)
      for (var i = 0; i < 11; i++) {
        final command = NewLetterRequest(n: 'test', content: 'm');
        final isBlocked = executor.isCommandBlocked(userId, command);
        if (i < 10) {
          expect(isBlocked, isFalse, reason: 'Request $i should be allowed');
        } else {
          expect(isBlocked, isTrue, reason: 'Request $i should be blocked');
        }
      }
    });

    test('1.4: Different users have separate rate limits', () {
      const userId1 = UserId('user1');
      const userId2 = UserId('user2');

      // Exhaust user1's limit (11 heavy requests)
      for (var i = 0; i < 11; i++) {
        executor.isCommandBlocked(
          userId1,
          NewLetterRequest(n: 'test', content: 'm'),
        );
      }

      // user2 should still be allowed
      final isBlocked = executor.isCommandBlocked(
        userId2,
        NewLetterRequest(n: 'test', content: 'm'),
      );
      expect(isBlocked, isFalse);
    });
  });

  group('BotCmdExecutor - Penalty Escalation', () {
    test('2.1: First violation = warning penalty', () {
      const userId = UserId('user1');

      // Exhaust limit to trigger violation
      for (var i = 0; i < 11; i++) {
        executor.isCommandBlocked(
          userId,
          NewLetterRequest(n: 'test', content: 'm'),
        );
      }

      final penalty = executor.getPenaltyLevel(userId);
      expect(penalty, isNotNull);
      expect(penalty, equals(PenaltyLevel.warning));
    });

    test('2.2: Multiple violations escalate penalty', () {
      const userId = UserId('user1');

      // First violation
      for (var i = 0; i < 11; i++) {
        executor.isCommandBlocked(
          userId,
          NewLetterRequest(n: 'test', content: 'm'),
        );
      }
      expect(executor.getPenaltyLevel(userId), PenaltyLevel.warning);

      // Reset and trigger second violation
      executor.enableBot(userId);
      for (var i = 0; i < 11; i++) {
        executor.isCommandBlocked(
          userId,
          NewLetterRequest(n: 'test', content: 'm'),
        );
      }
      expect(executor.getPenaltyLevel(userId), PenaltyLevel.mute5s);
    });
  });

  group('BotCmdExecutor - Broken Bot Detection', () {
    test('3.1: Bot marked as disabled after 5 consecutive violations', () {
      const userId = UserId('user1');

      // Trigger 5 consecutive violations to auto-disable
      for (var violation = 0; violation < 5; violation++) {
        for (var i = 0; i < 11; i++) {
          executor.isCommandBlocked(
            userId,
            NewLetterRequest(n: 'test', content: 'm'),
          );
        }
        if (violation < 4) {
          executor.enableBot(userId);
        }
      }

      expect(executor.isBotDisabled(userId), isTrue);
    });

    test('3.2: Disabled bot is always blocked', () {
      const userId = UserId('user1');

      // Trigger 5 violations to disable the bot
      for (var violation = 0; violation < 5; violation++) {
        for (var i = 0; i < 11; i++) {
          executor.isCommandBlocked(
            userId,
            NewLetterRequest(n: 'test', content: 'm'),
          );
        }
        if (violation < 4) {
          executor.enableBot(userId);
        }
      }

      final isBlocked = executor.isCommandBlocked(
        userId,
        PingRequest(n: 'test'),
      );
      expect(isBlocked, isTrue);
    });

    test('3.3: Bot not disabled before 5 violations', () {
      const userId = UserId('user1');

      // Only 4 violations
      for (var violation = 0; violation < 4; violation++) {
        for (var i = 0; i < 11; i++) {
          executor.isCommandBlocked(
            userId,
            NewLetterRequest(n: 'test', content: 'm'),
          );
        }
        executor.enableBot(userId);
      }

      expect(executor.isBotDisabled(userId), isFalse);
    });
  });

  group('BotCmdExecutor - Token Cost Differentiation', () {
    test('4.1: HeavyRequest costs 10 tokens', () {
      const userId = UserId('user1');

      // relaxed tier: 100 tokens capacity
      // HeavyRequest costs 10 tokens, so 10 requests = 100 tokens (exactly at limit)
      // 11th request should be blocked
      for (var i = 0; i < 11; i++) {
        final isBlocked = executor.isCommandBlocked(
          userId,
          NewLetterRequest(n: 'test', content: 'm'), // HeavyRequest
        );
        if (i < 10) {
          expect(isBlocked, isFalse, reason: 'Request $i should be allowed');
        } else {
          expect(isBlocked, isTrue, reason: 'Request $i should be blocked');
        }
      }
    });

    test('4.2: RegularRequest costs 1 token', () {
      const userId = UserId('user1');

      // Use a request that is NOT HeavyRequest
      // LeaveArenaRequest is not marked as HeavyRequest, tier = strict (30 tokens)
      // RegularRequest costs 1 token, so 30 requests = 30 tokens
      // 31st request should be blocked
      for (var i = 0; i < 31; i++) {
        final isBlocked = executor.isCommandBlocked(
          userId,
          LeaveArenaRequest(n: 'test'), // RegularRequest (not Heavy)
        );
        if (i < 30) {
          expect(isBlocked, isFalse, reason: 'Request $i should be allowed');
        } else {
          expect(isBlocked, isTrue, reason: 'Request $i should be blocked');
        }
      }
    });

    test('4.3: LightRequest bypasses rate limiting', () {
      const userId = UserId('user1');

      // LightRequest should not be rate limited
      // Send 200 light requests (should all pass)
      for (var i = 0; i < 200; i++) {
        final isBlocked = executor.isCommandBlocked(
          userId,
          PingRequest(n: 'test'), // LightRequest
        );
        expect(
          isBlocked,
          isFalse,
          reason: 'Light request $i should not be limited',
        );
      }
    });
  });

  group('BotCmdExecutor - RateLimiter Integration', () {
    test('5.1: Violations are recorded in RateLimiter', () {
      const userId = UserId('user1');

      // Create a separate RateLimiter and executor for this test
      final testRateLimiter = RateLimiter();
      final testExecutor = BotCmdExecutor(testRateLimiter);

      // Send heavy requests to generate violations (cost 10 tokens each)
      // With capacity 100, need 11 requests to exhaust (11 * 10 = 110 > 100)
      for (var i = 0; i < 11; i++) {
        testExecutor.isCommandBlocked(
          userId,
          NewLetterRequest(n: 'test', content: 'm'),
        );
      }

      // Check RateLimiter state through executor
      expect(testExecutor.getViolationCount(userId), greaterThan(0));
      expect(testExecutor.getPenaltyLevel(userId), isNotNull);
    });

    test('5.2: RateLimiter state persists across executor calls', () {
      const userId = UserId('user1');

      // Create a separate RateLimiter and executor for this test
      final testRateLimiter = RateLimiter();
      final testExecutor = BotCmdExecutor(testRateLimiter);

      // Exhaust tokens
      for (var i = 0; i < 11; i++) {
        testExecutor.isCommandBlocked(
          userId,
          NewLetterRequest(n: 'test', content: 'm'),
        );
      }

      // Verify penalty is recorded
      expect(testExecutor.getPenaltyLevel(userId), isNotNull);
      expect(testExecutor.getViolationCount(userId), greaterThan(0));
    });
  });

  group('BotCmdExecutor - Tier-Specific Behavior', () {
    test('6.1: Different tiers have different limits', () {
      const userId = UserId('user1');

      // JoinArenaRequest is strict tier (30 tokens capacity) and HeavyRequest (10 tokens cost)
      // Need 4 heavy requests to exceed (4 * 10 = 40 > 30)
      for (var i = 0; i < 4; i++) {
        final isBlocked = executor.isCommandBlocked(
          userId,
          JoinArenaRequest(n: 'test'),
        );
        if (i < 3) {
          expect(isBlocked, isFalse, reason: 'Request $i should be allowed');
        } else {
          expect(isBlocked, isTrue, reason: 'Request $i should be blocked');
        }
      }
    });
  });
}
