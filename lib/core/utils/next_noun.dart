import 'package:types/types.dart';

Noun nextNoun() {
  _nextN++;
  final n = '$_prefix$_nextN';
  return Noun(n);
}

const _prefix = 'zzz';
int _nextN = 0;
