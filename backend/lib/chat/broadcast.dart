import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:synchronized/synchronized.dart';

/// A class to manage and broadcast messages to WebSocket channels grouped by a topic.
/// It ensures thread-safe operations and includes methods for managing subscriptions.
class Broadcast {
  /// The in-memory map to store WebSocket channels grouped by a unique topic ID.
  /// Keys are topic IDs (e.g., chat room names), and values are lists of
  /// the channels subscribed to that topic.
  final _channels = <String, List<WebSocketChannel>>{};

  /// A lock to prevent concurrent modifications to the [_channels] map.
  final _lock = Lock();

  /// Broadcasts a message to all channels subscribed to a specific topic.
  ///
  /// The [topicId] is the identifier for the group (e.g., a chat room ID).
  /// The [message] is the content to be sent to all subscribed channels.
  Future<void> broadcast(String topicId, dynamic message) async {
    // Acquire a lock to safely read the list of channels.
    await _lock.synchronized(() async {
      final channels = _channels[topicId];
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
            _channels[topicId]?.remove(channel);
            print('Failed to send message to a channel: $e');
          }
        }
      }
    });
  }

  /// Subscribes a WebSocket channel to a specific topic.
  ///
  /// The [topicId] is the identifier of the group to join.
  /// The [channel] is the WebSocket connection to add to the topic's subscribers.
  Future<void> subscribe(String topicId, WebSocketChannel channel) async {
    // Acquire a lock to safely modify the map.
    await _lock.synchronized(() async {
      _channels.update(topicId, (value) => [...value, channel], ifAbsent: () => [channel]);
    });
  }

  /// Unsubscribes a WebSocket channel from a specific topic.
  ///
  /// The [topicId] is the identifier of the group to leave.
  /// The [channel] is the WebSocket connection to remove.
  Future<void> unsubscribe(String topicId, WebSocketChannel channel) async {
    // Acquire a lock to safely modify the map.
    await _lock.synchronized(() async {
      _channels[topicId]?.remove(channel);
      // Clean up the map if the topic becomes empty.
      if (_channels[topicId]?.isEmpty ?? false) {
        _channels.remove(topicId);
      }
    });
  }
}
