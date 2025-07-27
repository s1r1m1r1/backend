import 'dart:async';
import 'dart:io';

import 'package:backend/models/user.dart';
import 'package:backend/utils/result.dart';
import 'package:dart_frog/dart_frog.dart';

import '../../controller/http_controller.dart';
import '../../failures/validation_failure.dart';
import '../../models/create_user_dto.dart';
import '../../models/login_user_dto.dart';
import '../../services/jwt_service.dart';
import '../../utils/typedefs.dart';
import '../repository/user_repository.dart';

/// {@template user_controller}
/// This is the controller for the user resource
/// Use this class to handle requests to the user resource
/// {@endtemplate}
class UserController extends HttpController {
  /// {@macro user_controller}
  UserController(this._repo, this._jwtService);

  final UserRepository _repo;
  final JWTService _jwtService;

  @override
  FutureOr<Response> store(Request request) async {
    stdout.writeln('store store ');
    final parsedBody = await parseJson(request);
    return parsedBody.fold<FutureOr<Response>>(
      (left) {
        stdout.writeln('store parsedBody left');
        return Response.json(body: {'message': left.message}, statusCode: left.statusCode);
      },
      (Json json) {
        stdout.writeln('store parsedBody json');
        final createTodoDto = CreateUserDto.validated(json);
        return createTodoDto.fold(
          (left) {
            stdout.writeln('store createTodoDto left');
            return Response.json(body: {'message': left.errors}, statusCode: left.statusCode);
          },
          (CreateUserDto u) async {
            stdout.writeln('store createTodoDto right');
            final res = await _repo.createUser(u);
            return res.fold(
              (left) {
                stdout.writeln('store res left');
                return Response.json(body: {'message': left.message}, statusCode: left.statusCode);
              },
              (User user) {
                stdout.writeln('store res right');
                return _signAndSendToken(user, HttpStatus.created);
              },
            );
          },
        );
      },
    );
  }

  /// Login a user
  FutureOr<Response> login(Request request) async {
    final parsedBody = await parseJson(request);
    stdout.writeln('login parsedBody start');
    return parsedBody.fold<FutureOr<Response>>(
      (left) {
        stdout.writeln('login parsedBody left');
        return Response.json(body: {'message': left.message}, statusCode: left.statusCode);
      },
      (Json json) async {
        stdout.writeln('login parsedBody right');
        final loginUserDto = LoginUserDto.validated(json);
        switch (loginUserDto) {
          case Fail(value: final f):
            stdout.writeln('login loginUserDto fail');
            return Response.json(
              body: {"status": f.statusCode, 'message': f.message, 'errors': f.errors},
              statusCode: f.statusCode,
            );
          case Success<ValidationFailure, LoginUserDto>(value: final s):
            stdout.writeln('login loginUserDto success $s');
            final res = await _repo.loginUser(s);
            return res.fold<Response>(
              (left) {
                stdout.writeln('login loginUser fail');
                return Response.json(body: {'message': left.message}, statusCode: left.statusCode);
              },
              (User user) {
                stdout.writeln('login loginUser success');
                return _signAndSendToken(user);
              },
            );
        }
      },
    );
  }

  Response _signAndSendToken(User user, [int? httpStatus]) {
    final token = _jwtService.sign(user.toJson());
    return Response.json(
      body: {'token': token, 'user': user.toJson()..remove('password')},
      statusCode: httpStatus ?? HttpStatus.ok,
    );
  }

  @override
  FutureOr<Response> destroy(Request request, String id) {
    throw UnimplementedError();
  }

  @override
  FutureOr<Response> index(Request request) {
    // TODO: implement index
    throw UnimplementedError();
  }

  @override
  FutureOr<Response> show(Request request, String id) {
    // TODO: implement show
    throw UnimplementedError();
  }

  @override
  FutureOr<Response> update(Request request, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
