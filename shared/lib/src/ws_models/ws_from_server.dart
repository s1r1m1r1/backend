import 'package:json_annotation/json_annotation.dart';

import 'ws_event_from_server.dart';
part 'ws_from_server.g.dart';

@JsonSerializable()
class WsFromServer {
  @JsonKey(name: 'event')
  final WsEventFromServer eventType;

  @JsonKey(name: 'payload')
  final Map<String, dynamic> payload;

  WsFromServer({required this.eventType, required this.payload});

  factory WsFromServer.fromJson(Map<String, dynamic> json) => _$WsFromServerFromJson(json);
  Map<String, dynamic> toJson() => _$WsFromServerToJson(this);
}
