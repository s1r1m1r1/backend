import 'package:freezed_annotation/freezed_annotation.dart';
part 'update_todo.freezed.dart';

@freezed
abstract class UpdateTodo with _$UpdateTodo {
  const UpdateTodo._();
  const factory UpdateTodo({required int id, String? title, String? description, bool? completed}) = _UpdateTodo;
}
