// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_todo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateTodoDto _$CreateTodoDtoFromJson(Map<String, dynamic> json) =>
    _CreateTodoDto(
      title: json['title'] as String?,
      description: json['description'] as String?,
      completed: json['completed'] as bool?,
    );

Map<String, dynamic> _$CreateTodoDtoToJson(_CreateTodoDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'completed': instance.completed,
    };
