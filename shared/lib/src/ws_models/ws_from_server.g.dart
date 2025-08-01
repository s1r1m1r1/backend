// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_from_server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsFromServer _$WsFromServerFromJson(Map<String, dynamic> json) => WsFromServer(
  eventType: $enumDecode(_$WsEventFromServerEnumMap, json['event']),
  payload: json['payload'],
);

Map<String, dynamic> _$WsFromServerToJson(WsFromServer instance) =>
    <String, dynamic>{
      'event': _$WsEventFromServerEnumMap[instance.eventType]!,
      'payload': instance.payload,
    };

const _$WsEventFromServerEnumMap = {
  WsEventFromServer.initial: 'initial',
  WsEventFromServer.letters: 'letters',
  WsEventFromServer.counter: 'counter',
  WsEventFromServer.letterCreated: 'letterCreated',
};
