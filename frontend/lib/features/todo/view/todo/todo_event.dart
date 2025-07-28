part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final CreateTodo todo;
  const AddTodo(this.todo);
  @override
  List<Object> get props => [todo];
}

class UpdateTodo extends TodoEvent {
  final Todo todo;
  const UpdateTodo(this.todo);
  @override
  List<Object> get props => [todo];
}

class DeleteTodo extends TodoEvent {
  final int id;
  const DeleteTodo(this.id);
  @override
  List<Object> get props => [id];
}
