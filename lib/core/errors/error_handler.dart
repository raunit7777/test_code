import 'package:dio/dio.dart';

import '../utils/app_logger.dart';
import 'app_exception.dart';


class ErrorHandler {
  static AppException handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is AppException) {
      return error;
    } else {
      AppLogger.error("Unexpected Error", error);
      return AppException(error.toString());
    }
  }

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException("Connection timed out");
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? "Server error";
        return AppException(message, statusCode);
      case DioExceptionType.cancel:
        return AppException("Request cancelled");
      case DioExceptionType.connectionError:
        return NetworkException("No internet connection");
      default:
        return AppException("Something went wrong");
    }
  }
}