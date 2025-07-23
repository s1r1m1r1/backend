// Not required for test files
// ignore_for_file: prefer_const_constructors
import 'package:data_source/data_source.dart';
import 'package:test/test.dart';

void main() {
  group('DataSource', () {
    test('can be instantiated', () {
      expect(DataSource(), isNotNull);
    });
  });
}
