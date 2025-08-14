import 'package:backend/user/ws_active_sessions.dart';
import 'package:backend/ws_/cubit/active_users_cubit.dart';
import 'package:backend/ws_/cubit/letter_cubit.dart';
import 'package:backend/ws_/cubit/room_manager.dart';
import 'package:dart_frog/dart_frog.dart';

// for all users , create one for all
var _activeSessions = WsActiveSessions();
var _activeUsersCubit = ActiveUsersCubit();

var _roomManager = RoomManager()..roomLetter['main'] = LetterCubit('main');

// Handler middleware(Handler handler) {
//   return sessionMiddleware(handler, addToContext: [_addToContext]);
// }

Handler middleware(Handler handler) {
  // return sessionMiddleware(handler, addToContext: [_addToContext]);
  return (context) {
    var updatedContext = _addToContext(context);
    return handler(updatedContext);
  };
}

RequestContext _addToContext(RequestContext context) {
  var updatedContext = context.provide<WsActiveSessions>(() => _activeSessions);
  updatedContext = updatedContext.provide<ActiveUsersCubit>(() => _activeUsersCubit);
  updatedContext = updatedContext.provide<RoomManager>(() => _roomManager);
  return updatedContext;
}
