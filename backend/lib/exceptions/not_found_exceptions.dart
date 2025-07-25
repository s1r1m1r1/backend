// TODO Implement this library.
import 'dart:io';

import 'http_exceptions.dart';

class NotFoundException extends HttpException {
  const NotFoundException(String message) : super(message, HttpStatus.notFound);
}
