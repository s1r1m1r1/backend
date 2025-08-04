import 'package:backend/chat/broadcast.dart';
import 'package:backend/chat/counter_repository.dart';
import 'package:dart_frog/dart_frog.dart';

// for all users , create one for all
var _broadcast = Broadcast();
var _counterRepository = CounterRepository();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<Broadcast>((_) => _broadcast))
      .use(provider<CounterRepository>((_) => _counterRepository));
}
