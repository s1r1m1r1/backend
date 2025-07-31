class CounterRepository {
  int _counter = 0;

  Future<int> incrementCounter(Map<String, dynamic> payload) async {
    _counter++;
    return _counter;
  }

  Future<int> decrementCounter(Map<String, dynamic> payload) async {
    _counter--;
    return _counter;
  }
}
