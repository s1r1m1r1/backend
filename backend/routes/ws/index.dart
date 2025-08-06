import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:backend/chat/broadcast.dart';
import 'package:backend/chat/counter_repository.dart';
import 'package:backend/chat/letters_repository.dart';
import 'package:backend/core/log_colors.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import 'package:sha_red/sha_red.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    final broadcast = context.read<Broadcast>();
    stdout.writeln('$green onEvent $reset');
    channel.stream.listen(
      (message) {
        if (message is! String) {
          stdout.writeln('$green onEvent not string $reset');
          channel.sink.add('Invalid message');
          return;
        }

        Map<String, dynamic> decoded = jsonDecode(message);
        stdout.writeln('$green onEvent $decoded $reset');
        final request = WsToServer.fromJson(decoded);
        final command = _commandHandlers[request.eventType];
        if (command != null) {
          stdout.writeln('$red command has  $reset');
          command.execute(context, request.roomId, channel, request.payload);
        } else {
          stdout.writeln('$red command not found $reset');
        }
      },
      onDone: () {
        broadcast.unsubscribeAll(channel);
        channel.sink.close();
      },
    );
  });
  return handler(context);
}
//------------------------------------------------------------------------------------------

// This map is defined outside the stream listener, usually at the top of the file or in a separate file.
final _commandHandlers = <WsEventToServer, WsCommand>{
  WsEventToServer.joinAdmin: JoinAdminCommand(),
  WsEventToServer.incrementCounter: IncrementCounterCommand(),
  WsEventToServer.decrementCounter: DecrementCounterCommand(),
  WsEventToServer.newLetter: NewLetterCommand(),
  WsEventToServer.deleteLetter: DeleteLetterCommand(),
  WsEventToServer.joinLetters: JoinLettersCommand(),
  WsEventToServer.joinCounter: JoinCounterCommand(),
  WsEventToServer.leaveRoom: LeaveRoomCommand(),
  WsEventToServer.listRooms: ListRoomsCommand(),
  WsEventToServer.sendLetterToRoom: SendLetterToRoomCommand(),
  WsEventToServer.fetchRoomHistory: FetchRoomHistoryCommand(),
  // ... and so on
};

abstract class WsCommand {
  FutureOr<void> execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload);
}

class IncrementCounterCommand implements WsCommand {
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    final counter = context.read<CounterRepository>().counter(roomId);
    if (counter == null) return;
    final count = counter.increment();

    channel.sink.add(
      jsonEncode(
        WsFromServer(
          roomId: 'counter',
          eventType: WsEventFromServer.counter,
          payload: CounterPayload(count).toJson(),
        ).toJson(),
      ),
    );
  }
}

class DecrementCounterCommand implements WsCommand {
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    final counter = context.read<CounterRepository>().counter(roomId);
    if (counter == null) return;
    final count = counter.decrement();

    channel.sink.add(
      jsonEncode(
        WsFromServer(
          roomId: 'counter',
          eventType: WsEventFromServer.counter,
          payload: CounterPayload(count).toJson(),
        ).toJson(),
      ),
    );
  }
}

class NewLetterCommand implements WsCommand {
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    context
        .read<LettersRepository>()
        .createLetter(payload)
        .then((letter) {
          if (letter != null) {
            final encoded = jsonEncode(
              WsFromServer(roomId: 'letters', eventType: WsEventFromServer.letterCreated, payload: letter.toJson()),
            );
            channel.sink.add(encoded);
          }
        })
        .catchError((err) {
          print('Something went wrong: $err');
        });
  }
}

class DeleteLetterCommand implements WsCommand {
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    context
        .read<LettersRepository>()
        .deleteLetter(payload)
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
  }
}

class JoinLettersCommand implements WsCommand {
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) async {
    final broadcast = context.read<Broadcast>();
    stdout.writeln("$green Join 1 $reset");
    if (payload != String) return;
    stdout.writeln("$green Join 2 $reset");
    final topicId = payload;

    stdout.writeln("$green Join topicId $reset");
    broadcast.subscribe(topicId, channel);
    final letters = await context.read<LettersRepository>().fetchAllLetters();
    channel.sink.add(
      jsonEncode(
        WsFromServer(
          roomId: topicId,
          eventType: WsEventFromServer.joinedLetters,
          payload: LettersPayload(letters).toJson(),
        ).toJson(),
      ),
    );
  }
}

class JoinCounterCommand implements WsCommand {
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) async {
    stdout.writeln('$green JoinCounterCommand:start ${roomId} } $reset');
    final broadcast = context.read<Broadcast>();
    // final user = context.read<User>();
    final counter = context.read<CounterRepository>().counter(roomId);
    // todo send error

    stdout.writeln('$green JoinCounterCommand: $counter  $reset');
    if (counter == null) return;
    stdout.writeln('$green JoinCounterCommand:hasCounter } $reset');
    broadcast.subscribe(roomId, channel);
    broadcast.broadcast(
      'admin',
      jsonEncode(
        WsFromServer(
          roomId: 'admin',
          eventType: WsEventFromServer.adminInfo,
          payload: IdPayload(broadcast.count).toJson(),
        ).toJson(),
      ),
    );
    channel.sink.add(
      jsonEncode(
        WsFromServer(
          roomId: roomId,
          eventType: WsEventFromServer.joinedCounter,
          payload: CounterPayload(counter.value).toJson(),
        ).toJson(),
      ),
    );
  }
}

class JoinAdminCommand implements WsCommand {
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) async {
    stdout.writeln('$magenta JoinAdminCommand:start ${roomId} } $reset');
    final broadcast = context.read<Broadcast>();
    // final user = context.read<User>();
    // todo send error

    stdout.writeln('$green JoinAdminCommand:hasCounter } $reset');
    broadcast.subscribe(roomId, channel);
    broadcast.broadcast(
      'admin',
      jsonEncode(
        WsFromServer(
          roomId: 'admin',
          eventType: WsEventFromServer.adminInfo,
          payload: IdPayload(broadcast.count).toJson(),
        ).toJson(),
      ),
    );
  }
}

class LeaveRoomCommand implements WsCommand {
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    // Implement leave room logic using chat_room table
    // Example: context.read<ChatRoomRepository>().leaveRoom(payload['roomId'], userId)
    // Send confirmation or error back to client
  }
}

class ListRoomsCommand implements WsCommand {
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    // Implement list rooms logic using chat_room table
    // Example: context.read<ChatRoomRepository>().listRooms(userId)
    // Send list of rooms back to client
  }
}

class SendLetterToRoomCommand implements WsCommand {
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    // Implement send letter to room logic using letters and chat_room tables
    // Example: context.read<LettersRepository>().sendLetterToRoom(payload)
    // Send confirmation or error back to client
  }
}

class FetchRoomHistoryCommand implements WsCommand {
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    final broadcast = context.read<Broadcast>();

    // Implement fetch room history logic using letters and chat_room tables
    // Example: context.read<LettersRepository>().fetchRoomHistory(payload['roomId'])
    // Send history back to client
  }
}
