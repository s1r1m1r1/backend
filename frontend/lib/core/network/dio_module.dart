import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/domain/auth_repository.dart';
import 'auth_interceptor.dart';
import 'network_constants.dart';

// iOS
final host = '127.0.0.1';
// android
final host2 = '127.0.2.2';

final host3 = 'localhost';

@module
abstract class DioModule {
  @Named('withToken')
  @lazySingleton
  Dio dio(AuthRepository authRepository, @Named('retryDio') Dio retryDio) {
    final dio = Dio(BaseOptions(baseUrl: HttpConst.baseUrl));
    dio.interceptors.add(AuthInterceptor(authRepository, retryDio));
    return dio;
  }

  @lazySingleton
  @Named('registration')
  Dio registrationDio() {
    final dio = Dio(BaseOptions(baseUrl: HttpConst.baseUrl));
    dio.interceptors.add(RegistrationInterceptor());
    return dio;
  }

  @lazySingleton
  @Named('retryDio')
  Dio retryDio() {
    final dio = Dio(BaseOptions(baseUrl: HttpConst.baseUrl));
    // dio.interceptors.add(RetryInterceptor());
    return dio;
  }
}
