import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/network/ws_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';
import 'package:web_socket_client/web_socket_client.dart' show ConnectionState, Connected, Reconnected;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../ws_counter/domain/ws_config_repository.dart';
part 'letters_event.dart';
part 'letters_state.dart';
part 'letters_bloc.freezed.dart';

@injectable
class LettersBloc extends Bloc<LettersEvent, LettersState> {
  final WsLettersRepository _lettersRepository;
  final WsConfigRepository _wsConfigRepository;
  final WsManager _wsManager;
  String? _roomId;
  StreamSubscription? _lettersSubscription;
  StreamSubscription<ConnectionState>? _connectionSubscription;
  LettersBloc(this._lettersRepository, this._wsManager, this._wsConfigRepository) : super(const LettersState()) {
    on<LettersStarted>(_onStarted);
    on<LettersNewPressed>(_onNew);
    on<LettersCorrectLetterPressed>(_onCorrectLetter);
    on<LettersDeleteMessagePressed>(_onDeleteLetter);
    on<LetterOnNewLetters>(_onNewLetters);
    on<LetterOnUpdateLetters>(onUpdateLetters);
    on<LettersConnectionStateChanged>(_onConnectionStateChanged);
  }

  FutureOr<void> _onStarted(LettersStarted event, Emitter<LettersState> emit) async {
    final config = await _wsConfigRepository.getConfig();
    if (config == null) {
      return;
    }
    _roomId = config.lettersRoom;
    _lettersRepository.joinRoom(_roomId!);
    _lettersSubscription = _lettersRepository.letters.listen((letters) => add(LetterOnNewLetters(letters)));
    _connectionSubscription = _wsManager.connection.listen((state) {
      add(LettersConnectionStateChanged(state));
    });
  }

  FutureOr<void> _onNew(LettersNewPressed event, Emitter<LettersState> emit) async {
    if (_roomId == null) {
      return;
    }
    _lettersRepository.newLetter(
      _roomId!,
      LetterDto(chatRoomId: 1, senderId: 0, content: event.message, createdAt: DateTime.now()),
    );
  }

  FutureOr<void> _onCorrectLetter(LettersCorrectLetterPressed event, Emitter<LettersState> emit) {}

  FutureOr<void> _onDeleteLetter(LettersDeleteMessagePressed event, Emitter<LettersState> emit) {}

  FutureOr<void> _onNewLetters(LetterOnNewLetters event, Emitter<LettersState> emit) async {
    if (_roomId == null) {
      return;
    }
    emit(state.copyWith(letters: event.letters));
  }

  FutureOr<void> onUpdateLetters(LetterOnUpdateLetters event, Emitter<LettersState> emit) {}

  FutureOr<void> _onConnectionStateChanged(LettersConnectionStateChanged event, Emitter<LettersState> emit) async {
    if (_roomId == null) {
      return;
    }
    emit(state.copyWith(status: event.state.toStatus()));
  }

  @override
  Future<void> close() {
    _connectionSubscription?.cancel();
    _lettersSubscription?.cancel();
    return super.close();
  }
}

extension on ConnectionState {
  LettersStatus toStatus() {
    return this is Connected || this is Reconnected ? LettersStatus.connected : LettersStatus.disconnected;
  }
}
