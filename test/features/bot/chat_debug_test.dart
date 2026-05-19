import 'dart:async';
import 'dart:io';

import 'package:backend/core/constants.dart';
import 'package:backend/core/utils/noun_gen.dart';
import 'package:backend/db_client/dao/letters_dao.dart';
import 'package:backend/db_client/dao/unit_dao.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:drift/drift.dart';
import 'package:backend/db_client/tables/letter_table.dart';
import 'package:backend/features/auth/application/online_repository_impl.dart';
import 'package:backend/features/auth/application/presence_manager.dart';
import 'package:backend/features/auth/application/session_socket.dart';
import 'package:backend/features/auth/domain/session.dart';
import 'package:backend/features/bot/application/bot_strategy.dart';
import 'package:backend/features/bot/application/ws_bot_repository.dart';
import 'package:backend/features/chat/application/letters_broad_manager.dart';
import 'package:backend/features/chat/data/letters_repository_impl.dart';
import 'package:backend/features/game/application/arena_broadcast.dart';
import 'package:backend/features/game/application/combat_supervisor.dart';
import 'package:backend/features/game/domain/unit.dart';
import 'package:backend/features/auth/domain/user_repository.dart';
import 'package:backend/features/auth/domain/session_repository.dart';
import 'package:backend/features/game/domain/unit_repository.dart';
import 'package:backend/models/user.dart';
import 'package:dto/dto.dart';
import 'package:game_dto/game_dto.dart';
import 'package:drift/native.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([
  MockSpec<UserRepository>(),
  MockSpec<SessionRepository>(),
  MockSpec<UnitRepository>(),
])
import 'chat_debug_test.mocks.dart';

/// Instrumented LettersBroadManager that logs all calls
class InstrumentedLettersBroadManager extends LettersBroadManager {
  InstrumentedLettersBroadManager(super.lettersRepository);

  @override
  void subscribe(GameSocket socket, String n) {
    stdout.writeln(
      '[InstrumentedLBM] subscribe called: userId=${socket.userId}, n=$n',
    );
    super.subscribe(socket, n);
    stdout.writeln(
      '[InstrumentedLBM] subscribe returned (async running in background)',
    );
  }

  @override
  void newLetter(GameSocket socket, NewLetterTs message) {
    stdout.writeln(
      '[InstrumentedLBM] newLetter called: userId=${socket.userId}, content=${message.content}, n=${message.n}',
    );
    super.newLetter(socket, message);
    stdout.writeln(
      '[InstrumentedLBM] newLetter returned (async running in background)',
    );
  }
}

void main() {
  test('debug: trace bot chat message flow', () async {
    final mockUserRepository = MockUserRepository();
    final mockSessionRepository = MockSessionRepository();
    final mockUnitRepository = MockUnitRepository();

    final dbClient = DbClient(NativeDatabase.memory());
    final lettersDao = dbClient.lettersDao;
    final unitDao = dbClient.unitDao;

    // Get existing users from the DB (created by migration)
    final users = await dbClient.select(dbClient.userTable).get();
    final testUserId = users[0].id;
    stdout.writeln('testUserId: $testUserId');

    final lettersRepository = LettersRepositoryImpl(lettersDao);
    final lettersBroadManager = InstrumentedLettersBroadManager(
      lettersRepository,
    );

    final onlineRepository = OnlineRepository();
    final combatSupervisor = CombatSupervisor(
      onlineRepository,
      mockSessionRepository,
      mockUnitRepository,
      mockUserRepository,
    );
    final arenaBroadcast = ArenaBroadcast(combatSupervisor);
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
      unitDao,
      lettersBroadManager,
    );

    final session = GameSession(
      user: User(
        userId: UserId(testUserId),
        role: Role.user,
        email: 'debug@test.com',
        createdAt: DateTime.now(),
      ),
      unit: Unit(
        unitId: UnitId(999),
        name: 'DebugUnit',
        hp: 100,
        atk: 10,
        def: 5,
      ),
    );

    // Create a simple strategy that just joins and sends one message
    final receivedMessages = <ToClient>[];
    final completer = Completer<void>();

    final bot = ScenarioBot(
      strategy: _DebugChatStrategy(receivedMessages, completer),
      botRepository: repo,
      userId: UserId(testUserId),
      unitId: UnitId(999),
    );

    stdout.writeln('Calling joinBot...');
    await presenceManager.joinBot(bot, session);
    stdout.writeln('joinBot completed');

    // Check if socket is registered
    final socket = onlineRepository.getSessionUSERID(UserId(testUserId));
    stdout.writeln('Socket found: ${socket != null}');
    stdout.writeln('Socket isBot: ${socket?.isBot}');
    stdout.writeln('Socket botMode: ${socket?.botMode}');
    stdout.writeln('Socket userId: ${socket?.userId}');

    // Wait for messages
    try {
      await completer.future.timeout(const Duration(seconds: 5));
      stdout.writeln('SUCCESS - received ${receivedMessages.length} messages:');
      for (final msg in receivedMessages) {
        stdout.writeln('  - ${msg.runtimeType}');
      }
    } on TimeoutException {
      stdout.writeln('TIMEOUT - received ${receivedMessages.length} messages:');
      for (final msg in receivedMessages) {
        stdout.writeln('  - ${msg.runtimeType}');
      }
    }

    await dbClient.close();
  });
}

class _DebugChatStrategy extends BotStrategy {
  _DebugChatStrategy(this.receivedMessages, this.completer);
  final List<ToClient> receivedMessages;
  final Completer<void> completer;

  @override
  FutureOr<void> onInit(ScenarioBot bot) {
    stdout.writeln('[DebugStrategy] onInit called, userId=${bot.userId}');
    // Send join letters
    final n = NouN.next().v;
    stdout.writeln('[DebugStrategy] Sending JoinLettersTs with n=$n');
    bot.send(ToServer.joinLetters(n: n));
    // Wait a bit then send a message
    Future.delayed(const Duration(milliseconds: 500), () {
      final n2 = NouN.next().v;
      stdout.writeln('[DebugStrategy] Sending NewLetterTs with n=$n2');
      bot.send(ToServer.newLetter(n: n2, content: 'Hello from debug bot'));
    });
  }

  @override
  void onMessage(ScenarioBot bot, ToClient message) {
    stdout.writeln('[DebugStrategy] onMessage: ${message.runtimeType}');
    receivedMessages.add(message);
    if (message is OnLetterTc) {
      stdout.writeln('[DebugStrategy] Got OnLetterTc: id=${message.dto.id}');
      if (!completer.isCompleted) completer.complete();
    }
  }

  @override
  void onDispose(ScenarioBot bot) {
    stdout.writeln('[DebugStrategy] onDispose');
  }
}
