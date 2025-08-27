part of 'letter.bloc.dart';

@freezed
sealed class LetterState with _$LetterState implements BroadcastState {
  const LetterState._();
  const factory LetterState.hasRoom(int roomId) = _HasRoomState;
  const factory LetterState.newLetter(int roomId, LetterDto letter) =
      _NewLetterState;
  const factory LetterState.deleted({
    required int roomId,
    required int letterId,
  }) = _DeletedLetterState;

  @override
  ToClient? toClient() {
    switch (this) {
      case _HasRoomState():
        return null;
      case _NewLetterState(:final roomId, :final letter):
        return ToClient.onLetter(LastLetterPayload(roomId, letter));

      case _DeletedLetterState(:final roomId, :final letterId):
        return ToClient.deletedLetter(
          IdLetterPayload(roomId: roomId, letterId: letterId),
        );
    }
  }
}
