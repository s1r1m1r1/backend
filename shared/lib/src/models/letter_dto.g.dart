// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LetterDto _$LetterDtoFromJson(Map<String, dynamic> json) => LetterDto(
  id: (json['id'] as num?)?.toInt(),
  chatRoomId: (json['chatRoomId'] as num).toInt(),
  senderId: (json['senderId'] as num).toInt(),
  content: json['content'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$LetterDtoToJson(LetterDto instance) => <String, dynamic>{
  'id': instance.id,
  'chatRoomId': instance.chatRoomId,
  'senderId': instance.senderId,
  'content': instance.content,
  'createdAt': instance.createdAt.toIso8601String(),
};

ChatRoomDto _$ChatRoomDtoFromJson(Map<String, dynamic> json) => ChatRoomDto(
  id: json['id'] as String,
  participants: (json['participants'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  lastMessage: LetterDto.fromJson(json['lastMessage'] as Map<String, dynamic>),
  unreadCount: (json['unreadCount'] as num).toInt(),
);

Map<String, dynamic> _$ChatRoomDtoToJson(ChatRoomDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participants': instance.participants,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
    };
