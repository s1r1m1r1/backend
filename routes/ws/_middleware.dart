import 'package:backend/features/arena/arena.broadcast.dart';
import 'package:backend/features/online/active_users/active_users.broadcast.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:get_it/get_it.dart';

final _activeUsersBloc = GetIt.I.get<ActiveUsersBroad>();
final _arenaBroadcast = GetIt.I.get<ArenaBroadcast>();

Handler middleware(Handler handler) {
  // return sessionMiddleware(handler, addToContext: [_addToContext]);
  return (context) {
    var updatedContext = _addToContext(context);
    return handler(updatedContext);
  };
}

RequestContext _addToContext(RequestContext context) {
  var updatedContext = context.provide<ActiveUsersBroad>(
    () => _activeUsersBloc,
  );
  updatedContext = updatedContext.provide<ArenaBroadcast>(
    () => _arenaBroadcast,
  );
  return updatedContext;
}
