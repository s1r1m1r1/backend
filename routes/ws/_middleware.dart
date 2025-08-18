import 'package:backend/user/active_sessions_repository.dart';
import 'package:backend/ws_/logic/active_users.bloc.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:get_it/get_it.dart';

// for all users , create one for all
var _activeSessions = GetIt.I.get<ActiveSessionsRepository>();
var _activeUsersBloc = GetIt.I.get<ActiveUsersBloc>();

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
  var updatedContext = context.provide<ActiveSessionsRepository>(
    () => _activeSessions,
  );
  updatedContext = updatedContext.provide<ActiveUsersBloc>(
    () => _activeUsersBloc,
  );
  return updatedContext;
}
