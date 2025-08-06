import 'package:sha_red/sha_red.dart';

import '../domain/create_todo.dart';

extension CreateTodoExtension on CreateTodo {
  CreateTodoDto toDto() => CreateTodoDto(title, description);
}
