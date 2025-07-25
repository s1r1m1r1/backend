import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/di/injectable.dart';
import 'package:logging/logging.dart';

import 'app/app.dart';
import 'core/logging/bloc_observer.dart';
import 'core/logging/log_colors.dart';
import 'core/logging/logger_utils.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

//  /\_/\
// ( o.o )
//  > ^ <
//  LETS START
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  Bloc.observer = MyBlocObserver();
  hierarchicalLoggingEnabled = true;
  Logger.root.onRecord.listen(watchRecords);

  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      debugPrintStack(stackTrace: stack, label: '${red}PlatformDispatcher$reset$error');
    } else {
      // Sentry.captureException(details.exception, stackTrace: details.stack);
      // FirebaseCrashlytics.instance.recordError(details.exception, details.stack);
    }
    return true;
  };

  FlutterError.onError = (details) {
    if (kDebugMode) {
      // In debug mode, simply print the error to the console
      FlutterError.dumpErrorToConsole(details);
    } else {
      // Sentry.captureException(details.exception, stackTrace: details.stack);
      // FirebaseCrashlytics.instance.recordError(details.exception, details.stack);
    }
  };
  // no # hash for web , and with # on native
  usePathUrlStrategy();
  runApp(const App());
}
