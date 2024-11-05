import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'base_result.dart';

class BaseRepo {
  final dio.Dio _dio;

  BaseRepo(this._dio);

  Future<BaseResult<T>> callApi<T>(
      Future<dio.Response<T>> Function() call, {
        bool isolate = false,
      }) async {
    if (isolate) {
      return await _processInIsolate<T>(call);
    } else {
      return await _callApiDirectly<T>(call());
    }
  }

  Future<BaseResult<T>> _callApiDirectly<T>(Future<dio.Response<T>> call) async {
    try {
      final response = await call;
      if ((response.statusCode ?? 0) / 100 == 2) {
        return BaseResult.success(response.data as T);
      } else {
        return BaseResult.failed(message: response.data?.toString() ?? 'Unknown Error');
      }
    } catch (e) {
      return BaseResult.failed(message: e.toString());
    }
  }

  Future<BaseResult<T>> _processInIsolate<T>(Future<dio.Response<T>> Function() call) async {
    return await compute(_computeEntryPoint<T>, call);
  }

  static Future<BaseResult<T>> _computeEntryPoint<T>(Future<dio.Response<T>> Function() call) async {
    try {
      final response = await call();
      return BaseResult.success(response.data as T);
    } catch (e) {
      return BaseResult.failed(message: e.toString());
    }
  }

  Future<BaseResult<T>> get<T>(
      String endpoint, {
        Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParameters,
        bool isolate = false,
      }) async {
    return await callApi<T>(
          () => _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: dio.Options(headers: headers),
      ),
      isolate: isolate,
    );
  }

  Future<BaseResult<T>> post<T>(
      String endpoint, {
        Map<String, dynamic>? headers,
        dynamic body,
        bool isolate = false,
      }) async {
    return await callApi<T>(
          () => _dio.post<T>(
        endpoint,
        data: body,
        options: dio.Options(headers: headers),
      ),
      isolate: isolate,
    );
  }

  Future<BaseResult<T>> delete<T>(
      String endpoint, {
        Map<String, dynamic>? headers,
        dynamic body,
        bool isolate = false,
      }) async {
    return await callApi<T>(
          () => _dio.delete<T>(
        endpoint,
        data: body,
        options: dio.Options(headers: headers),
      ),
      isolate: isolate,
    );
  }

  Future<BaseResult<T>> put<T>(
      String endpoint, {
        Map<String, dynamic>? headers,
        dynamic body,
        bool isolate = false,
      }) async {
    return await callApi<T>(
          () => _dio.put<T>(
        endpoint,
        data: body,
        options: dio.Options(headers: headers),
      ),
      isolate: isolate,
    );
  }

  Future<BaseResult<T>> postMultipart<T>(
      String endpoint, {
        Map<String, String>? headers,
        dio.FormData? body,
        bool isolate = false,
      }) async {
    return await callApi<T>(
          () => _dio.post<T>(
        endpoint,
        data: body,
        options: dio.Options(headers: headers),
      ),
      isolate: isolate,
    );
  }
}
