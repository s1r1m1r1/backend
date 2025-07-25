// TODO Implement this library.
abstract class HttpException implements Exception {
  const HttpException(this.message, this.statusCode);
  final String message;
  final int statusCode;

  @override
  String toString() => '$runtimeType: $message';
}
