import 'package:dio/dio.dart';

import '../exceptions/network_exception.dart';

class DioNetworkException extends DioException implements NetworkException {
  DioNetworkException({
    required this.message,
    required this.statusCode,
    required this.errors,
    required super.requestOptions,
  });

  @override
  final int statusCode;
  @override
  // ignore: overridden_fields
  final String message;
  @override
  final Map<String, List<String>> errors;
}
