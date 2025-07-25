// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_failure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerFailure _$ServerFailureFromJson(Map<String, dynamic> json) =>
    _ServerFailure(
      message: json['message'] as String,
      statusCode: (json['statusCode'] as num?)?.toInt() ??
          HttpStatus.internalServerError,
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ServerFailureToJson(_ServerFailure instance) =>
    <String, dynamic>{
      'message': instance.message,
      'statusCode': instance.statusCode,
      'errors': instance.errors,
    };
