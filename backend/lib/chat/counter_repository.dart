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

class CounterRepository {
  final _counters = <String, Counter>{};

  void putCounter(String roomId) {
    _counters[roomId] = Counter();
  }

  Counter? counter(String roomId) {
    return _counters[roomId];
  }
}
