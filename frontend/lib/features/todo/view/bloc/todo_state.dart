part of 'todo_bloc.dart';

@freezed
abstract class TodoState with _$TodoState {
  const factory TodoState.loading() = TodoLoading;

  const factory TodoState.loaded({required List<Todo> todos}) = TodoLoaded;

  const factory TodoState.error({required String message}) = TodoError;
}
