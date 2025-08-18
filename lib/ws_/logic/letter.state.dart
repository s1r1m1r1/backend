part of 'letter.bloc.dart';

abstract class LetterState extends Equatable {
  const LetterState();
  @override
  List<Object?> get props => [];

  const factory LetterState.initial() = _InitialLetterState;
  const factory LetterState.newLetter(String roomId, LetterDto letter) =
      _NewLetterState;
  const factory LetterState.deleted(String roomId, int letterId) =
      _DeletedLetterState;
}

class _InitialLetterState extends LetterState {
  const _InitialLetterState();
  @override
  String toString() {
    return '';
  }
}

class _NewLetterState extends LetterState {
  const _NewLetterState(this.roomId, this.letter);
  final String roomId;
  final LetterDto letter;

  /// jsonEncode  here
  @override
  String toString() {
    final body = ToClient.onLetter(LastLetterPayload(roomId, letter)).toJson();
    final encoded = jsonEncode(body);
    return encoded;
  }

  @override
  List<Object?> get props => [letter];
}

class _DeletedLetterState extends LetterState {
  const _DeletedLetterState(this.roomId, this.letterId);
  final String roomId;
  final int letterId;
  @override
  List<Object?> get props => [roomId, letterId];

  /// jsonEncode  here
  @override
  String toString() {
    final body = ToClient.deletedLetter(
      IdLetterPayload(roomId: roomId, letterId: letterId),
    ).toJson();
    final encoded = jsonEncode(body);
    return encoded;
  }
}
