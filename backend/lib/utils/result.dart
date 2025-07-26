import 'dart:async';

import 'package:meta/meta.dart';

/// A sealed class representing either a failure [F] or a success [S].
///
/// This provides a robust and type-safe way to handle operations that can
/// either succeed with a value or fail with an error.
@immutable
sealed class Result<F, S> {
  const Result();

  bool get isSuccess => this is Success<F, S>;
  bool get isFailure => this is Fail<F, S>;

  F? get failure => this is Fail<F, S> ? (this as Fail<F, S>).value : null;
  S? get success => this is Success<F, S> ? (this as Success<F, S>).value : null;
}

final class Fail<F, S> extends Result<F, S> {
  final F value;
  const Fail(this.value);
}

final class Success<F, S> extends Result<F, S> {
  final S value;
  const Success(this.value);
}

extension ResultX<F, S> on Result<F, S> {
  /// Transforms a `Result<F, S>` into a `FutureOr<Result<F, S2>>`
  /// by applying `onSuccess` if this result is a `Success`.
  /// If this result is a `Fail`, it propagates the failure.
  FutureOr<Result<F, S2>> flatMap<S2>(FutureOr<Result<F, S2>> Function(S value) onSuccess) {
    if (this is Success<F, S>) {
      return onSuccess((this as Success<F, S>).value);
    } else {
      // Propagate the failure with the original failure type
      return Fail<F, S2>((this as Fail<F, S>).value);
    }
  }

  /// Transforms a `Result<F, S>` into a `FutureOr<T>`
  /// by applying `onFailure` if this result is a `Fail`,
  /// or `onSuccess` if this result is a `Success`.
  FutureOr<T> match<T>(FutureOr<T> Function(F failure) onFailure, FutureOr<T> Function(S success) onSuccess) {
    if (this is Fail<F, S>) {
      return onFailure((this as Fail<F, S>).value);
    } else {
      return onSuccess((this as Success<F, S>).value);
    }
  }
}
