import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/features/todo/domain/todo.dart';

import '../../../core/serializer/datetime_converter.dart';
part 'todo_dto.freezed.dart';
part 'todo_dto.g.dart';

@freezed
abstract class TodoDto with _$TodoDto {
  const TodoDto._();

  const factory TodoDto({
    int? id,
    required String title,
    @Default('') String description,
    @Default(false) bool? completed,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverterNullable() DateTime? updatedAt,
  }) = _Todo;

  factory TodoDto.fromJson(Map<String, dynamic> json) => _$TodoDtoFromJson(json);

  factory TodoDto.fromModel(Todo todo) {
    return TodoDto(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      completed: todo.completed,
      createdAt: todo.createdAt,
      updatedAt: todo.updatedAt,
    );
  }

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
