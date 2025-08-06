import 'package:backend/web_socket/broadcast.dart';
import 'package:backend/web_socket/counter_repository.dart';
import 'package:backend/inject/inject.dart';
import 'package:dart_frog/dart_frog.dart';

// for all users , create one for all
var _broadcast = Broadcast();
//
// Todo
// check token for user once for init connection
//
Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<Broadcast>((_) => _broadcast))
      .use(provider<CounterRepository>((_) => getIt<CounterRepository>()));
}
