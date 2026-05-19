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
import 'package:backend/features/bot/application/chat_bot_strategy.dart';
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
import 'chat_bot_test.mocks.dart';

void main() {
  late ArenaBroadcast arenaBroadcast;
  late CombatSupervisor combatSupervisor;
  late OnlineRepository onlineRepository;
  late DbClient dbClient;
  late LettersDao lettersDao;
  late UnitDao unitDao;
  late LettersRepositoryImpl lettersRepository;
  late LettersBroadManager lettersBroadManager;

  late MockUserRepository mockUserRepository;
  late MockSessionRepository mockSessionRepository;
  late MockUnitRepository mockUnitRepository;

  late String testUserId;
  late String otherUserId;

  setUp(() async {
    mockUserRepository = MockUserRepository();
    mockSessionRepository = MockSessionRepository();
    mockUnitRepository = MockUnitRepository();

    // Set up in-memory database for chat tests
    // The DB migration already creates rooms (publicLetters, developLetters)
    // and default users (qq@qq.qq, ww@ww.ww)
    dbClient = DbClient(NativeDatabase.memory());
    lettersDao = dbClient.lettersDao;
    unitDao = dbClient.unitDao;

    // Get existing users from the DB (created by migration)
    final users = await dbClient.select(dbClient.userTable).get();
    testUserId = users[0].id;
    otherUserId = users[1].id;

    lettersRepository = LettersRepositoryImpl(lettersDao);
    lettersBroadManager = LettersBroadManager(lettersRepository);
    lettersBroadManager.createRooms();

    onlineRepository = OnlineRepository();
    combatSupervisor = CombatSupervisor(
      onlineRepository,
      mockSessionRepository,
      mockUnitRepository,
      mockUserRepository,
    );
    arenaBroadcast = ArenaBroadcast(combatSupervisor);
  });

  tearDown(() async {
    await dbClient.close();
  });

  GameSession createDummySession(String id, {String? userId}) {
    return GameSession(
      user: User(
        userId: UserId(userId ?? testUserId),
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

  group('Chat Bot Strategy Tests', () {
    test('SimpleMessageBot: bot sends multiple messages', () async {
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

      final strategy = SimpleMessageBotStrategy(
        messages: ['Hello!', 'How are you?', 'Goodbye!'],
      );
      final bot = ScenarioBot(
        strategy: strategy,
        botRepository: repo,
        userId: UserId('simple_bot'),
        unitId: UnitId(100),
      );

      await presenceManager.joinBot(bot, createDummySession('simple_bot'));

      await expectLater(
        strategy.done.future.timeout(const Duration(seconds: 10)),
        completes,
      );

      // Verify messages were persisted in the database
      final letters = await lettersDao.getListLetter();
      expect(letters.length, greaterThanOrEqualTo(3));

      stdout.writeln(
        'Test Passed: SimpleMessageBot sent ${letters.length} messages',
      );
    });

    test(
      'DeleteOwnMessageStrategy: bot creates and deletes own message',
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
          unitDao,
          lettersBroadManager,
        );

        const testMessage = 'Message to delete';
        final strategy = DeleteOwnMessageStrategy(message: testMessage);
        final bot = ScenarioBot(
          strategy: strategy,
          botRepository: repo,
          userId: UserId('delete_own_bot'),
          unitId: UnitId(200),
        );

        await presenceManager.joinBot(
          bot,
          createDummySession('delete_own_bot'),
        );

        await expectLater(
          strategy.done.future.timeout(const Duration(seconds: 10)),
          completes,
        );

        // Verify the message was deleted from the database
        final letters = await lettersDao.getListLetter();
        final remainingWithContent = letters.where(
          (l) => l.content == testMessage,
        );
        expect(
          remainingWithContent.isEmpty,
          isTrue,
          reason: 'Message should have been deleted',
        );

        stdout.writeln(
          'Test Passed: DeleteOwnMessageStrategy deleted own message',
        );
      },
    );

    test(
      'DeleteOtherMessageStrategy: bot fails to delete another user message',
      () async {
        // First, create a message from a different user (otherUserId)
        await lettersDao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: BroadcastKeys.publicLetters,
            senderId: otherUserId,
            content: 'Other user message',
          ),
        );

        final allLetters = await lettersDao.getListLetter();
        expect(allLetters.isNotEmpty, isTrue);
        final targetLetterId = allLetters.first.id;

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

        final strategy = DeleteOtherMessageStrategy(
          targetLetterId: targetLetterId,
        );
        final bot = ScenarioBot(
          strategy: strategy,
          botRepository: repo,
          userId: UserId('delete_other_bot'),
          unitId: UnitId(300),
        );

        await presenceManager.joinBot(
          bot,
          createDummySession('delete_other_bot'),
        );

        await expectLater(
          strategy.done.future.timeout(const Duration(seconds: 10)),
          completes,
        );

        // Verify the message still exists (delete should have failed)
        final letters = await lettersDao.getListLetter();
        final stillExists = letters.any((l) => l.id == targetLetterId);
        expect(
          stillExists,
          isTrue,
          reason: 'Other user message should still exist after failed delete',
        );

        stdout.writeln(
          'Test Passed: DeleteOtherMessageStrategy correctly failed to delete other user message',
        );
      },
    );

    test('EditOwnMessageStrategy: bot creates and edits own message', () async {
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

      const originalMessage = 'Original text';
      const editedMessage = 'Edited text';

      final strategy = EditOwnMessageStrategy(
        originalMessage: originalMessage,
        editedMessage: editedMessage,
      );
      final bot = ScenarioBot(
        strategy: strategy,
        botRepository: repo,
        userId: UserId('edit_own_bot'),
        unitId: UnitId(400),
      );

      await presenceManager.joinBot(bot, createDummySession('edit_own_bot'));

      await expectLater(
        strategy.done.future.timeout(const Duration(seconds: 10)),
        completes,
      );

      // Verify the message was edited in the database
      final letters = await lettersDao.getListLetter();
      final editedLetters = letters.where((l) => l.content == editedMessage);
      expect(
        editedLetters.isNotEmpty,
        isTrue,
        reason: 'Message should have been edited',
      );

      final originalLetters = letters.where(
        (l) => l.content == originalMessage,
      );
      expect(
        originalLetters.isEmpty,
        isTrue,
        reason: 'Original message content should not exist after edit',
      );

      stdout.writeln('Test Passed: EditOwnMessageStrategy edited own message');
    });

    test('SingleMessageBotStrategy: bot sends a single message', () async {
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

      const testMessage = 'Single test message';
      final strategy = SingleMessageBotStrategy(message: testMessage);
      final bot = ScenarioBot(
        strategy: strategy,
        botRepository: repo,
        userId: UserId('single_msg_bot'),
        unitId: UnitId(500),
      );

      await presenceManager.joinBot(bot, createDummySession('single_msg_bot'));

      final letterId = await strategy.letterId.future.timeout(
        const Duration(seconds: 10),
      );
      expect(letterId, greaterThan(0));

      // Verify the message exists in the database
      final letters = await lettersDao.getListLetter();
      final found = letters.any(
        (l) => l.id == letterId && l.content == testMessage,
      );
      expect(found, isTrue, reason: 'Single message should exist in DB');

      stdout.writeln(
        'Test Passed: SingleMessageBotStrategy sent message with id=$letterId',
      );
    });
  });

  group('Chat Bot Strategy Tests - Medium Complexity', () {
    test('SpamBotStrategy: bot sends many messages rapidly', () async {
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

      final strategy = SpamBotStrategy(messageCount: 10);
      final bot = ScenarioBot(
        strategy: strategy,
        botRepository: repo,
        userId: UserId('spam_bot'),
        unitId: UnitId(600),
      );

      await presenceManager.joinBot(bot, createDummySession('spam_bot'));

      await expectLater(
        strategy.done.future.timeout(const Duration(seconds: 15)),
        completes,
      );

      // Verify all spam messages were persisted
      final letters = await lettersDao.getListLetter();
      final spamMessages = letters.where(
        (l) => l.content.startsWith('Spam message #'),
      );
      expect(spamMessages.length, greaterThanOrEqualTo(10));

      stdout.writeln(
        'Test Passed: SpamBotStrategy sent ${spamMessages.length} messages',
      );
    });

    test(
      'FullLifecycleBotStrategy: bot tests send → edit → delete flow',
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
          unitDao,
          lettersBroadManager,
        );

        final strategy = FullLifecycleBotStrategy();
        final bot = ScenarioBot(
          strategy: strategy,
          botRepository: repo,
          userId: UserId('lifecycle_bot'),
          unitId: UnitId(700),
        );

        await presenceManager.joinBot(bot, createDummySession('lifecycle_bot'));

        await expectLater(
          strategy.done.future.timeout(const Duration(seconds: 15)),
          completes,
        );

        // Verify the message was deleted (original and edited should not exist)
        final letters = await lettersDao.getListLetter();
        final originalExists = letters.any(
          (l) => l.content == 'Original message',
        );
        final editedExists = letters.any((l) => l.content == 'Edited message');
        expect(
          originalExists,
          isFalse,
          reason: 'Original message should not exist after lifecycle',
        );
        expect(
          editedExists,
          isFalse,
          reason: 'Edited message should not exist after delete',
        );

        stdout.writeln(
          'Test Passed: FullLifecycleBotStrategy completed full lifecycle',
        );
      },
    );

    test(
      'Two bots chat: both bots send messages and receive each other messages',
      () async {
        final presenceManager = PresenceManagerImpl(
          onlineRepository,
          mockUnitRepository,
          mockSessionRepository,
        );

        final repo1 = BotRepository(
          presenceManager,
          arenaBroadcast,
          combatSupervisor,
          mockUnitRepository,
          unitDao,
          lettersBroadManager,
        );

        final repo2 = BotRepository(
          presenceManager,
          arenaBroadcast,
          combatSupervisor,
          mockUnitRepository,
          unitDao,
          lettersBroadManager,
        );

        final bot1Messages = <LetterDto>[];
        final bot2Messages = <LetterDto>[];
        final bot1Completer = Completer<void>();
        final bot2Completer = Completer<void>();
        final bothJoined = Completer<void>();

        final strategy1 = _CollectingBotStrategy(
          messagesToSend: ['Hello from bot1', 'Bot1 says hi'],
          receivedMessages: bot1Messages,
          completer: bot1Completer,
          expectedCount: 4, // 2 own + 2 from bot2
          readySignal: bothJoined.future,
        );

        final strategy2 = _CollectingBotStrategy(
          messagesToSend: ['Hello from bot2', 'Bot2 replies'],
          receivedMessages: bot2Messages,
          completer: bot2Completer,
          expectedCount: 4, // 2 own + 2 from bot1
          readySignal: bothJoined.future,
        );

        final bot1 = ScenarioBot(
          strategy: strategy1,
          botRepository: repo1,
          userId: UserId('chat_bot_1'),
          unitId: UnitId(800),
        );

        final bot2 = ScenarioBot(
          strategy: strategy2,
          botRepository: repo2,
          userId: UserId('chat_bot_2'),
          unitId: UnitId(801),
        );

        // Join both bots
        await presenceManager.joinBot(bot1, createDummySession('chat_bot_1'));
        await presenceManager.joinBot(
          bot2,
          createDummySession('chat_bot_2', userId: otherUserId),
        );
        // Signal both bots to start sending now that both are joined
        bothJoined.complete();

        // Wait for both bots to complete
        await expectLater(
          Future.wait([
            bot1Completer.future,
            bot2Completer.future,
          ]).timeout(const Duration(seconds: 15)),
          completes,
        );

        // Verify both bots received messages
        expect(
          bot1Messages.length,
          greaterThanOrEqualTo(2),
          reason: 'Bot1 should have received at least 2 messages',
        );
        expect(
          bot2Messages.length,
          greaterThanOrEqualTo(2),
          reason: 'Bot2 should have received at least 2 messages',
        );

        // Verify messages were persisted in DB
        final letters = await lettersDao.getListLetter();
        final bot1Letters = letters.where(
          (l) => l.content.toLowerCase().contains('bot1'),
        );
        final bot2Letters = letters.where(
          (l) => l.content.toLowerCase().contains('bot2'),
        );
        expect(bot1Letters.length, greaterThanOrEqualTo(2));
        expect(bot2Letters.length, greaterThanOrEqualTo(2));

        stdout.writeln(
          'Test Passed: Two bots chat - bot1 received ${bot1Messages.length} messages, bot2 received ${bot2Messages.length} messages',
        );
      },
    );

    test('Bot receives history: bot joins chat with existing messages', () async {
      // Pre-populate the database with messages
      final existingMessages = [
        'Existing message 1',
        'Existing message 2',
        'Existing message 3',
      ];

      for (final msg in existingMessages) {
        await lettersDao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: BroadcastKeys.publicLetters,
            senderId: otherUserId,
            content: msg,
          ),
        );
      }

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

      final receivedHistory = <LetterDto>[];
      final completer = Completer<void>();

      final strategy = _HistoryCheckingBotStrategy(
        receivedHistory: receivedHistory,
        completer: completer,
        expectedMinCount: existingMessages.length,
      );

      final bot = ScenarioBot(
        strategy: strategy,
        botRepository: repo,
        userId: UserId('history_bot'),
        unitId: UnitId(900),
      );

      await presenceManager.joinBot(bot, createDummySession('history_bot'));

      await expectLater(
        completer.future.timeout(const Duration(seconds: 10)),
        completes,
      );

      // Verify the bot received the history
      expect(
        receivedHistory.length,
        greaterThanOrEqualTo(existingMessages.length),
      );

      // Verify the content of the history messages
      final receivedContents = receivedHistory.map((l) => l.content).toSet();
      for (final msg in existingMessages) {
        expect(
          receivedContents.contains(msg),
          isTrue,
          reason: 'History should contain: $msg',
        );
      }

      stdout.writeln(
        'Test Passed: Bot received history with ${receivedHistory.length} messages',
      );
    });

    test('Edit other message fails: bot2 cannot edit bot1 message', () async {
      // First, create a message from bot1
      final insertedEntry = await lettersDao.insertRow(
        LetterTableCompanion.insert(
          chatRoomId: BroadcastKeys.publicLetters,
          senderId: testUserId,
          content: 'Bot1 original message',
        ),
      );
      final bot1LetterId = insertedEntry!.id;

      final presenceManager = PresenceManagerImpl(
        onlineRepository,
        mockUnitRepository,
        mockSessionRepository,
      );

      final repo1 = BotRepository(
        presenceManager,
        arenaBroadcast,
        combatSupervisor,
        mockUnitRepository,
        unitDao,
        lettersBroadManager,
      );

      final repo2 = BotRepository(
        presenceManager,
        arenaBroadcast,
        combatSupervisor,
        mockUnitRepository,
        unitDao,
        lettersBroadManager,
      );

      final bot1Completer = Completer<void>();
      final bot2Completer = Completer<void>();

      // Bot1 just joins and waits
      final strategy1 = _WaitingBotStrategy(completer: bot1Completer);

      // Bot2 tries to edit bot1's message
      final strategy2 = _EditOtherMessageStrategy(
        targetLetterId: bot1LetterId,
        editedContent: 'Bot2 edited message',
        completer: bot2Completer,
      );

      final bot1 = ScenarioBot(
        strategy: strategy1,
        botRepository: repo1,
        userId: UserId('owner_bot'),
        unitId: UnitId(1000),
      );

      final bot2 = ScenarioBot(
        strategy: strategy2,
        botRepository: repo2,
        userId: UserId('intruder_bot'),
        unitId: UnitId(1001),
      );

      await presenceManager.joinBot(bot1, createDummySession('owner_bot'));
      await presenceManager.joinBot(
        bot2,
        createDummySession('intruder_bot', userId: otherUserId),
      );

      // Wait for bot2 to attempt the edit
      await expectLater(
        bot2Completer.future.timeout(const Duration(seconds: 10)),
        completes,
      );

      // Verify the message was NOT edited
      final letters = await lettersDao.getListLetter();
      final originalMessage = letters.where(
        (l) => l.id == bot1LetterId && l.content == 'Bot1 original message',
      );
      expect(
        originalMessage.isNotEmpty,
        isTrue,
        reason: 'Original message should still exist unchanged',
      );

      final editedMessage = letters.where(
        (l) => l.content == 'Bot2 edited message',
      );
      expect(
        editedMessage.isEmpty,
        isTrue,
        reason: 'Edited message should not exist',
      );

      stdout.writeln('Test Passed: Edit other message correctly failed');
    });
  });
}

