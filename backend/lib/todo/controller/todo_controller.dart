import 'dart:async';
import 'dart:io';
import 'package:backend/failures/validation_failure.dart';
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
      case Fail<Failure, List<Todo>>(:final f):
        return Response.json(
          body: {'message': f.message},
          statusCode: f.statusCode,
        );
      case Success<Failure, List<Todo>>(:final s):
        return Response.json(
          body: s.map((e) => e.toJson()).toList(),
        );
    }
    ;
  }

  @override
  FutureOr<Response> show(Request request, String id) async {
    final todoId = mapTodoId(id);
    switch (todoId) {
      case Fail<Failure, TodoId>(:final f):
        return Response.json(
          body: {'message': f.message},
          statusCode: f.statusCode,
        );
      case Success<Failure, TodoId>(:final s):
        final res = await _repo.getTodoById(s);
        return switch (res) {
          Fail<Failure, Todo>(:final f) => Response.json(
              body: {'message': f.message},
              statusCode: f.statusCode,
            ),
          Success<Failure, Todo>(:final s) => Response.json(
              body: s.toJson(),
            ),
        };
    }
  }

  @override
  FutureOr<Response> destroy(Request request, String id) async {
    final todoId = mapTodoId(id);
    switch (todoId) {
      case Fail<Failure, TodoId>(:final f):
        return Response.json(
          body: {'message': f.message},
          statusCode: f.statusCode,
        );
      case Success<Failure, TodoId>(:final s):
        final res = await _repo.deleteTodo(s);
        return switch (res) {
          Fail<Failure, void>(:final f) => Response.json(
              body: {'message': f.message},
              statusCode: f.statusCode,
            ),
          Success<Failure, void>() => Response.json(body: {'message': 'OK'}),
        };
    }
  }

  @override
  FutureOr<Response> store(Request request) async {
    stdout.writeln('store 1');
    final parsedBody = await parseJson(request);
    switch (parsedBody) {
      case Fail<Failure, Map<String, dynamic>>(:final f):
        return Response.json(
          body: {'message': f.message},
          statusCode: f.statusCode,
        );
      case Success<Failure, Map<String, dynamic>>(:final s):
        final json = s;
        final validated = CreateTodoDto.validated(json);
        switch (validated) {
          case Fail(:final f):
            return Response.json(
              body: {'message': f.message},
              statusCode: f.statusCode,
            );
          case Success(:final s):
            final result = await _repo.createTodo(s);
            switch (result) {
              case Fail<Failure, Todo>(:final f):
                return Response.json(
                  body: {'message': f.message},
                  statusCode: f.statusCode,
                );
              case Success<Failure, Todo>(:final s):
                stdout.writeln('store final ${s.toJson()}');
                return Response.json(
                  body: s.toJson(),
                  statusCode: HttpStatus.created,
                );
            }
        }
    }
  }

  @override
  FutureOr<Response> update(Request request, String id) async {
    final parsedBody = await parseJson(request);
    final todoIdResult = mapTodoId(id);
    late final TodoId todoId;
    switch (todoIdResult) {
      case Fail(:final f):
        return Response.json(
          body: {'message': f.message},
          statusCode: f.statusCode,
        );
      case Success<Failure, TodoId>():
        todoId = todoIdResult.s;
    }
    stdout.writeln('update todo 1');
    late final Json json;
    switch (parsedBody) {
      case Fail(:final f):
        return Response.json(
          body: {'message': f.message},
          statusCode: f.statusCode,
        );
      case Success<Failure, Map<String, dynamic>>(:final s):
        json = s;
    }

    final updateTodoDto = UpdateTodoDto.validated(json);
    switch (updateTodoDto) {
      case Fail<ValidationFailure, UpdateTodoDto>(:final f):
        return Response.json(
          body: {
            'message': f.message,
            'errors': f.errors,
          },
          statusCode: f.statusCode,
        );
      case Success<ValidationFailure, UpdateTodoDto>():
        stdout.writeln('update todo 2');
        final res = await _repo.updateTodo(
          id: todoId,
          updateTodoDto: updateTodoDto.s,
        );
        switch (res) {
          case Fail<Failure, Todo>(:final f):
            stdout.writeln('update todo fail 3');
            return Response.json(
              body: {'message': f.message},
              statusCode: f.statusCode,
            );
          case Success<Failure, Todo>(:final s):
            stdout.writeln('update todo 3');
            return Response.json(
              body: s.toJson(),
            );
        }
    }
  }
}
