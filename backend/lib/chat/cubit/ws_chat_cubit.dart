import 'package:broadcast_bloc/broadcast_bloc.dart';

class ChatCubit extends BroadcastCubit<int> {
  ChatCubit() : super(0);

  /// Increment the current state.
  void increment() => emit(state + 1);

  /// Decrement the current state.
  void decrement() => emit(state - 1);
}
