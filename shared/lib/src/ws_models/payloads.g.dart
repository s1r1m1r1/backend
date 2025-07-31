// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payloads.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewMessagePayload _$NewMessagePayloadFromJson(Map<String, dynamic> json) =>
    NewMessagePayload(
      content: json['content'] as String,
      senderId: json['senderId'] as String,
    );

Map<String, dynamic> _$NewMessagePayloadToJson(NewMessagePayload instance) =>
    <String, dynamic>{
      'content': instance.content,
      'senderId': instance.senderId,
    };

DeleteMessagePayload _$DeleteMessagePayloadFromJson(
  Map<String, dynamic> json,
) => DeleteMessagePayload(messageId: json['messageId'] as String);

Map<String, dynamic> _$DeleteMessagePayloadToJson(
  DeleteMessagePayload instance,
) => <String, dynamic>{'messageId': instance.messageId};

CounterPayload _$CounterPayloadFromJson(Map<String, dynamic> json) =>
    CounterPayload((json['value'] as num).toInt());

Map<String, dynamic> _$CounterPayloadToJson(CounterPayload instance) =>
    <String, dynamic>{'value': instance.value};
