import 'package:test/test.dart';

/// Simple version comparison
/// Returns: 1 if v1 > v2, 0 if equal, -1 if v1 < v2
int _compareVersions(String v1, String v2) {
  final parts1 = v1.split('.').map(int.parse).toList();
  final parts2 = v2.split('.').map(int.parse).toList();

  for (var i = 0; i < parts1.length && i < parts2.length; i++) {
    if (parts1[i] > parts2[i]) return 1;
    if (parts1[i] < parts2[i]) return -1;
  }

  if (parts1.length > parts2.length) return 1;
  if (parts1.length < parts2.length) return -1;
  return 0;
}

bool _isVersionAccepted(String version, String minVersion) {
  return _compareVersions(version, minVersion) >= 0;
}

void main() {
  group('FrontendVersion comparison', () {
    test('version above minRequired is accepted', () {
      expect(_isVersionAccepted('1.2.3', '1.0.0'), isTrue);
    });

    test('version equal to minRequired is accepted', () {
      expect(_isVersionAccepted('1.0.0', '1.0.0'), isTrue);
    });

    test('version below minRequired is rejected', () {
      expect(_isVersionAccepted('0.9.0', '1.0.0'), isFalse);
    });

    test('major version difference', () {
      expect(_isVersionAccepted('2.0.0', '1.9.9'), isTrue);
      expect(_isVersionAccepted('1.9.9', '2.0.0'), isFalse);
    });

    test('patch version difference', () {
      expect(_isVersionAccepted('1.0.1', '1.0.0'), isTrue);
      expect(_isVersionAccepted('1.0.0', '1.0.1'), isFalse);
    });

    test('complex version comparison', () {
      expect(_isVersionAccepted('1.5.2', '1.5.2'), isTrue);
      expect(_isVersionAccepted('1.5.3', '1.5.2'), isTrue);
      expect(_isVersionAccepted('1.5.1', '1.5.2'), isFalse);
      expect(_isVersionAccepted('2.0.0', '1.9.9'), isTrue);
      expect(_isVersionAccepted('1.9.9', '2.0.0'), isFalse);
    });
  });
}
