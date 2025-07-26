import 'dart:async';
import 'dart:io';
import 'package:backend/models/create_todo_dto.dart';
import 'package:backend/models/todo.dart';
import 'package:backend/utils/result.dart';
import 'package:backend/utils/typedefs.dart';
import 'package:dart_frog/dart_frog.dart';
import '../../controller/http_controller.dart';
import '../../failures/failure.dart';
import '../../models/update_todo_dto.dart';
import '../repository/todo_repository.dart';

class TodoController extends HttpController {
  TodoController(this._repo);

  final TodoRepository _repo;
  @override
  FutureOr<Response> index(Request request) async {
    final res = await _repo.getTodos();
    switch (res) {
      case Fail(value: final f):
        return Response.json(body: {'message': f.message}, statusCode: f.statusCode);
      case Success(value: final s):
        return Response.json(body: s.map((e) => e.toJson()).toList());
    }
    ;
  }

  @override
  FutureOr<Response> show(Request request, String id) async {
    final todoId = mapTodoId(id);
    switch (todoId) {
      case Fail<Failure, TodoId>(value: final f):
        return Response.json(body: {'message': f.message}, statusCode: f.statusCode);
      case Success<Failure, TodoId>(value: final s):
        final res = await _repo.getTodoById(s);
        return switch (res) {
          Fail<Failure, Todo>(value: final f) => Response.json(body: {'message': f.message}, statusCode: f.statusCode),
          Success<Failure, Todo>(value: final s) => Response.json(body: s.toJson()),
        };
    }
  }

  @override
  FutureOr<Response> destroy(Request request, String id) async {
    final todoId = mapTodoId(id);
    switch (todoId) {
      case Fail(value: final f):
        return Response.json(body: {'message': f.message}, statusCode: f.statusCode);
      case Success(value: final s):
        final res = await _repo.deleteTodo(s);
        return switch (res) {
          Fail(value: final f) => Response.json(body: {'message': f.message}, statusCode: f.statusCode),
          Success() => Response.json(body: {'message': 'OK'}),
        };
    }
  }

  @override
  FutureOr<Response> store(Request request) async {
    stdout.writeln('store 1');
    final parsedBody = await parseJson(request);
    return parsedBody.fold<FutureOr<Response>>(
      (left) {
        return Response.json(body: {'message': left.message}, statusCode: left.statusCode);
      },
      (Json json) async {
        final validated = CreateTodoDto.validated(json);
        switch (validated) {
          case Fail(value: final f):
            return Response.json(body: {'message': f.message}, statusCode: f.statusCode);
          case Success(value: final s):
            final result = await _repo.createTodo(s);
            switch (result) {
              case Fail(value: final f):
                return Response.json(body: {'message': f.message}, statusCode: f.statusCode);
              case Success(value: final s):
                stdout.writeln('store final ${s.toJson()}');
                return Response.json(body: s.toJson(), statusCode: HttpStatus.created);
            }
        }
      },
    );
  }

  @override
  FutureOr<Response> update(Request request, String id) async {
    final parsedBody = await parseJson(request);
    final todoIdResult = mapTodoId(id);
    late final TodoId todoId;
    switch (todoIdResult) {
      case Fail(value: final f):
        return Response.json(body: {'message': f.message}, statusCode: f.statusCode);
      case Success(value: final s):
        todoId = s;
    }
    stdout.writeln('update todo 1');
    late final Json json;
    return parsedBody.fold<FutureOr<Response>>(
      (left) {
        return Response.json(body: {'message': left.message}, statusCode: left.statusCode);
      },
      (Json json) async {
        final updateTodoDto = UpdateTodoDto.validated(json);
        switch (updateTodoDto) {
          case Fail(value: final f):
            return Response.json(body: {'message': f.message, 'errors': f.errors}, statusCode: f.statusCode);
          case Success(value: final s):
            final res = await _repo.updateTodo(id: todoId, updateTodoDto: s);
            switch (res) {
              case Fail(value: final f):
                return Response.json(body: {'message': f.message}, statusCode: f.statusCode);
              case Success(value: final s):
                stdout.writeln('update todo 3');
                return Response.json(body: s.toJson());
            }
        }
      },
    );
  }
}
