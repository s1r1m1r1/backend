import 'package:backend/ws_/broadcast.dart';
import 'package:dart_frog/dart_frog.dart';

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
  return updatedContext;
}
