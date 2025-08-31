import 'dart:async';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/core/session_channel.dart';
import 'package:backend/core/broadcast.dart';
import 'package:backend/modules/game/domain/letters_repository.dart';
import 'package:sha_red/sha_red.dart';
import 'package:synchronized/synchronized.dart';

mixin LettersBroadGuard on _LettersBroad {
  bool hasAccess(Role role) {
    // return Role.user == role || Role.admin == role;
    return true;
  }
}

class LettersBroad extends _LettersBroad with LettersBroadGuard {
  LettersBroad(super.lettersRepository, super.roomId);
}

// letter_bloc.dart
class _LettersBroad extends Broadcast<LetterTC> {
  final LettersRepository _lettersRepository;
  final _lock = Lock();
  final _letterCache = <LetterDto>[];
  @override
  late BroadcastId blocId;

  _LettersBroad(LettersRepository lettersRepository, int roomId)
    : _lettersRepository = lettersRepository {
    blocId = BroadcastId(family: BroadcastFamily.letters, id: roomId);
  }

  @override
  FutureOr<void> dispose() {
    super.dispose();
  }

  // --- Event Handlers ---

  void newLetter(SessionChannel channel, CreateLetterDto dto) {
    _lock.synchronized(() async {
      try {
        final newLetter = await _lettersRepository.createLetter(dto);
        if (newLetter != null) {
          debugLog('new letter: for ');
          _letterCache.add(newLetter);
          final LetterTC letter =
              ToClient.onLetter(LastLetterPayload(blocId.id, newLetter))
                  as LetterTC;
          broadcast(letter);
          // emit(LetterState.newLetter(state.blocId, newLetter));
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
    });
  }

  void removeLetter(SessionChannel channel, int letterId) {
    _lock.synchronized(() async {
      try {
        final indexLetter = _letterCache.indexWhere((i) => i.id == letterId);
        if (indexLetter == -1) return;
        final letter = _letterCache[indexLetter];
        if (letter.senderId != channel.session.unit.id) return;
        final deletedId = await _lettersRepository.deleteLetter(letterId);
        if (deletedId == -1) return;
        final index = _letterCache.indexWhere((i) => i.id == deletedId);
        if (index == -1) return;
        _letterCache.removeAt(index);
        broadcast(
          ToClient.deletedLetter(
                IdLetterPayload(roomId: blocId.id, letterId: deletedId),
              )
              as LetterTC,
        );
      } catch (e, s) {
        debugLog('$e $s');
        channel.sinkAdd(
          ToClient.statusError(error: WsServerError.letterNotRemoved).encoded(),
        );
      }
    });
  }

  // --- Helper Methods ---

  ToClient _lettersDTO() {
    return ToClient.letterHistory(
      LetterHistoryPayload(blocId.id, _letterCache),
    );
  }

  FutureOr<void> subscribeChannel(SessionChannel channel) async {
    _lock.synchronized(() async {
      try {
        subscribe(channel);
        channel.shouldUnsubscribe[blocId] = () => unsubscribe(channel);
        channel.sinkAdd(_lettersDTO().encoded());
        channel.sinkAdd(
          ToClient.broadcastInfo(channel.getJoinedBroads().toList()).encoded(),
        );
      } catch (e, s) {
        addError(e, s);
      }
    });
  }
}
