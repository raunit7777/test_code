// import 'package:dio/dio.dart';
//
// import '../errors/app_exception.dart';
//
// class ApiClient {
//   final Dio _dio;
//
//   ApiClient(this._dio);
//
//   Future<Response> get(
//       String path, {
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//         CancelToken? cancelToken,
//       }) async {
//     try {
//       final response = await _dio.get(
//         path,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//       );
//       return _handleResponse(response);
//     } on DioException catch (e) {
//       throw _handleDioError(e);
//     }
//   }
//
//   Future<Response> post(
//       String path, {
//         dynamic data,
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//         CancelToken? cancelToken,
//       }) async {
//     try {
//       final response = await _dio.post(
//         path,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//       );
//       return _handleResponse(response);
//     } on DioException catch (e) {
//       throw _handleDioError(e);
//     }
//   }
//
//   Future<Response> put(
//       String path, {
//         dynamic data,
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//         CancelToken? cancelToken,
//       }) async {
//     try {
//       final response = await _dio.put(
//         path,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//       );
//       return _handleResponse(response);
//     } on DioException catch (e) {
//       throw _handleDioError(e);
//     }
//   }
//
//   Future<Response> delete(
//       String path, {
//         dynamic data,
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//         CancelToken? cancelToken,
//       }) async {
//     try {
//       final response = await _dio.delete(
//         path,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//       );
//       return _handleResponse(response);
//     } on DioException catch (e) {
//       throw _handleDioError(e);
//     }
//   }
//
//   Response _handleResponse(Response response) {
//     final code = response.statusCode;
//
//     if (code == null) {
//       throw AppException('Unknown Error');
//     }
//
//     switch (code) {
//       case 200:
//       case 201:
//       case 202:
//       case 204:
//         return response;
//
//       case 400:
//         throw BadRequestException(
//           response.data?['message'] ?? 'Bad Request',
//           code,
//         );
//
//       case 401:
//         throw UnauthorizedException(
//           response.data?['message'] ?? 'Unauthorized',
//           code,
//         );
//
//       case 403:
//         throw ForbiddenException(
//           response.data?['message'] ?? 'Access Denied',
//           code,
//         );
//
//       case 404:
//         throw NotFoundException(
//           response.data?['message'] ?? 'Data Not Found',
//           code,
//         );
//
//       case 409:
//         throw ConflictException(
//           response.data?['message'] ?? 'Conflict Error',
//           code,
//         );
//
//       case 422:
//         throw ValidationException(
//           response.data?['message'] ?? 'Validation Failed',
//           code,
//         );
//
//       case 429:
//         throw AppException('Too Many Requests', code);
//
//       case 500:
//         throw ServerException(
//           response.data?['message'] ?? 'Internal Server Error',
//           code,
//         );
//
//       case 502:
//         throw ServerException('Bad Gateway', code);
//
//       case 503:
//         throw ServerException('Service Unavailable', code);
//
//       case 504:
//         throw ServerException('Gateway Timeout', code);
//
//       default:
//         throw AppException(
//           response.data?['message'] ?? 'Something Went Wrong',
//           code,
//         );
//     }
//   }
//
//   AppException _handleDioError(DioException e) {
//     if (e.type == DioExceptionType.connectionTimeout ||
//         e.type == DioExceptionType.receiveTimeout ||
//         e.type == DioExceptionType.sendTimeout) {
//       return NetworkException('Connection Timeout');
//     } else if (e.type == DioExceptionType.connectionError) {
//       return NetworkException('No Internet Connection');
//     }
//
//     if (e.response != null) {
//       try {
//         return _handleResponseAsException(e.response!);
//       } catch (err) {
//         if (err is AppException) return err;
//         return AppException(err.toString());
//       }
//     }
//     return AppException('Network Error: ${e.message}');
//   }
//
//   AppException _handleResponseAsException(Response response) {
//     final statusCode = response.statusCode;
//     final message = response.data?['message'] ?? 'Something went wrong';
//
//     if (statusCode == 401) {
//       return UnauthorizedException(message, statusCode);
//     } else if (statusCode == 500) {
//       return ServerException(message, statusCode);
//     } else {
//       return AppException(message, statusCode);
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../features/auth/reposiotory/auth_repo.dart';
import '../../routes/app_routes.dart';
import '../di/service_locator.dart';
import '../errors/app_exception.dart';
import '../storage/loacal_storage.dart';
import 'api_endpoints.dart';

