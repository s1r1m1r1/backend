// import 'package:stream_channel/stream_channel.dart';

// mixin BroadcastMixin<State> on BlocBase<State> {
//   final _channels = <StreamChannel<dynamic>>[];

//   /// Convert the [state] to an object which will be broadcast to all
//   /// subscribers. The object returned must either be a `String` or `List<int>`.
//   Object toMessage(State state) => state is Object ? state : state.toString();

//   @override
//   void onChange(Change<State> change) {
//     super.onChange(change);
//     _broadcast(toMessage(change.nextState));
//   }

//   void _broadcast(dynamic message) {
//     for (final channel in _channels) {
//       if (message is! String && message is! List<int>) {
//         channel.sink.add(message.toString());
//       } else {
//         channel.sink.add(message);
//       }
//     }
//   }

//   /// The provided [channel] will be notified of all state changes.
//   void subscribe(StreamChannel<dynamic> channel) => _channels.add(channel);

//   /// The provided [channel] will no longer be notified of state changes.
//   void unsubscribe(StreamChannel<dynamic> channel) => _channels.remove(channel);
// }
