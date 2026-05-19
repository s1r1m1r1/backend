// ignore_for_file: file_names

import 'dart:io';

import 'package:backend/features/todo/domain/todo.repository.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:backend/models/validation/map_to_int.dart';
import 'package:backend/models/validation/update_todo_validated.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final HttpMethod method = context.request.method;
  switch (method) {
    case .get:
      return getTodo(context, id);
    case .put:
    case .patch:
      return updateTodo(context, id);
    case .delete:
      return deleteTodo(context, id);
    default:
      return Response.json(
        body: {'error': '👀 Looks like you are lost 🔦'},
        statusCode: HttpStatus.methodNotAllowed,
      );
  }
}

Future<Response> getTodo(RequestContext context, String id) async {
  final todoRepo = context.read<TodoRepository>();
  final todoId = mapToInt(id);
  final res = await todoRepo.getTodoById(todoId);
  return Response.json(body: res.toJson());
}

Future<Response> updateTodo(RequestContext context, String id) async {
  final todoRepo = context.read<TodoRepository>();
  final parsedBody = await parseJson(context.request);
  final todoId = mapToInt(id);
  final dto = UpdateTodoMethod.validated(parsedBody);

  final res = await todoRepo.updateTodo(todoId: todoId, updateTodoDto: dto);
  return Response.json(body: res.toJson());
}

Future<Response> deleteTodo(RequestContext context, String id) async {
  final todoRepo = context.read<TodoRepository>();
  final todoId = mapToInt(id);

  final res = await todoRepo.deleteTodo(todoId);
  if (res == 0) {
    return Response(statusCode: HttpStatus.notFound);
  }
  return Response.json();
}
