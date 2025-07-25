import 'package:freezed_annotation/freezed_annotation.dart';

import 'failure.dart';

part 'request_failure.freezed.dart';
part 'request_failure.g.dart';

@freezed
abstract class RequestFailure with _$RequestFailure implements Failure {
  const factory RequestFailure({required String message, required int statusCode, @Default([]) List<String> errors}) =
      $RequestFailure;

  const RequestFailure._();

  factory RequestFailure.fromJson(Map<String, dynamic> json) => _$RequestFailureFromJson(json);
}
