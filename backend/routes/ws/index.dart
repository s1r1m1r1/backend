import 'dart:convert';

import 'package:backend/chat/counter_repository.dart';
import 'package:backend/chat/message_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:shared/shared.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    channel.stream.listen((message) {
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
        case WsEventToServer.newMessage:
          context
              .read<LettersRepository>()
              .createMessage(request.payload)
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
        case WsEventToServer.deleteMessage:
          context
              .read<LettersRepository>()
              .createMessage(request.payload)
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
        // case 'message.create':
        //   messageRepository
        //       .createMessage(data)
        //       .then((message) {
        //         if (message != null)
        //           channel.sink.add(jsonEncode(WsEventDto(eventType: 'message.created', data: message.toJson())));
        //       })
        //       .catchError((err) {
        //         print('Something went wrong');
        //       });

        //   break;
        default:
      }
    });
  });
  return handler(context);
}
