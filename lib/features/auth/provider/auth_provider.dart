// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:go_router/go_router.dart';
// import 'package:infinity_love/core/di/service_locator.dart';
// import 'package:infinity_love/core/utils/utils.dart';
// import 'package:infinity_love/features/auth/reposiotory/auth_repo.dart';
// import '../../../core/storage/loacal_storage.dart';
// import '../../notification/notification_service.dart';
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
//       // 🟢 Fetch FCM Token from NotificationService dynamically
//
//       final value = await _repository.sendOtp(mobile,);
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
//             value['msg']?.toString() ??
//                 value['message']?.toString() ??
//                 "Failed to send OTP",
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
//
//       BuildContext context,
//       ) async {
//     state = state.copyWith(loading: true, error: null);
//     final String fcmToken = await NotificationService.getFcmToken();
//     debugPrint("🔥 Passing FCM Token to OTP API: $fcmToken");
//
//     final Map<String, dynamic> requestData = {
//       "mobileNumber": mobile,
//       "otp": otp,
//       "fcmToken": fcmToken,
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
//     // 1️⃣ Context ko starting me hold karein ya GoRouter reference safely save karein
//     final navigator = Navigator.of(context, rootNavigator: true);
//
//     final String? refreshToken = await LocalStorage.getRefreshToken();
//     debugPrint('👉 [STEP 1] Fetched Refresh Token: $refreshToken');
//
//     if (refreshToken == null || refreshToken.isEmpty) {
//       debugPrint('❌ [STEP 1.1] Refresh Token missing! Triggering Logout...');
//       await _forceLogout(context, 'Session expired. Please login again.');
//       return;
//     }
//
//     state = state.copyWith(loading: true, error: null);
//
//     final Map<String, dynamic> requestData = {
//       "refreshToken": refreshToken,
//     };
//
//     try {
//       debugPrint('⌛ [STEP 2] Sending Refresh API Call...');
//       final value = await _repository.refresh(requestData);
//
//       debugPrint('✅ [STEP 3] Response Received: $value');
//       state = state.copyWith(loading: false);
//
//       final bool isSuccess = value != null &&
//           (value['success'] == true || value['status'].toString() == "1");
//
//       if (isSuccess) {
//         debugPrint('🎉 [STEP 4] Refresh Token Success!');
//         final data = value['data'];
//
//         if (data != null) {
//           final newAccessToken = data['accessToken']?.toString() ?? '';
//           final newRefreshToken = data['refreshToken']?.toString() ?? refreshToken;
//           final userId = data['user']?['id']?.toString();
//
//           await LocalStorage.saveAuthData(
//             token: newAccessToken,
//             refreshToken: newRefreshToken,
//             userId: userId,
//           );
//         }
//
//         if (context.mounted) {
//           debugPrint('🚀 Redirecting User to MainNav Screen...');
//           context.goNamed('mainNav');
//         }
//       } else {
//         // 🔴 401 Status / Invalid Session Handling
//         final String msg = value?['message']?.toString() ?? "Session expired. Please login again.";
//         debugPrint('❌ [STEP 4-FAIL] Refresh Failed: $msg');
//         await _forceLogout(context, msg);
//       }
//     } catch (e, stackTrace) {
//       debugPrint('🚨 [EXCEPTION CAUGHT IN REFRESH TOKEN]: $e');
//       debugPrint('📋 [STACK TRACE]: $stackTrace');
//
//       state = state.copyWith(loading: false, error: e.toString());
//
//       // 🔴 401 Network/Server Exceptions par Clean Logout
//       await _forceLogout(context, 'Session expired. Please login again.');
//     } finally {
//       debugPrint('================ 🏁 [REFRESH TOKEN ENDED] ================');
//     }
//   }
//
//   /// Helper function to clear storage and safely navigate to login screen
//   Future<void> _forceLogout(BuildContext context, String message) async {
//     await LocalStorage.clear();
//
//     if (context.mounted) {
//       Utils.showErrorMessage(context, message);
//       // Ensure all previous routes are popped and user is routed clean to login
//       context.goNamed('login');
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:infinity_love/core/di/service_locator.dart';
import 'package:infinity_love/core/utils/utils.dart';
import 'package:infinity_love/features/auth/reposiotory/auth_repo.dart';
import '../../../core/storage/loacal_storage.dart';
import '../../notification/notification_service.dart';

// -----------------------------------------------------------------------------
// Auth State Model
// -----------------------------------------------------------------------------
class AuthState {
  final bool loading;
  final bool verifyingOtp;
  final bool registering;
  final dynamic data;
  final String? error;

  AuthState({
    this.loading = false,
    this.verifyingOtp = false,
    this.registering = false,
    this.data,
    this.error,
  });

  AuthState copyWith({
    bool? loading,
    bool? verifyingOtp,
    bool? registering,
    dynamic data,
    String? error,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      verifyingOtp: verifyingOtp ?? this.verifyingOtp,
      registering: registering ?? this.registering,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}

// -----------------------------------------------------------------------------
// Auth Provider & Notifier
// -----------------------------------------------------------------------------
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(sl<AuthRepository>());
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState());

