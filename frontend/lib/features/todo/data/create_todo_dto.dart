import 'package:shared/shared.dart';

import '../domain/create_todo.dart';

extension CreateTodoExtension on CreateTodo {
  CreateTodoDto toDto() => CreateTodoDto(title, description);
}
