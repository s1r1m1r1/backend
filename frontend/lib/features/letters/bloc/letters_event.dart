part of 'letters_bloc.dart';

abstract class LettersEvent extends Equatable {
  const LettersEvent();

  @override
  List<Object?> get props => [];
}

class LettersStarted extends LettersEvent {
  const LettersStarted();
}

class LettersNewPressed extends LettersEvent {
  const LettersNewPressed(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class LettersDeleteMessagePressed extends LettersEvent {
  final int messageId;
  const LettersDeleteMessagePressed(this.messageId);
  @override
  List<Object?> get props => [messageId];
}

class LettersCorrectLetterPressed extends LettersEvent {
  const LettersCorrectLetterPressed(this.message, this.messageId);
  final int messageId;
  final String message;
  @override
  List<Object?> get props => [messageId, message];
}

class _LetterOnNewLetters extends LettersEvent {
  const _LetterOnNewLetters(this.letters);

  final List<LetterDto> letters;

  @override
  List<Object?> get props => [letters.length];
}

class _LetterOnUpdateLetters extends LettersEvent {
  const _LetterOnUpdateLetters(this.letters);

  final List<LetterDto> letters;

  @override
  List<Object?> get props => [letters.length];
}

class _LettersOnDeleteMessage extends LettersEvent {
  const _LettersOnDeleteMessage(this.messageIds);

  final List<int> messageIds;

  @override
  List<Object?> get props => [messageIds];
}

class _LettersConnectionStateChanged extends LettersEvent {
  const _LettersConnectionStateChanged(this.state);

  final ConnectionState state;
}
