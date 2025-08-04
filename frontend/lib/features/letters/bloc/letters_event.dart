part of 'letters_bloc.dart';

@freezed
sealed class LettersEvent with _$LettersEvent {
  const factory LettersEvent.started() = LettersStarted;
  const factory LettersEvent.newPressed(String message) = LettersNewPressed;
  const factory LettersEvent.deleteMessagePressed(int messageId) = LettersDeleteMessagePressed;
  const factory LettersEvent.correctLetterPressed({required String message, required int messageId}) =
      LettersCorrectLetterPressed;
  const factory LettersEvent.onNewLetters(List<LetterDto> letters) = LetterOnNewLetters;
  const factory LettersEvent.onUpdateLetters(List<LetterDto> letters) = LetterOnUpdateLetters;
  const factory LettersEvent.onDeleteMessage(List<int> messageIds) = LettersOnDeleteMessage;
  const factory LettersEvent.connectionStateChanged(ConnectionState state) = LettersConnectionStateChanged;
}
