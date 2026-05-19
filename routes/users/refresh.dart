import 'dart:io';

import 'package:backend/core/api_exceptions.dart';
import 'package:backend/features/auth/domain/session_repository.dart';
import 'package:backend/models/serializers/parse_json.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
  return refresh(context);
}

Future<Response> refresh(RequestContext context) async {
  final body = await parseJson(context.request);
  final refreshToken = RefreshTokenDto.fromJson(body);

  final sessionRepository = context.read<SessionRepository>();
  final session = await sessionRepository.getSession(
    refreshToken: refreshToken.value,
  );

  if (session == null) {
    throw const ApiException.unauthorized(
      message: 'Invalid or expired refresh token',
      code: 'INVALID_REFRESH_TOKEN',
    );
  }

  final isValidRefresh = sessionRepository.validateRefreshToken(session);

  if (!isValidRefresh) {
    throw const ApiException.unauthorized(
      message: 'Invalid or expired refresh token',
      code: 'EXPIRED_REFRESH_TOKEN',
    );
  }

  // If token is still valid, we can return it or force update.
  // Based on original logic: if valid, return accepted.
  // Original had a mix of returning existing and updateSession.

  // Checking if accessToken is still valid too
  final isValidToken = sessionRepository.validateToken(session);

  if (isValidToken && isValidRefresh) {
    return Response.json(
      body: TokensDto(
        accessToken: session.token,
        refreshToken: session.refreshToken,
      ).toJson(),
      statusCode: HttpStatus.accepted,
    );
  }

  // Otherwise update the session
  final newSession = await sessionRepository.updateSession(session);

  return Response.json(
    body: TokensDto(
      accessToken: newSession.token,
      refreshToken: newSession.refreshToken,
    ).toJson(),
    statusCode: HttpStatus.accepted,
  );
}
