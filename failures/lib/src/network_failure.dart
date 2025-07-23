import 'package:failures/failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_failure.freezed.dart';
part 'network_failure.g.dart';

@freezed
abstract class NetworkFailure with _$NetworkFailure {
  @Implements<Failure>()
  const factory NetworkFailure({
    required String message,
    required int code,
    @Default([]) List<String> errors,
  }) = _NetworkFailure;

  factory NetworkFailure.fromJson(Map<String, dynamic> json) => _$NetworkFailureFromJson(json);
}
