import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/reposiotory/auth_repo.dart';
import '../../routes/app_routes.dart';
import '../di/service_locator.dart';
import '../errors/app_exception.dart';
import '../storage/loacal_storage.dart';

class ApiClient {
  final Dio _dio;

  // Active CancelTokens to support cancellation of all in-flight requests on logout
  final Set<CancelToken> _activeCancelTokens = {};

  // Global callback for complete logout (to reset Riverpod providers, etc.)
  static Future<void> Function(String reason)? onForceLogout;

  ApiClient(this._dio) {
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = LocalStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (kDebugMode) {
            debugPrint("🔴 [ApiClient Error] Status Code: ${e.response?.statusCode} | Path: ${e.requestOptions.path}");
          }

          // 🟢 401 Unauthorized Handling & Token Refresh
          if (e.response?.statusCode == 401) {
            final path = e.requestOptions.path.toLowerCase();

            // Do not attempt refresh on auth endpoints themselves
            if (path.contains('refresh') || path.contains('login') || path.contains('verify-otp')) {
              if (kDebugMode) {
                debugPrint("⛔ [401 Interceptor] Auth endpoint returned 401. Triggering session reset...");
              }
              await handleCompleteLogout('Authentication failed.');
              return handler.next(e);
            }

            final String? refreshToken = LocalStorage.getRefreshToken();
            if (refreshToken == null || refreshToken.isEmpty) {
              if (kDebugMode) {
                debugPrint("❌ [401 Interceptor] No Refresh Token available. Triggering Logout...");
              }
              await handleCompleteLogout('Session expired. Please log in again.');
              return handler.next(e);
            }

            try {
              if (kDebugMode) {
                debugPrint("🔄 [401 Interceptor] Attempting token refresh...");
              }

              final responseData = await sl<AuthRepository>().refresh({
                "refreshToken": refreshToken,
              });

              final bool isSuccess = responseData != null &&
                  (responseData['success'] == true || responseData['status'].toString() == "1");

              if (isSuccess && responseData['data'] != null) {
                final data = responseData['data'];
                final newAccessToken = data['accessToken']?.toString() ?? '';
                final newRefreshToken = data['refreshToken']?.toString() ?? refreshToken;
                final userId = data['user']?['id']?.toString() ?? data['userId']?.toString();

                if (newAccessToken.isNotEmpty) {
                  await LocalStorage.saveAuthData(
                    token: newAccessToken,
                    refreshToken: newRefreshToken,
                    userId: userId,
                  );

                  if (kDebugMode) {
                    debugPrint("✅ [Refresh Success] Tokens refreshed successfully. Retrying original request...");
                  }

                  e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                  final clonedRequest = await _dio.fetch(e.requestOptions);
                  return handler.resolve(clonedRequest);
                }
              }

              // Backend explicitly rejected refresh
              if (kDebugMode) {
                debugPrint("❌ [Refresh Failed] Backend rejected refresh token.");
              }
              await handleCompleteLogout('Session expired. Please log in again.');
              return handler.next(e);
            } catch (err) {
              // Differentiate refresh errors:
              // Only trigger logout on explicit 401 / token revoked / invalid token.
              // For timeouts, socket exceptions, or 500 errors, preserve session and return a recoverable error.
              bool isDefinitiveAuthFailure = false;

              if (err is DioException) {
                final statusCode = err.response?.statusCode;
                final responseBody = err.response?.data?.toString().toLowerCase() ?? '';

                if (statusCode == 401 ||
                    statusCode == 403 ||
                    responseBody.contains('invalid token') ||
                    responseBody.contains('token revoked') ||
                    responseBody.contains('token expired') ||
                    responseBody.contains('unauthorized')) {
                  isDefinitiveAuthFailure = true;
                }
              }

              if (isDefinitiveAuthFailure) {
                if (kDebugMode) {
                  debugPrint("⛔ [Refresh Error] Refresh token is revoked or expired. Logging out...");
                }
                await handleCompleteLogout('Session expired. Please log in again.');
              } else {
                if (kDebugMode) {
                  debugPrint("⚠️ [Refresh Error] Recoverable network/server error during refresh: $err. Preserving session.");
                }
              }

              return handler.next(e);
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  /// Cancels all ongoing Dio network requests
  void cancelAllRequests({String reason = 'Session terminated'}) {
    for (final token in _activeCancelTokens) {
      if (!token.isCancelled) {
        token.cancel(reason);
      }
    }
    _activeCancelTokens.clear();
  }

  /// Complete logout reset: cancels pending requests, purges secure storage,
  /// invokes application-level provider reset, and safely routes to login.
  Future<void> handleCompleteLogout(String reason) async {
    cancelAllRequests(reason: reason);
    await LocalStorage.clear();

    if (onForceLogout != null) {
      try {
        await onForceLogout!(reason);
      } catch (e) {
        debugPrint('⚠️ Error in onForceLogout callback: $e');
      }
    } else {
      final context = rootNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        context.goNamed('login');
      }
    }
  }

  CancelToken _registerCancelToken(CancelToken? providedToken) {
    final token = providedToken ?? CancelToken();
    _activeCancelTokens.add(token);
    return token;
  }

  void _unregisterCancelToken(CancelToken token) {
    _activeCancelTokens.remove(token);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final effectiveToken = _registerCancelToken(cancelToken);
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: effectiveToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } finally {
      _unregisterCancelToken(effectiveToken);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final effectiveToken = _registerCancelToken(cancelToken);
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: effectiveToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } finally {
      _unregisterCancelToken(effectiveToken);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final effectiveToken = _registerCancelToken(cancelToken);
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: effectiveToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } finally {
      _unregisterCancelToken(effectiveToken);
    }
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final effectiveToken = _registerCancelToken(cancelToken);
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: effectiveToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } finally {
      _unregisterCancelToken(effectiveToken);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final effectiveToken = _registerCancelToken(cancelToken);
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: effectiveToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } finally {
      _unregisterCancelToken(effectiveToken);
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
