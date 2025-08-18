import 'dart:async';
import 'dart:convert';

import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/ws_/letters_repository.dart';
import 'package:backend/ws_/model/web_socket_disposer.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:equatable/equatable.dart';
import 'package:sha_red/sha_red.dart';
export 'package:bloc/bloc.dart';

// import 'package:broadcast_bloc/broadcast_bloc.dart';

part 'letter.event.dart';
part 'letter.state.dart';
part 'letter.guard.dart';

class LetterBloc extends _LetterBloc with LetterBlocGuard {
  LetterBloc(super.roomId, super.lettersRepository);
}

// letter_bloc.dart
class _LetterBloc extends BroadcastBloc<LetterEvent, LetterState> {
  final String roomId;
  final LettersRepository _lettersRepository;
  final _letterCache = <LetterDto>[];

  _LetterBloc(this.roomId, LettersRepository lettersRepository)
    : _lettersRepository = lettersRepository,
      super(const LetterState.initial()) {
    on<_SubscribeLE>(_onSubscribe);
    on<_RemoveLetterLE>(_onRemoveLetter);
    on<_NewLetterLE>(_onNewLetter);
  }

  // --- Event Handlers ---

  Future<void> _onNewLetter(
    _NewLetterLE event,
    Emitter<LetterState> emit,
  ) async {
    try {
      final newLetter = await _lettersRepository.createLetter(event.dto);
      if (newLetter != null) {
        _letterCache.add(newLetter);
        emit(LetterState.newLetter(roomId, newLetter));
      }
    } on ApiException catch (e, s) {
    } on Object catch (e, s) {
      addError(e, s);
      /*
      final errMessage = Todo
      event.channel.sink(errMessage);
      ? */
    }
  }

  Future<void> _onRemoveLetter(
    _RemoveLetterLE event,
    Emitter<LetterState> emit,
  ) async {
    try {
      final deletedId = await _lettersRepository.deleteLetter(event.letterId);
      if (deletedId == -1) return;
      final index = _letterCache.indexWhere((i) => i.id == deletedId);
      if (index == -1) return;
      _letterCache.removeAt(index);
      emit(LetterState.deleted(roomId, event.letterId));
    } catch (e, s) {
      // event.channel.sink
    }
  }

  // --- Helper Methods ---

  String _lettersJSON() {
    final body = ToClient.letters(
      LetterHistoryPayload(roomId, _letterCache),
    ).toJson();
    return jsonEncode(body);
  }

  FutureOr<void> _onSubscribe(
    _SubscribeLE event,
    Emitter<LetterState> emit,
  ) async {
    try {
      final channel = event.channel;
      channel.sink.add(_lettersJSON());
      subscribe(channel);
      event.disposer.shouldUnsubscribe.add(unsubscribe);
    } catch (e, s) {
      addError(e, s);
    }
  }
}
