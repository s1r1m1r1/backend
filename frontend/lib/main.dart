import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app/app.dart';
import 'package:frontend/app/app_bloc_observer.dart';
import 'package:frontend/features/auth/view/bloc/login/login_bloc.dart';
import 'package:frontend/features/auth/view/bloc/signup/signup_bloc.dart';
import 'package:frontend/features/todo/view/bloc/todo_bloc.dart';
import 'package:frontend/bloc/user/user_bloc.dart';
import 'package:logging/logging.dart';

import 'app/logger/log_colors.dart';
import 'app/logger/logger_utils.dart';
import 'inject/inject.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
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
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (_) => getIt<UserBloc>()..add(LoadUsers())),
        BlocProvider<LoginBloc>(create: (_) => getIt<LoginBloc>()),
        BlocProvider<SignupBloc>(create: (_) => getIt<SignupBloc>()),
        BlocProvider<TodoBloc>(create: (_) => getIt<TodoBloc>()..add(LoadTodosEvent())),
      ],
      child: const App(),
    ),
  );
}
