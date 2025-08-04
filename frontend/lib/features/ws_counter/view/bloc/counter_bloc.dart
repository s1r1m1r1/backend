import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/features/ws_counter/domain/ws_config_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_client/web_socket_client.dart' show ConnectionState, Connected, Reconnected;

import '../../../../app/logger/log_colors.dart';
import '../../../../core/network/ws_manager.dart';

part 'counter_event.dart';
part 'counter_state.dart';
part 'counter_bloc.freezed.dart';

@injectable
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc(this._counterRepository, this._wsManager, this._wsConfigRepository) : super(const CounterState()) {
    on<CounterEvent>((event, emit) async {
      switch (event) {
        case InitCounterEvent():
          await _onInit(event, emit);
        case StartedCounterEvent():
          _onCounterStarted(event, emit);
        case IncrementCounterEvent():
          _onCounterIncrementPressed(event, emit);
        case DecrementCounterEvent():
          _onCounterDecrementPressed(event, emit);
        case ChangedCounterEvent():
          _onCounterCountChanged(event, emit);
        case ConnectionStateChangedCounterEvent():
          _onCounterConnectionStateChanged(event, emit);
      }
    });
    // on<CounterStarted>(_onCounterStarted);
    // on<_CounterConnectionStateChanged>(_onCounterConnectionStateChanged);
    // on<_CounterCountChanged>(_onCounterCountChanged);
    // on<CounterIncrementPressed>(_onCounterIncrementPressed);
    // on<CounterDecrementPressed>(_onCounterDecrementPressed);
  }
  final WsConfigRepository _wsConfigRepository;
  final WsCounterRepository _counterRepository;
  final WsManager _wsManager;
  StreamSubscription<int>? _countSubscription;
  StreamSubscription<ConnectionState>? _connectionSubscription;
  String? _counterRoom;

  FutureOr<void> _onCounterStarted(StartedCounterEvent event, Emitter<CounterState> emit) async {
    final config = await _wsConfigRepository.getConfig();
    if (config == null) {
      debugPrint('$red config is null $reset');
      return;
    }

    debugPrint('$green config is ok ${config.counterRoom} $reset');
    _counterRoom = config.counterRoom;
    _counterRepository.joinRoom(_counterRoom!);
    _countSubscription = _counterRepository.countStream.listen((count) => add(CounterEvent.countChanged(count)));
    _connectionSubscription = _wsManager.connection.listen((state) {
      add(CounterEvent.connectionStateChanged(state));
    });
  }

  void _onCounterIncrementPressed(IncrementCounterEvent event, Emitter<CounterState> emit) {
    if (_counterRoom == null) return;
    _counterRepository.increment(_counterRoom!);
  }

  void _onCounterDecrementPressed(DecrementCounterEvent event, Emitter<CounterState> emit) {
    if (_counterRoom == null) return;
    _counterRepository.decrement(_counterRoom!);
  }

  void _onCounterConnectionStateChanged(ConnectionStateChangedCounterEvent event, Emitter<CounterState> emit) {
    emit(state.copyWith(status: event.state.toStatus()));
  }

  void _onCounterCountChanged(ChangedCounterEvent event, Emitter<CounterState> emit) {
    emit(state.copyWith(count: event.count, status: CounterStatus.connected));
  }

  @override
  Future<void> close() {
    _connectionSubscription?.cancel();
    _countSubscription?.cancel();
    return super.close();
  }

  Future<void> _onInit(InitCounterEvent event, Emitter<CounterState> emit) async {}
}

extension on ConnectionState {
  CounterStatus toStatus() {
    return this is Connected || this is Reconnected ? CounterStatus.connected : CounterStatus.disconnected;
  }
}
