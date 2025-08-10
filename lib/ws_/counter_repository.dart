import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';

class Counter {
  int _value = 0;
  int get value => _value;
  int increment() {
    _value++;
    return _value;
  }

  /*************  ✨ Windsurf Command ⭐  *************/
  /// Decrement the counter's value by 1 and return the new value.
  /*******  295303de-f7ec-4406-9bc6-5a51f85bd655  *******/
  int decrement() {
    _value--;
    return _value;
  }
}

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
