// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_failure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

$RequestFailure _$$RequestFailureFromJson(Map<String, dynamic> json) =>
    $RequestFailure(
      message: json['message'] as String,
      statusCode: (json['statusCode'] as num).toInt(),
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RequestFailureToJson($RequestFailure instance) =>
    <String, dynamic>{
      'message': instance.message,
      'statusCode': instance.statusCode,
      'errors': instance.errors,
    };