import 'package:go_router/go_router.dart';


// class ApiClient {
//   final Dio _dio;
//
//   ApiClient(this._dio) {
//     // 🔒 Automatically attach Bearer token to all requests via Interceptor
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           final token = LocalStorage.getToken();
//           if (token != null && token.isNotEmpty) {
//             options.headers['Authorization'] = 'Bearer $token';
//           }
//           options.headers['Content-Type'] = 'application/json';
//           options.headers['Accept'] = 'application/json';
//           return handler.next(options);
//         },
//         onError: (DioException e, handler) {
//           // Token expire / 401 Unauthorized par LocalStorage clear kar do
//           if (e.response?.statusCode == 401) {
//             LocalStorage.clear();
//           }
//           return handler.next(e);
//         },
//       ),
//     );
//   }
//
//   Future<Response> get(
//       String path, {
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//         CancelToken? cancelToken,
//       }) async {
//     try {
//       final response = await _dio.get(
//         path,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//       );
//       return _handleResponse(response);
//     } on DioException catch (e) {
//       throw _handleDioError(e);
//     }
//   }
//
//   Future<Response> post(
//       String path, {
//         dynamic data,
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//         CancelToken? cancelToken,
//       }) async {
//     try {
//       final response = await _dio.post(
//         path,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//       );
//       return _handleResponse(response);
//     } on DioException catch (e) {
//       throw _handleDioError(e);
//     }
//   }
//
//   Future<Response> put(
//       String path, {
//         dynamic data,
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//         CancelToken? cancelToken,
//       }) async {
//     try {
//       final response = await _dio.put(
//         path,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//       );
//       return _handleResponse(response);
//     } on DioException catch (e) {
//       throw _handleDioError(e);
//     }
//   }
//
//   Future<Response> delete(
//       String path, {
//         dynamic data,
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//         CancelToken? cancelToken,
//       }) async {
//     try {
//       final response = await _dio.delete(
//         path,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//       );
//       return _handleResponse(response);
//     } on DioException catch (e) {
//       throw _handleDioError(e);
//     }
//   }
//
//   Response _handleResponse(Response response) {
//     final code = response.statusCode;
//
//     if (code == null) {
//       throw AppException('Unknown Error');
//     }
//
//     switch (code) {
//       case 200:
//       case 201:
//       case 202:
//       case 204:
//         return response;
//
//       case 400:
//         throw BadRequestException(
//           response.data?['message'] ?? 'Bad Request',
//           code,
//         );
//
//       case 401:
//         throw UnauthorizedException(
//           response.data?['message'] ?? 'Unauthorized',
//           code,
//         );
//
//       case 403:
//         throw ForbiddenException(
//           response.data?['message'] ?? 'Access Denied',
//           code,
//         );
//
//       case 404:
//         throw NotFoundException(
//           response.data?['message'] ?? 'Data Not Found',
//           code,
//         );
//
//       case 409:
//         throw ConflictException(
//           response.data?['message'] ?? 'Conflict Error',
//           code,
//         );
//
//       case 422:
//         throw ValidationException(
//           response.data?['message'] ?? 'Validation Failed',
//           code,
//         );
//
//       case 429:
//         throw AppException('Too Many Requests', code);
//
//       case 500:
//         throw ServerException(
//           response.data?['message'] ?? 'Internal Server Error',
//           code,
//         );
//
//       case 502:
//         throw ServerException('Bad Gateway', code);
//
//       case 503:
//         throw ServerException('Service Unavailable', code);
//
//       case 504:
//         throw ServerException('Gateway Timeout', code);
//
//       default:
//         throw AppException(
//           response.data?['message'] ?? 'Something Went Wrong',
//           code,
//         );
//     }
//   }
//
//   AppException _handleDioError(DioException e) {
//     if (e.type == DioExceptionType.connectionTimeout ||
//         e.type == DioExceptionType.receiveTimeout ||
//         e.type == DioExceptionType.sendTimeout) {
//       return NetworkException('Connection Timeout');
//     } else if (e.type == DioExceptionType.connectionError) {
//       return NetworkException('No Internet Connection');
//     }
//
//     if (e.response != null) {
//       try {
//         return _handleResponseAsException(e.response!);
//       } catch (err) {
//         if (err is AppException) return err;
//         return AppException(err.toString());
//       }
//     }
//     return AppException('Network Error: ${e.message}');
//   }
//
//   AppException _handleResponseAsException(Response response) {
//     final statusCode = response.statusCode;
//     final message = response.data?['message'] ?? 'Something went wrong';
//
//     if (statusCode == 401) {
//       return UnauthorizedException(message, statusCode);
//     } else if (statusCode == 500) {
//       return ServerException(message, statusCode);
//     } else {
//       return AppException(message, statusCode);
//     }
//   }
// }



class ApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          // 🟢 FIX: Requests me Access Token (getToken) jana chahiye, Refresh Token nahi!
          final token = LocalStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            debugPrint("🔑 [ApiClient] Attached Bearer Access Token to Header");
          } else {
            debugPrint("⚠️ [ApiClient] No Access Token found in LocalStorage");
          }

          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          debugPrint("🔴 [ApiClient Error] Status Code: ${e.response?.statusCode}");
          debugPrint("🔴 [ApiClient Error Path]: ${e.requestOptions.path}");

          // 🟢 401 Unauthorized Handling
          if (e.response?.statusCode == 401) {
            final path = e.requestOptions.path.toLowerCase();

            // Refresh, Login, ya Verify OTP khud 401 de to loop roko aur Logout kar do
            if (path.contains('refresh') || path.contains('login') || path.contains('verify-otp')) {
              debugPrint("⛔ [401 Interceptor] Auth/Refresh endpoint failed. Navigating to Login...");
              await _logoutAndNavigateToLogin();
              return handler.next(e);
            }

            try {
              final String? refreshToken = LocalStorage.getRefreshToken();
              debugPrint("🔄 [401 Interceptor] Retrying with Refresh Token: $refreshToken");

              if (refreshToken != null && refreshToken.isNotEmpty) {
                // 🚀 Direct AuthRepository refresh call
                final responseData = await sl<AuthRepository>().refresh({
                  "refreshToken": refreshToken,
                });

                debugPrint("📦 [Refresh API Raw Response]: $responseData");

                final bool isSuccess = responseData['success'] == true ||
                    responseData['status'].toString() == "1";

                if (isSuccess) {
                  final data = responseData['data'];
                  final newAccessToken = data['accessToken']?.toString() ?? '';
                  final newRefreshToken = data['refreshToken']?.toString() ?? refreshToken;
                  final userId = data['user']?['id']?.toString();

                  debugPrint("✅ [Refresh Success] Saving New Access Token: $newAccessToken");

                  // Save New Tokens
                  await LocalStorage.saveAuthData(
                    token: newAccessToken,
                    refreshToken: newRefreshToken,
                    userId: userId,
                  );

                  // Update Header in Failed Request & Retry Original API
                  e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                  debugPrint("🔁 [401 Interceptor] Retrying original API: ${e.requestOptions.path}");

                  final clonedRequest = await _dio.fetch(e.requestOptions);
                  return handler.resolve(clonedRequest);
                } else {
                  debugPrint("❌ [Refresh Failed] Backend returned success = false");
                  await _logoutAndNavigateToLogin();
                }
              } else {
                debugPrint("❌ [Refresh Failed] No Refresh Token found in Local Storage");
                await _logoutAndNavigateToLogin();
              }
            } catch (err) {
              debugPrint("💥 [Refresh Exception]: $err");
              await _logoutAndNavigateToLogin();
              return handler.next(e);
            }
          }

          return handler.next(e);
        },
      ),
    );
  }
  Future<void> _logoutAndNavigateToLogin() async {
    await LocalStorage.clear();
    final context = rootNavigatorKey.currentContext;
    if (context != null && context.mounted) {
      context.goNamed('login');
    }
  }
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