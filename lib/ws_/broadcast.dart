import 'package:backend/core/debug_log.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:synchronized/synchronized.dart';

import 'package:backend/session/session.dart';

/// A class to manage and broadcast messages to WebSocket channels grouped by a room.
/// It ensures thread-safe operations and includes methods for managing subscriptions.
class Broadcast {
  // ⭐️ New field to store active users and their channels.
  final _activeSession = <WebSocketChannel, Session>{};

  Session? getSession(WebSocketChannel channel) => _activeSession[channel];

  // ⭐️ A getter to return the list of active user names.
  List<Session> get activeUsersList => _activeSession.values.toList();

  /// The in-memory map to store WebSocket channels grouped by a unique room ID.
  /// Keys are room IDs (e.g., chat room names), and values are lists of
  /// the channels subscribed to that room.
  final _channelsByRoom = <String, List<WebSocketChannel>>{};

  /// A reverse-lookup map to store which rooms a given channel is subscribed to.
  /// Keys are WebSocket channels, and values are lists of the room IDs they
  /// are subscribed to. This is crucial for efficiently unsubscribing a channel
  /// from all rooms upon disconnection.
  final _roomsByChannel = <WebSocketChannel, List<String>>{};

  /// A lock to prevent concurrent modifications to the maps.
  final _lock = Lock();

  int get count => _roomsByChannel.length;

  /// Broadcasts a message to all channels subscribed to a specific room.
  ///
  /// The [roomId] is the identifier for the group (e.g., a chat room ID).
  /// The [message] is the content to be sent to all subscribed channels.
  Future<void> broadcast(String roomId, dynamic message) async {
    // Acquire a lock to safely read the list of channels.
    await _lock.synchronized(() async {
      final channels = _channelsByRoom[roomId];
      if (channels != null) {
        // Iterate over a copy to prevent errors if a channel is unsubscribed
        // while the loop is running.
        for (final channel in [...channels]) {
          // Wrap the sink.add call in a try-catch to handle potential
          // disconnections gracefully without crashing the broadcast.
          try {
            channel.sink.add(message);
          } catch (e) {
            // Log the error and remove the channel from the list.
            _channelsByRoom[roomId]?.remove(channel);
            debugLog('Failed to send message to a channel: $e');
            // Remove the channel from the reverse-lookup map as well.
            _roomsByChannel.remove(channel);
          }
        }
      }
    });
  }

  /// Subscribes a WebSocket channel to a specific room.
  ///
  /// The [roomId] is the identifier of the group to join.
  /// The [channel] is the WebSocket connection to add to the room's subscribers.
  Future<void> subscribe({
    required String roomId,
    required Session session,
    required WebSocketChannel channel,
  }) async {
    // Acquire a lock to safely modify the maps.
    await _lock.synchronized(() async {
      // Add the channel to the room's list.
      _channelsByRoom.update(roomId, (value) => [...value, channel], ifAbsent: () => [channel]);

      // Add the roomId to the channel's list of subscriptions.
      _roomsByChannel.update(channel, (value) => [...value, roomId], ifAbsent: () => [roomId]);

      // ⭐️ Add the user to the active users map.
      _activeSession[channel] = session;
    });
  }

  /// Unsubscribes a WebSocket channel from a specific room.
  ///
  /// The [roomId] is the identifier of the group to leave.
  /// The [channel] is the WebSocket connection to remove.
  Future<void> unsubscribe({required String roomId, required WebSocketChannel channel}) async {
    // Acquire a lock to safely modify the maps.
    await _lock.synchronized(() async {
      // Remove the channel from the room's list.
      _channelsByRoom[roomId]?.remove(channel);
      // Clean up the map if the room becomes empty.
      if (_channelsByRoom[roomId]?.isEmpty ?? false) {
        _channelsByRoom.remove(roomId);
      }

      // Remove the roomId from the channel's list of subscriptions.
      _roomsByChannel[channel]?.remove(roomId);
      // Clean up the reverse-lookup map if the channel has no more subscriptions.
      if (_roomsByChannel[channel]?.isEmpty ?? false) {
        _roomsByChannel.remove(channel);
        // ⭐️ Remove the user from the active users map.
        _activeSession.remove(channel);
        channel.sink.close();
      }
    });
  }

  // Add this method to your Broadcast class
  Future<void> unsubscribeAll(WebSocketChannel channel) async {
    await _lock.synchronized(() async {
      // Get all rooms this channel is subscribed to.
      final roomIds = _roomsByChannel[channel];
      if (roomIds != null) {
        // Iterate over a copy of the list to avoid issues while removing.
        for (final roomId in [...roomIds]) {
          // Remove the channel from each room's list.
          _channelsByRoom[roomId]?.remove(channel);

          // Clean up the room list if it becomes empty.
          if (_channelsByRoom[roomId]?.isEmpty ?? false) {
            _channelsByRoom.remove(roomId);
          }
        }
      }

      // Finally, remove the channel from the reverse-lookup map.
      _roomsByChannel.remove(channel);

      // ⭐️ Find and remove the user from the active users map.
      _activeSession.remove(channel);
    });
  }
}
