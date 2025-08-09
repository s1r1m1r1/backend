import '../../lib/middlewares/session_middleware_.dart';
import '../../lib/web_socket/broadcast.dart';
import '../../lib/web_socket/counter_repository.dart';
import '../../lib/inject/inject.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:path/path.dart';

// for all users , create one for all
var _broadcast = Broadcast();
//
// Todo
// check token for user once for init connection
//
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
  var updatedContext = context.provide<Broadcast>(() => _broadcast);
  updatedContext = updatedContext.provide<CounterRepository>(() => getIt<CounterRepository>());
  return updatedContext;
}
