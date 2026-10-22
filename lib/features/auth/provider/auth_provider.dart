import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/network/api_clinet.dart';
import '../../../core/storage/loacal_storage.dart';
import '../../../core/utils/utils.dart';
import '../../../routes/app_routes.dart';
import '../../alarm/provider/alram_provider.dart';
import '../../chat/provider/chat_provider.dart';
import '../../custmization/provider/customization_provider.dart';
import '../../home/provider/features_provider.dart';
import '../../notification/notification_service.dart';
import '../../payment/provider/subcription_provider.dart';
import '../../profile/provider/profile_provider.dart';
import '../../streak/provider/streak_provider.dart';
import '../reposiotory/auth_repo.dart';

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
  final notifier = AuthNotifier(sl<AuthRepository>(), ref);
  // Wire global ApiClient force logout callback to complete provider reset
  ApiClient.onForceLogout = (reason) async {
    await notifier.completeLogout(null, reason: reason);
  };
  return notifier;
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthNotifier(this._repository, this._ref) : super(AuthState());

  // ---------------------------------------------------------------------------
  // Send OTP API
  // ---------------------------------------------------------------------------
  Future<void> otpSentApi(String mobile, BuildContext context) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final value = await _repository.sendOtp(mobile);
      state = state.copyWith(loading: false);

      final bool isSuccess = value != null &&
          (value['error'].toString() == "200" ||
              value['status'].toString() == "1" ||
              value['status'] == 200 ||
              value['statusCode'] == 200 ||
              value['code'] == 200 ||
              value['success'] == true);

      if (isSuccess) {
        if (context.mounted) {
          Utils.showSuccessMessage(
            context,
            value['msg'] ?? value['message'] ?? 'OTP sent successfully',
          );
          context.pushNamed('otp', extra: mobile);
        }
      } else {
        final errorMsg = value?['msg']?.toString() ??
            value?['message']?.toString() ??
            "Failed to send OTP";
        state = state.copyWith(error: errorMsg);
        if (context.mounted) {
          Utils.showErrorMessage(context, errorMsg);
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
  // Verify OTP API with Schema & Token Validation
  // ---------------------------------------------------------------------------
  Future<void> verifyOtpApi(
    String mobile,
    String otp,
    BuildContext context,
  ) async {
    state = state.copyWith(loading: true, error: null);

    final String fcmToken = await NotificationService.getFcmToken();

    final Map<String, dynamic> requestData = {
      "mobileNumber": mobile,
      "otp": otp,
      "fcmToken": fcmToken,
    };

    try {
      final value = await _repository.verifyOtp(requestData);
      state = state.copyWith(loading: false);

      final bool isSuccess = value != null &&
          (value['success'] == true || value['status'].toString() == "1");

      if (isSuccess && value['data'] != null && value['data'] is Map<String, dynamic>) {
        final data = value['data'] as Map<String, dynamic>;

        final accessToken = data['accessToken']?.toString().trim() ?? '';
        final refreshToken = data['refreshToken']?.toString().trim() ?? '';
        final userId = (data['user']?['id'] ??
                data['user']?['_id'] ??
                data['userId'] ??
                data['id'])
            ?.toString()
            .trim() ?? '';

        // Strict Schema Validation: tokens and user ID must be non-empty
        if (accessToken.isNotEmpty && refreshToken.isNotEmpty && userId.isNotEmpty) {
          await LocalStorage.saveAuthData(
            token: accessToken,
            refreshToken: refreshToken,
            userId: userId,
          );

          if (context.mounted) {
            Utils.showSuccessMessage(
              context,
              value['message'] ?? 'OTP verified successfully',
            );
            context.goNamed('mainNav');
          }
          return;
        } else {
          final schemaError = 'Verification failed: Incomplete authentication tokens received from server.';
          state = state.copyWith(error: schemaError);
          if (context.mounted) {
            Utils.showErrorMessage(context, schemaError);
          }
          return;
        }
      } else {
        final errorMsg = value?['message']?.toString() ?? "Verification failed";
        state = state.copyWith(error: errorMsg);
        if (context.mounted) {
          Utils.showErrorMessage(context, errorMsg);
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
  // Refresh Token API with Differentiated Error Handling
  // ---------------------------------------------------------------------------
  Future<void> refreshToken(BuildContext context) async {
    final String? refreshToken = LocalStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      await completeLogout(context, reason: 'Session expired. Please log in again.');
      return;
    }

    state = state.copyWith(loading: true, error: null);

    final Map<String, dynamic> requestData = {
      "refreshToken": refreshToken,
    };

    try {
      final value = await _repository.refresh(requestData);
      state = state.copyWith(loading: false);

      final bool isSuccess = value != null &&
          (value['success'] == true || value['status'].toString() == "1");

      if (isSuccess && value['data'] != null && value['data'] is Map<String, dynamic>) {
        final data = value['data'] as Map<String, dynamic>;
        final newAccessToken = data['accessToken']?.toString().trim() ?? '';
        final newRefreshToken = data['refreshToken']?.toString().trim() ?? refreshToken;
        final userId = (data['user']?['id'] ?? data['userId'])?.toString().trim();

        if (newAccessToken.isNotEmpty) {
          await LocalStorage.saveAuthData(
            token: newAccessToken,
            refreshToken: newRefreshToken,
            userId: userId,
          );

          if (context.mounted) {
            context.goNamed('mainNav');
          }
          return;
        }
      }

      // Backend explicitly rejected refresh
      final String msg = value?['message']?.toString() ?? "Session expired. Please log in again.";
      await completeLogout(context.mounted ? context : null, reason: msg);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());

      // Differentiate errors:
      // Only logout on explicit 401 / revoked token.
      // For timeouts, network errors, or 500 server errors, preserve session.
      bool isDefinitiveAuthFailure = false;
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        final responseBody = e.response?.data?.toString().toLowerCase() ?? '';
        if (statusCode == 401 ||
            statusCode == 403 ||
            responseBody.contains('token revoked') ||
            responseBody.contains('invalid token') ||
            responseBody.contains('token expired')) {
          isDefinitiveAuthFailure = true;
        }
      }

      if (isDefinitiveAuthFailure) {
        await completeLogout(context.mounted ? context : null, reason: 'Session expired. Please log in again.');
      } else {
        if (context.mounted) {
          Utils.showErrorMessage(
            context,
            'Unable to connect to server. Please check your internet connection.',
          );
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Complete Logout Reset
  // ---------------------------------------------------------------------------
  Future<void> completeLogout(BuildContext? context, {String? reason}) async {
    // 1. Cancel all active Dio cancel tokens
    sl<ApiClient>().cancelAllRequests(reason: reason ?? 'User logged out');

    // 2. Clear secure storage
    await LocalStorage.clear();

    // 3. Invalidate / Reset all in-memory user-scoped Riverpod providers
    try {
      _ref.invalidate(profileProvider);
      _ref.invalidate(chatNotifierProvider);
      _ref.invalidate(featuresProvider);
      _ref.invalidate(subscriptionProvider);
      _ref.invalidate(streakProvider);
      _ref.invalidate(customizationProvider);
      _ref.invalidate(alarmProvider);
    } catch (e) {
      debugPrint('⚠️ [AuthNotifier] Provider invalidation warning: $e');
    }

    state = AuthState();

    // 4. Safely navigate to Login
    final effectiveContext = context ?? rootNavigatorKey.currentContext;
    if (effectiveContext != null && effectiveContext.mounted) {
      if (reason != null && reason.isNotEmpty) {
        Utils.showErrorMessage(effectiveContext, reason);
      }
      effectiveContext.goNamed('login');
    }
  }
}
