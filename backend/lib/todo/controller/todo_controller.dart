import 'dart:async';
import 'dart:io';
import 'package:backend/models/create_todo_dto.dart';
import 'package:backend/utils/typedefs.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:either_dart/either.dart';
import '../../controller/http_controller.dart';
import '../../models/update_todo_dto.dart';
import '../repository/todo_repository.dart';

class TodoController extends HttpController {
  TodoController(this._repo);

  final TodoRepository _repo;
  @override
  FutureOr<Response> index(Request request) async {
    final res = await _repo.getTodos();
    return res.fold(
      (left) => Response.json(body: {'message': left.message}, statusCode: left.statusCode),
      (right) => Response.json(body: right.map((e) => e.toJson()).toList()),
    );
  }

  @override
  FutureOr<Response> show(Request request, String id) async {
    final todoId = mapTodoId(id);
    switch (todoId) {
      case Left(value: final f):
        return Response.json(body: {'message': f.message}, statusCode: f.statusCode);
      case Right(value: final s):
        final res = await _repo.getTodoById(s);
        return res.fold(
          (left) => Response.json(body: {'message': left.message}, statusCode: left.statusCode),
          (right) => Response.json(body: right.toJson()),
        );
    }
  }

  @override
  FutureOr<Response> destroy(Request request, String id) async {
    final todoId = mapTodoId(id);
    switch (todoId) {
      case Left(value: final f):
        return Response.json(body: {'message': f.message}, statusCode: f.statusCode);
      case Right(value: final s):
        final res = await _repo.deleteTodo(s);
        return res.fold(
          (left) => Response.json(body: {'message': left.message}, statusCode: left.statusCode),
          (right) => Response.json(body: {'message': 'OK'}),
        );
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
        return validated.fold<FutureOr<Response>>(
          (left) => Response.json(body: {'message': left.message}, statusCode: left.statusCode),
          (CreateTodoDto dto) async {
            final result = await _repo.createTodo(dto);
            return result.fold(
              (left) => Response.json(body: {'message': left.message}, statusCode: left.statusCode),
              (right) => Response.json(body: right.toJson()),
            );
          },
        );
      },
    );
  }

  @override
  FutureOr<Response> update(Request request, String id) async {
    final parsedBody = await parseJson(request);
    final todoIdResult = mapTodoId(id);
    late final TodoId todoId;
    switch (todoIdResult) {
      case Left(value: final f):
        return Response.json(body: {'message': f.message}, statusCode: f.statusCode);
      case Right(value: final s):
        todoId = s;
    }
    stdout.writeln('update todo 1');
    return parsedBody.fold<FutureOr<Response>>(
      (left) {
        return Response.json(body: {'message': left.message}, statusCode: left.statusCode);
      },
      (Json json) async {
        final updateTodoDto = UpdateTodoDto.validated(json);
        return updateTodoDto.fold<FutureOr<Response>>(
          (left) => Response.json(body: {'message': left.message}, statusCode: left.statusCode),
          (UpdateTodoDto dto) async {
            final res = await _repo.updateTodo(id: todoId, updateTodoDto: dto);
            return res.fold<Response>(
              (left) => Response.json(body: {'message': left.message}, statusCode: left.statusCode),
              (right) => Response.json(body: right.toJson()),
            );
          },
        );
      },
    );
  }
}
