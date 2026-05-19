import 'dart:async';

import 'package:dto/dto.dart';
import 'package:synchronized/synchronized.dart';

import '../../../core/api_exceptions.dart';
import '../../../core/broadcast.dart';
import '../../../core/debug_log.dart';
import '../../auth/application/session_socket.dart';
import '../domain/letters_repository.dart';

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
class _LettersBroad extends Broadcast<LetterResponse> {
  _LettersBroad(LettersRepository lettersRepository, BroadcastId roomId)
    : _lettersRepository = lettersRepository {
    broadcastId = roomId;
    _loadExistingLetters();
  }
  // Вынесено в единую константу класса
  static const _defaultTimeout = Duration(seconds: 5);

  final LettersRepository _lettersRepository;
  final _lock = Lock();
  final _letterCache = <LetterDto>[];
  int _nonceCount = 0;
  String get _nextN => "letter_${_nonceCount++}";
  @override
  late BroadcastId broadcastId;

  /// Load existing letters from the database into the cache.
  /// This ensures that when a bot (or user) joins, they receive
  /// the full history even if messages were inserted directly via DAO.
  Future<void> _loadExistingLetters() async {
    try {
      final existingLetters = await _lettersRepository.fetchMessages(
        broadcastId,
      );
      _letterCache.addAll(existingLetters);
      debugLog(
        'Loaded ${existingLetters.length} existing letters for room $broadcastId',
      );
    } catch (e, s) {
      debugLog('Error loading existing letters: $e $s');
    }
  }

  // --- Event Handlers ---

  void newLetter(GameSocket socket, String content, String n) {
    _lock.synchronized(() async {
      try {
        final trimmed = content.trim();
        if (trimmed.isEmpty || trimmed.length > 10000) {
          _sendLetterError(
            socket,
            n,
            WsLetterError.invalidContent,
            [],
            'Letter content must be between 1 and 10000 characters',
          );
          return;
        }
        final newLetter = await _lettersRepository.createLetter(
          trimmed,
          socket.userId,
          broadcastId,
        );
        if (newLetter == null) {
          debugLog('new letter: failed to create');
          _sendLetterError(
            socket,
            n,
            WsLetterError.internalError,
            [],
            'Failed to create letter',
          );
          return;
        }
        debugLog('new letter: for ');
        _letterCache.add(newLetter);
        final OnLetterResponse letter =
            WsResponse.onLetter(n: n, roomId: broadcastId, dto: newLetter)
                as OnLetterResponse;
        broadcast(letter as LetterResponse);
      } on ApiException catch (e, s) {
        addError(e, s);
        _sendLetterError(
          socket,
          n,
          WsLetterError.internalError,
          [],
          'Failed to create letter: $e',
        );
      } on Object catch (e, s) {
        addError(e, s);
        _sendLetterError(
          socket,
          n,
          WsLetterError.internalError,
          [],
          'Failed to create letter: $e',
        );
      }
    }, timeout: _defaultTimeout);
  }

  void editLetter(GameSocket socket, int letterId, String content, String n) {
    _lock.synchronized(() async {
      try {
        final trimmed = content.trim();
        if (trimmed.isEmpty || trimmed.length > 1000) {
          _sendLetterError(
            socket,
            n,
            WsLetterError.invalidContent,
            [letterId],
            'Letter content must be between 1 and 1000 characters',
          );
          return;
        }
        final indexLetter = _letterCache.indexWhere(
          (LetterDto i) => i.id == letterId,
        );
        if (indexLetter == -1) {
          debugLog('letter not found in cache');
          _sendLetterError(socket, n, WsLetterError.notFound, [
            letterId,
          ], 'Letter not found');
          return;
        }
        final letter = _letterCache[indexLetter];
        if (letter.senderId != socket.session.user.userId.id) {
          debugLog('letter access denied');
          _sendLetterError(socket, n, WsLetterError.accessDenied, [
            letterId,
          ], 'Access denied');
          return;
        }

        final updatedLetter = await _lettersRepository.updateLetter(
          letterId,
          trimmed,
        );
        if (updatedLetter == null) {
          _sendLetterError(socket, n, WsLetterError.internalError, [
            letterId,
          ], 'Failed to update letter');
          return;
        }

        _letterCache[indexLetter] = updatedLetter;
        broadcast(
          WsResponse.editedLetter(n: n, roomId: broadcastId, dto: updatedLetter)
              as LetterResponse,
        );
      } catch (e, s) {
        debugLog('$e $s');
        _sendLetterError(socket, n, WsLetterError.internalError, [
          letterId,
        ], 'Internal server error: $e');
      }
    }, timeout: _defaultTimeout);
  }

