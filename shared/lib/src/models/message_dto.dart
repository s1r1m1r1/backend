import 'package:json_annotation/json_annotation.dart';

part 'message_dto.g.dart';

@JsonSerializable()
class MessageDto {
  final int? channelId;
  final String content;
  final int senderId;
  final DateTime createdAt;
  const MessageDto({this.channelId, required this.content, required this.senderId, required this.createdAt});

  factory MessageDto.fromJson(Map<String, dynamic> json) => _$MessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);
}
