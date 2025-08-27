import 'dart:async';

import 'package:backend/core/broadcast_bloc.dart';
import 'package:backend/core/debug_log.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/core/session_channel.dart';
import 'package:backend/user/session.dart';
import 'package:backend/ws_/letters_repository.dart';
import 'package:backend/ws_/model/web_socket_disposer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sha_red/sha_red.dart';
export 'package:bloc/bloc.dart';

// import 'package:broadcast_bloc/broadcast_bloc.dart';

part 'letter.event.dart';
part 'letter.state.dart';
part 'letter.guard.dart';
part 'letter.bloc.freezed.dart';

class LetterBloc extends _LetterBloc with LetterBlocGuard {
  LetterBloc(super.lettersRepository);
}

// letter_bloc.dart
class _LetterBloc extends BroadcastBloc<LetterEvent, LetterState> {
  final LettersRepository _lettersRepository;
  final _letterCache = <LetterDto>[];

  _LetterBloc(LettersRepository lettersRepository)
    : _lettersRepository = lettersRepository,
      super(const LetterState.hasRoom(-1)) {
    on<_SetRoomLE>(_onSetRoom);
    on<_SubscribeLE>(_onSubscribe);
    on<_RemoveLetterLE>(_onRemoveLetter);
    on<_NewLetterLE>(_onNewLetter);
  }
  void _onSetRoom(_SetRoomLE event, Emitter<LetterState> emit) {
    emit(LetterState.hasRoom(event.roomId));
  }
  // --- Event Handlers ---

  Future<void> _onNewLetter(
    _NewLetterLE event,
    Emitter<LetterState> emit,
  ) async {
    try {
      final newLetter = await _lettersRepository.createLetter(event.dto);
      if (newLetter != null) {
        debugLog('new letter: for ');
        _letterCache.add(newLetter);
        emit(LetterState.newLetter(state.roomId, newLetter));
      }
    } on ApiException catch (e, s) {
      addError(e, s);
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
      final indexLetter = _letterCache.indexWhere(
        (i) => i.id == event.letterId,
      );
      if (indexLetter == -1) return;
      final letter = _letterCache[indexLetter];
      if (letter.senderId != event.channel.session.unit.id) return;
      final deletedId = await _lettersRepository.deleteLetter(event.letterId);
      if (deletedId == -1) return;
      final index = _letterCache.indexWhere((i) => i.id == deletedId);
      if (index == -1) return;
      _letterCache.removeAt(index);
      emit(LetterState.deleted(roomId: state.roomId, letterId: event.letterId));
    } catch (e, s) {
      debugLog('$e $s');
      event.channel.sinkAdd(
        ToClient.statusError(error: WsServerError.letterNotRemoved),
      );
    }
  }

  // --- Helper Methods ---

  ToClient _lettersDTO() {
    return ToClient.letterHistory(
      LetterHistoryPayload(state.roomId, _letterCache),
    );
  }

  FutureOr<void> _onSubscribe(
    _SubscribeLE event,
    Emitter<LetterState> emit,
  ) async {
    try {
      final channel = event.channel;
      channel.sinkAdd(_lettersDTO());
      subscribe(channel);
      event.channel.shouldUnsubscribe.add(() => unsubscribe(channel));
    } catch (e, s) {
      addError(e, s);
    }
  }
}
