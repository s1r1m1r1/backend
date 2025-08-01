// lib/payloads.dart
import 'package:json_annotation/json_annotation.dart';

import '../../shared.dart';

part 'payloads.g.dart';

@JsonSerializable()
class NewMessagePayload {
  final String content;
  final String senderId;

  NewMessagePayload({required this.content, required this.senderId});

  factory NewMessagePayload.fromJson(Map<String, dynamic> json) => _$NewMessagePayloadFromJson(json);
  Map<String, dynamic> toJson() => _$NewMessagePayloadToJson(this);
}

@JsonSerializable()
class DeleteMessagePayload {
  final String messageId;

  DeleteMessagePayload({required this.messageId});

  factory DeleteMessagePayload.fromJson(Map<String, dynamic> json) => _$DeleteMessagePayloadFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteMessagePayloadToJson(this);
}

@JsonSerializable()
class CounterPayload {
  final int value;
  const CounterPayload(this.value);

  factory CounterPayload.fromJson(Map<String, dynamic> json) => _$CounterPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$CounterPayloadToJson(this);
}

@JsonSerializable()
class LettersPayload {
  final Iterable<LetterDto> letters;

  LettersPayload(this.letters);

  factory LettersPayload.fromJson(Map<String, dynamic> json) => _$LettersPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$LettersPayloadToJson(this);
}
