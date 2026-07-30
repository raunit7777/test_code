import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/auth/provider/otp_provider.dart';

import '../../core/constants/app_btn.dart';
import '../../core/constants/app_string.dart';
import '../../core/constants/const_text.dart';
import '../../core/constants/custom_text_feild.dart';
import '../../core/utils/utils.dart';
import '../../extensions/context_extension.dart';
import '../bottom_nav.dart';





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
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      AppStrings.otpLength,
          (_) => TextEditingController(),
    );
    _focusNodes = List.generate(
      AppStrings.otpLength,
          (_) => FocusNode(),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _getOtp() {
    return _controllers.map((c) => c.text).join();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < AppStrings.otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        if (_getOtp().length == AppStrings.otpLength) {
          _verifyOtp();
        }
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  void _verifyOtp() {
    final otp = _getOtp();
    if (otp.length == AppStrings.otpLength) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>  MainNavigationScreen(),
        ),
            (route) => false,
      );
    } else {
      // 👈 AppStrings used for error message
      Utils.showErrorMessage(
        context,
        AppStrings.enterCompleteOtp,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(otpProvider);

    // Responsive Dimensions via Context Extensions
    final screenH = context.screenHeight;
    final screenW = context.screenWidth;

    final fieldWidth = screenW * 0.12;
    final fieldHeight = screenH * 0.07;
    final horizontalPadding = screenW * 0.06;

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
          onPressed: () => Navigator.of(context).maybePop(),
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
              SizedBox(height: screenH * 0.025),

              // Title Header
              CustomText.bold(
                AppStrings.verifyOtpTitle, // 👈 AppStrings
                color: AppColors.textPrimaryLight,
                fontSize: screenW * 0.07,
              ),

              SizedBox(height: screenH * 0.012),

              // Subtitle with Phone Number
              RichText(
                text: TextSpan(
                  text: AppStrings.codeSentTo, // 👈 AppStrings
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: screenW * 0.038,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: widget.phoneNumber,
                      style: TextStyle(
                        color: AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenH * 0.05),

              // 6-Digit TextField Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  AppStrings.otpLength,
                      (index) => ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _controllers[index],
                    builder: (context, value, child) {
                      final bool isFilled = value.text.isNotEmpty;

                      return CustomTextField(
                        width: fieldWidth,
                        height: fieldHeight,
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        contentPadding: EdgeInsets.zero,
                        fieldRadius: BorderRadius.circular(screenW * 0.035),
                        fillColor: AppColors.cardDarkBg,
                        cursorColor: AppColors.primaryPink,
                        borderSide: BorderSide(
                          color: isFilled
                              ? AppColors.primaryPink
                              : AppColors.cardBorder,
                          width: isFilled ? 1.5 : 1.0,
                        ),
                        style: TextStyle(
                          color: AppColors.textPrimaryLight,
                          fontSize: screenW * 0.055,
                          fontWeight: FontWeight.bold,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        onChanged: (val) => _onOtpChanged(val, index),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: screenH * 0.045),

              // Verify Code Button
              AppBtn(
                title: AppStrings.verifyCodeBtn, // 👈 AppStrings
                color: AppColors.primaryPink,
                borderRadius: screenW * 0.04,
                height: screenH * 0.068,
                loading: otpState.isVerifying,
                onTap: _verifyOtp,
              ),

              SizedBox(height: screenH * 0.038),

              // Resend Timer Section
              Center(
                child: otpState.canResend
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText.regular(
                      AppStrings.didntReceiveCode, // 👈 AppStrings
                      color: AppColors.textSecondaryLight,
                      fontSize: screenW * 0.035,
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(otpProvider.notifier).startTimer();
                      },
                      child: CustomText.bold(
                        AppStrings.resendCode, // 👈 AppStrings
                        color: AppColors.primaryPink,
                        fontSize: screenW * 0.035,
                      ),
                    ),
                  ],
                )
                    : CustomText.medium(
                  '${AppStrings.resendCodeIn}${otpState.timerSeconds.toString().padLeft(2, '0')}', // 👈 AppStrings
                  color: AppColors.textSecondaryDark,
                  fontSize: screenW * 0.035,
                ),
              ),

              SizedBox(height: screenH * 0.025),
            ],
          ),
        ),
      ),
    );
  }
}