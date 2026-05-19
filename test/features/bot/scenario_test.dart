import 'dart:async';
import 'dart:io';
import 'package:dto/dto.dart';
import 'package:test/test.dart';
import 'package:backend/features/bot/application/bot_strategy.dart';
import 'package:backend/features/bot/application/arena_test_scenario.dart';
import 'package:backend/features/bot/application/reset_scenario_strategy.dart';
import 'package:backend/features/bot/application/winner_scenario_strategy.dart';
import 'package:backend/features/bot/application/ws_bot_repository.dart';
import 'package:backend/features/chat/application/letters_broad_manager.dart';
import 'package:backend/features/game/application/arena_broadcast.dart';
import 'package:backend/features/game/application/combat_supervisor.dart';
import 'package:backend/features/auth/application/online_repository_impl.dart';
import 'package:backend/features/auth/application/presence_manager.dart';
import 'package:backend/models/user.dart';
import 'package:backend/features/auth/domain/session.dart';
import 'package:backend/features/game/domain/unit.dart';
import 'package:game_dto/game_dto.dart';
import 'package:backend/features/auth/domain/user_repository.dart';
import 'package:backend/features/auth/domain/session_repository.dart';
import 'package:backend/features/game/domain/unit_repository.dart';
import 'package:backend/features/auth/application/session_socket.dart';
import 'package:backend/db_client/dao/unit_dao.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<UserRepository>(),
  MockSpec<SessionRepository>(),
  MockSpec<UnitRepository>(),
  MockSpec<PresenceManager>(),
  MockSpec<UnitDao>(),
  MockSpec<LettersBroadManager>(),
])
import 'scenario_test.mocks.dart';

