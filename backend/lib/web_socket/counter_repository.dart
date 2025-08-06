import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:injectable/injectable.dart';

import '../inject/inject.dart';

class Counter {
  int _value = 0;
  int get value => _value;
  int increment() {
    _value++;
    return _value;
  }

  int decrement() {
    _value--;
    return _value;
  }
}

@LazySingleton(scope: BackendScope.name)
class CounterRepository {
  final _counters = <String, Counter>{};

  void putCounter(String roomId) {
    debugLog('$green CounterRepository:putCounter $roomId $reset');
    _counters[roomId] = Counter();
  }

  Counter? counter(String roomId) {
    return _counters[roomId];
  }
}
