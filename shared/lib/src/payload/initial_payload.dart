import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared.dart';
part 'initial_payload.g.dart';

@JsonSerializable()
class InitialPayload {
  final int counter;
  final Iterable<LetterDto> letters;

  const InitialPayload(this.counter, this.letters);

  factory InitialPayload.fromJson(Map<String, dynamic> json) => _$InitialPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$InitialPayloadToJson(this);
}
