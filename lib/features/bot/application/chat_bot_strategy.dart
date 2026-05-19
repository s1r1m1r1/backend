import 'dart:async';
import 'dart:math';

import 'package:dto/dto.dart';

import '../../../core/debug_log.dart';
import '../../../core/utils/noun_gen.dart';
import 'bot_strategy.dart';

/// Base class for chat bot strategies with common functionality.
abstract class ChatBotStrategy extends BotStrategy {
  ChatBotStrategy();

  bool _joined = false;
  final List<LetterDto> _receivedLetters = [];
  final Random _random = Random();

  @override
  FutureOr<void> onInit(ScenarioBot bot) {
    debugLog('[ChatBot ${bot.userId}] Initializing chat bot strategy');
    _joinChat(bot);
  }

  void _joinChat(ScenarioBot bot) {
    if (!_joined) {
      bot.send(WsRequest.joinLetters(n: NouN.next().v));
      _joined = true;
    }
  }

  @override
  void onMessage(ScenarioBot bot, WsResponse message) {
    if (message is RequiredAckTc) {
      bot.send(
        WsRequest.ack(n: message.n, ts: DateTime.now().millisecondsSinceEpoch),
      );
    }

    switch (message) {
      case LetterHistoryTc(:final letters):
        _receivedLetters.clear();
        _receivedLetters.addAll(letters);
        debugLog(
          '[ChatBot ${bot.userId}] Received ${letters.length} letters in history',
        );
        onHistoryLoaded(bot, letters);

      case OnLetterTc(:final dto):
        _receivedLetters.add(dto);
        debugLog('[ChatBot ${bot.userId}] New letter received: ${dto.id}');
        onNewLetter(bot, dto);

      case EditedLetterTc(:final dto):
        final index = _receivedLetters.indexWhere((l) => l.id == dto.id);
        if (index != -1) {
          _receivedLetters[index] = dto;
        }
        debugLog('[ChatBot ${bot.userId}] Letter edited: ${dto.id}');
        onLetterEdited(bot, dto);

      case DeletedLetterTc(:final letterId):
        _receivedLetters.removeWhere((l) => letterId.contains(l.id));
        debugLog('[ChatBot ${bot.userId}] Letters deleted: $letterId');
        onLettersDeleted(bot, letterId);

      case LetterErrorTc(:final error, :final letterIds, :final reason):
        debugLog(
          '[ChatBot ${bot.userId}] Letter error: $error, '
          'letterIds: $letterIds, reason: $reason',
        );
        if (error == WsLetterError.alreadyDeleted) {
          // Letter already gone on server — remove locally too
          _receivedLetters.removeWhere((l) => letterIds.contains(l.id));
        }
        onDeleteFailed(bot, letterIds, reason ?? error.name);

      case AckTc(:final status, :final message, :final payload):
        // Handle error responses (e.g., editLetterFail sent as ack with status >= 400)
        if (status >= 400 && message == 'editLetterFail') {
          final letterId = payload?['letterId'] as int?;
          final reason = payload?['reason'] as String? ?? 'Unknown error';
          debugLog(
            '[ChatBot ${bot.userId}] Edit failed for letter $letterId: $reason',
          );
          if (letterId != null) {
            onEditFailed(bot, letterId, reason);
          }
        }

      case BroadcastInfoTc(:final broadcasts):
        debugLog(
          '[ChatBot ${bot.userId}] Broadcast info: ${broadcasts.length} broadcasts',
        );
        onBroadcastInfo(bot, broadcasts);

      default:
        break;
    }
  }

  /// Called when chat history is loaded.
  void onHistoryLoaded(ScenarioBot bot, List<LetterDto> letters) {}

  /// Called when a new letter is received.
  void onNewLetter(ScenarioBot bot, LetterDto letter) {}

  /// Called when a letter is edited.
  void onLetterEdited(ScenarioBot bot, LetterDto letter) {}

  /// Called when letters are deleted.
  void onLettersDeleted(ScenarioBot bot, List<int> letterIds) {}

  /// Called when a delete operation fails.
  void onDeleteFailed(ScenarioBot bot, List<int> letterIds, String reason) {}

  /// Called when an edit operation fails.
  void onEditFailed(ScenarioBot bot, int letterId, String reason) {}

  /// Called when broadcast info is received.
  void onBroadcastInfo(ScenarioBot bot, List<BroadcastMemberDto> broadcasts) {}

  /// Send a new letter.
  void sendLetter(ScenarioBot bot, String content) {
    bot.send(WsRequest.newLetter(n: NouN.next().v, content: content));
  }

