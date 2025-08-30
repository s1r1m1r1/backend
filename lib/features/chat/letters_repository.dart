import 'package:backend/core/debug_log.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:drift/drift.dart' show Value;
import 'package:injectable/injectable.dart';

import 'package:sha_red/sha_red.dart';

@lazySingleton
class LettersRepository {
  final DbClient _db;
  const LettersRepository(this._db);

  Future<LetterDto?> createLetter(CreateLetterDto dto) async {
    try {
      final entry = await _db.lettersDao.insertRow(
        LetterTableCompanion(
          chatRoomId: Value(dto.roomId),
          content: Value(dto.content),
          senderId: Value(dto.senderId),
          createdAt: Value(DateTime.now()),
        ),
      );
      if (entry?.id == null || entry?.chatRoomId == null) {
        return null;
      }
      debugLog('Creating letter: success');
      return LetterDto(
        id: entry!.id,
        chatRoomId: entry.chatRoomId,
        senderId: entry.senderId,
        content: entry.content,
        createdAt: entry.createdAt,
      );
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<int> deleteLetter(int letterId) async {
    final deleted = await _db.lettersDao.deleteLetter(letterId);
    if (deleted.isNotEmpty) return deleted.last.id;
    return -1;
  }

  Future<Iterable<LetterDto>> fetchAllLetters() async {
    try {
      final messages = await _db.lettersDao.getListLetter();

      return messages.map(
        (i) => LetterDto(
          id: i.id,
          chatRoomId: i.chatRoomId,
          content: i.content,
          senderId: i.senderId,
          createdAt: i.createdAt,
        ),
      );
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<Iterable<LetterDto>> fetchMessages(String chatRoomId) async {
    try {
      final messages = await _db.lettersDao.getListLetter();

      return messages.map(
        (i) => LetterDto(
          id: i.id,
          chatRoomId: i.chatRoomId,
          content: i.content,
          senderId: i.senderId,
          createdAt: i.createdAt,
        ),
      );
    } catch (err) {
      throw Exception(err);
    }
  }
}
