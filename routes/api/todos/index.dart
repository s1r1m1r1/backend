import 'dart:io';

import 'package:backend/features/todo/domain/todo.repository.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return getTodos(context);
    case HttpMethod.post:
      return postTodo(context);
    default:
      return Response.json(
        body: {'error': '👀 Looks like you are lost 🔦'},
        statusCode: HttpStatus.methodNotAllowed,
      );
  }
}

Future<Response> getTodos(RequestContext context) async {
  final todoRepo = context.read<TodoRepository>();
  final list = await todoRepo.getTodos();
  return Response.json(body: list.map((todo) => todo.toJson()).toList());
}

Future<Response> postTodo(RequestContext context) async {
  final todoRepo = context.read<TodoRepository>();
  final json = await parseJson(context.request);
  final validated = CreateTodoDto.fromJson(json);
  final result = await todoRepo.createTodo(validated);
  return Response.json(body: result.toJson());
}