/// Strategy that collects all received messages until a certain count.
/// Delays initial send to allow other bots to subscribe first.
class _CollectingBotStrategy extends ChatBotStrategy {
  _CollectingBotStrategy({
    required this.messagesToSend,
    required this.receivedMessages,
    required this.completer,
    required this.expectedCount,
    this.readySignal,
  });

  final List<String> messagesToSend;
  final List<LetterDto> receivedMessages;
  final Completer<void> completer;
  final int expectedCount;
  final Future<void>? readySignal;
  int _sentCount = 0;

  @override
  void onHistoryLoaded(ScenarioBot bot, List<LetterDto> letters) {
    // Wait for readySignal if provided, then start sending
    // This ensures all bots are joined before any start sending
    final startSending = readySignal ?? Future<void>.value();
    startSending.then((_) => _sendNext(bot));
  }

  void _sendNext(ScenarioBot bot) {
    if (_sentCount < messagesToSend.length) {
      sendLetter(bot, messagesToSend[_sentCount]);
      _sentCount++;
      Future.delayed(const Duration(milliseconds: 100), () {
        _sendNext(bot);
      });
    }
  }

  @override
  void onNewLetter(ScenarioBot bot, LetterDto letter) {
    receivedMessages.add(letter);
    if (receivedMessages.length >= expectedCount && !completer.isCompleted) {
      completer.complete();
    }
  }
}

