import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'api_interceptor.dart';
import 'environment.dart';
import 'log_interceptor.dart' as log;

class DioModule with DioMixin implements Dio {
  DioModule._() {
    options = BaseOptions(
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      followRedirects: true,
      receiveDataWhenStatusError: true,
      baseUrl: Environment.current.apiUrl,
    );

    interceptors.add(ApiInterceptor());
    interceptors.add(log.LogInterceptor());

    httpClientAdapter = IOHttpClientAdapter();
  }

  static Dio getInstance() => DioModule._();
}
