import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../state/otp_state.dart';

class OtpNotifier extends StateNotifier<OtpState> {
  Timer? _timer;

  OtpNotifier() : super(const OtpState()) {
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    state = state.copyWith(timerSeconds: 30, canResend: false);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timerSeconds <= 1) {
        timer.cancel();
        state = state.copyWith(timerSeconds: 0, canResend: true);
      } else {
        state = state.copyWith(timerSeconds: state.timerSeconds - 1);
      }
    });
  }

  void setVerifying(bool value) {
    state = state.copyWith(isVerifying: value);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

