// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_todo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateTodoDto _$UpdateTodoDtoFromJson(Map<String, dynamic> json) =>
    _UpdateTodoDto(
      title: json['title'] as String?,
      description: json['description'] as String?,
      completed: json['completed'] as bool?,
    );

Map<String, dynamic> _$UpdateTodoDtoToJson(_UpdateTodoDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'completed': instance.completed,
    };
