import 'package:bloc/bloc.dart';
import 'package:frontend/features/todo/domain/todo_repository.dart';
import 'package:frontend/features/todo/domain/todo.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/create_todo.dart';
part 'todo_bloc.freezed.dart';

part 'todo_event.dart';
part 'todo_state.dart';

@injectable
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository;

  TodoBloc(this._todoRepository) : super(TodoLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    try {
      final todos = await _todoRepository.getTodos();
      emit(TodoState.loaded(todos: todos));
    } catch (e) {
      emit(TodoState.error(message: e.toString()));
    }
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      await _todoRepository.createTodo(event.todo);
      add(TodoEvent.loadTodos()); // Reload todos after adding
    } catch (e) {
      emit(TodoState.error(message: e.toString()));
    }
  }

  void _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    try {
      // await _apiService.updateTodo(event.todo.id, event.todo);
      add(LoadTodos()); // Reload todos after updating
    } catch (e) {
      emit(TodoState.error(message: e.toString()));
    }
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      await _todoRepository.deleteTodo(event.id);
      add(LoadTodos()); // Reload todos after deleting
    } catch (e) {
      emit(TodoState.error(message: e.toString()));
    }
  }
}