/// Strategy that checks history on join
class _HistoryCheckingBotStrategy extends ChatBotStrategy {
  _HistoryCheckingBotStrategy({
    required this.receivedHistory,
    required this.completer,
    required this.expectedMinCount,
  });

  final List<LetterDto> receivedHistory;
  final Completer<void> completer;
  final int expectedMinCount;

  @override
  void onHistoryLoaded(ScenarioBot bot, List<LetterDto> letters) {
    receivedHistory.addAll(letters);
    if (receivedHistory.length >= expectedMinCount && !completer.isCompleted) {
      completer.complete();
    }
  }
}

/// Strategy that just waits (for the owner bot)
class _WaitingBotStrategy extends ChatBotStrategy {
  _WaitingBotStrategy({required this.completer});

  final Completer<void> completer;

  @override
  void onHistoryLoaded(ScenarioBot bot, List<LetterDto> letters) {
    // Just complete immediately - we're just here to be present
    if (!completer.isCompleted) {
      completer.complete();
    }
  }
}

/// Strategy that tries to edit another user's message
class _EditOtherMessageStrategy extends ChatBotStrategy {
  _EditOtherMessageStrategy({
    required this.targetLetterId,
    required this.editedContent,
    required this.completer,
  });

  final int targetLetterId;
  final String editedContent;
  final Completer<void> completer;
  bool _attempted = false;

  @override
  void onHistoryLoaded(ScenarioBot bot, List<LetterDto> letters) {
    // Try to edit the target letter (should fail since it's not ours)
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!_attempted) {
        _attempted = true;
        editLetter(bot, targetLetterId, editedContent);
      }
    });
  }

  @override
  void onEditFailed(ScenarioBot bot, int letterId, String reason) {
    if (!completer.isCompleted) completer.complete();
  }

  @override
  void onLetterEdited(ScenarioBot bot, LetterDto letter) {
    // This would be unexpected - we tried to edit someone else's message
    if (letter.id == targetLetterId) {
      if (!completer.isCompleted) completer.complete();
    }
  }
}
