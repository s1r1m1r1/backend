import 'dart:async';
import 'dart:io';

import 'package:backend/exceptions/new_api_exceptions.dart';
import 'package:backend/models/user.dart';
import 'package:dart_frog/dart_frog.dart';

import '../../controller/http_controller.dart';
import '../../models/create_user_dto.dart';
import '../../models/login_user_dto.dart';
import '../../services/jwt_service.dart';
import '../repository/user_repository.dart';

class UserController extends HttpController {
  UserController(this._repo, this._jwtService);

  final UserRepository _repo;
  final JWTService _jwtService;

  @override
  FutureOr<Response> store(Request request) async {
    stdout.writeln('store store ');
    try {
      final parsedBody = await parseJson(request);
      final createTodoDto = CreateUserDto.validated(parsedBody);
      final user = await _repo.createUser(createTodoDto);
      stdout.writeln('store res right');
      return _signAndSendToken(user, HttpStatus.created);
    } on ApiException catch (e) {
      // stdout.writeln('UserController  ${e.errors}');
      return Response.json(body: {'message': e.message, 'errors': e.errors}, statusCode: e.statusCode);
    } catch (e, stack) {
      stdout.writeln('UserController UNKNOWN ERROR ${stack}');
      return Response.json(
        body: {'message': 'An unexpected error occurred. Please try again later'},
        statusCode: HttpStatus.internalServerError,
      );
    }
  }

  /// Login a user
  FutureOr<Response> login(Request request) async {
    try {
      final parsedBody = await parseJson(request);
      stdout.writeln('login parsedBody start');

      stdout.writeln('login parsedBody right');
      final loginUserDto = LoginUserDto.validated(parsedBody);
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
    } catch (e, stack) {
      stdout.writeln('UserController UNKNOWN ERROR ${stack}');
      return Response.json(body: {'message': e.toString()}, statusCode: HttpStatus.internalServerError);
    }
  }

  Response _signAndSendToken(User user, [int? httpStatus]) {
    final token = _jwtService.sign(user.toJson());
    final userDto = UserDto.fromUser(user);
    return Response.json(body: {'token': token, 'user': userDto.toJson()}, statusCode: HttpStatus.created);
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