  void removeLetter(GameSocket socket, int letterId, String n) {
    _lock.synchronized(() async {
      try {
        debugLog('remove letter -start');
        final indexLetter = _letterCache.indexWhere(
          (LetterDto i) => i.id == letterId,
        );
        if (indexLetter == -1) {
          _sendLetterError(socket, n, WsLetterError.notFound, [
            letterId,
          ], 'Letter not found');
          return;
        }
        debugLog('remove letter 1');
        final letter = _letterCache[indexLetter];
        if (letter.senderId != socket.session.user.userId) {
          _sendLetterError(socket, n, WsLetterError.accessDenied, [
            letterId,
          ], 'Access denied');
          return;
        }
        debugLog('remove letter 2');
        final deletedId = await _lettersRepository.deleteLetter(letterId);
        if (deletedId == -1) {
          _sendLetterError(socket, n, WsLetterError.internalError, [
            letterId,
          ], 'Failed to delete letter');
          return;
        }
        debugLog('remove letter 3');
        final index = _letterCache.indexWhere((i) => i.id == deletedId);
        if (index == -1) {
          _sendLetterError(socket, n, WsLetterError.notFound, [
            letterId,
          ], 'Letter not found in cache');
          return;
        }
        debugLog('remove letter 4');
        _letterCache.removeAt(index);
        broadcast(
          DeletedLetterResponse(
            n: n,
            roomId: broadcastId,
            letterId: [deletedId],
          ),
        );
      } catch (e, s) {
        debugLog('$e $s');
        _sendLetterError(socket, n, WsLetterError.internalError, [
          letterId,
        ], 'Internal server error: $e');
      }
    }, timeout: _defaultTimeout);
  }

  void removeLetters(GameSocket socket, List<int> letterIds, String n) {
    _lock.synchronized(() async {
      try {
        debugLog('remove letters - start, count: ${letterIds.length}');

        // Validate all letters exist and belong to user
        final validLetterIds = <int>[];
        final notFoundIds = <int>[];
        final accessDeniedIds = <int>[];

        for (final letterId in letterIds) {
          final indexLetter = _letterCache.indexWhere(
            (LetterDto i) => i.id == letterId,
          );
          if (indexLetter == -1) {
            notFoundIds.add(letterId);
          } else if (_letterCache[indexLetter].senderId !=
              socket.session.user.userId) {
            accessDeniedIds.add(letterId);
          } else {
            validLetterIds.add(letterId);
          }
        }

        // Send errors for failed letters
        if (notFoundIds.isNotEmpty) {
          _sendLetterError(
            socket,
            n,
            WsLetterError.notFound,
            notFoundIds,
            'Letters not found',
          );
        }
        if (accessDeniedIds.isNotEmpty) {
          _sendLetterError(
            socket,
            n,
            WsLetterError.accessDenied,
            accessDeniedIds,
            'Access denied',
          );
        }

        if (validLetterIds.isEmpty) {
          debugLog('remove letters - no valid letters to delete');
          return;
        }

        // Delete valid letters
        final deletedIds = await _lettersRepository.deleteLetters(
          validLetterIds,
        );

        // Check for partial failures
        final partialFailures = validLetterIds
            .where((id) => !deletedIds.contains(id))
            .toList();
        if (partialFailures.isNotEmpty) {
          _sendLetterError(
            socket,
            n,
            WsLetterError.internalError,
            partialFailures,
            'Failed to delete some letters',
          );
        }

        if (deletedIds.isEmpty) {
          debugLog('remove letters - no letters were deleted');
          return;
        }

        // Remove from cache
        _letterCache.removeWhere((letter) => deletedIds.contains(letter.id));

        debugLog('remove letters - success, deleted: ${deletedIds.length}');
        broadcast(
          DeletedLetterResponse(
            n: n,
            roomId: broadcastId,
            letterId: deletedIds,
          ),
        );
      } catch (e, s) {
        debugLog('remove letters error: $e $s');
        _sendLetterError(
          socket,
          n,
          WsLetterError.internalError,
          letterIds,
          'Internal server error: $e',
        );
      }
    }, timeout: _defaultTimeout);
  }

  /// Send a letter error to the client.
  /// This is a "cold path" — errors should not arrive if everything works correctly.
  void _sendLetterError(
    GameSocket socket,
    String n,
    WsLetterError error,
    List<int> letterIds,
    String reason,
  ) {
    debugLog('letter error: $error - $reason');
    socket.sinkAdd(
      WsResponse.letterError(
        n: n,
        roomId: broadcastId,
        error: error,
        letterIds: letterIds,
        reason: reason,
      ).toPacket(),
    );
  }

  // --- Helper Methods ---

  WsResponse _lettersDTO(String n) {
    return WsResponse.letterHistory(
      n: n,
      roomId: broadcastId,
      letters: _letterCache,
    );
  }

  FutureOr<void> subscribeChannel(GameSocket socket, String n) async {
    await _lock.synchronized(() async {
      try {
        subscribe(socket);
        socket.shouldUnsubscribe[broadcastId] = () => unsubscribe(socket);
        // Reload cache from DB to catch any messages inserted directly
        // (e.g., via DAO) since the constructor's initial load
        final existingLetters = await _lettersRepository.fetchMessages(
          broadcastId,
        );
        _letterCache.clear();
        _letterCache.addAll(existingLetters);
        socket.sinkAdd(_lettersDTO(n).toPacket());
        socket.sinkAdd(
          WsResponse.broadcastInfo(
            n: _nextN,
            broadcasts: socket.joinedBroadsInfo().toList(),
          ).toPacket(),
        );
      } catch (e, s) {
        addError(e, s);
      }
    }, timeout: _defaultTimeout);
  }
}
