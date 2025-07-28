// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_todo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTodoDto _$CreateTodoDtoFromJson(Map<String, dynamic> json) =>
    CreateTodoDto(json['title'] as String, json['description'] as String);

Map<String, dynamic> _$CreateTodoDtoToJson(CreateTodoDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
    };
