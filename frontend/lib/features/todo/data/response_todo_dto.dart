import 'package:frontend/models/todo.dart' show Todo;

class ResponseTodoDto {
  final String id;
  final String title;
  final bool completed;

  const ResponseTodoDto({required this.id, required this.title, this.completed = false});

  factory ResponseTodoDto.fromJson(Map<String, dynamic> json) {
    return ResponseTodoDto(
      id: json['id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool? ?? false,
    );
  }
}

extension ResponseTodoDtoExt on ResponseTodoDto {
  Todo toModel() {
    return Todo(id: id, title: title, completed: completed);
  }
}
