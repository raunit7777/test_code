import 'package:dio/dio.dart';

import '../errors/app_exception.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> put(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> delete(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Response _handleResponse(Response response) {
    final code = response.statusCode;

    if (code == null) {
      throw AppException('Unknown Error');
    }

    switch (code) {
      case 200:
      case 201:
      case 202:
      case 204:
        return response;

      case 400:
        throw BadRequestException(
          response.data?['message'] ?? 'Bad Request',
          code,
        );

      case 401:
        throw UnauthorizedException(
          response.data?['message'] ?? 'Unauthorized',
          code,
        );

      case 403:
        throw ForbiddenException(
          response.data?['message'] ?? 'Access Denied',
          code,
        );

      case 404:
        throw NotFoundException(
          response.data?['message'] ?? 'Data Not Found',
          code,
        );

      case 409:
        throw ConflictException(
          response.data?['message'] ?? 'Conflict Error',
          code,
        );

      case 422:
        throw ValidationException(
          response.data?['message'] ?? 'Validation Failed',
          code,
        );

      case 429:
        throw AppException('Too Many Requests', code);

      case 500:
        throw ServerException(
          response.data?['message'] ?? 'Internal Server Error',
          code,
        );

      case 502:
        throw ServerException('Bad Gateway', code);

      case 503:
        throw ServerException('Service Unavailable', code);

      case 504:
        throw ServerException('Gateway Timeout', code);

      default:
        throw AppException(
          response.data?['message'] ?? 'Something Went Wrong',
          code,
        );
    }
  }

  AppException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkException('Connection Timeout');
    } else if (e.type == DioExceptionType.connectionError) {
      return NetworkException('No Internet Connection');
    }

    if (e.response != null) {
      try {
        return _handleResponseAsException(e.response!);
      } catch (err) {
        if (err is AppException) return err;
        return AppException(err.toString());
      }
    }
    return AppException('Network Error: ${e.message}');
  }

  AppException _handleResponseAsException(Response response) {
    final statusCode = response.statusCode;
    final message = response.data?['message'] ?? 'Something went wrong';

    if (statusCode == 401) {
      return UnauthorizedException(message, statusCode);
    } else if (statusCode == 500) {
      return ServerException(message, statusCode);
    } else {
      return AppException(message, statusCode);
    }
  }
}