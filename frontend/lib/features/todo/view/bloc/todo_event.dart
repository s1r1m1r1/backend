part of 'todo_bloc.dart';

@freezed
abstract class TodoEvent with _$TodoEvent {
  const TodoEvent._();
  const factory TodoEvent.loadTodos() = LoadTodos;
  const factory TodoEvent.addTodo(CreateTodo todo) = AddTodo;
  const factory TodoEvent.updateTodo(Todo todo) = UpdateTodo;
  const factory TodoEvent.deleteTodo(int id) = DeleteTodo;
}
