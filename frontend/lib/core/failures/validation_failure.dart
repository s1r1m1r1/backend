import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'failure.dart';
part 'validation_failure.freezed.dart';
part 'validation_failure.g.dart';

@freezed
abstract class ValidationFailure with _$ValidationFailure implements Failure {
  const factory ValidationFailure({
    required String message,
    @Default(HttpStatus.badRequest) int statusCode,
    @Default({}) Map<String, List<String>> errors,
  }) = $ValidationFailure;

  const ValidationFailure._();

  factory ValidationFailure.fromJson(Map<String, dynamic> json) => _$ValidationFailureFromJson(json);
}
