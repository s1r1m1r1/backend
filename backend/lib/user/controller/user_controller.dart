import 'dart:async';
import 'dart:io';

import 'package:backend/models/user.dart';
import 'package:dart_frog/dart_frog.dart';

import '../../controller/http_controller.dart';
import '../../models/create_user_dto.dart';
import '../../models/login_user_dto.dart';
import '../../services/jwt_service.dart';
import '../../utils/typedefs.dart';
import '../repository/user_repository.dart';

class UserController extends HttpController {
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
        return loginUserDto.fold<FutureOr<Response>>(
          (left) {
            stdout.writeln('login loginUserDto fail');
            return Response.json(
              body: {"status": left.statusCode, 'message': left.message, 'errors': left.errors},
              statusCode: left.statusCode,
            );
          },
          (LoginUserDto dto) async {
            stdout.writeln('login loginUserDto success');
            final res = await _repo.loginUser(dto);
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
          },
        );
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
