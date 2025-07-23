import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_todo_dto.freezed.dart';
part 'create_todo_dto.g.dart';

@freezed
abstract class CreateTodoDto with _$CreateTodoDto {
  const CreateTodoDto._();
  const factory CreateTodoDto({
    String? title,
    String? description,
    bool? completed,
  }) = _CreateTodoDto;

  factory CreateTodoDto.fromJson(Map<String, dynamic> json) => _$CreateTodoDtoFromJson(json);
}
