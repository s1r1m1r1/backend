// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => MessageDto(
  channelId: (json['channelId'] as num?)?.toInt(),
  content: json['content'] as String,
  senderId: (json['senderId'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$MessageDtoToJson(MessageDto instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'content': instance.content,
      'senderId': instance.senderId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
