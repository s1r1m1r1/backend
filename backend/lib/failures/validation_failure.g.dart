// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_failure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

$ValidationFailure _$$ValidationFailureFromJson(Map<String, dynamic> json) =>
    $ValidationFailure(
      message: json['message'] as String?,
      statusCode: (json['statusCode'] as num).toInt(),
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ValidationFailureToJson($ValidationFailure instance) =>
    <String, dynamic>{
      'message': instance.message,
      'statusCode': instance.statusCode,
      'errors': instance.errors,
    };
