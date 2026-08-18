// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart'; // ✅ Added GoRouter Import
// import 'package:infinity_love/core/constants/app_color.dart';
// import 'package:infinity_love/features/auth/provider/auth_provider.dart'; // ✅ Added AuthProvider
// import 'package:infinity_love/features/auth/provider/otp_provider.dart';
//
// import '../../core/constants/app_btn.dart';
// import '../../core/constants/app_string.dart';
// import '../../core/constants/const_text.dart';
// import '../../core/constants/custom_text_feild.dart';
// import '../../core/utils/utils.dart';
// import '../../extensions/context_extension.dart';
//
// class OtpScreen extends ConsumerStatefulWidget {
//   final String phoneNumber;
//
//   const OtpScreen({
//     super.key,
//     this.phoneNumber = AppStrings.defaultPhoneNumber,
//   });
//
//   @override
//   ConsumerState<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends ConsumerState<OtpScreen> {
//   late final List<TextEditingController> _controllers;
//   late final List<FocusNode> _focusNodes;
//
//   @override
//   void initState() {
//     super.initState();
//     _controllers = List.generate(
//       AppStrings.otpLength,
//           (_) => TextEditingController(),
//     );
//     _focusNodes = List.generate(
//       AppStrings.otpLength,
//           (_) => FocusNode(),
//     );
//   }
//
//   @override
//   void dispose() {
//     for (final controller in _controllers) {
//       controller.dispose();
//     }
//     for (final node in _focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }
//
//   String _getOtp() {
//     return _controllers.map((c) => c.text).join();
//   }
//
//   void _onOtpChanged(String value, int index) {
//     if (value.isNotEmpty) {
//       if (index < AppStrings.otpLength - 1) {
//         _focusNodes[index + 1].requestFocus();
//       } else {
//         _focusNodes[index].unfocus();
//         if (_getOtp().length == AppStrings.otpLength) {
//           _verifyOtp();
//         }
//       }
//     } else {
//       if (index > 0) {
//         _focusNodes[index - 1].requestFocus();
//       }
//     }
//   }
//
//   // ✅ Fixed OTP Verification Function (Hits API + Handles GoRouter Navigation)
//   void _verifyOtp() {
//     final otp = _getOtp();
//     if (otp.length == AppStrings.otpLength) {
//       // API call triggers navigation on success
//       ref.read(authProvider.notifier).verifyOtpApi(
//         widget.phoneNumber,
//         otp,
//         context,
//       );
//     } else {
//       Utils.showErrorMessage(
//         context,
//         AppStrings.enterCompleteOtp,
//       );
//     }
//   }
//
//   // ✅ Added Resend OTP Function
//   void _resendOtp() {
//     ref.read(otpProvider.notifier).startTimer();
//     ref.read(authProvider.notifier).otpSentApi(
//       widget.phoneNumber,
//       context,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final otpState = ref.watch(otpProvider);
//     final authState = ref.watch(authProvider); // ✅ Watch Auth Loading State
//
//     final screenH = context.screenHeight;
//     final screenW = context.screenWidth;
//
//     final fieldWidth = screenW * 0.12;
//     final fieldHeight = screenH * 0.07;
//     final horizontalPadding = screenW * 0.06;
//
//     return Scaffold(
//       backgroundColor: AppColors.bgBlack,
//       appBar: AppBar(
//         backgroundColor: AppColors.bgBlack,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: AppColors.textPrimaryLight,
//             size: screenW * 0.05,
//           ),
//           onPressed: () => context.pop(), // ✅ GoRouter Pop
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(
//             horizontal: horizontalPadding,
//             vertical: screenH * 0.012,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 1. Title Header
//               Padding(
//                 padding: EdgeInsets.only(top: screenH * 0.025),
//                 child: CustomText.bold(
//                   AppStrings.verifyOtpTitle,
//                   color: AppColors.textPrimaryLight,
//                   fontSize: screenW * 0.07,
//                 ),
//               ),
//
//               // 2. Subtitle with Phone Number
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: screenH * 0.012,
//                   bottom: screenH * 0.05,
//                 ),
//                 child: RichText(
//                   text: TextSpan(
//                     text: AppStrings.codeSentTo,
//                     style: TextStyle(
//                       color: AppColors.textSecondaryLight,
//                       fontSize: screenW * 0.038,
//                       height: 1.4,
//                     ),
//                     children: [
//                       TextSpan(
//                         text: " ${widget.phoneNumber}",
//                         style: const TextStyle(
//                           color: AppColors.textPrimaryLight,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // 3. 6-Digit Row
//               Padding(
//                 padding: EdgeInsets.only(bottom: screenH * 0.045),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: List.generate(
//                     AppStrings.otpLength,
//                         (index) => ValueListenableBuilder<TextEditingValue>(
//                       valueListenable: _controllers[index],
//                       builder: (context, value, child) {
//                         final bool isFilled = value.text.isNotEmpty;
//
//                         return CustomTextField(
//                           width: fieldWidth,
//                           height: fieldHeight,
//                           controller: _controllers[index],
//                           focusNode: _focusNodes[index],
//                           keyboardType: TextInputType.number,
//                           textAlign: TextAlign.center,
//                           contentPadding: EdgeInsets.zero,
//                           fieldRadius: BorderRadius.circular(screenW * 0.035),
//                           fillColor: AppColors.cardDarkBg,
//                           cursorColor: AppColors.primaryPink,
//                           borderSide: BorderSide(
//                             color: isFilled
//                                 ? AppColors.primaryPink
//                                 : AppColors.cardBorder,
//                             width: isFilled ? 1.5 : 1.0,
//                           ),
//                           style: TextStyle(
//                             color: AppColors.textPrimaryLight,
//                             fontSize: screenW * 0.055,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           inputFormatters: [
//                             FilteringTextInputFormatter.digitsOnly,
//                             LengthLimitingTextInputFormatter(1),
//                           ],
//                           onChanged: (val) => _onOtpChanged(val, index),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//
//               // 4. Verify Code Button (Shows loader during API call)
//               Padding(
//                 padding: EdgeInsets.only(bottom: screenH * 0.038),
//                 child: AppBtn(
//                   title: AppStrings.verifyCodeBtn,
//                   color: AppColors.primaryPink,
//                   borderRadius: screenW * 0.04,
//                   height: screenH * 0.068,
//                   loading: authState.loading || otpState.isVerifying, // ✅ Show loader on API hit
//                   onTap: _verifyOtp,
//                 ),
//               ),
//
//               // 5. Resend Timer Section
//               Padding(
//                 padding: EdgeInsets.only(bottom: screenH * 0.025),
//                 child: Center(
//                   child: otpState.canResend
//                       ? Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CustomText.regular(
//                         AppStrings.didntReceiveCode,
//                         color: AppColors.textSecondaryLight,
//                         fontSize: screenW * 0.035,
//                       ),
//                       const SizedBox(width: 4),
//                       GestureDetector(
//                         onTap: _resendOtp, // ✅ Resends OTP & resets timer
//                         child: CustomText.bold(
//                           AppStrings.resendCode,
//                           color: AppColors.primaryPink,
//                           fontSize: screenW * 0.035,
//                         ),
//                       ),
//                     ],
//                   )
//                       : CustomText.medium(
//                     '${AppStrings.resendCodeIn}${otpState.timerSeconds.toString().padLeft(2, '0')}s',
//                     color: AppColors.textSecondaryDark,
//                     fontSize: screenW * 0.035,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart'; // 🟢 needed for SmsRetriever implementation
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/auth/provider/auth_provider.dart';
import 'package:infinity_love/features/auth/provider/otp_provider.dart';

import '../../core/constants/app_btn.dart';
import '../../core/constants/app_string.dart';
import '../../core/constants/const_text.dart';
import '../../core/utils/utils.dart';
import '../../extensions/context_extension.dart';

// 🟢 Wraps SmartAuth's User Consent API to satisfy Pinput's SmsRetriever interface (pinput v6+)
class _UserConsentSmsRetriever implements SmsRetriever {
  _UserConsentSmsRetriever(this.smartAuth);
  final SmartAuth smartAuth;

  @override
  bool get listenForMultipleSms => false;

  @override
  Future<void> dispose() {
    return smartAuth.removeUserConsentApiListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final res = await smartAuth.getSmsWithUserConsentApi();
    if (res.hasData) {
      return res.requireData.code;
    }
    return null;
  }
}

class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpScreen({
    super.key,
    this.phoneNumber = AppStrings.defaultPhoneNumber,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  late final TextEditingController _otpController;
  late final FocusNode _focusNode;
  late final _UserConsentSmsRetriever _smsRetriever; // 🟢

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _focusNode = FocusNode();
    _smsRetriever = _UserConsentSmsRetriever(SmartAuth.instance); // 🟢 fixed: SmartAuth is a singleton, use .instance not a constructor
  }
  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    final otp = _otpController.text;
    if (otp.length == AppStrings.otpLength) {
      ref.read(authProvider.notifier).verifyOtpApi(
        widget.phoneNumber,
        otp,
        context,
      );
    } else {
      Utils.showErrorMessage(
        context,
        AppStrings.enterCompleteOtp,
      );
    }
  }

  void _resendOtp() {
    _otpController.clear();
    ref.read(otpProvider.notifier).startTimer();
    ref.read(authProvider.notifier).otpSentApi(
      widget.phoneNumber,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(otpProvider);
    final authState = ref.watch(authProvider);

    final screenH = context.screenHeight;
    final screenW = context.screenWidth;
    final horizontalPadding = screenW * 0.06;

    final defaultPinTheme = PinTheme(
      width: screenW * 0.12,
      height: screenH * 0.07,
      textStyle: TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: screenW * 0.055,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardDarkBg,
        borderRadius: BorderRadius.circular(screenW * 0.035),
        border: Border.all(color: AppColors.cardBorder, width: 1.0),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.primaryPink, width: 1.5),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.primaryPink, width: 1.5),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      appBar: AppBar(
        backgroundColor: AppColors.bgBlack,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimaryLight,
            size: screenW * 0.05,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: screenH * 0.012,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Title Header
              Padding(
                padding: EdgeInsets.only(top: screenH * 0.025),
                child: CustomText.bold(
                  AppStrings.verifyOtpTitle,
                  color: AppColors.textPrimaryLight,
                  fontSize: screenW * 0.07,
                ),
              ),

              // 2. Subtitle with Phone Number
              Padding(
                padding: EdgeInsets.only(
                  top: screenH * 0.012,
                  bottom: screenH * 0.05,
                ),
                child: RichText(
                  text: TextSpan(
                    text: AppStrings.codeSentTo,
                    style: TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontSize: screenW * 0.038,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: " ${widget.phoneNumber}",
                        style: const TextStyle(
                          color: AppColors.textPrimaryLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. OTP Pin Field with SMS Autofill (User Consent API)
              Padding(
                padding: EdgeInsets.only(bottom: screenH * 0.045),
                child: Center(
                  child: Pinput(
                    length: AppStrings.otpLength,
                    controller: _otpController,
                    focusNode: _focusNode,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,

                    // 🟢 pinput v6 API: pass the SmsRetriever implementation
                    smsRetriever: _smsRetriever,

                    onCompleted: (pin) {
                      _verifyOtp();
                    },
                  ),
                ),
              ),

              // 4. Verify Code Button
              Padding(
                padding: EdgeInsets.only(bottom: screenH * 0.038),
                child: AppBtn(
                  title: AppStrings.verifyCodeBtn,
                  color: AppColors.primaryPink,
                  borderRadius: screenW * 0.04,
                  height: screenH * 0.068,
                  loading: authState.loading || otpState.isVerifying,
                  onTap: _verifyOtp,
                ),
              ),

              // 5. Resend Timer Section
              Padding(
                padding: EdgeInsets.only(bottom: screenH * 0.025),
                child: Center(
                  child: otpState.canResend
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText.regular(
                        AppStrings.didntReceiveCode,
                        color: AppColors.textSecondaryLight,
                        fontSize: screenW * 0.035,
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: _resendOtp,
                        child: CustomText.bold(
                          AppStrings.resendCode,
                          color: AppColors.primaryPink,
                          fontSize: screenW * 0.035,
                        ),
                      ),
                    ],
                  )
                      : CustomText.medium(
                    '${AppStrings.resendCodeIn}${otpState.timerSeconds.toString().padLeft(2, '0')}s',
                    color: AppColors.textSecondaryDark,
                    fontSize: screenW * 0.035,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}