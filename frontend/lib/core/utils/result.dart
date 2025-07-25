import 'package:meta/meta.dart';

/// A sealed class representing either a failure [F] or a success [S].
///
/// This provides a robust and type-safe way to handle operations that can
/// either succeed with a value or fail with an error.
@immutable
sealed class Result<F, S> {
  const Result._();
  const factory Result.success(S value) = Success;
  const factory Result.fail(F value) = Fail;
}

/// Represents a failed state with a value of type [F].
final class Fail<F, S> extends Result<F, S> {
  final F f;

  const Fail(this.f) : super._();
}

/// Represents a successful state with a value of type [S].
final class Success<F, S> extends Result<F, S> {
  final S s;

  const Success(this.s) : super._();
}
