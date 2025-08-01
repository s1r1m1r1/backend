import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_client/web_socket_client.dart' show ConnectionState, Connected, Reconnected;

import '../../domain/ws_manager.dart';

part 'counter_event.dart';
part 'counter_state.dart';

@injectable
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc(this._counterRepository, this._wsManager) : super(const CounterState()) {
    on<CounterStarted>(_onCounterStarted);
    on<_CounterConnectionStateChanged>(_onCounterConnectionStateChanged);
    on<_CounterCountChanged>(_onCounterCountChanged);
    on<CounterIncrementPressed>(_onCounterIncrementPressed);
    on<CounterDecrementPressed>(_onCounterDecrementPressed);
  }

  final WsCounterRepository _counterRepository;
  final WsManager _wsManager;
  StreamSubscription<int>? _countSubscription;
  StreamSubscription<ConnectionState>? _connectionSubscription;

  void _onCounterStarted(CounterStarted event, Emitter<CounterState> emit) {
    _countSubscription = _counterRepository.countStream.listen((count) => add(_CounterCountChanged(count)));
    _connectionSubscription = _wsManager.connection.listen((state) {
      add(_CounterConnectionStateChanged(state));
    });
  }

  void _onCounterIncrementPressed(CounterIncrementPressed event, Emitter<CounterState> emit) {
    _counterRepository.increment();
  }

  void _onCounterDecrementPressed(CounterDecrementPressed event, Emitter<CounterState> emit) {
    _counterRepository.decrement();
  }

  void _onCounterConnectionStateChanged(_CounterConnectionStateChanged event, Emitter<CounterState> emit) {
    emit(state.copyWith(status: event.state.toStatus()));
  }

  void _onCounterCountChanged(_CounterCountChanged event, Emitter<CounterState> emit) {
    emit(state.copyWith(count: event.count, status: CounterStatus.connected));
  }

  @override
  Future<void> close() {
    _connectionSubscription?.cancel();
    _countSubscription?.cancel();
    return super.close();
  }
}

extension on ConnectionState {
  CounterStatus toStatus() {
    return this is Connected || this is Reconnected ? CounterStatus.connected : CounterStatus.disconnected;
  }
}
