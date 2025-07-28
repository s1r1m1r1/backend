import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import 'logger/log_colors.dart';

///  /\_/\
/// ( o.o )
///  > ^ <

class MyBlocObserver extends BlocObserver {
  static const String loggerName = 'BlocObserver';
  MyBlocObserver();
  late final _logger = Logger(loggerName);

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _logger.severe(
      ':${bloc.runtimeType}:\n'
      '${red}err$reset:',
      error,
      stackTrace,
    );
    // not throw excepted exception error to this
    // Sentry.captureException(error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (kDebugMode) {
      /* UNCOMMENT IF YOU NEED TO FILTER SPECIFIC BLOCS
         JUST COPY LINE AND RENAME WHAT YOU WANT */
      // if(bloc is! OtherCubit) return;
      _logger.info(
        '${bloc.runtimeType}:\n'
        'event: ${transition.event}\n'
        'state: ${transition.nextState}',
      );
    }
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    // if (kDebugMode) {
    /* UNCOMMENT IF YOU NEED TO FILTER SPECIFIC BLOCS
         JUST COPY LINE AND RENAME WHAT YOU WANT */
    // if(bloc is! OtherCubit) return;
    _logger.info(
      '${bloc.runtimeType}:\n'
      'event: ${event}\n',
    );
    // }
    super.onEvent(bloc, event);
  }

  @override
  void onCreate(BlocBase bloc) {
    if (kDebugMode) _logger.info('${bloc.runtimeType} onCreate()');
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    if (kDebugMode) _logger.info('${bloc.runtimeType} onClose()');
    super.onClose(bloc);
  }
}
