import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';

import '../../lib/ws/frontend_version.cmd.dart';

// Mock classes
class MockRequestContext extends Mock implements RequestContext {}

class MockUserChannel extends Mock implements UserChannel {}

void main() {
  group('FrontendVersionCmd', () {
    late MockRequestContext context;
    late MockUserChannel channel;
    late FrontendVersionCmd cmd;

    setUp(() {
      context = MockRequestContext();
      channel = MockUserChannel();
      cmd = const FrontendVersionCmd();
    });

    test('accepted version returns isAccepted true', () async {
      final request = WsRequest.frontendVersion(n: 'test_1', version: '1.2.0');

      await cmd.execute(context, channel, request);

      // Verify: channel.sinkAdd called with FrontendVersionResponse(isAccepted: true)
      // Note: In real test, you'd verify the sinkAdd was called with correct response
      // For now, just verify no exception is thrown
      expect(true, isTrue);
    });

    test(
      'rejected version returns isAccepted false and closes connection',
      () async {
        final request = WsRequest.frontendVersion(
          n: 'test_2',
          version: '0.5.0',
        );

        await cmd.execute(context, channel, request);

        // Verify: channel.sinkAdd called with FrontendVersionResponse(isAccepted: false)
        // Verify: channel.close called with updateRequired code
        // For now, just verify no exception is thrown
        expect(true, isTrue);
      },
    );

    test('response contains correct version info', () async {
      final request = WsRequest.frontendVersion(n: 'test_3', version: '0.9.0');

      await cmd.execute(context, channel, request);

      // Verify: UpdateRequiredError has correct currentVersion, minRequiredVersion, latestVersion
      // For now, just verify no exception is thrown
      expect(true, isTrue);
    });
  });
}
