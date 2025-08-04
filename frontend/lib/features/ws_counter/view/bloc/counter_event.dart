part of 'counter_bloc.dart';

@freezed
sealed class CounterEvent with _$CounterEvent {
  const factory CounterEvent.init() = InitCounterEvent;
  const factory CounterEvent.started() = StartedCounterEvent;
  const factory CounterEvent.incrementPressed() = IncrementCounterEvent;
  const factory CounterEvent.decrementPressed() = DecrementCounterEvent;
  const factory CounterEvent.countChanged(int count) = ChangedCounterEvent;
  const factory CounterEvent.connectionStateChanged(ConnectionState state) = ConnectionStateChangedCounterEvent;
}
