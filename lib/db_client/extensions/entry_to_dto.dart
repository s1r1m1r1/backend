import 'package:dto/dto.dart';
import 'package:game_dto/game_dto.dart';

import '../db_client.dart';

// =============================================================================
// UnitEntry → UnitDto
// =============================================================================
extension UnitEntryToDto on UnitEntry {
  UnitDto toDto() => UnitDto(
    id: UnitId(id),
    name: name,
    hp: vitality,
    atk: atk,
    def: def,
    level: level,
    statPoints: statPoints,
  );
}

// =============================================================================
// UserEntry → UserDto
// =============================================================================
extension UserEntryToDto on UserEntry {
  UserDto toDto() =>
      UserDto(userId: UserId(id), email: Email(email), role: role);
}

// =============================================================================
// LetterEntry → LetterDto
// =============================================================================
extension LetterEntryToDto on LetterEntry {
  LetterDto toDto() => LetterDto(
    id: id,
    chatRoomId: chatRoomId,
    senderId: UserId(senderId),
    content: content,
    createdAt: createdAt,
  );
}

// =============================================================================
// TodoEntry → TodoDto
// =============================================================================
extension TodoEntryToDto on TodoEntry {
  TodoDto toDto() => TodoDto(
    id: id,
    title: title,
    description: description,
    completed: completed,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

// =============================================================================
// SessionEntry → SessionDto
// =============================================================================
extension SessionEntryToDto on SessionEntry {
  SessionDto toDto() => SessionDto(
    user: UserDto(userId: UserId(userId), email: null, role: Role.user),
    unit: null,
  );
}
