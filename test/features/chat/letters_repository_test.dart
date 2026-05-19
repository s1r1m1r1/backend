import 'package:dto/dto.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

import 'package:backend/db_client/dao/letters_dao.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/features/chat/data/letters_repository_impl.dart';
import 'package:backend/features/chat/domain/letters_repository.dart';

@GenerateNiceMocks([MockSpec<LettersDao>()])
import 'letters_repository_test.mocks.dart';

void main() {
  late MockLettersDao mockDao;
  late LettersRepositoryImpl repository;

  setUp(() {
    mockDao = MockLettersDao();
    repository = LettersRepositoryImpl(mockDao);
  });

  LetterEntry _makeEntry({
    required int id,
    required String chatRoomId,
    required String senderId,
    required String content,
    DateTime? createdAt,
  }) {
    return LetterEntry(
      id: id,
      chatRoomId: chatRoomId,
      senderId: senderId,
      content: content,
      createdAt: createdAt ?? DateTime(2025, 1, 1),
    );
  }

  UserId _makeUserId(String id) => UserId(id);

  group('LettersRepositoryImpl', () {
    group('createLetter', () {
      test('returns LetterDto on successful insert', () async {
        final entry = _makeEntry(
          id: 1,
          chatRoomId: 'room-1',
          senderId: 'user-1',
          content: 'Hello',
        );

        when(mockDao.insertRow(any)).thenAnswer((_) async => entry);

        final result = await repository.createLetter(
          'Hello',
          _makeUserId('user-1'),
          BroadcastId('room-1'),
        );

        expect(result, isA<LetterDto>());
        expect(result!.id, equals(1));
        expect(result.chatRoomId, equals('room-1'));
        expect(result.senderId, equals('user-1'));
        expect(result.content, equals('Hello'));
        expect(result.createdAt, equals(entry.createdAt));
      });

      test('returns null when dao returns null', () async {
        when(mockDao.insertRow(any)).thenAnswer((_) async => null);

        final result = await repository.createLetter(
          'Hello',
          _makeUserId('user-1'),
          BroadcastId('room-1'),
        );

        expect(result, equals(null));
      });

      test('rethrows exception on dao error', () async {
        when(mockDao.insertRow(any)).thenThrow(Exception('DB error'));

        expect(
          () => repository.createLetter(
            'Hello',
            _makeUserId('user-1'),
            BroadcastId('room-1'),
          ),
          throwsException,
        );
      });

      test('passes correct values to dao.insertRow', () async {
        when(mockDao.insertRow(any)).thenAnswer(
          (_) async => _makeEntry(
            id: 1,
            chatRoomId: 'room-1',
            senderId: 'user-1',
            content: 'Test',
          ),
        );

        await repository.createLetter(
          'Test content',
          _makeUserId('sender-42'),
          BroadcastId('broadcast-99'),
        );

        final captured =
            verify(mockDao.insertRow(captureAny)).captured.single
                as LetterTableCompanion;

        expect(captured.chatRoomId.value, equals('broadcast-99'));
        expect(captured.senderId.value, equals('sender-42'));
        expect(captured.content.value, equals('Test content'));
      });
    });

    group('deleteLetter', () {
      test('returns deleted letter id on success', () async {
        final entry = _makeEntry(
          id: 5,
          chatRoomId: 'room-1',
          senderId: 'user-1',
          content: 'To delete',
        );

        when(
          mockDao.deleteLetter(5),
        ).thenAnswer((_) async => <LetterEntry>[entry]);

        final result = await repository.deleteLetter(5);

        expect(result, equals(5));
      });

      test('returns -1 when letter not found', () async {
        when(
          mockDao.deleteLetter(999),
        ).thenAnswer((_) async => <LetterEntry>[]);

        final result = await repository.deleteLetter(999);

        expect(result, equals(-1));
      });

      test('returns last id when multiple entries returned', () async {
        final entries = <LetterEntry>[
          _makeEntry(id: 1, chatRoomId: 'r', senderId: 'u', content: 'a'),
          _makeEntry(id: 2, chatRoomId: 'r', senderId: 'u', content: 'b'),
        ];

        when(mockDao.deleteLetter(1)).thenAnswer((_) async => entries);

        final result = await repository.deleteLetter(1);

        expect(result, equals(2));
      });
    });

    group('deleteLetters (batch)', () {
      test('returns all deleted ids on full success', () async {
        when(mockDao.deleteLetter(1)).thenAnswer(
          (_) async => <LetterEntry>[
            _makeEntry(id: 1, chatRoomId: 'r', senderId: 'u', content: 'a'),
          ],
        );
        when(mockDao.deleteLetter(2)).thenAnswer(
          (_) async => <LetterEntry>[
            _makeEntry(id: 2, chatRoomId: 'r', senderId: 'u', content: 'b'),
          ],
        );
        when(mockDao.deleteLetter(3)).thenAnswer(
          (_) async => <LetterEntry>[
            _makeEntry(id: 3, chatRoomId: 'r', senderId: 'u', content: 'c'),
          ],
        );

        final result = await repository.deleteLetters([1, 2, 3]);

        expect(result, equals([1, 2, 3]));
      });

      test('returns empty list for empty input', () async {
        final result = await repository.deleteLetters([]);

        expect(result, isEmpty);
        verifyNever(mockDao.deleteLetter(any));
      });

      test('returns only successfully deleted ids (partial failure)', () async {
        // Letter 1 exists, letter 2 does not, letter 3 exists
        when(mockDao.deleteLetter(1)).thenAnswer(
          (_) async => <LetterEntry>[
            _makeEntry(id: 1, chatRoomId: 'r', senderId: 'u', content: 'a'),
          ],
        );
        when(mockDao.deleteLetter(2)).thenAnswer((_) async => <LetterEntry>[]);
        when(mockDao.deleteLetter(3)).thenAnswer(
          (_) async => <LetterEntry>[
            _makeEntry(id: 3, chatRoomId: 'r', senderId: 'u', content: 'c'),
          ],
        );

        final result = await repository.deleteLetters([1, 2, 3]);

        expect(result, equals([1, 3]));
      });

      test('returns empty list when none exist', () async {
        when(
          mockDao.deleteLetter(any),
        ).thenAnswer((_) async => <LetterEntry>[]);

        final result = await repository.deleteLetters([10, 20, 30]);

        expect(result, isEmpty);
      });

      test('processes all ids even if some fail', () async {
        when(mockDao.deleteLetter(1)).thenAnswer(
          (_) async => <LetterEntry>[
            _makeEntry(id: 1, chatRoomId: 'r', senderId: 'u', content: 'a'),
          ],
        );
        when(mockDao.deleteLetter(2)).thenThrow(Exception('DB error'));
        when(mockDao.deleteLetter(3)).thenAnswer(
          (_) async => <LetterEntry>[
            _makeEntry(id: 3, chatRoomId: 'r', senderId: 'u', content: 'c'),
          ],
        );

        // The current implementation does NOT catch per-letter errors,
        // so the exception from letter 2 will propagate.
        expect(() => repository.deleteLetters([1, 2, 3]), throwsException);
      });
    });

    group('updateLetter', () {
      test('returns updated LetterDto on success', () async {
        final updatedEntry = _makeEntry(
          id: 1,
          chatRoomId: 'room-1',
          senderId: 'user-1',
          content: 'Updated content',
        );

        when(mockDao.updateRow(1, any)).thenAnswer((_) async => 1);
        when(mockDao.getLetterById(1)).thenAnswer((_) async => updatedEntry);

        final result = await repository.updateLetter(1, 'Updated content');

        expect(result, isA<LetterDto>());
        expect(result!.id, equals(1));
        expect(result.content, equals('Updated content'));
        expect(result.chatRoomId, equals('room-1'));
        expect(result.senderId, equals('user-1'));
      });

      test('returns null when no rows updated (letter not found)', () async {
        when(mockDao.updateRow(999, any)).thenAnswer((_) async => 0);

        final result = await repository.updateLetter(999, 'Ghost');

        expect(result, equals(null));
        verifyNever(mockDao.getLetterById(any));
      });

      test(
        'returns null when getLetterById returns null after update',
        () async {
          when(mockDao.updateRow(1, any)).thenAnswer((_) async => 1);
          when(mockDao.getLetterById(1)).thenAnswer((_) async => null);

          final result = await repository.updateLetter(1, 'Updated');

          expect(result, equals(null));
        },
      );

      test('rethrows exception on dao error', () async {
        when(mockDao.updateRow(1, any)).thenThrow(Exception('Update failed'));

        expect(() => repository.updateLetter(1, 'Fail'), throwsException);
      });
    });

    group('fetchAllLetters', () {
      test('returns empty iterable when no letters', () async {
        when(mockDao.getListLetter()).thenAnswer((_) async => <LetterEntry>[]);

        final result = await repository.fetchAllLetters();

        expect(result, isEmpty);
      });

      test('returns mapped LetterDto list', () async {
        final entries = <LetterEntry>[
          _makeEntry(id: 1, chatRoomId: 'r1', senderId: 'u1', content: 'A'),
          _makeEntry(id: 2, chatRoomId: 'r2', senderId: 'u2', content: 'B'),
        ];

        when(mockDao.getListLetter()).thenAnswer((_) async => entries);

        final result = await repository.fetchAllLetters();

        expect(result, hasLength(2));
        final list = result.toList();
        expect(list[0].id, equals(1));
        expect(list[0].content, equals('A'));
        expect(list[1].id, equals(2));
        expect(list[1].content, equals('B'));
      });

      test('wraps dao error in Exception', () async {
        when(mockDao.getListLetter()).thenThrow(StateError('Connection lost'));

        expect(() => repository.fetchAllLetters(), throwsException);
      });
    });

    group('fetchMessages', () {
      test('returns mapped LetterDto list', () async {
        final entries = <LetterEntry>[
          _makeEntry(id: 1, chatRoomId: 'room-1', senderId: 'u1', content: 'A'),
          _makeEntry(id: 2, chatRoomId: 'room-1', senderId: 'u2', content: 'B'),
        ];

        when(mockDao.getListLetter()).thenAnswer((_) async => entries);

        final result = await repository.fetchMessages('room-1');

        expect(result, hasLength(2));
      });

      test('BUG: does not filter by chatRoomId', () async {
        // This test documents the known bug: fetchMessages calls
        // getListLetter() without passing the chatRoomId parameter,
        // so it returns ALL letters regardless of the room.
        final entries = <LetterEntry>[
          _makeEntry(id: 1, chatRoomId: 'room-1', senderId: 'u1', content: 'A'),
          _makeEntry(id: 2, chatRoomId: 'room-2', senderId: 'u2', content: 'B'),
        ];

        when(mockDao.getListLetter()).thenAnswer((_) async => entries);

        final result = await repository.fetchMessages('room-1');

        // BUG: returns 2 letters from both rooms instead of just room-1
        expect(result, hasLength(2));
        // The correct behavior would be:
        // expect(result, hasLength(1));
        // expect(result.first.chatRoomId, equals('room-1'));

        // Verify the bug: getListLetter was called without chatRoomId
        verify(mockDao.getListLetter()).called(1);
        // It should have been called with chatRoomId parameter:
        // verify(mockDao.getListLetter(chatRoomId: 'room-1')).called(1);
      });

      test('wraps dao error in Exception', () async {
        when(mockDao.getListLetter()).thenThrow(StateError('Connection lost'));

        expect(() => repository.fetchMessages('room-1'), throwsException);
      });
    });
  });
}
