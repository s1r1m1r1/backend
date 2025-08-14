import 'dart:async';
import 'dart:convert';

import 'package:backend/core/debug_log.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sha_red/sha_red.dart';

class LetterCubit extends BroadcastCubit<LetterState> {
  final String roomId;

  LetterCubit(this.roomId) : super(InitialLetterState());

  final letterCache = <LetterDto>[];

  void addLetter(LetterDto letter) {
    letterCache.add(letter);
    emit(LastLetterState(letterCache.last, roomId));
  }

  String lettersJSON() {
    final body = WsFromServer(
      eventType: WsEventFromServer.letters,
      payload: LetterHistoryPayload(roomId, letterCache),
    ).toJson(LetterHistoryPayload.toJsonF);
    return jsonEncode(body);
  }

  @override
  Future<void> close() async {
    return super.close();
  }

  void removeLetter(int deletedId) {
    final index = letterCache.indexWhere((i) => i.id == deletedId);
    if (index == -1) return;
    debugLog('emit Deleted');
    final removed = letterCache.removeAt(index);
    emit(DeletedLetterState(roomId, removed.id ?? -1));
  }
}

//-------------------------------------------------------
//--------------- state ---------------------------------

abstract class LetterState extends Equatable {
  const LetterState();

  @override
  List<Object?> get props => [];
}

class InitialLetterState extends LetterState {
  const InitialLetterState();
  @override
  String toString() {
    return '';
  }
}

class LastLetterState extends LetterState {
  LastLetterState(this.letter, this.roomId);
  final String roomId;
  final LetterDto letter;

  /// jsonEncode  here
  @override
  String toString() {
    final body = WsFromServer(
      eventType: WsEventFromServer.onLetter,
      payload: LastLetterPayload(roomId, letter!),
    ).toJson(LastLetterPayload.toJsonF);
    final encoded = jsonEncode(body);
    return encoded;
  }

  @override
  List<Object?> get props => [letter];
}

class DeletedLetterState extends LetterState {
  DeletedLetterState(this.roomId, this.id);
  final String roomId;
  final int id;
  @override
  List<Object?> get props => [roomId, id];

  /// jsonEncode  here
  @override
  String toString() {
    final body = WsFromServer(
      eventType: WsEventFromServer.deletedLetter,
      payload: IdLetterPayload(roomId, id),
    ).toJson(IdLetterPayload.toJsonF);
    final encoded = jsonEncode(body);
    return encoded;
  }
}
