import 'dart:async';
import 'package:dto/dto.dart';
import 'package:test/test.dart';
import 'package:backend/features/bot/application/bot_strategy.dart';
import 'package:backend/features/bot/application/upgrade_scenario_strategy.dart';
import 'package:backend/features/bot/application/ws_bot_repository.dart';
import 'package:backend/features/game/application/arena_broadcast.dart';
import 'package:backend/features/game/application/combat_supervisor.dart';
import 'package:backend/features/auth/application/online_repository_impl.dart';
import 'package:backend/features/auth/application/presence_manager.dart';
import 'package:backend/models/user.dart';
import 'package:backend/features/auth/domain/session.dart';
import 'package:backend/features/game/domain/unit.dart';
import 'package:backend/features/auth/domain/user_repository.dart';
import 'package:backend/features/auth/domain/session_repository.dart';
import 'package:backend/features/game/domain/unit_repository.dart';
import 'package:backend/db_client/dao/unit_dao.dart';
import 'package:backend/features/chat/application/letters_broad_manager.dart';
import 'package:game_dto/game_dto.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<UserRepository>(),
  MockSpec<SessionRepository>(),
  MockSpec<UnitRepository>(),
  MockSpec<UnitDao>(),
  MockSpec<LettersBroadManager>(),
])
import 'bot_upgrade_test.mocks.dart';

void main() {
  late ArenaBroadcast arenaBroadcast;
  late CombatSupervisor combatSupervisor;
  late OnlineRepository onlineRepository;
  late BotRepository botRepository;
  late PresenceManager presenceManager;

  late MockUserRepository mockUserRepository;
  late MockSessionRepository mockSessionRepository;
  late MockUnitRepository mockUnitRepository;
  late MockUnitDao mockUnitDao;
  late MockLettersBroadManager mockLettersBroadManager;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockSessionRepository = MockSessionRepository();
    mockUnitRepository = MockUnitRepository();
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
    presenceManager = PresenceManagerImpl(
      onlineRepository,
      mockUnitRepository,
      mockSessionRepository,
    );
    botRepository = BotRepository(
      presenceManager,
      arenaBroadcast,
      combatSupervisor,
      mockUnitRepository,
      mockUnitDao,
      mockLettersBroadManager,
    );
  });

  GameSession createUpgradeSession(String id, {int level = 1}) {
    return GameSession(
      user: User(
        userId: UserId(id),
        role: Role.user,
        email: '$id@test.com',
        createdAt: DateTime.now(),
      ),
      unit: Unit(
        unitId: UnitId(id.hashCode.toString()),
        name: 'Unit_$id',
        hp: 100,
        atk: 50, // High ATK for fast win
        def: 5,
        level: level,
        statPoints: 0,
      ),
    );
  }

  test(
    'Bot Stat Upgrade and Persistence Test',
    () async {
      final uId1 = UnitId('bot_1'.hashCode);
      final uId2 = UnitId('bot_2'.hashCode);

      final strategy1 = UpgradeScenarioStrategy(isCreator: true);
      final bot1 = ScenarioBot(
        strategy: strategy1,
        botRepository: botRepository,
        userId: UserId('bot_1'),
        unitId: uId1,
      );

      final strategy2 = UpgradeScenarioStrategy(isCreator: false);
      final bot2 = ScenarioBot(
        strategy: strategy2,
        botRepository: botRepository,
        userId: UserId('bot_2'),
        unitId: uId2,
      );

      // Setup Mocks
      var getListCallCount = 0;
      when(
        mockUnitRepository.getListUnit(userId: anyNamed('userId')),
      ).thenAnswer((_) async {
        getListCallCount++;
        if (getListCallCount <= 2) {
          // Initial join for both bots
          return [
            UnitDto(
              id: uId1.s,
              name: 'Unit_bot_1',
              hp: 100,
              atk: 50,
              def: 5,
              statPoints: 0,
              level: 1,
            ),
          ];
        } else {
          // Give stat points for level up in subsequent calls
          return [
            UnitDto(
              id: uId1.s,
              name: 'Unit_bot_1',
              hp: 100,
              atk: 50,
              def: 5,
              statPoints: 5,
              level: 2,
            ),
          ];
        }
      });

      when(
        mockUnitRepository.updateStats(
          unitId: anyNamed('unitId'),
          winDelta: anyNamed('winDelta'),
          lossDelta: anyNamed('lossDelta'),
          coinDelta: anyNamed('coinDelta'),
          expDelta: anyNamed('expDelta'),
          newLevel: anyNamed('newLevel'),
          newStatPoints: anyNamed('newStatPoints'),
        ),
      ).thenAnswer((_) async => {});

      when(
        mockUnitRepository.allocateStats(any, any, any, any),
      ).thenAnswer((_) async => {});

      when(mockUnitRepository.getSelectedUnit(any)).thenAnswer(
        (_) async => UnitDto(
          id: uId1.s,
          name: 'Unit_bot_1',
          hp: 100,
          atk: 50,
          def: 5,
          statPoints: 0,
          level: 1,
        ),
      );

      // First, join the bots
      print('Joining bots...');
      await presenceManager.joinBot(bot1, createUpgradeSession('bot_1'));
      await presenceManager.joinBot(bot2, createUpgradeSession('bot_2'));

      // 1. Wait for Combat 1 to finish
      print('Waiting for Combat 1 to finish...');
      await strategy1.winnerTeamId.future.timeout(const Duration(seconds: 30));
      print(
        'Combat 1 finished! Winner team: ${strategy1.winnerTeamId.isCompleted}',
      );

      // 2. Wait for the bot to detect upgrade
      print('Waiting for Upgrade detection...');
      await strategy1.upgraded.future.timeout(const Duration(seconds: 30));
      print('Upgrade detected! Final ATK: ${strategy1.lastAtk}');

      expect(strategy1.upgradesDetected, greaterThan(0));
      verify(
        mockUnitRepository.allocateStats(uId1.s, any, any, any),
      ).called(greaterThanOrEqualTo(1));

      // 3. Cleanup
      arenaBroadcast.reset();
    },
    timeout: const Timeout(Duration(seconds: 60)),
  );
}
