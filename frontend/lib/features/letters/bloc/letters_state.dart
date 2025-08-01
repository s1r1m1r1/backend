part of 'letters_bloc.dart';

enum LettersStatus { connected, disconnected }

class LettersState extends Equatable {
  const LettersState({this.updater = false, this.letters = const [], this.status = LettersStatus.disconnected});

  final List<LetterDto> letters;
  final LettersStatus status;
  final bool updater;

  @override
  List<Object?> get props => [updater, status];

  LettersState copyWith({List<LetterDto>? letters, LettersStatus? status}) {
    return LettersState(updater: !updater, letters: letters ?? this.letters, status: status ?? this.status);
  }
}
