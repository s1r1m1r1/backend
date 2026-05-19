import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

import 'app_observer.dart';

/// Standard implementation of AppObserver using the 'logging' package.
@LazySingleton(as: AppObserver)
class ServerAppObserver implements AppObserver {
  const ServerAppObserver();

  Logger _getLogger(Object instanceOrName) {
    if (instanceOrName is String) {
      return Logger(instanceOrName);
    }
    final name = instanceOrName.runtimeType.toString();
    final prefix = _getPrefixFor(instanceOrName);
    return Logger(prefix != null ? '$prefix.$name' : name);
  }

  String? _getPrefixFor(Object instance) {
    final name = instance.runtimeType.toString();
    if (name.contains('Repository')) return 'Repository';
    if (name.contains('UseCase')) return 'UseCase';
    if (name.contains('Service')) return 'Service';
    if (name.contains('Supervisor')) return 'Supervisor';
    if (name.contains('Broadcast')) return 'Broadcast';
    return null;
  }

  @override
  void log(String name, String message) => _getLogger(name).info(message);

  @override
  void warn(String name, String message) => _getLogger(name).warning(message);

  @override
  void error(String name, Object error, [StackTrace? stackTrace]) {
    final trace = stackTrace != null ? Trace.from(stackTrace).terse : null;
    _getLogger(name).severe('ERROR: $error', error, trace);
  }

  @override
  void onStart(String name, String operation, [Map<String, dynamic>? params]) {
    final paramsStr = params != null ? ' params: $params' : '';
    _getLogger(name).info('▶️ START: $operation$paramsStr');
  }

  @override
  void onSuccess(String name, String operation, [Object? result]) {
    final resultStr = result != null ? ' result: $result' : '';
    _getLogger(name).info('✅ SUCCESS: $operation$resultStr');
  }

  @override
  void onCreate(Object instance) {
    _getLogger(instance).info('✨ Created');
  }

  @override
  void onDispose(Object instance) {
    _getLogger(instance).info('♻️ Disposed');
  }

  @override
  void onLifecycleError(
    Object instance,
    Object error, [
    StackTrace? stackTrace,
  ]) {
    final trace = stackTrace != null ? Trace.from(stackTrace).terse : null;
    _getLogger(instance).severe('❌ Error: $error', error, trace);
  }

  @override
  void onBroadcast(Object source, Object? message) {
    _getLogger(source).info('📡 Broadcast: $message');
  }

  @override
  void setLevel(String name, String level) {
    final l = Level.LEVELS.firstWhere(
      (element) => element.name.toUpperCase() == level.toUpperCase(),
      orElse: () => Level.INFO,
    );
    Logger(name).level = l;
  }
}
