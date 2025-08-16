import 'package:backend/ws_/logic/active_users_cubit.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:synchronized/synchronized.dart';

import 'package:backend/user/session.dart';

/// A class to manage and broadcast messages to WebSocket channels grouped by a room.
/// It ensures thread-safe operations and includes methods for managing subscriptions.
class Broadcast {
  // A single instance of the cubit to manage active users for all rooms.

  // The map to store active sessions linked to their WebSocket channels.
  final _activeSession = <WebSocketChannel, Session>{};
  Session? getSession(WebSocketChannel channel) => _activeSession[channel];

  /// A lock to prevent concurrent modifications to the maps.
  final _lock = Lock();

  /// Subscribes a WebSocket channel to a specific room.
  ///
  /// The [roomId] is the identifier of the group to join.
  /// The [channel] is the WebSocket connection to add to the room's subscribers.
  Future<void> subscribe({required Session session, required WebSocketChannel channel}) async {
    await _lock.synchronized(() async {
      // Add the session to the _activeSession map.
      _activeSession[channel] = session;
    });
  }

  /// Unsubscribes a WebSocket channel from a specific room.
  ///
  /// The [roomId] is the identifier of the group to leave.
  /// The [channel] is the WebSocket connection to remove.
  Future<void> unsubscribe({required String roomId, required WebSocketChannel channel}) async {
    await _lock.synchronized(() async {
      final sessionToRemove = getSession(channel);
      channel.sink.close();
      if (sessionToRemove != null) {}
      _activeSession.remove(channel); // Remove from active sessions
    });
  }
}
