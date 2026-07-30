import 'package:dio/dio.dart';

import '../storage/loacal_storage.dart';
import '../utils/app_logger.dart';


class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final userId = LocalStorage.getUserId();
    if (userId != null) {
      options.headers['user-id'] = userId;
    }

    AppLogger.debug('REQUEST[${options.method}] => PATH: ${options.path}');
    AppLogger.debug('Headers: ${options.headers}');
    if (options.data != null) {
      AppLogger.debug('Body: ${options.data}');
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.debug('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    AppLogger.error('Message: ${err.message}');
    return super.onError(err, handler);
  }
}