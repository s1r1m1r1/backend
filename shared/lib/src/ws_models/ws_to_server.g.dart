// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_to_server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsToServer _$WsToServerFromJson(Map<String, dynamic> json) => WsToServer(
  roomId: json['room'] as String,
  eventType: $enumDecode(_$WsEventToServerEnumMap, json['event']),
  payload: json['payload'],
);

Map<String, dynamic> _$WsToServerToJson(WsToServer instance) =>
    <String, dynamic>{
      'event': _$WsEventToServerEnumMap[instance.eventType]!,
      'payload': instance.payload,
      'room': instance.roomId,
    };

const _$WsEventToServerEnumMap = {
  WsEventToServer.newMessage: 'newMessage',
  WsEventToServer.deleteMessage: 'deleteMessage',
  WsEventToServer.incrementCounter: 'incrementCounter',
  WsEventToServer.decrementCounter: 'decrementCounter',
  WsEventToServer.deleteLetter: 'deleteLetter',
  WsEventToServer.newLetter: 'newLetter',
  WsEventToServer.joinLetters: 'joinLetters',
  WsEventToServer.joinCounter: 'joinCounter',
  WsEventToServer.leaveRoom: 'leaveRoom',
  WsEventToServer.listRooms: 'listRooms',
  WsEventToServer.sendLetterToRoom: 'sendLetterToRoom',
  WsEventToServer.fetchRoomHistory: 'fetchRoomHistory',
  WsEventToServer.joinAdmin: 'joinAdmin',
};
