import 'package:backend/ws_/broadcast.dart';
import 'package:backend/ws_/command/_ws_cmd.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

class LeaveRoomCommand implements WsCommand {
  const LeaveRoomCommand();
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    // Implement leave room logic using chat_room table
    // Example: context.read<ChatRoomRepository>().leaveRoom(payload['roomId'], userId)
    // Send confirmation or error back to client
  }
}

class ListRoomsCommand implements WsCommand {
  const ListRoomsCommand();
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    // Implement list rooms logic using chat_room table
    // Example: context.read<ChatRoomRepository>().listRooms(userId)
    // Send list of rooms back to client
  }
}

class SendLetterToRoomCommand implements WsCommand {
  const SendLetterToRoomCommand();
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    // Implement send letter to room logic using letters and chat_room tables
    // Example: context.read<LettersRepository>().sendLetterToRoom(payload)
    // Send confirmation or error back to client
  }
}

class FetchRoomHistoryCommand implements WsCommand {
  const FetchRoomHistoryCommand();
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    final broadcast = context.read<Broadcast>();

    // Implement fetch room history logic using letters and chat_room tables
    // Example: context.read<LettersRepository>().fetchRoomHistory(payload['roomId'])
    // Send history back to client
  }
}

// TODO Implement this library.
