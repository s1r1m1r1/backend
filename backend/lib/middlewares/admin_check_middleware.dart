// import 'package:dart_frog/dart_frog.dart';
// import 'package:backend/user/user_repository.dart';
// import 'package:backend/session/session_repository.dart';
// import 'package:shared/shared.dart';

// Future<Response?> adminCheckMiddleware(RequestContext context) async {
//   final sessionRepo = context.read<SessionRepository>();
//   final userRepo = context.read<UserRepository>();
//   final authHeader = context.request.headers['Authorization'];
//   if (authHeader == null || !authHeader.startsWith('Bearer ')) {
//     return Response(statusCode: 401, body: 'Unauthorized');
//   }
//   final token = authHeader.substring(7);
//   final session = await sessionRepo.getSessionByToken(token);
//   if (session == null) {
//     return Response(statusCode: 401, body: 'Invalid session');
//   }
//   final user = await userRepo.getUserById(session.userId);
//   if (user == null || user.role != Role.admin) {
//     return Response(statusCode: 403, body: 'Admin access required');
//   }
//   return null; // Allow request to proceed
// }

// Handler useAdminCheck(Handler handler) {
//   return (context) async {
//     final res = await adminCheckMiddleware(context);
//     if (res != null) return res;
//     return handler(context);
//   };
// }
