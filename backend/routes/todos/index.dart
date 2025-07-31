import 'dart:async';
import 'dart:io';

import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:backend/models/validation/create_todo_validated.dart';
import 'package:backend/todo/todo_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return getTodos(context);
    case HttpMethod.post:
      return postTodo(context);
    case HttpMethod.put:
    case HttpMethod.patch:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
      return Response.json(body: {'error': '👀 Looks like you are lost 🔦'}, statusCode: HttpStatus.methodNotAllowed);
  }
}

FutureOr<Response> getTodos(RequestContext context) async {
  try {
    final todoRepo = context.read<TodoRepository>();
    stdout.writeln('TodoController index start');
    final list = await todoRepo.getTodos();
    return Response.json(body: list.map((todo) => todo.toJson()).toList());
  } on ApiException catch (e, stack) {
    stdout.writeln('UserController ${e.statusCode} ${stack}');
    return Response.json(body: {'message': e.toString()}, statusCode: HttpStatus.noContent);
  } on Object catch (e, stack) {
    stdout.writeln('UserController UNKNOWN ERROR ${stack}');
    return Response.json(body: {'message': e.toString()}, statusCode: HttpStatus.internalServerError);
  }
}

FutureOr<Response> postTodo(RequestContext context) async {
  stdout.writeln('store 1');
  try {
    final todoRepo = context.read<TodoRepository>();
    final json = await parseJson(context.request);
    final validated = CreateTodoMethod.validated(json);
    final result = await todoRepo.createTodo(validated);
    return Response.json(body: result.toJson());
  } on ApiException catch (e, stack) {
    // stdout.writeln('store errors${e.errors} ${stack}');
    return Response.json(
      body: {'message': e.toString(), "errors": e.errors},
      statusCode: HttpStatus.internalServerError,
    );
  } on Object catch (e) {
    stdout.writeln('store UNEXPECTED ERROR');
    return Response.json(body: {'message': e.toString()}, statusCode: HttpStatus.internalServerError);
  }
}
