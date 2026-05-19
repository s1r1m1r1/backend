import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:test/test.dart';

import 'package:backend/db_client/db_client.dart';
import 'package:backend/db_client/dao/letters_dao.dart';
import 'package:backend/db_client/tables/letter_table.dart';
import 'package:backend/db_client/tables/room_table.dart';
import 'package:backend/db_client/tables/user_table.dart';

/// Test database that skips the default-data migration but still
/// creates the schema so we start from a clean state each time.
class TestDb extends DbClient {
  TestDb() : super(NativeDatabase.memory());

  @override
  drift.MigrationStrategy get migration => drift.MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

void main() {
  late TestDb db;
  late LettersDao dao;

  setUp(() {
    db = TestDb();
    dao = LettersDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  /// Helper: insert a room and user so FK constraints are satisfied.
  Future<void> seedPrerequisites() async {
    await db
        .into(db.roomTable)
        .insert(RoomTableCompanion.insert(id: 'room-1', name: 'Test Room'));
    await db
        .into(db.roomTable)
        .insert(RoomTableCompanion.insert(id: 'room-2', name: 'Second Room'));
    await db
        .into(db.userTable)
        .insert(
          UserTableCompanion.insert(
            id: const drift.Value('user-1'),
            email: 'one@test.com',
            password: 'hashed_password_that_is_long_enough_1',
          ),
        );
    await db
        .into(db.userTable)
        .insert(
          UserTableCompanion.insert(
            id: const drift.Value('user-2'),
            email: 'two@test.com',
            password: 'hashed_password_that_is_long_enough_2',
          ),
        );
  }

  group('LettersDao', () {
    group('insertRow', () {
      test(
        'inserts a letter and returns the entry with auto-generated id',
        () async {
          await seedPrerequisites();

          final entry = await dao.insertRow(
            LetterTableCompanion.insert(
              chatRoomId: 'room-1',
              senderId: 'user-1',
              content: 'Hello world',
            ),
          );

          expect(entry, isA<LetterEntry>());
          expect(entry!.id, greaterThan(0));
          expect(entry.chatRoomId, equals('room-1'));
          expect(entry.senderId, equals('user-1'));
          expect(entry.content, equals('Hello world'));
          expect(entry.createdAt, isA<DateTime>());
        },
      );

      test('throws when insert fails (non-existent room FK)', () async {
        // FK constraint violations throw SqliteException at the DB level
        // because insertReturningOrNull executes RETURNING which fails.
        expect(
          () => dao.insertRow(
            LetterTableCompanion.insert(
              chatRoomId: 'nonexistent-room',
              senderId: 'nonexistent-user',
              content: 'Should fail',
            ),
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('inserts multiple letters with incrementing ids', () async {
        await seedPrerequisites();

        final entry1 = await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-1',
            content: 'First',
          ),
        );
        final entry2 = await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-1',
            content: 'Second',
          ),
        );

        expect(entry1, isA<LetterEntry>());
        expect(entry2, isA<LetterEntry>());
        expect(entry2!.id, greaterThan(entry1!.id));
      });
    });

    group('getListLetter', () {
      test('returns empty list when no letters exist', () async {
        final result = await dao.getListLetter();
        expect(result, isEmpty);
      });

      test('returns all letters when no chatRoomId filter', () async {
        await seedPrerequisites();

        await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-1',
            content: 'Letter in room 1',
          ),
        );
        await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-2',
            senderId: 'user-2',
            content: 'Letter in room 2',
          ),
        );

        final result = await dao.getListLetter();
        expect(result, hasLength(2));
      });

      test('filters letters by chatRoomId', () async {
        await seedPrerequisites();

        await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-1',
            content: 'Letter in room 1',
          ),
        );
        await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-2',
            senderId: 'user-2',
            content: 'Letter in room 2',
          ),
        );
        await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-2',
            content: 'Another in room 1',
          ),
        );

        final result = await dao.getListLetter(chatRoomId: 'room-1');
        expect(result, hasLength(2));
        expect(result.every((l) => l.chatRoomId == 'room-1'), isTrue);
      });

      test('returns empty list for non-existent chatRoomId', () async {
        await seedPrerequisites();

        await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-1',
            content: 'Letter',
          ),
        );

        final result = await dao.getListLetter(chatRoomId: 'no-such-room');
        expect(result, isEmpty);
      });
    });

    group('getLetterById', () {
      test('returns null for non-existent id', () async {
        final result = await dao.getLetterById(999);
        expect(result, equals(null));
      });

      test('returns the correct letter', () async {
        await seedPrerequisites();

        final inserted = await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-1',
            content: 'Find me',
          ),
        );

        final result = await dao.getLetterById(inserted!.id);
        expect(result, isA<LetterEntry>());
        expect(result!.id, equals(inserted.id));
        expect(result.content, equals('Find me'));
      });
    });

    group('updateRow', () {
      test('updates letter content', () async {
        await seedPrerequisites();

        final inserted = await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-1',
            content: 'Original',
          ),
        );

        final updatedCount = await dao.updateRow(
          inserted!.id,
          const LetterTableCompanion(content: drift.Value('Updated')),
        );
        expect(updatedCount, equals(1));

        final fetched = await dao.getLetterById(inserted.id);
        expect(fetched!.content, equals('Updated'));
      });

      test('returns 0 when updating non-existent letter', () async {
        final updatedCount = await dao.updateRow(
          999,
          const LetterTableCompanion(content: drift.Value('Ghost')),
        );
        expect(updatedCount, equals(0));
      });

      test('preserves other fields when updating content', () async {
        await seedPrerequisites();

        final inserted = await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-1',
            content: 'Original',
          ),
        );

        await dao.updateRow(
          inserted!.id,
          const LetterTableCompanion(content: drift.Value('Changed')),
        );

        final fetched = await dao.getLetterById(inserted.id);
        expect(fetched!.chatRoomId, equals('room-1'));
        expect(fetched.senderId, equals('user-1'));
        expect(fetched.content, equals('Changed'));
      });
    });

    group('deleteLetter', () {
      test('deletes a letter and returns the deleted entry', () async {
        await seedPrerequisites();

        final inserted = await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-1',
            content: 'To delete',
          ),
        );

        final deleted = await dao.deleteLetter(inserted!.id);
        expect(deleted, hasLength(1));
        expect(deleted.first.id, equals(inserted.id));
        expect(deleted.first.content, equals('To delete'));

        final fetched = await dao.getLetterById(inserted.id);
        expect(fetched, equals(null));
      });

      test('returns empty list when deleting non-existent letter', () async {
        final deleted = await dao.deleteLetter(999);
        expect(deleted, isEmpty);
      });

      test('only deletes the specified letter, not others', () async {
        await seedPrerequisites();

        final letter1 = await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-1',
            content: 'Keep me',
          ),
        );
        final letter2 = await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-1',
            content: 'Delete me',
          ),
        );

        await dao.deleteLetter(letter2!.id);

        final remaining = await dao.getListLetter();
        expect(remaining, hasLength(1));
        expect(remaining.first.id, equals(letter1!.id));
      });
    });

    group('deleteLettersByChannel', () {
      test('deletes all letters in a channel', () async {
        await seedPrerequisites();

        await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-1',
            content: 'Letter 1',
          ),
        );
        await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-2',
            content: 'Letter 2',
          ),
        );
        await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-2',
            senderId: 'user-1',
            content: 'Letter 3',
          ),
        );

        await dao.deleteLettersByChannel('room-1');

        final remaining = await dao.getListLetter();
        expect(remaining, hasLength(1));
        expect(remaining.first.chatRoomId, equals('room-2'));
      });

      test('does nothing when channel has no letters', () async {
        await seedPrerequisites();

        await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-1',
            content: 'Letter',
          ),
        );

        await dao.deleteLettersByChannel('empty-room');

        final remaining = await dao.getListLetter();
        expect(remaining, hasLength(1));
      });

      test('works on empty database without error', () async {
        await dao.deleteLettersByChannel('any-room');
        final remaining = await dao.getListLetter();
        expect(remaining, isEmpty);
      });
    });

    group('cascade delete', () {
      test('deleting a room cascades to its letters', () async {
        await seedPrerequisites();

        await dao.insertRow(
          LetterTableCompanion.insert(
            chatRoomId: 'room-1',
            senderId: 'user-1',
            content: 'Will be cascade-deleted',
          ),
        );

        await (db.delete(
          db.roomTable,
        )..where((t) => t.id.equals('room-1'))).go();

        final remaining = await dao.getListLetter();
        expect(remaining, isEmpty);
      });
    });
  });
}
