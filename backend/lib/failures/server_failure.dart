import 'dart:io';

import 'failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'server_failure.freezed.dart';
part 'server_failure.g.dart';

@freezed
abstract class ServerFailure with _$ServerFailure implements Failure {
  const factory ServerFailure({
    required String message,
    @Default(HttpStatus.internalServerError) int statusCode,
    @Default([]) List<String> errors,
  }) = _ServerFailure;

  const ServerFailure._();

  factory ServerFailure.fromJson(Map<String, dynamic> json) => _$ServerFailureFromJson(json);
}