  /// Edit a letter.
  void editLetter(ScenarioBot bot, int letterId, String content) {
    bot.send(
      WsRequest.editLetter(
        n: NouN.next().v,
        letterId: letterId,
        content: content,
      ),
    );
  }

  /// Delete a letter.
  void deleteLetter(ScenarioBot bot, int letterId) {
    bot.send(WsRequest.deleteLetter(n: NouN.next().v, letterId: [letterId]));
  }

  /// Delete multiple letters.
  void deleteLetters(ScenarioBot bot, List<int> letterIds) {
    bot.send(WsRequest.deleteLetter(n: NouN.next().v, letterId: letterIds));
  }

  @override
  void onDispose(ScenarioBot bot) {
    debugLog('[ChatBot ${bot.userId}] Disposing chat bot strategy');
    _joined = false;
    _receivedLetters.clear();
  }
}

/// Simple chat bot that sends a specified number of messages.
class SimpleMessageBotStrategy extends ChatBotStrategy {
  SimpleMessageBotStrategy({required this.messages});

  final List<String> messages;
  int _sentCount = 0;
  final Completer<void> _done = Completer<void>();

  Completer<void> get done => _done;

  @override
  void onHistoryLoaded(ScenarioBot bot, List<LetterDto> letters) {
    _sendNextMessage(bot);
  }

  void _sendNextMessage(ScenarioBot bot) {
    if (_sentCount < messages.length) {
      Future.delayed(Duration(milliseconds: 100 + Random().nextInt(200)), () {
        sendLetter(bot, messages[_sentCount]);
        _sentCount++;
        _sendNextMessage(bot);
      });
    } else if (!_done.isCompleted) {
      _done.complete();
    }
  }

  @override
  void onNewLetter(ScenarioBot bot, LetterDto letter) {
    // Track sent messages
  }
}

/// Bot that tests deleting its own messages.
class DeleteOwnMessageStrategy extends ChatBotStrategy {
  DeleteOwnMessageStrategy({required this.message});

  final String message;
  int? _letterId;
  final Completer<void> _done = Completer<void>();

  Completer<void> get done => _done;

  @override
  void onHistoryLoaded(ScenarioBot bot, List<LetterDto> letters) {
    Future.delayed(const Duration(milliseconds: 100), () {
      sendLetter(bot, message);
    });
  }

  @override
  void onNewLetter(ScenarioBot bot, LetterDto letter) {
    if (letter.content == message && _letterId == null) {
      _letterId = letter.id;
      debugLog(
        '[DeleteOwnMessageBot ${bot.userId}] Created letter: $letter.id',
      );
      // Try to delete our own letter
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_letterId != null) {
          deleteLetter(bot, _letterId!);
        }
      });
    }
  }

  @override
  void onLettersDeleted(ScenarioBot bot, List<int> letterIds) {
    if (_letterId != null && letterIds.contains(_letterId)) {
      debugLog(
        '[DeleteOwnMessageBot ${bot.userId}] Successfully deleted own letter',
      );
      if (!_done.isCompleted) {
        _done.complete();
      }
    }
  }
}

/// Bot that tries to delete another user's message (should fail).
class DeleteOtherMessageStrategy extends ChatBotStrategy {
  DeleteOtherMessageStrategy({required this.targetLetterId});

  final int targetLetterId;
  bool _attempted = false;
  final Completer<void> _done = Completer<void>();

  Completer<void> get done => _done;

  @override
  void onHistoryLoaded(ScenarioBot bot, List<LetterDto> letters) {
    // Try to delete the target letter (should fail if not ours)
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!_attempted) {
        _attempted = true;
        deleteLetter(bot, targetLetterId);
      }
    });
  }

  @override
  void onDeleteFailed(ScenarioBot bot, List<int> letterIds, String reason) {
    debugLog(
      '[DeleteOtherMessageBot ${bot.userId}] Delete failed as expected: $reason',
    );
    if (!_done.isCompleted) {
      _done.complete();
    }
  }

  @override
  void onLettersDeleted(ScenarioBot bot, List<int> letterIds) {
    // This would be unexpected - we tried to delete someone else's message
    debugLog(
      '[DeleteOtherMessageBot ${bot.userId}] WARNING: Delete succeeded unexpectedly!',
    );
    if (!_done.isCompleted) {
      _done.complete();
    }
  }
}

/// Bot that spams many messages in quick succession.
class SpamBotStrategy extends ChatBotStrategy {
  SpamBotStrategy({
    required this.messageCount,
    this.baseMessage = 'Spam message',
  });

