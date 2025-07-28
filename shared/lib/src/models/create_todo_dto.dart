import 'package:freezed_annotation/freezed_annotation.dart';
part 'create_todo_dto.g.dart';

@JsonSerializable()
class CreateTodoDto {
  CreateTodoDto(this.title, this.description);
  final String title;
  final String description;

  factory CreateTodoDto.fromJson(Map<String, dynamic> json) => _$CreateTodoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTodoDtoToJson(this);
}
