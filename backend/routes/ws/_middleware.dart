import 'package:backend/chat/broadcast.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(provider<Broadcast>((_) => Broadcast()));
}
