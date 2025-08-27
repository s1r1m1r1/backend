part of 'letter.bloc.dart';

@freezed
abstract class LetterEvent with _$LetterEvent {
  const factory LetterEvent.setRoom(int roomId) = _SetRoomLE;
  const factory LetterEvent.newLetter(
    SessionChannel channel,
    CreateLetterDto dto,
  ) = _NewLetterLE;
  const factory LetterEvent.subscribe(SessionChannel channel) = _SubscribeLE;
  const factory LetterEvent.removeLetter(SessionChannel channel, int letterId) =
      _RemoveLetterLE;
}
