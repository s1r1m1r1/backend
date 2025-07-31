import 'dart:async';
import 'dart:io';

import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:backend/models/validation/map_to_int.dart';
import 'package:backend/models/validation/update_todo_validated.dart';
import 'package:backend/todo/todo_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return getTodo(context, id);
    case HttpMethod.put:
    case HttpMethod.patch:
      return updateTodo(context, id);
    case HttpMethod.delete:
      return deleteTodo(context, id);
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.post:
      return Response.json(body: {'error': '👀 Looks like you are lost 🔦'}, statusCode: HttpStatus.methodNotAllowed);
  }
}

FutureOr<Response> getTodo(RequestContext context, String id) async {
  try {
    final todoRepo = context.read<TodoRepository>();
    final todoId = mapToInt(id);
    final res = await todoRepo.getTodoById(todoId);
    return Response.json(body: res.toJson());
  } on ApiException catch (e, stack) {
    stdout.writeln('store errors${e.errors} ${stack}');
    return Response.json(
      body: {'message': e.toString(), "errors": e.errors},
      statusCode: HttpStatus.internalServerError,
    );
  } on Object catch (e) {
    stdout.writeln('store UNEXPECTED ERROR');
    return Response.json(body: {'message': e.toString()}, statusCode: HttpStatus.internalServerError);
  }
}

FutureOr<Response> updateTodo(RequestContext context, String id) async {
  try {
    final todoRepo = context.read<TodoRepository>();
    final parsedBody = await parseJson(context.request);
    final todoId = mapToInt(id);
    final dto = UpdateTodoMethod.validated(parsedBody);
    stdout.writeln('TodoController update start');
    final res = await todoRepo.updateTodo(todoId: todoId, updateTodoDto: dto);
    return Response.json(body: res.toJson());
  } on ApiException catch (e, stack) {
    stdout.writeln('TodoController err: ${stack}');
    return Response.json(body: {'message': e.toString()}, statusCode: HttpStatus.internalServerError);
  } on Object catch (e, stackTrace) {
    stdout.writeln('TodoController UNKNOWN ERROR ${stackTrace}');
    return Response.json(body: {'message': e.toString()}, statusCode: HttpStatus.internalServerError);
  }
}

FutureOr<Response> deleteTodo(RequestContext context, String id) async {
  stdout.writeln('destroy 1');
  try {
    final todoRepo = context.read<TodoRepository>();
    final todoId = mapToInt(id);

    final res = await todoRepo.deleteTodo(todoId);
    if (res == 0) {
      return Response(statusCode: HttpStatus.notFound);
    }
    return Response.json();
  } on Object catch (e) {
    stdout.writeln('store UNEXPECTED ERROR');
    return Response.json(body: {'message': e.toString()}, statusCode: HttpStatus.internalServerError);
  }
}
