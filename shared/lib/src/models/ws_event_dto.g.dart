// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsEventDto _$WsEventDtoFromJson(Map<String, dynamic> json) => WsEventDto(
  eventType: json['eventType'] as String,
  data: json['data'] as Map<String, dynamic>,
);

Map<String, dynamic> _$WsEventDtoToJson(WsEventDto instance) =>
    <String, dynamic>{'eventType': instance.eventType, 'data': instance.data};
