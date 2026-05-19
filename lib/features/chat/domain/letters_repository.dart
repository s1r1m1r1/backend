import 'package:dto/dto.dart';

abstract class LettersRepository {
  Future<LetterDto> createLetter(
    String content,
    UserId senderId,
    BroadcastId broadcastId,
  );

  Future<int> deleteLetter(int letterId);

  Future<List<int>> deleteLetters(List<int> letterIds);

  Future<LetterDto?> updateLetter(int letterId, String content);

  Future<Iterable<LetterDto>> fetchAllLetters();

  Future<Iterable<LetterDto>> fetchMessages(String chatRoomId);
}
