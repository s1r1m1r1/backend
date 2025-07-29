import 'package:bloc/bloc.dart';
import 'package:frontend/features/todo/domain/todo_repository.dart';
import 'package:frontend/features/todo/domain/todo.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/create_todo.dart';
import '../../domain/update_todo.dart';
part 'todo_bloc.freezed.dart';

part 'todo_event.dart';
part 'todo_state.dart';

@injectable
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository;

  TodoBloc(this._todoRepository) : super(TodoLoading()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  void _onLoadTodos(LoadTodosEvent event, Emitter<TodoState> emit) async {
    try {
      final todos = await _todoRepository.getTodos();
      emit(TodoState.loaded(todos: todos));
    } catch (e) {
      emit(TodoState.error(message: e.toString()));
    }
  }

  void _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await _todoRepository.createTodo(event.todo);
      add(TodoEvent.loadTodos()); // Reload todos after adding
    } catch (e) {
      emit(TodoState.error(message: e.toString()));
    }
  }

  void _onUpdateTodo(UpdateTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await _todoRepository.updateTodo(event.todo);
      add(LoadTodosEvent()); // Reload todos after updating
    } catch (e) {
      emit(TodoState.error(message: e.toString()));
    }
  }

  void _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await _todoRepository.deleteTodo(event.id);
      add(LoadTodosEvent()); // Reload todos after deleting
    } catch (e) {
      emit(TodoState.error(message: e.toString()));
    }
  }
}
