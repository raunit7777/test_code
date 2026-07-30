import 'package:flutter_riverpod/legacy.dart';

import '../notfire/otp_notifier.dart';
import '../state/otp_state.dart';

final otpProvider = StateNotifierProvider.autoDispose<OtpNotifier, OtpState>((ref) {
  return OtpNotifier();
});