  // ---------------------------------------------------------------------------
  // Send OTP API
  // ---------------------------------------------------------------------------
  Future<void> otpSentApi(String mobile, BuildContext context) async {
    state = state.copyWith(loading: true, error: null);

    // 🟢 Dynamic FCM Token Fetching
    final String fcmToken = await NotificationService.getFcmToken();
    debugPrint("🔥 Passing FCM Token to Send OTP API: $fcmToken");

    try {
      // 🟢 Note: If your AuthRepository accepts (mobile, fcmToken) or Map, pass it accordingly
      final value = await _repository.sendOtp(mobile);
      state = state.copyWith(loading: false);

      final bool isSuccess = value['error'].toString() == "200" ||
          value['status'].toString() == "1" ||
          value['status'] == 200 ||
          value['statusCode'] == 200 ||
          value['code'] == 200 ||
          value['success'] == true;

      if (isSuccess) {
        if (context.mounted) {
          Utils.showSuccessMessage(
            context,
            value['msg'] ?? value['message'] ?? 'OTP sent successfully',
          );
          context.pushNamed('otp', extra: mobile);
        }
      } else {
        if (context.mounted) {
          Utils.showErrorMessage(
            context,
            value['msg']?.toString() ??
                value['message']?.toString() ??
                "Failed to send OTP",
          );
        }
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      if (context.mounted) {
        Utils.showErrorMessage(context, e.toString());
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Verify OTP API
  // ---------------------------------------------------------------------------
  Future<void> verifyOtpApi(
      String mobile,
      String otp,
      BuildContext context,
      ) async {
    state = state.copyWith(loading: true, error: null);
    final String fcmToken = await NotificationService.getFcmToken();
    debugPrint("🔥 Passing FCM Token to OTP API: $fcmToken");

    final Map<String, dynamic> requestData = {
      "mobileNumber": mobile,
      "otp": otp,
      "fcmToken": fcmToken,
    };

    try {
      final value = await _repository.verifyOtp(requestData);
      state = state.copyWith(loading: false);

      if (value['success'] == true || value['status'].toString() == "1") {
        final data = value['data'];

        if (data != null) {
          final accessToken = data['accessToken']?.toString() ?? '';
          final refreshToken = data['refreshToken']?.toString() ?? '';
          final userId = data['user']?['id']?.toString();

          // 💾 Save Tokens to Storage
          await LocalStorage.saveAuthData(
            token: accessToken,
            refreshToken: refreshToken,
            userId: userId,
          );
        }

        if (context.mounted) {
          Utils.showSuccessMessage(
            context,
            value['message'] ?? 'OTP verified successfully',
          );
          context.goNamed('mainNav');
        }
      } else {
        if (context.mounted) {
          Utils.showErrorMessage(
            context,
            value['message']?.toString() ?? "Verification failed",
          );
        }
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      if (context.mounted) {
        Utils.showErrorMessage(context, e.toString());
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Refresh Token API
  // ---------------------------------------------------------------------------
  Future<void> refreshToken(BuildContext context) async {
    debugPrint('================ 🚀 [REFRESH TOKEN STARTED] ================');

    final String? refreshToken = await LocalStorage.getRefreshToken();
    debugPrint('👉 [STEP 1] Fetched Refresh Token: $refreshToken');

    if (refreshToken == null || refreshToken.isEmpty) {
      debugPrint('❌ [STEP 1.1] Refresh Token missing! Triggering Logout...');
      await _forceLogout(context, 'Session expired. Please login again.');
      return;
    }

    state = state.copyWith(loading: true, error: null);

    final Map<String, dynamic> requestData = {
      "refreshToken": refreshToken,
    };

    try {
      debugPrint('⌛ [STEP 2] Sending Refresh API Call...');
      final value = await _repository.refresh(requestData);

      debugPrint('✅ [STEP 3] Response Received: $value');
      state = state.copyWith(loading: false);

      final bool isSuccess = value != null &&
          (value['success'] == true || value['status'].toString() == "1");

      if (isSuccess) {
        debugPrint('🎉 [STEP 4] Refresh Token Success!');
        final data = value['data'];

        if (data != null) {
          final newAccessToken = data['accessToken']?.toString() ?? '';
          final newRefreshToken = data['refreshToken']?.toString() ?? refreshToken;
          final userId = data['user']?['id']?.toString();

          await LocalStorage.saveAuthData(
            token: newAccessToken,
            refreshToken: newRefreshToken,
            userId: userId,
          );
        }

        if (context.mounted) {
          debugPrint('🚀 Redirecting User to MainNav Screen...');
          context.goNamed('mainNav');
        }
      } else {
        final String msg = value?['message']?.toString() ?? "Session expired. Please login again.";
        debugPrint('❌ [STEP 4-FAIL] Refresh Failed: $msg');
        await _forceLogout(context, msg);
      }
    } catch (e, stackTrace) {
      debugPrint('🚨 [EXCEPTION CAUGHT IN REFRESH TOKEN]: $e');
      debugPrint('📋 [STACK TRACE]: $stackTrace');

      state = state.copyWith(loading: false, error: e.toString());
      await _forceLogout(context, 'Session expired. Please login again.');
    } finally {
      debugPrint('================ 🏁 [REFRESH TOKEN ENDED] ================');
    }
  }

  /// Clear storage & navigate to login screen safely
  Future<void> _forceLogout(BuildContext context, String message) async {
    await LocalStorage.clear();

    if (context.mounted) {
      Utils.showErrorMessage(context, message);
      context.goNamed('login');
    }
  }
}