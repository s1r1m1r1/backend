import 'package:sha_red/sha_red.dart';

import '../domain/update_todo.dart';

extension UpdateTodoExtension on UpdateTodo {
  UpdateTodoDto toDto() => UpdateTodoDto(id, title: title, description: description, completed: completed);
}
