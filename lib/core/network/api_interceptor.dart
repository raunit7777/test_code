import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/loacal_storage.dart';
import '../utils/app_logger.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final userId = LocalStorage.getUserId();
    if (userId != null && userId.isNotEmpty) {
      options.headers['user-id'] = userId;
    }

    if (kDebugMode) {
      AppLogger.debug('REQUEST[${options.method}] => PATH: ${options.path}');
      // Redact sensitive headers before logging
      final sanitizedHeaders = Map<String, dynamic>.from(options.headers);
      if (sanitizedHeaders.containsKey('Authorization')) {
        sanitizedHeaders['Authorization'] = 'Bearer [REDACTED]';
      }
      if (sanitizedHeaders.containsKey('refreshToken')) {
        sanitizedHeaders['refreshToken'] = '[REDACTED]';
      }
      AppLogger.debug('Headers: $sanitizedHeaders');
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      AppLogger.debug(
          'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      AppLogger.error(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    }
    return super.onError(err, handler);
  }
}
