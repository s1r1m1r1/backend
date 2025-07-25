// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_failure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NetworkFailure _$NetworkFailureFromJson(Map<String, dynamic> json) =>
    _NetworkFailure(
      message: json['message'] as String,
      statusCode: (json['statusCode'] as num).toInt(),
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$NetworkFailureToJson(_NetworkFailure instance) =>
    <String, dynamic>{
      'message': instance.message,
      'statusCode': instance.statusCode,
      'errors': instance.errors,
    };
