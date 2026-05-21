import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';

import '../features/auth/application/session_socket.dart';
import 'ws_cmd.dart';

class FrontendVersionCmd extends WsCmd<FrontendVersionRequest> {
  const FrontendVersionCmd();

  @override
  FutureOr<void> execute(
    RequestContext context,
    UserChannel channel,
    FrontendVersionRequest message,
  ) {
    final version = message.version;
    // ignore: unused_local_variable
    final platform = message.platform;

    // TODO: Implement proper version validation logic
    // For now, accept all versions (conditional values for testing)
    const minVersion = '1.0.0';
    const latestVersion = '1.2.0';

    // Simple version comparison (for demo purposes)
    // In production, use proper semver comparison
    final isAccepted = _compareVersions(version, minVersion) >= 0;

    if (isAccepted) {
      channel.sinkAdd(
        WsResponse.frontendVersion(n: message.n, isAccepted: true).toPacket(),
      );
    } else {
      channel.sinkAdd(
        WsResponse.frontendVersion(
          n: message.n,
          isAccepted: false,
          error: UpdateRequiredError(
            message: 'Version $version is no longer supported',
            currentVersion: version,
            minRequiredVersion: minVersion,
            latestVersion: latestVersion,
          ),
        ).toPacket(),
      );
      // Close connection with updateRequired code
      channel.close(
        WebSocketCloseCode.updateRequired.code,
        WebSocketCloseCode.updateRequired.message,
      );
    }
  }

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
}
