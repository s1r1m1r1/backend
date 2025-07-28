import 'package:freezed_annotation/freezed_annotation.dart';
part 'create_todo.freezed.dart';

@freezed
abstract class CreateTodo with _$CreateTodo {
  const CreateTodo._();
  const factory CreateTodo({required String title, @Default('test') String description}) = _CreateTodo;
}
