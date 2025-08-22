import 'dart:async';
import 'dart:io';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:backend/models/validation/email_password_ext.dart';
import 'package:backend/user/http_check_session_.dart';
import 'package:backend/user/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:sha_red/sha_red.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return getListFake(context);
    case HttpMethod.post:
      return postFake(context);
    case HttpMethod.put:
    case HttpMethod.patch:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
      return Response.json(
        body: {'error': '👀 Looks like you are lost 🔦'},
        statusCode: HttpStatus.methodNotAllowed,
      );
  }
}

FutureOr<Response> getListFake(RequestContext context) async {
  try {
    final record = await checkSession(context);
    final user = record.$1;
    if (user.role != Role.admin) {
      return Response.json(statusCode: HttpStatus.forbidden);
    }
    final userRepo = context.read<UserRepository>();
    final fakes = await userRepo.getListFakes();

    debugLog(
      '$yellow geListUnit length ${fakes.length}, fakes: ${fakes.map((i) => i.toJson()).join()} $reset ',
    );
    return Response.json(
      body: fakes.map((i) => i.toJson()).toList(),
      statusCode: HttpStatus.ok,
    );
  } on ApiException catch (e, stack) {
    debugLog('$yellow geListUnit $reset ${e.statusCode} ${stack}');
    return Response.json(
      body: {'message': e.toString()},
      statusCode: e.statusCode,
    );
  } on Object catch (e, stack) {
    debugLog('$yellow getListUnit $reset UNKNOWN ERROR ${stack}');
    return Response.json(
      body: {'message': e.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  }
}

FutureOr<Response> postFake(RequestContext context) async {
  try {
    final record = await checkSession(context);
    final user = record.$1;
    if (user.role != Role.admin) {
      return Response.json(statusCode: HttpStatus.forbidden);
    }
    final body = await parseJson(context.request);
    stdout.writeln('$magenta signup 1$reset');
    final emailCredential = EmailCredentialDto.fromJson(body);
    emailCredential.onCreateValidated();

    final userRepo = context.read<UserRepository>();
    final fakes = await userRepo.createFakeUser(emailCredential);
    return Response.json(body: fakes.toJson(), statusCode: HttpStatus.ok);
  } on ApiException catch (e, stack) {
    debugLog('$yellow postFake $reset ${e.statusCode} ${stack}');
    return Response.json(
      body: {'message': e.toString()},
      statusCode: e.statusCode,
    );
  } on Object catch (e, stack) {
    debugLog('$yellow postFake $reset UNKNOWN ERROR ${stack}');
    return Response.json(
      body: {'message': e.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  }
}
