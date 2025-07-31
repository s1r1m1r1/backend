import 'package:backend/ws_counter/cubit/counter_cubit.dart';
import 'package:backend/ws_counter/model/message.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    final cubit = context.read<CounterCubit>()..subscribe(channel);

    channel.sink.add('${cubit.state}');

    channel.stream.listen((event) {
      if (event is! String) {
        channel.sink.add('Invalid message');
        return;
      }

      switch ('$event'.toMessage()) {
        case Message.increment:
          cubit.increment();
        case Message.decrement:
          cubit.decrement();
        case null:
          break;
      }
    }, onDone: () => cubit.unsubscribe(channel));
  });

  return handler(context);
}

extension on String {
  Message? toMessage() {
    for (final message in Message.values) {
      if (this == message.value) {
        return message;
      }
    }
    return null;
  }
}
