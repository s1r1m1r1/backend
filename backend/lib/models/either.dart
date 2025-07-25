/// The Either type itself, using a sealed class for exhaustiveness
sealed class Either<L, R> {
  const Either(); // Private constructor for sealed class
}

/// Left side represents a failure/error
final class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);
}

/// Right side represents a success
final class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);
}
