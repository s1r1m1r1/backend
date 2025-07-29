import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:json_annotation/json_annotation.dart';

part 'update_todo_dto.g.dart';

@JsonSerializable()
class UpdateTodoDto {
  final int id;
  final String? title;
  final String? description;
  final bool? completed;

  const UpdateTodoDto(this.id, {this.title, this.description, this.completed});

  factory UpdateTodoDto.fromJson(Map<String, dynamic> json) => _$UpdateTodoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateTodoDtoToJson(this);
}
