import 'package:freezed_annotation/freezed_annotation.dart';

import 'failure.dart';

part 'network_failure.freezed.dart';
part 'network_failure.g.dart';

@freezed
abstract class NetworkFailure with _$NetworkFailure implements Failure {
  const NetworkFailure._();

  const factory NetworkFailure({
    required String message,
    required int statusCode,
    @Default([]) List<String> errors,
  }) = _NetworkFailure;

  factory NetworkFailure.fromJson(Map<String, dynamic> json) => _$NetworkFailureFromJson(json);
}
