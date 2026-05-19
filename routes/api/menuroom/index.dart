import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
    // return getListUnit(context);
    case HttpMethod.post:
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

// FutureOr<Response> getListUnit(RequestContext context) async {
//   try {
//     final record = await checkSession(context);
//     final user = record.$1;
//     final uRepo = context.read<PresenceManager>().broadcastID;
//     stdout.writeln('TodoController index start');
// final list = await uRepo.getListUnit(userId: user.userId);
// final selected = await uRepo.getSelectedUnit(user.userId);
// final dto = ListUnitDto(selectedId: selected?.id ?? -1, list: list);

// return Response.json(body: dto.toJson());
//   } on ApiException catch (e, stack) {
//     stdout.writeln('$yellow geListUnit $reset ${e.statusCode} $stack');
//     return Response.json(
//       body: {'message': e.toString()},
//       statusCode: e.statusCode,
//     );
//   } on Object catch (e, stack) {
//     stdout.writeln('$yellow getListUnit $reset UNKNOWN ERROR $stack');
//     return Response.json(
//       body: {'message': e.toString()},
//       statusCode: HttpStatus.internalServerError,
//     );
//   }
// }
