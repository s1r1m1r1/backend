part of 'letter.bloc.dart';

@freezed
abstract class LetterEvent with _$LetterEvent {
  const factory LetterEvent.setRoom(int roomId) = _SetRoomLE;
  const factory LetterEvent.newLetter(
    WebSocketChannel channel,
    GameSession session,
    CreateLetterDto dto,
  ) = _NewLetterLE;
  const factory LetterEvent.subscribe(
    WebSocketChannel channel,
    WebSocketDisposer disposer,
  ) = _SubscribeLE;
  const factory LetterEvent.removeLetter(
    WebSocketChannel channel,
    GameSession session,
    int letterId,
  ) = _RemoveLetterLE;
}
