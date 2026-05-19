import 'package:drift/drift.dart' show Value;
import 'package:dto/dto.dart';
import 'package:injectable/injectable.dart';

import '../../../core/debug_log.dart';
import '../../../db_client/dao/letters_dao.dart';
import '../../../db_client/db_client.dart';
import '../domain/letters_repository.dart';

@LazySingleton(as: LettersRepository)
class LettersRepositoryImpl implements LettersRepository {
  const LettersRepositoryImpl(this._lettersDao);
  final LettersDao _lettersDao;

  @override
  Future<LetterDto?> createLetter(
    String content,
    UserId senderId,
    BroadcastId broadcastId,
  ) async {
    try {
      final entry = await _lettersDao.insertRow(
        LetterTableCompanion.insert(
          chatRoomId: broadcastId,
          content: content,
          senderId: senderId.id,
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
      debugLog('${err.runtimeType} ');
      rethrow;
    }
  }

  @override
  Future<int> deleteLetter(int letterId) async {
    final deleted = await _lettersDao.deleteLetter(letterId);
    if (deleted.isNotEmpty) return deleted.last.id;
    return -1;
  }

  @override
  Future<List<int>> deleteLetters(List<int> letterIds) async {
    final deletedIds = <int>[];
    for (final letterId in letterIds) {
      final deleted = await _lettersDao.deleteLetter(letterId);
      if (deleted.isNotEmpty) {
        deletedIds.add(deleted.last.id);
      }
    }
    return deletedIds;
  }

  @override
  Future<LetterDto?> updateLetter(int letterId, String content) async {
    try {
      final updatedCount = await _lettersDao.updateRow(
        letterId,
        LetterTableCompanion(content: Value(content)),
      );
      if (updatedCount == 0) return null;

      final updated = await _lettersDao.getLetterById(letterId);
      if (updated == null) return null;
      return LetterDto(
        id: updated.id,
        chatRoomId: updated.chatRoomId,
        senderId: updated.senderId,
        content: updated.content,
        createdAt: updated.createdAt,
      );
    } catch (err) {
      debugLog('Updating letter error: $err');
      rethrow;
    }
  }

  @override
  Future<Iterable<LetterDto>> fetchAllLetters() async {
    try {
      final messages = await _lettersDao.getListLetter();

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

  @override
  Future<Iterable<LetterDto>> fetchMessages(String chatRoomId) async {
    try {
      final messages = await _lettersDao.getListLetter();

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
