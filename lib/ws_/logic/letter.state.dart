part of 'letter.bloc.dart';

@freezed
sealed class LetterState with _$LetterState {
  const LetterState._();
  const factory LetterState.hasRoom(int roomId) = _HasRoomState;
  const factory LetterState.newLetter(int roomId, LetterDto letter) =
      _NewLetterState;
  const factory LetterState.deleted({
    required int roomId,
    required int letterId,
  }) = _DeletedLetterState;

  @override
  String toString() {
    switch (this) {
      case _HasRoomState():
        return 'LetterState: roomId: roomId';
      case _NewLetterState(:final roomId, :final letter):
        final body = ToClient.onLetter(
          LastLetterPayload(roomId, letter),
        ).toJson();
        final encoded = jsonEncode(body);
        return encoded;

      case _DeletedLetterState(:final roomId, :final letterId):
        final body = ToClient.deletedLetter(
          IdLetterPayload(roomId: roomId, letterId: letterId),
        ).toJson();
        final encoded = jsonEncode(body);
        return encoded;
    }
  }
}
