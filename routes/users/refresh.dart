import 'dart:async' show FutureOr;
import 'dart:io';

import '../../lib/core/new_api_exceptions.dart';
import '../../lib/models/serializers/parse_json.dart';
import '../../lib/core/log_colors.dart';
import '../../lib/session/session_repository.dart';
import 'package:dart_frog/dart_frog.dart' as frog;
import 'package:dart_frog/dart_frog.dart';
import 'package:sha_red/sha_red.dart';

FutureOr<frog.Response> onRequest(frog.RequestContext context) {
  return switch (context.request.method) {
    frog.HttpMethod.post => refresh(context),
    _ => Future.value(frog.Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

FutureOr<Response> refresh(RequestContext context) async {
  try {
    stdout.writeln('$magenta [refresh] Incoming request $reset');
    final body = await parseJson(context.request);
    stdout.writeln('$magenta [refresh] Parsed body: ${body.toString()} $reset');
    final refreshDto = RefreshDto.fromJson(body);

    final sessionRepository = context.read<SessionRepository>();
    stdout.writeln('$magenta [refresh] Looking up session for refreshToken: ${refreshDto.refreshToken} $reset');
    final session = await sessionRepository.getSession(refreshToken: refreshDto.refreshToken);
    if (session == null) {
      stdout.writeln("$red [refresh] Invalid or expired refresh token: ${refreshDto.refreshToken} $reset");
      return Response.json(body: {'message': 'Invalid or expired refresh token'}, statusCode: HttpStatus.unauthorized);
    }
    stdout.writeln('$magenta [refresh] Session found for userId: ${session.userId} $reset');
    final newSession = await sessionRepository.updateSession(session); // Implement this
    stdout.writeln(
      '$magenta [refresh] New session issued: accessToken=${newSession.token}, refreshToken=${newSession.refreshToken} $reset',
    );

    return Response.json(
      body: TokenDto(accessToken: newSession.token, refreshToken: newSession.refreshToken).toJson(),
      statusCode: HttpStatus.accepted,
    );
  } on ApiException catch (e, stack) {
    stdout.writeln('$red [refresh] ApiException: ${e.errors} ${stack} $reset');
    return Response.json(body: {'message': e.message, 'errors': e.errors}, statusCode: e.statusCode);
  } catch (e, stack) {
    stdout.writeln('$red [refresh] UNKNOWN ERROR: $e ${stack} $reset');
    return Response.json(
      body: {'message': 'An unexpected error occurred. Please try again later'},
      statusCode: HttpStatus.internalServerError,
    );
  }
}
