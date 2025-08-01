// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initial_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitialPayload _$InitialPayloadFromJson(Map<String, dynamic> json) =>
    InitialPayload(
      (json['counter'] as num).toInt(),
      (json['letters'] as List<dynamic>).map(
        (e) => LetterDto.fromJson(e as Map<String, dynamic>),
      ),
    );

Map<String, dynamic> _$InitialPayloadToJson(InitialPayload instance) =>
    <String, dynamic>{
      'counter': instance.counter,
      'letters': instance.letters.toList(),
    };
