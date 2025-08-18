part of 'letter.bloc.dart';

sealed class LetterEvent extends Equatable {
  const LetterEvent();

  const factory LetterEvent.newLetter(
    WebSocketChannel channel,
    CreateLetterDto dto,
  ) = _NewLetterLE;
  const factory LetterEvent.subscribe(
    WebSocketChannel channel,
    WebSocketDisposer disposer,
  ) = _SubscribeLE;
  const factory LetterEvent.removeLetter(
    WebSocketChannel channel,
    int letterId,
  ) = _RemoveLetterLE;
}

class _NewLetterLE extends LetterEvent {
  const _NewLetterLE(this.channel, this.dto);

  final WebSocketChannel channel;
  final CreateLetterDto dto;

  @override
  List<Object?> get props => [channel];
}

class _RemoveLetterLE extends LetterEvent {
  const _RemoveLetterLE(this.channel, this.letterId);
  final WebSocketChannel channel;
  final int letterId;

  @override
  List<Object?> get props => [letterId];
}

class _SubscribeLE extends LetterEvent {
  const _SubscribeLE(this.channel, this.disposer);

  final WebSocketChannel channel;
  final WebSocketDisposer disposer;

  @override
  List<Object?> get props => [channel];
}
