import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/create_todo.dart';
part 'create_todo_dto.g.dart';

@JsonSerializable()
class CreateTodoDto {
  CreateTodoDto(this.tile, this.description);
  final String tile;
  final String description;

  factory CreateTodoDto.fromJson(Map<String, dynamic> json) => _$CreateTodoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTodoDtoToJson(this);

  factory CreateTodoDto.fromModel(CreateTodo model) => CreateTodoDto(model.title, model.description);
}
