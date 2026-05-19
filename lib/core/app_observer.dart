import 'package:freezed_annotation/freezed_annotation.dart';
import 'di/injection.dart';

/// Unified observer for different application layers (Repository, UseCase, etc.)
abstract class AppObserver {
  const AppObserver();

  /// Logs a standard information message
  void log(String name, String message);

  /// Logs a warning message
  void warn(String name, String message);

  /// Logs an error with stack trace
  void error(String name, Object error, [StackTrace? stackTrace]);

  /// Tracks the start of an operation (e.g., repository method call)
  void onStart(String name, String operation, [Map<String, dynamic>? params]);

  /// Tracks the successful completion of an operation
  void onSuccess(String name, String operation, [Object? result]);

  /// Tracks the creation of an object
  void onCreate(Object instance);

  /// Tracks the disposal of an object
  void onDispose(Object instance);

  /// Tracks an error in an object
  void onLifecycleError(
    Object instance,
    Object error, [
    StackTrace? stackTrace,
  ]);

  /// Tracks a broadcast event
  void onBroadcast(Object source, Object? message);

  /// Changes the level for a specific logger or prefix
  void setLevel(String name, String level);
}

/// Mixin to provide lifecycle logging capabilities to any class.
mixin LifecycleLogging {
  /// The observer instance used for logging.
  @protected
  late final AppObserver observer = getIt<AppObserver>();

  /// Logs the creation of the current instance.
  @mustCallSuper
  void captureCreate() => observer.onCreate(this);

  /// Logs the disposal of the current instance.
  @mustCallSuper
  void captureDispose() => observer.onDispose(this);

  /// Logs an error occurring within the current instance.
  @mustCallSuper
  void captureError(Object error, [StackTrace? stackTrace]) =>
      observer.onLifecycleError(this, error, stackTrace);
}
