import 'package:frontend/features/todo/domain/todo.dart';

import 'package:sha_red/sha_red.dart';

extension TodoDtoExtension on TodoDto {
  Todo toModel() {
    if (id == null) throw Exception('Dto cannot be converted to model, id is null');
    return Todo(
      id: id!,
      title: title,
      description: description,
      completed: completed,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension TodoExtension on Todo {
  TodoDto toDto(Todo todo) {
    return TodoDto(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      completed: todo.completed,
      createdAt: todo.createdAt,
      updatedAt: todo.updatedAt,
    );
  }
}
