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

        switch (request.eventType) {
          case WsEventToServer.incrementCounter:
            context
                .read<CounterRepository>()
                .incrementCounter(request.payload)
                .then((counter) {
                  channel.sink.add(
                    jsonEncode(
                      WsFromServer(
                        eventType: WsEventFromServer.counter,
                        payload: CounterPayload(counter).toJson(),
                      ).toJson(),
                    ),
                  );
                })
                .catchError((err) {
                  print('Something went wrong: $err');
                });
          case WsEventToServer.decrementCounter:
            context
                .read<CounterRepository>()
                .decrementCounter(request.payload)
                .then((counter) {
                  final encoded = jsonEncode(
                    WsFromServer(
                      eventType: WsEventFromServer.counter,
                      payload: CounterPayload(counter).toJson(),
                    ).toJson(),
                  );
                  channel.sink.add(encoded);
                })
                .catchError((err) {
                  print('Something went wrong: $err');
                });
          case WsEventToServer.newMessage:
            context
                .read<LettersRepository>()
                .createLetter(request.payload)
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
          case WsEventToServer.getMessages:
            context
                .read<LettersRepository>()
                .fetchAllMessages()
                .then((messages) {
                  if (messages.isNotEmpty) {
                    final encoded = jsonEncode(
                      WsFromServer(
                        eventType: WsEventFromServer.messages,
                        payload: LettersPayload(messages).toJson(),
                      ).toJson(),
                    );
                    channel.sink.add(encoded);
                  }

                  // final json = jsonEncode(object)
                })
                .catchError((err) {});

          case WsEventToServer.deleteMessage:
            context
                .read<LettersRepository>()
                .createLetter(request.payload)
                .then((message) {
                  if (message != null) {
                    channel.sink.add(
                      jsonEncode(WsFromServer(eventType: WsEventFromServer.messageCreated, payload: message.toJson())),
                    );
                  }
                })
                .catchError((err) {
                  print('Something went wrong: $err');
                });
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
