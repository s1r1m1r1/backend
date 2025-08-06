import 'package:backend/core/debug_log.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:synchronized/synchronized.dart';

/// A class to manage and broadcast messages to WebSocket channels grouped by a topic.
/// It ensures thread-safe operations and includes methods for managing subscriptions.
class Broadcast {
  /// The in-memory map to store WebSocket channels grouped by a unique topic ID.
  /// Keys are topic IDs (e.g., chat room names), and values are lists of
  /// the channels subscribed to that topic.
  final _channelsByTopic = <String, List<WebSocketChannel>>{};

  /// A reverse-lookup map to store which topics a given channel is subscribed to.
  /// Keys are WebSocket channels, and values are lists of the topic IDs they
  /// are subscribed to. This is crucial for efficiently unsubscribing a channel
  /// from all topics upon disconnection.
  final _topicsByChannel = <WebSocketChannel, List<String>>{};

  /// A lock to prevent concurrent modifications to the maps.
  final _lock = Lock();

  int get count => _topicsByChannel.length;

  /// Broadcasts a message to all channels subscribed to a specific topic.
  ///
  /// The [topicId] is the identifier for the group (e.g., a chat room ID).
  /// The [message] is the content to be sent to all subscribed channels.
  Future<void> broadcast(String topicId, dynamic message) async {
    // Acquire a lock to safely read the list of channels.
    await _lock.synchronized(() async {
      final channels = _channelsByTopic[topicId];
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
            _channelsByTopic[topicId]?.remove(channel);
            debugLog('Failed to send message to a channel: $e');
            // Remove the channel from the reverse-lookup map as well.
            _topicsByChannel.remove(channel);
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
    // Acquire a lock to safely modify the maps.
    await _lock.synchronized(() async {
      // Add the channel to the topic's list.
      _channelsByTopic.update(topicId, (value) => [...value, channel], ifAbsent: () => [channel]);

      // Add the topicId to the channel's list of subscriptions.
      _topicsByChannel.update(channel, (value) => [...value, topicId], ifAbsent: () => [topicId]);
    });
  }

  /// Unsubscribes a WebSocket channel from a specific topic.
  ///
  /// The [topicId] is the identifier of the group to leave.
  /// The [channel] is the WebSocket connection to remove.
  Future<void> unsubscribe(String topicId, WebSocketChannel channel) async {
    // Acquire a lock to safely modify the maps.
    await _lock.synchronized(() async {
      // Remove the channel from the topic's list.
      _channelsByTopic[topicId]?.remove(channel);
      // Clean up the map if the topic becomes empty.
      if (_channelsByTopic[topicId]?.isEmpty ?? false) {
        _channelsByTopic.remove(topicId);
      }

      // Remove the topicId from the channel's list of subscriptions.
      _topicsByChannel[channel]?.remove(topicId);
      // Clean up the reverse-lookup map if the channel has no more subscriptions.
      if (_topicsByChannel[channel]?.isEmpty ?? false) {
        _topicsByChannel.remove(channel);
        channel.sink.close();
      }
    });
  }

  // Add this method to your Broadcast class
  Future<void> unsubscribeAll(WebSocketChannel channel) async {
    await _lock.synchronized(() async {
      // Get all topics this channel is subscribed to.
      final topicIds = _topicsByChannel[channel];
      if (topicIds != null) {
        // Iterate over a copy of the list to avoid issues while removing.
        for (final topicId in [...topicIds]) {
          // Remove the channel from each topic's list.
          _channelsByTopic[topicId]?.remove(channel);

          // Clean up the topic list if it becomes empty.
          if (_channelsByTopic[topicId]?.isEmpty ?? false) {
            _channelsByTopic.remove(topicId);
          }
        }
      }
      // Finally, remove the channel from the reverse-lookup map.
      _topicsByChannel.remove(channel);
    });
  }
}
