import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:stream_channel/stream_channel.dart';

typedef UnsubscribeCallback = Function(StreamChannel<dynamic> channel);

class WebSocketDisposer {
  final WebSocketChannel _channel;
  WebSocketDisposer(this._channel);

  final shouldUnsubscribe = <UnsubscribeCallback>[];

  void dispose() {
    for (final callback in shouldUnsubscribe) {
      callback(_channel);
    }
    _channel.sink.close();
  }
}
