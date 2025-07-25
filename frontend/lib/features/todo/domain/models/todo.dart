import 'package:freezed_annotation/freezed_annotation.dart';

import 'serializers/datetime_converter.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
abstract class Todo with _$Todo {
  const factory Todo({
    required int id,
    required String title,
    @Default('') String description,
    @Default(false) bool? completed,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverterNullable() DateTime? updatedAt,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
