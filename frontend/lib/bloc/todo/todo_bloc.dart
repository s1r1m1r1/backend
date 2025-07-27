import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/models/todo.dart';
import 'package:frontend/services/api_service.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final ApiService _apiService;

  TodoBloc(this._apiService) : super(TodoLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    try {
      final todos = await _apiService.fetchTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      await _apiService.createTodo(event.todo);
      add(LoadTodos()); // Reload todos after adding
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  void _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    try {
      await _apiService.updateTodo(event.todo.id, event.todo);
      add(LoadTodos()); // Reload todos after updating
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      await _apiService.deleteTodo(event.id);
      add(LoadTodos()); // Reload todos after deleting
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
}
