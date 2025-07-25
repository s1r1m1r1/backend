import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fullstack_todo/core/app/routes.router.dart';
import 'package:fullstack_todo/data_services/todos_data_service.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';
import 'package:repository/repository.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
part '../../../show_todo/bloc/show_todo_bloc.freezed.dart';

@injectable
class ShowTodosBloc extends Bloc<ShowTodosEvent, ShowTodosState> {
  ShowTodosBloc(this._todoRepository, this._todosDataService, this._navigationService) : super(const ShowTodosState()) {
    on<ShowTodosEventFetch>(_onFetch);
    on<ShowTodosEventDelete>(_onDelete);
    on<ShowTodosEventMarkCompleted>(_onMarkCompleted);
  }

  final TodoRepository _todoRepository;
  final TodosDataService _todosDataService;
  final NavigationService _navigationService;

  void _onFetch(ShowTodosEventFetch event, Emitter<ShowTodosState> emit) async {
    final response = await _todoRepository.getTodos();
    response.fold(
      (failure) => emit(state.copyWith(failure: failure.message)),
      (todos) => _todosDataService.addAll(todos),
    );
  }

  void _onDelete(ShowTodosEventDelete event, Emitter<ShowTodosState> emit) async {
    final response = await _todoRepository.deleteTodo(event.todo.id);
    response.fold(
      (failure) => emit(state.copyWith(failure: failure.message)),
      (_) => _todosDataService.remove(event.todo),
    );
  }

  void _onMarkCompleted(ShowTodosEventMarkCompleted event, Emitter<ShowTodosState> emit) async {
    final completed = !event.todo.completed;
    _todosDataService.add(event.todo.copyWith(completed: completed));
    final updateDto = UpdateTodoDto(completed: completed);
    final update = await _todoRepository.updateTodo(id: event.todo.id, updateTodoDto: updateDto);
    update.fold((failure) {
      _todosDataService.add(event.todo.copyWith(completed: !completed));
      emit(state.copyWith(failure: failure.message));
    }, (_) {});
  }

  Future<void>? handleTodo([Todo? todo]) {
    return _navigationService.navigateTo<void>(
      Routes.maintainTodoView,
      arguments: MaintainTodoViewArguments(todo: todo),
    );
  }
}

@freezed
abstract class ShowTodosEvent with _$ShowTodosEvent {
  const ShowTodosEvent._();
  const factory ShowTodosEvent.fetch() = ShowTodosEventFetch;

  const factory ShowTodosEvent.delete(Todo todo) = ShowTodosEventDelete;

  const factory ShowTodosEvent.markCompleted(Todo todo) = ShowTodosEventMarkCompleted;
}

@freezed
abstract class ShowTodosState with _$ShowTodosState {
  const ShowTodosState._();
  const factory ShowTodosState({@Default('') String failure}) = _ShowTodosState;

  factory ShowTodosState.initial() => const ShowTodosState();
}
