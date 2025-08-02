import 'dart:convert';

import 'package:backend/chat/counter_repository.dart';
import 'package:backend/chat/letters_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:shared/shared.dart';

Future<Response> onRequest(RequestContext context) async {
  final initialLetters = await context.read<LettersRepository>().fetchAllLetters();
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
          case WsEventToServer.deleteLetter:
            context
                .read<LettersRepository>()
                .deleteLetter(request.payload)
                .then((letter) {
                  // if (letter != null) {
                  //   channel.sink.add(
                  //     jsonEncode(WsFromServer(eventType: WsEventFromServer.letterCreated, payload: letter.toJson())),
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
  WsEventToServer.newLetter: NewLetterCommand(),
  WsEventToServer.joinRoom: JoinRoomCommand(),
  WsEventToServer.leaveRoom: LeaveRoomCommand(),
  WsEventToServer.listRooms: ListRoomsCommand(),
  WsEventToServer.sendLetterToRoom: SendLetterToRoomCommand(),
  WsEventToServer.fetchRoomHistory: FetchRoomHistoryCommand(),
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

class NewLetterCommand implements Command {
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    context
        .read<LettersRepository>()
        .createLetter(payload)
        .then((letter) {
          if (letter != null) {
            final encoded = jsonEncode(
              WsFromServer(eventType: WsEventFromServer.letterCreated, payload: letter.toJson()),
            );
            channel.sink.add(encoded);
          }
        })
        .catchError((err) {
          print('Something went wrong: $err');
        });
  }
}

class JoinRoomCommand implements Command {
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    // Implement join room logic using chat_room table
    // Example: context.read<ChatRoomRepository>().joinRoom(payload['roomId'], userId)
    // Send confirmation or error back to client
  }
}

class LeaveRoomCommand implements Command {
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    // Implement leave room logic using chat_room table
    // Example: context.read<ChatRoomRepository>().leaveRoom(payload['roomId'], userId)
    // Send confirmation or error back to client
  }
}

class ListRoomsCommand implements Command {
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    // Implement list rooms logic using chat_room table
    // Example: context.read<ChatRoomRepository>().listRooms(userId)
    // Send list of rooms back to client
  }
}

class SendLetterToRoomCommand implements Command {
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    // Implement send letter to room logic using letters and chat_room tables
    // Example: context.read<LettersRepository>().sendLetterToRoom(payload)
    // Send confirmation or error back to client
  }
}

class FetchRoomHistoryCommand implements Command {
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    // Implement fetch room history logic using letters and chat_room tables
    // Example: context.read<LettersRepository>().fetchRoomHistory(payload['roomId'])
    // Send history back to client
  }
}
