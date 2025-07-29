import 'package:freezed_annotation/freezed_annotation.dart';

import 'update_todo.dart';
part 'todo.freezed.dart';

@freezed
abstract class Todo with _$Todo {
  const Todo._();
  const factory Todo({
    required int id,
    required String title,
    @Default('') String description,
    @Default(false) bool? completed,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Todo;

  UpdateTodo toUpdateTodo() {
    return UpdateTodo(id: id, title: title, description: description, completed: completed);
  }
}
