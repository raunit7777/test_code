import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpState {
  final int timerSeconds;
  final bool canResend;
  final bool isVerifying;

  const OtpState({
    this.timerSeconds = 30,
    this.canResend = false,
    this.isVerifying = false,
  });

  OtpState copyWith({
    int? timerSeconds,
    bool? canResend,
    bool? isVerifying,
  }) {
    return OtpState(
      timerSeconds: timerSeconds ?? this.timerSeconds,
      canResend: canResend ?? this.canResend,
      isVerifying: isVerifying ?? this.isVerifying,
    );
  }
}

