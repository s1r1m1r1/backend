import 'dart:async' show FutureOr;
import 'dart:io';

import 'package:backend/exceptions/new_api_exceptions.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:backend/other/log_colors.dart';
import 'package:backend/session/session_repository.dart';
import 'package:backend/user/repository/user_repository.dart';
import 'package:dart_frog/dart_frog.dart' as frog;
import 'package:dart_frog/dart_frog.dart';
import 'package:shared/shared.dart';

FutureOr<frog.Response> onRequest(frog.RequestContext context) {
  return switch (context.request.method) {
    frog.HttpMethod.post => refresh(context),
    _ => Future.value(frog.Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

FutureOr<Response> refresh(RequestContext context) async {
  try {
    final body = await parseJson(context.request);
    final refreshDto = RefreshDto.fromJson(body);

    final sessionRepository = context.read<SessionRepository>();
    final session = await sessionRepository.getSessionByRefreshToken(refreshDto.refreshToken);
    if (session == null) {
      stdout.writeln("Invalid or expired refresh token");
      return Response.json(body: {'message': 'Invalid or expired refresh token'}, statusCode: HttpStatus.unauthorized);
    }
    final newSession = await sessionRepository.updateSession(session); // Implement this

    return Response.json(
      body: TokenDto(accessToken: newSession.token, refreshToken: newSession.refreshToken).toJson(),
      statusCode: HttpStatus.accepted,
    );
  } on ApiException catch (e, stack) {
    stdout.writeln('$red refresh err $reset ${stack}');
    return Response.json(body: {'message': e.message, 'errors': e.errors}, statusCode: e.statusCode);
  } catch (e, stack) {
    stdout.writeln('$red refresh UNKNOWN ERROR $reset ${stack}');
    return Response.json(
      body: {'message': 'An unexpected error occurred. Please try again later'},
      statusCode: HttpStatus.internalServerError,
    );
  }
}