  final int messageCount;
  final String baseMessage;
  int _sentCount = 0;
  final Completer<void> _done = Completer<void>();

  Completer<void> get done => _done;

  @override
  void onHistoryLoaded(ScenarioBot bot, List<LetterDto> letters) {
    _spam(bot);
  }

  void _spam(ScenarioBot bot) {
    if (_sentCount < messageCount) {
      sendLetter(bot, '$baseMessage #${_sentCount + 1}');
      _sentCount++;
      Future.delayed(const Duration(milliseconds: 50), () {
        _spam(bot);
      });
    } else if (!_done.isCompleted) {
      _done.complete();
    }
  }
}

/// Bot that edits its own message.
class EditOwnMessageStrategy extends ChatBotStrategy {
  EditOwnMessageStrategy({
    required this.originalMessage,
    required this.editedMessage,
  });

  final String originalMessage;
  final String editedMessage;
  int? _letterId;
  final Completer<void> _done = Completer<void>();

  Completer<void> get done => _done;

  @override
  void onHistoryLoaded(ScenarioBot bot, List<LetterDto> letters) {
    Future.delayed(const Duration(milliseconds: 100), () {
      sendLetter(bot, originalMessage);
    });
  }

  @override
  void onNewLetter(ScenarioBot bot, LetterDto letter) {
    if (letter.content == originalMessage && _letterId == null) {
      _letterId = letter.id;
      debugLog('[EditOwnMessageBot ${bot.userId}] Created letter: $letter.id');
      // Edit our own letter
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_letterId != null) {
          editLetter(bot, _letterId!, editedMessage);
        }
      });
    }
  }

  @override
  void onLetterEdited(ScenarioBot bot, LetterDto letter) {
    if (letter.id == _letterId) {
      debugLog('[EditOwnMessageBot ${bot.userId}] Successfully edited letter');
      if (!_done.isCompleted) {
        _done.complete();
      }
    }
  }
}

/// Bot that sends a single message and waits.
class SingleMessageBotStrategy extends ChatBotStrategy {
  SingleMessageBotStrategy({required this.message});

  final String message;
  final Completer<int> letterId = Completer<int>();

  @override
  void onHistoryLoaded(ScenarioBot bot, List<LetterDto> letters) {
    Future.delayed(const Duration(milliseconds: 100), () {
      sendLetter(bot, message);
    });
  }

  @override
  void onNewLetter(ScenarioBot bot, LetterDto letter) {
    if (letter.content == message && !letterId.isCompleted) {
      letterId.complete(letter.id);
    }
  }
}

/// Bot that tests multiple operations: send, edit, delete.
class FullLifecycleBotStrategy extends ChatBotStrategy {
  FullLifecycleBotStrategy();

  int? _letterId;
  int _step = 0;
  final Completer<void> _done = Completer<void>();

  Completer<void> get done => _done;

  @override
  void onHistoryLoaded(ScenarioBot bot, List<LetterDto> letters) {
    _executeNextStep(bot);
  }

  void _executeNextStep(ScenarioBot bot) {
    switch (_step) {
      case 0:
        debugLog('[LifecycleBot ${bot.userId}] Step 1: Send message');
        sendLetter(bot, 'Original message');
        break;
      case 1:
        debugLog('[LifecycleBot ${bot.userId}] Step 2: Edit message');
        if (_letterId != null) {
          editLetter(bot, _letterId!, 'Edited message');
        }
        break;
      case 2:
        debugLog('[LifecycleBot ${bot.userId}] Step 3: Delete message');
        if (_letterId != null) {
          deleteLetter(bot, _letterId!);
        }
        break;
    }
    _step++;
  }

  @override
  void onNewLetter(ScenarioBot bot, LetterDto letter) {
    if (letter.content == 'Original message' && _letterId == null) {
      _letterId = letter.id;
      Future.delayed(const Duration(milliseconds: 100), () {
        _executeNextStep(bot);
      });
    }
  }

  @override
  void onLetterEdited(ScenarioBot bot, LetterDto letter) {
    if (letter.id == _letterId) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _executeNextStep(bot);
      });
    }
  }

  @override
  void onLettersDeleted(ScenarioBot bot, List<int> letterIds) {
    if (_letterId != null && letterIds.contains(_letterId)) {
      debugLog('[LifecycleBot ${bot.userId}] Full lifecycle completed');
      if (!_done.isCompleted) {
        _done.complete();
      }
    }
  }
}
