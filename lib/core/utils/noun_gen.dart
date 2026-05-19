extension type NouN._(String v) {
  factory NouN.next() {
    _nextN++;
    final n = '$_prefix$_nextN';
    return ._(n);
  }
  static const _prefix = 'zzz';
  static int _nextN = 0;
}
