import 'dart:convert';

import 'package:backend/chat/counter_repository.dart';
import 'package:backend/chat/message_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:shared/shared.dart';

Future<Response> onRequest(RequestContext context) async {
  final initialLetters = await context.read<LettersRepository>().fetchAllMessages();
  final initialCounter = context.read<CounterRepository>().counter;
  final handler = webSocketHandler((channel, protocol) {
    channel.sink.add(
      jsonEncode(
        WsFromServer(
          eventType: WsEventFromServer.initial,
          payload: InitialPayload(initialCounter, initialLetters).toJson(),
        ).toJson(),
      ),
    );

    channel.stream.listen(
      (message) {
        if (message is! String) {
          channel.sink.add('Invalid message');
          return;
        }

        Map<String, dynamic> decoded = jsonDecode(message);
        final request = WsToServer.fromJson(decoded);
        final command = _commandHandlers[request.eventType];
        if (command != null) {
          command.execute(context, channel, request.payload);
        }

        switch (request.eventType) {
          case WsEventToServer.deleteMessage:
            context
                .read<LettersRepository>()
                .deleteLetter(request.payload)
                .then((message) {
                  // if (message != null) {
                  //   channel.sink.add(
                  //     jsonEncode(WsFromServer(eventType: WsEventFromServer.messageCreated, payload: message.toJson())),
                  //   );
                  // }
                })
                .catchError((err) {
                  print('Something went wrong: $err');
                });
            break;
          default:
            break;
        }
      },
      onDone: () {
        channel.sink.close();
      },
    );
  });
  return handler(context);
}

// This map is defined outside the stream listener, usually at the top of the file or in a separate file.
final _commandHandlers = <WsEventToServer, Command>{
  WsEventToServer.incrementCounter: IncrementCounterCommand(),
  WsEventToServer.decrementCounter: DecrementCounterCommand(),
  WsEventToServer.newMessage: NewMessageCommand(),
  // ... and so on
};

abstract class Command {
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload);
}

class IncrementCounterCommand implements Command {
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    context
        .read<CounterRepository>()
        .incrementCounter(payload)
        .then((counter) {
          channel.sink.add(
            jsonEncode(
              WsFromServer(eventType: WsEventFromServer.counter, payload: CounterPayload(counter).toJson()).toJson(),
            ),
          );
        })
        .catchError((err) {
          print('Something went wrong: $err');
        });
  }
}

class DecrementCounterCommand implements Command {
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    context
        .read<CounterRepository>()
        .incrementCounter(payload)
        .then((counter) {
          channel.sink.add(
            jsonEncode(
              WsFromServer(eventType: WsEventFromServer.counter, payload: CounterPayload(counter).toJson()).toJson(),
            ),
          );
        })
        .catchError((err) {
          print('Something went wrong: $err');
        });
  }
}

class NewMessageCommand implements Command {
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    context
        .read<LettersRepository>()
        .createLetter(payload)
        .then((message) {
          if (message != null) {
            final encoded = jsonEncode(
              WsFromServer(eventType: WsEventFromServer.messageCreated, payload: message.toJson()),
            );
            channel.sink.add(encoded);
          }
        })
        .catchError((err) {
          print('Something went wrong: $err');
        });
  }
}
