import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/ws_counter/domain/ws_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:web_socket_client/web_socket_client.dart' show ConnectionState, Connected, Reconnected;
part 'letters_event.dart';
part 'letters_state.dart';

@injectable
class LettersBloc extends Bloc<LettersEvent, LettersState> {
  final WsLettersRepository _lettersRepository;
  final WsManager _wsManager;
  StreamSubscription? _lettersSubscription;
  StreamSubscription<ConnectionState>? _connectionSubscription;
  LettersBloc(this._lettersRepository, this._wsManager) : super(const LettersState()) {
    on<LettersStarted>(_onStarted);
    on<LettersNewPressed>(_onNew);
    on<LettersCorrectLetterPressed>(_onCorrectLetter);
    on<LettersDeleteMessagePressed>(_onDeleteLetter);
    on<_LetterOnNewLetters>(_onNewLetters);
    on<_LetterOnUpdateLetters>(onUpdateLetters);
    on<_LettersConnectionStateChanged>(_onConnectionStateChanged);
  }

  FutureOr<void> _onStarted(LettersStarted event, Emitter<LettersState> emit) {
    _lettersSubscription = _lettersRepository.letters.listen((letters) => add(_LetterOnNewLetters(letters)));
    _connectionSubscription = _wsManager.connection.listen((state) {
      add(_LettersConnectionStateChanged(state));
    });
  }

  FutureOr<void> _onNew(LettersNewPressed event, Emitter<LettersState> emit) {
    print('_onNew');
    _lettersRepository.newLetter(
      LetterDto(chatRoomId: 0, senderId: 0, content: event.message, createdAt: DateTime.now()),
    );
    ;
  }

  FutureOr<void> _onCorrectLetter(LettersCorrectLetterPressed event, Emitter<LettersState> emit) {}

  FutureOr<void> _onDeleteLetter(LettersDeleteMessagePressed event, Emitter<LettersState> emit) {}

  FutureOr<void> _onNewLetters(_LetterOnNewLetters event, Emitter<LettersState> emit) {
    emit(state.copyWith(letters: event.letters));
  }

  FutureOr<void> onUpdateLetters(_LetterOnUpdateLetters event, Emitter<LettersState> emit) {}

  FutureOr<void> _onConnectionStateChanged(_LettersConnectionStateChanged event, Emitter<LettersState> emit) {
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
