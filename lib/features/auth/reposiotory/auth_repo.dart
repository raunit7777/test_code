// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
//
// import '../../../core/network/api_clinet.dart';
// import '../../../core/network/api_endpoints.dart';
// import '../../../core/network/dio_provider.dart';
// part 'auth_repo.g.dart';
// @riverpod
// AuthRepository authRepository(Ref ref) {
//   final apiClient = ref.watch(apiClientProvider); // Inject ApiClient
//   return AuthRepository(apiClient);
// }
//
// class AuthRepository {
//   final ApiClient _apiClient;
//
//   AuthRepository(this._apiClient);
//
//   Future<dynamic> sendOtp(String mobile) async {
//     final response = await _apiClient.post(
//       ApiEndpoints.sendOtp,
//       queryParameters: {'mobileNumber': mobile},
//     );
//     return response.data;
//   }
//
//   // Future<dynamic> verifyOtp(String mobile, String otp) async {
//   //   final response = await _apiClient.get(
//   //     ApiEndpoints.verifyOtp,
//   //     queryParameters: {
//   //       'mobile': mobile,
//   //       'otp': otp,
//   //     },
//   //   );
//   //   return response.data;
//   // }
//   //
//   // Future<dynamic> login(String phone, String fcmToken) async {
//   //   final response = await _apiClient.post(
//   //     ApiEndpoints.login,
//   //     data: {
//   //       'phone': phone,
//   //       'fcm': fcmToken,
//   //     },
//   //   );
//   //   return response.data;
//   // }
//   //
//   // Future<dynamic> register(Map<String, dynamic> data) async {
//   //   final response = await _apiClient.post(
//   //     ApiEndpoints.register,
//   //     data: data,
//   //   );
//   //   return response.data;
//   // }
// }


import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_clinet.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_provider.dart';

part 'auth_repo.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient);
}

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<dynamic> sendOtp(String mobile ,) async {
    final response = await _apiClient.post(
      ApiEndpoints.sendOtp,
      data: {
        'mobileNumber': mobile, // ✅ Pass in request body/data
         // ✅ Pass in request body/data
      },
    );
    return response.data;
  }
  Future<dynamic> verifyOtp(dynamic data) async {
    final response = await _apiClient.post(
      ApiEndpoints.verifyOtp,
      data:data ,
    );
    return response.data;
  }
  Future<dynamic> refresh(dynamic data) async {
    print('================ [REFRESH TOKEN STARTED] ================');
    print('👉 [1] Endpoint URL: ${ApiEndpoints.refreshToken}');
    print('👉 [2] Payload Data Sent: $data');

    try {
      print('⌛ [3] Sending POST request via ApiClient...');

      final response = await _apiClient.post(
        ApiEndpoints.refreshToken,
        data: data,
      );

      print('✅ [4] Response Received Successfully!');
      print('📊 [5] Status Code: ${response.statusCode}');
      print('📦 [6] Raw Response Data: ${response.data}');
      print('================ [REFRESH TOKEN COMPLETED] ================');

      return response.data;
    } on DioException catch (e) {
      print('❌ [ERROR] DioException in refresh(): ${e.response?.statusCode} | ${e.message}');

      // Agar 401/403/400 error aaye, toh map return karo taaki StateNotifier ka 'else' block chal sake
      if (e.response != null) {
        return e.response?.data ?? {
          "success": false,
          "message": "Session expired. Please login again."
        };
      }
      rethrow;
    } catch (e, stackTrace) {
      print('❌ [ERROR] Exception caught in refresh(): $e');
      print('🚨 [TRACE] Stack Trace: $stackTrace');
      print('================ [REFRESH TOKEN FAILED] ================');
      rethrow;
    }
  }

}