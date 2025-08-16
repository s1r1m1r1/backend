import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';

class ServerBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugLog('${bloc.runtimeType} $change');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugLog('$yellow${bloc.runtimeType}$reset ${event.runtimeType} ');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    debugLog('$yellow${bloc.runtimeType} onCLOSE$reset ');
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugLog('$yellow${bloc.runtimeType} onCREATE$reset ');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugLog('$red${bloc.runtimeType}$reset $error');
  }
}
