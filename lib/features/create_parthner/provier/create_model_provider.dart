// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:go_router/go_router.dart';
// import 'package:infinity_love/core/di/service_locator.dart';
// import 'package:infinity_love/core/utils/utils.dart';
// import 'package:infinity_love/features/auth/reposiotory/auth_repo.dart';
// import '../../../core/storage/loacal_storage.dart';
//
// // -----------------------------------------------------------------------------
// // Auth State Model
// // -----------------------------------------------------------------------------
// class AuthState {
//   final bool loading;
//   final bool verifyingOtp;
//   final bool registering;
//   final dynamic data;
//   final String? error;
//
//   AuthState({
//     this.loading = false,
//     this.verifyingOtp = false,
//     this.registering = false,
//     this.data,
//     this.error,
//   });
//
//   AuthState copyWith({
//     bool? loading,
//     bool? verifyingOtp,
//     bool? registering,
//     dynamic data,
//     String? error,
//   }) {
//     return AuthState(
//       loading: loading ?? this.loading,
//       verifyingOtp: verifyingOtp ?? this.verifyingOtp,
//       registering: registering ?? this.registering,
//       data: data ?? this.data,
//       error: error ?? this.error,
//     );
//   }
// }
//
// // -----------------------------------------------------------------------------
// // Auth Provider & Notifier
// // -----------------------------------------------------------------------------
// final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
//   return AuthNotifier(sl<AuthRepository>());
// });
//
// class AuthNotifier extends StateNotifier<AuthState> {
//   final AuthRepository _repository;
//
//   AuthNotifier(this._repository) : super(AuthState());
//
//   // ---------------------------------------------------------------------------
//   // Send OTP API
//   // ---------------------------------------------------------------------------
//   Future<void> otpSentApi(String mobile, BuildContext context) async {
//     state = state.copyWith(loading: true, error: null);
//     try {
//       final value = await _repository.sendOtp(mobile);
//       state = state.copyWith(loading: false);
//
//       final bool isSuccess = value['error'].toString() == "200" ||
//           value['status'].toString() == "1" ||
//           value['status'] == 200 ||
//           value['statusCode'] == 200 ||
//           value['code'] == 200 ||
//           value['success'] == true;
//
//       if (isSuccess) {
//         if (context.mounted) {
//           Utils.showSuccessMessage(
//             context,
//             value['msg'] ?? value['message'] ?? 'OTP sent successfully',
//           );
//           context.pushNamed('otp', extra: mobile);
//         }
//       } else {
//         if (context.mounted) {
//           Utils.showErrorMessage(
//             context,
//             value['msg']?.toString() ?? value['message']?.toString() ?? "Failed to send OTP",
//           );
//         }
//       }
//     } catch (e) {
//       state = state.copyWith(loading: false, error: e.toString());
//       if (context.mounted) {
//         Utils.showErrorMessage(context, e.toString());
//       }
//     }
//   }
//
//   // ---------------------------------------------------------------------------
//   // Verify OTP API
//   // ---------------------------------------------------------------------------
//   Future<void> verifyOtpApi(
//       String mobile,
//       String otp,
//       BuildContext context,
//       ) async {
//     state = state.copyWith(loading: true, error: null);
//
//     final Map<String, dynamic> requestData = {
//       "mobileNumber": mobile,
//       "otp": otp,
//     };
//
//     try {
//       final value = await _repository.verifyOtp(requestData);
//       state = state.copyWith(loading: false);
//
//       if (value['success'] == true || value['status'].toString() == "1") {
//         final data = value['data'];
//
//         if (data != null) {
//           final accessToken = data['accessToken']?.toString() ?? '';
//           final refreshToken = data['refreshToken']?.toString() ?? '';
//           final userId = data['user']?['id']?.toString();
//
//           // 💾 Save Tokens to Storage
//           await LocalStorage.saveAuthData(
//             token: accessToken,
//             refreshToken: refreshToken,
//             userId: userId,
//           );
//         }
//
//         if (context.mounted) {
//           Utils.showSuccessMessage(
//             context,
//             value['message'] ?? 'OTP verified successfully',
//           );
//           context.goNamed('mainNav');
//         }
//       } else {
//         if (context.mounted) {
//           Utils.showErrorMessage(
//             context,
//             value['message']?.toString() ?? "Verification failed",
//           );
//         }
//       }
//     } catch (e) {
//       state = state.copyWith(loading: false, error: e.toString());
//       if (context.mounted) {
//         Utils.showErrorMessage(context, e.toString());
//       }
//     }
//   }
//
//   // ---------------------------------------------------------------------------
//   // Refresh Token API
//   // ---------------------------------------------------------------------------
//   Future<void> refreshToken(BuildContext context) async {
//     debugPrint('================ 🚀 [REFRESH TOKEN STARTED] ================');
//
//     // 1️⃣ Local Storage se token retrieve karo
//     final String? refreshToken = await LocalStorage.getRefreshToken();
//     debugPrint('👉 [STEP 1] Fetched Refresh Token from Storage: $refreshToken');
//
//     if (refreshToken == null || refreshToken.isEmpty) {
//       debugPrint('❌ [STEP 1.1] Refresh Token is NULL or Empty! Clearing Storage & Navigating to Login...');
//       await LocalStorage.clear();
//
//       if (context.mounted) {
//         Utils.showErrorMessage(context, 'Session expired. Please login again.');
//         context.goNamed('login');
//       }
//       return;
//     }
//
//     state = state.copyWith(loading: true, error: null);
//
//     final Map<String, dynamic> requestData = {
//       "refreshToken": refreshToken,
//     };
//
//     debugPrint('👉 [STEP 2] Request Payload Data: $requestData');
//
//     try {
//       debugPrint('⌛ [STEP 3] Sending Refresh API Call via Repository...');
//       final value = await _repository.refresh(requestData);
//
//       debugPrint('✅ [STEP 4] Response Received from Backend!');
//       debugPrint('📦 [STEP 4.1] Raw Response: $value');
//
//       state = state.copyWith(loading: false);
//
//       final bool isSuccess = value['success'] == true || value['status'].toString() == "1";
//
//       if (isSuccess) {
//         debugPrint('🎉 [STEP 5] Refresh Token Success Verified!');
//         final data = value['data'];
//
//         if (data != null) {
//           final newAccessToken = data['accessToken']?.toString() ?? '';
//           final newRefreshToken = data['refreshToken']?.toString() ?? refreshToken;
//           final userId = data['user']?['id']?.toString();
//
//           debugPrint('💾 [STEP 5.1] Saving New Access Token: $newAccessToken');
//           debugPrint('💾 [STEP 5.2] Saving New Refresh Token: $newRefreshToken');
//
//           await LocalStorage.saveAuthData(
//             token: newAccessToken,
//             refreshToken: newRefreshToken,
//             userId: userId,
//           );
//         }
//
//         if (context.mounted) {
//           debugPrint('🚀 [STEP 5.3] Redirecting User to MainNav Screen...');
//           context.goNamed('mainNav');
//         }
//       } else {
//         // 🔴 Response Status Fail hone par Logout + Login Navigation
//         debugPrint('❌ [STEP 5-FAIL] Refresh API returned success: false or invalid status.');
//         debugPrint('🧹 Clearing Storage & Navigating to Login...');
//
//         await LocalStorage.clear();
//
//         if (context.mounted) {
//           Utils.showErrorMessage(
//             context,
//             value['message']?.toString() ?? "Session expired. Please login again.",
//           );
//           context.goNamed('login');
//         }
//       }
//     } catch (e, stackTrace) {
//       // 🔴 Exception handling
//       debugPrint('🚨 [EXCEPTION CAUGHT IN REFRESH TOKEN]: $e');
//       debugPrint('📋 [STACK TRACE]: $stackTrace');
//       debugPrint('🧹 Clearing Local Storage & Navigating to Login Screen...');
//
//       await LocalStorage.clear();
//       state = state.copyWith(loading: false, error: e.toString());
//
//       if (context.mounted) {
//         Utils.showErrorMessage(context, 'Session expired. Please login again.');
//         context.goNamed('login');
//       }
//     } finally {
//       debugPrint('================ 🏁 [REFRESH TOKEN ENDED] ================');
//     }
//   }
// }