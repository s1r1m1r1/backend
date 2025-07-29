part of 'todo_bloc.dart';

@freezed
abstract class TodoEvent with _$TodoEvent {
  const TodoEvent._();
  const factory TodoEvent.loadTodos() = LoadTodosEvent;
  const factory TodoEvent.addTodo(CreateTodo todo) = AddTodoEvent;
  const factory TodoEvent.updateTodo(UpdateTodo todo) = UpdateTodoEvent;
  const factory TodoEvent.deleteTodo(int id) = DeleteTodoEvent;
}
