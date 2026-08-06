import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpState {
  final bool isLoading;
  final bool isVerifying;
  final bool isRegistering;
  final int timerSeconds;
  final bool canResend;
  final String? error;
  final String? successMessage;

  const OtpState({
    this.isLoading = false,
    this.isVerifying = false,
    this.isRegistering = false,
    this.timerSeconds = 30,
    this.canResend = false,
    this.error,
    this.successMessage,
  });

  OtpState copyWith({
    bool? isLoading,
    bool? isVerifying,
    bool? isRegistering,
    int? timerSeconds,
    bool? canResend,
    String? error,
    String? successMessage,
  }) {
    return OtpState(
      isLoading: isLoading ?? this.isLoading,
      isVerifying: isVerifying ?? this.isVerifying,
      isRegistering: isRegistering ?? this.isRegistering,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      canResend: canResend ?? this.canResend,
      error: error,
      successMessage: successMessage,
    );
  }
}