void main() {
  late ArenaBroadcast arenaBroadcast;
  late CombatSupervisor combatSupervisor;
  late OnlineRepository onlineRepository;

  late MockUserRepository mockUserRepository;
  late MockSessionRepository mockSessionRepository;
  late MockUnitRepository mockUnitRepository;
  late MockPresenceManager mockPresenceManager;
  late MockUnitDao mockUnitDao;
  late MockLettersBroadManager mockLettersBroadManager;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockSessionRepository = MockSessionRepository();
    mockUnitRepository = MockUnitRepository();
    mockPresenceManager = MockPresenceManager();
    mockUnitDao = MockUnitDao();
    mockLettersBroadManager = MockLettersBroadManager();

    onlineRepository = OnlineRepository();
    combatSupervisor = CombatSupervisor(
      onlineRepository,
      mockSessionRepository,
      mockUnitRepository,
      mockUserRepository,
    );
    arenaBroadcast = ArenaBroadcast(combatSupervisor);
  });

  GameSession createDummySession(String id) {
    return GameSession(
      user: User(
        userId: UserId(id),
        role: Role.user,
        email: '$id@test.com',
        createdAt: DateTime.now(),
      ),
      unit: Unit(
        unitId: UnitId(id.hashCode),
        name: 'Unit_$id',
        hp: 100,
        atk: 10,
        def: 5,
      ),
    );
  }

  group('ScenarioBot Integration Tests', () {
    test(
      'Test 1: Full Edict to Combat flow with two bots',
      () async {
        // Use real PresenceManagerImpl for integration logic, or mock if we only want to test bot flow
        final presenceManager = PresenceManagerImpl(
          onlineRepository,
          mockUnitRepository,
          mockSessionRepository,
        );

        final repo = BotRepository(
          presenceManager,
          arenaBroadcast,
          combatSupervisor,
          mockUnitRepository,
          mockUnitDao,
          mockLettersBroadManager,
        );

        final strategy1 = ArenaTestScenarioStrategy(isCreator: true);
        final bot1 = ScenarioBot(
          strategy: strategy1,
          botRepository: repo,
          userId: UserId('bot_1'),
          unitId: UnitId(1),
        );

        final strategy2 = ArenaTestScenarioStrategy(isCreator: false);
        final bot2 = ScenarioBot(
          strategy: strategy2,
          botRepository: repo,
          userId: UserId('bot_2'),
          unitId: UnitId(2),
        );

        await presenceManager.joinBot(bot1, createDummySession('bot_1'));
        await presenceManager.joinBot(bot2, createDummySession('bot_2'));

        await expectLater(
          strategy1.combatStarted.future.timeout(const Duration(seconds: 10)),
          completes,
        );
        await expectLater(
          strategy2.combatStarted.future.timeout(const Duration(seconds: 10)),
          completes,
        );

        await expectLater(
          strategy1.battleLoaded.future.timeout(const Duration(seconds: 10)),
          completes,
        );
        await expectLater(
          strategy2.battleLoaded.future.timeout(const Duration(seconds: 10)),
          completes,
        );

        stdout.writeln(
          'Test 1 Passed: Bots successfully created and started combat',
        );
      },
      timeout: const Timeout(Duration(seconds: 15)),
    );

    test('Test 2: Reset Edicts', () async {
      final presenceManager = PresenceManagerImpl(
        onlineRepository,
        mockUnitRepository,
        mockSessionRepository,
      );
      final repo = BotRepository(
        presenceManager,
        arenaBroadcast,
        combatSupervisor,
        mockUnitRepository,
        mockUnitDao,
        mockLettersBroadManager,
      );

      final bot = ScenarioBot(
        strategy: ArenaTestScenarioStrategy(isCreator: true),
        botRepository: repo,
        userId: UserId('reset_bot'),
        unitId: UnitId(3),
      );
      await presenceManager.joinBot(bot, createDummySession('reset_bot'));

      await Future.delayed(const Duration(milliseconds: 500));

      final resetStrategy = ResetScenarioStrategy(isResetEdicts: true);
      final adminBot = ScenarioBot(
        strategy: resetStrategy,
        botRepository: repo,
        userId: UserId('admin'),
        unitId: UnitId(0),
      );
      await presenceManager.joinBot(adminBot, createDummySession('admin'));

      await expectLater(
        resetStrategy.done.future.timeout(const Duration(seconds: 2)),
        completes,
      );
      stdout.writeln('Test 2 Passed: Edicts reset');
    });

    test('Test 3: Reset Combats', () async {
      final presenceManager = PresenceManagerImpl(
        onlineRepository,
        mockUnitRepository,
        mockSessionRepository,
      );
      final repo = BotRepository(
        presenceManager,
        arenaBroadcast,
        combatSupervisor,
        mockUnitRepository,
        mockUnitDao,
        mockLettersBroadManager,
      );

      final resetStrategy = ResetScenarioStrategy(isResetEdicts: false);
      final adminBot = ScenarioBot(
        strategy: resetStrategy,
        botRepository: repo,
        userId: UserId('admin_combat'),
        unitId: UnitId(0),
      );
      await presenceManager.joinBot(
        adminBot,
        createDummySession('admin_combat'),
      );

      await expectLater(
        resetStrategy.done.future.timeout(const Duration(seconds: 2)),
        completes,
      );
      stdout.writeln('Test 3 Passed: Combats reset');
    });

    test(
      'Test 4: Combat Outcome - Winner Rewards and Loser Consolation',
      () async {
        final presenceManager = PresenceManagerImpl(
          onlineRepository,
          mockUnitRepository,
          mockSessionRepository,
        );
        final repo = BotRepository(
          presenceManager,
          arenaBroadcast,
          combatSupervisor,
          mockUnitRepository,
          mockUnitDao,
          mockLettersBroadManager,
        );

        final uId1 = UnitId('winner_bot_1'.hashCode);
        final uId2 = UnitId('loser_bot_2'.hashCode);

        final strategy1 = WinnerScenarioStrategy(isCreator: true);
        final bot1 = ScenarioBot(
          strategy: strategy1,
          botRepository: repo,
          userId: UserId('winner_bot_1'),
          unitId: uId1,
        );

        final strategy2 = WinnerScenarioStrategy(isCreator: false);
        final bot2 = ScenarioBot(
          strategy: strategy2,
          botRepository: repo,
          userId: UserId('loser_bot_2'),
          unitId: uId2,
        );

        await presenceManager.joinBot(bot1, createDummySession('winner_bot_1'));
        await presenceManager.joinBot(bot2, createDummySession('loser_bot_2'));

        // 1. Ждем завершения боя
        final winnerId = await strategy1.winnerTeamId.future.timeout(
          const Duration(seconds: 15),
        );
        expect(winnerId, isNotNull);
        stdout.writeln('[TEST] Combat finished. Winner team: $winnerId');

        // 2. Ждем обновления статистики для обоих участников
        final stats1 = await strategy1.statsUpdated.future.timeout(
          const Duration(seconds: 5),
        );
        final stats2 = await strategy2.statsUpdated.future.timeout(
          const Duration(seconds: 5),
        );

        // 3. Проверка наград
        if (winnerId == uId1.s) {
          expect(stats1.wins, equals(1), reason: 'Winner should have 1 win');
          expect(
            stats1.coins,
            greaterThan(0),
            reason: 'Winner should receive coins',
          );
          expect(
            stats1.exp,
            greaterThan(0),
            reason: 'Winner should receive exp',
          );
          expect(stats2.losses, equals(1), reason: 'Loser should have 1 loss');
          expect(
            stats2.exp,
            greaterThan(0),
            reason: 'Loser should also receive consolation exp',
          );
        } else {
          expect(stats2.wins, equals(1), reason: 'Winner should have 1 win');
          expect(stats1.losses, equals(1), reason: 'Loser should have 1 loss');
        }

        stdout.writeln(
          'Test 4 Passed: Winner rewards and loser consolation exp verified.',
        );
      },
      timeout: const Timeout(Duration(seconds: 25)),
    );
  });
}
