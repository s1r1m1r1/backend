import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  ChatRoomBloc() : super(ChatRoomInitial()) {
    on<ChatRoomEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
