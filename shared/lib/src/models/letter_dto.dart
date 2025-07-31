import 'package:json_annotation/json_annotation.dart';

part 'letter_dto.g.dart';

@JsonSerializable()
class LetterDto {
  final int? id;
  final int chatRoomId;
  final int senderId;
  final String content;
  final DateTime createdAt;

  const LetterDto({
    this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => _$LetterDtoToJson(this);

  factory LetterDto.fromJson(Map<String, dynamic> json) => _$LetterDtoFromJson(json);
}

@JsonSerializable()
class ChatRoomDto {
  final String id;
  // id of users
  final List<String> participants;
  final LetterDto lastMessage;
  final int unreadCount;

  const ChatRoomDto({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.unreadCount,
  });

  Map<String, dynamic> toJson() => _$ChatRoomDtoToJson(this);
  factory ChatRoomDto.fromJson(Map<String, dynamic> json) => _$ChatRoomDtoFromJson(json);
}
