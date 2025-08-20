import 'dart:async';
import 'dart:io';

import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/user/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  return _confirmEmail(context);
}

Future<Response> _confirmEmail(RequestContext context) async {
  final userRepository = context.read<UserRepository>();
  final body =
      await context.request.uri.queryParameters as Map<String, dynamic>;
  final confirmationToken = body['token'] as String?;

  if (confirmationToken == null) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'confirmationToken is required',
    );
  }

  try {
    final user = await userRepository.confirmEmail(confirmationToken);
    return Response.json(body: user.toDto());
  } on ApiException catch (e) {
    return Response(statusCode: e.statusCode, body: e.message);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
