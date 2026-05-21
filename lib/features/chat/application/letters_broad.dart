import 'dart:async';

import 'package:dto/dto.dart';
import 'package:synchronized/synchronized.dart';

import '../../../core/api_exceptions.dart';
import '../../../core/broadcast.dart';
import '../../../core/debug_log.dart';
import '../../auth/application/session_socket.dart';
import '../domain/letters_repository.dart';

class LettersBroad extends _LettersBroad {
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

  // --- Spam protection ---
  /// Maximum number of letters kept in the per-room cache.
  static const _maxCacheSize = 500;

  /// Maximum messages a single user can send within the rate-limit window.
  static const _rateLimitMaxMessages = 10;

  /// Rate-limit window duration.
  static const _rateLimitWindow = Duration(seconds: 30);

  final LettersRepository _lettersRepository;
  final _lock = Lock();
  final _letterCache = <LetterDto>[];
  int _nonceCount = 0;
  Noun _nextNoun() => Noun('letter_${_nonceCount++}');

  /// Per-user rate limiter: userId → list of timestamps (ms since epoch).
  final _rateLimiter = <String, List<int>>{};
  @override
  late BroadcastId broadcastId;

  /// Trim the cache to [_maxCacheSize] by removing the oldest entries.
  void _trimCache() {
    if (_letterCache.length > _maxCacheSize) {
      _letterCache.removeRange(0, _letterCache.length - _maxCacheSize);
    }
  }

  /// Check whether [userId] has exceeded the rate limit.
  /// Returns `true` if the user is allowed to send, `false` if rate-limited.
  bool _checkRateLimit(String userId) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final windowStart = now - _rateLimitWindow.inMilliseconds;
    final timestamps = _rateLimiter.putIfAbsent(userId, () => <int>[]);
    // Remove timestamps outside the current window
    timestamps.removeWhere((ts) => ts < windowStart);
    if (timestamps.length >= _rateLimitMaxMessages) {
      return false;
    }
    timestamps.add(now);
    return true;
  }

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

  void newLetter(GameSocket socket, String content, Noun n) {
    _lock.synchronized(() async {
      try {
        // Rate limit check
        if (!_checkRateLimit(socket.userId)) {
          _sendLetterError(
            socket,
            n,
            .rateLimited,
            [],
            'Rate limit exceeded: max $_rateLimitMaxMessages messages per ${_rateLimitWindow.inSeconds}s',
          );
          return;
        }
        final trimmed = content.trim();
        if (trimmed.isEmpty || trimmed.length > 1000) {
          _sendLetterError(
            socket,
            n,
            .invalidContent,
            [],
            'Letter content must be between 1 and 1000 characters',
          );
          return;
        }
        final newLetter = await _lettersRepository.createLetter(
          trimmed,
          socket.userId,
          broadcastId,
        );

        debugLog('new letter: for ');
        _letterCache.add(newLetter);
        _trimCache();
        final OnLetterResponse letter =
            WsResponse.onLetter(n: n, roomId: broadcastId, dto: newLetter)
                as OnLetterResponse;
        broadcast(letter as LetterResponse);
      } on ApiException catch (e, s) {
        addError(e, s);
        _sendLetterError(
          socket,
          n,
          .internalError,
          [],
          'Failed to create letter: $e',
        );
      } on Object catch (e, s) {
        addError(e, s);
        _sendLetterError(
          socket,
          n,
          .internalError,
          [],
          'Failed to create letter: $e',
        );
      }
    }, timeout: _defaultTimeout);
  }

  void editLetter(GameSocket socket, int letterId, String content, Noun n) {
    _lock.synchronized(() async {
      try {
        // Rate limit check
        if (!_checkRateLimit(socket.userId)) {
          _sendLetterError(
            socket,
            n,
            .rateLimited,
            [letterId],
            'Rate limit exceeded: max $_rateLimitMaxMessages messages per ${_rateLimitWindow.inSeconds}s',
          );
          return;
        }
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
        if (letter.senderId != socket.session.user.userId) {
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

  void removeLetter(GameSocket socket, int letterId, Noun n) {
    _lock.synchronized(() async {
      try {
        // Rate limit check
        if (!_checkRateLimit(socket.userId)) {
          _sendLetterError(
            socket,
            n,
            .rateLimited,
            [letterId],
            'Rate limit exceeded: max $_rateLimitMaxMessages messages per ${_rateLimitWindow.inSeconds}s',
          );
          return;
        }
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

  void removeLetters(GameSocket socket, List<int> letterIds, Noun n) {
    _lock.synchronized(() async {
      try {
        // Rate limit check
        if (!_checkRateLimit(socket.userId)) {
          _sendLetterError(
            socket,
            n,
            .rateLimited,
            letterIds,
            'Rate limit exceeded: max $_rateLimitMaxMessages messages per ${_rateLimitWindow.inSeconds}s',
          );
          return;
        }
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
    Noun n,
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

  WsResponse _lettersDTO(Noun n) {
    return WsResponse.letterHistory(
      n: n,
      roomId: broadcastId,
      letters: _letterCache,
    );
  }

  FutureOr<void> subscribeChannel(GameSocket socket, Noun n) async {
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
            n: _nextNoun(),
            broadcasts: socket.joinedBroadsInfo().toList(),
          ).toPacket(),
        );
      } catch (e, s) {
        addError(e, s);
      }
    }, timeout: _defaultTimeout);
  }
}
