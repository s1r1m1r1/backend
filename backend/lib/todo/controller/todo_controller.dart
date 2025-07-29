import 'dart:async';
import 'dart:io';
import 'package:backend/exceptions/new_api_exceptions.dart';
import 'package:backend/models/validation/create_todo_validated.dart';
import 'package:dart_frog/dart_frog.dart';
import '../../controller/http_controller.dart';
import '../../models/validation/map_to_int.dart';
import '../../models/validation/update_todo_validated.dart';
import '../repository/todo_repository.dart';

class TodoController extends HttpController {
  TodoController(this._repo);

  final TodoRepository _repo;
  @override
  FutureOr<Response> index(Request request) async {
    try {
      stdout.writeln('TodoController index start');
      final list = await _repo.getTodos();
      return Response.json(body: list.map((todo) => todo.toJson()).toList());
    } on ApiException catch (e, stack) {
      stdout.writeln('UserController ${e.statusCode} ${stack}');
      return Response.json(body: {'message': e.toString()}, statusCode: HttpStatus.noContent);
    } on Object catch (e, stack) {
      stdout.writeln('UserController UNKNOWN ERROR ${stack}');
      return Response.json(body: {'message': e.toString()}, statusCode: HttpStatus.internalServerError);
    }
  }

  @override
  FutureOr<Response> show(Request request, String id) async {
    try {
      final todoId = mapToInt(id);
      final res = await _repo.getTodoById(todoId);
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

  @override
  FutureOr<Response> destroy(Request request, String id) async {
    stdout.writeln('destroy 1');
    try {
      final todoId = mapToInt(id);

      final res = await _repo.deleteTodo(todoId);
      if (res == 0) {
        return Response(statusCode: HttpStatus.notFound);
      }
      return Response.json();
    } on Object catch (e) {
      stdout.writeln('store UNEXPECTED ERROR');
      return Response.json(body: {'message': e.toString()}, statusCode: HttpStatus.internalServerError);
    }
  }

  @override
  FutureOr<Response> store(Request request) async {
    stdout.writeln('store 1');
    try {
      final json = await parseJson(request);
      final validated = CreateTodoMethod.validated(json);
      final result = await _repo.createTodo(validated);
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

  @override
  FutureOr<Response> update(Request request, String id) async {
    try {
      final parsedBody = await parseJson(request);
      final todoId = mapToInt(id);
      final dto = UpdateTodoMethod.validated(parsedBody);
      stdout.writeln('TodoController update start');
      final res = await _repo.updateTodo(todoId: todoId, updateTodoDto: dto);
      return Response.json(body: res.toJson());
    } on ApiException catch (e, stack) {
      stdout.writeln('TodoController err: ${stack}');
      return Response.json(body: {'message': e.toString()}, statusCode: HttpStatus.internalServerError);
    } on Object catch (e, stackTrace) {
      stdout.writeln('TodoController UNKNOWN ERROR ${stackTrace}');
      return Response.json(body: {'message': e.toString()}, statusCode: HttpStatus.internalServerError);
    }
  }
}
