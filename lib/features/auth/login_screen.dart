import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/app_btn.dart';
import '../../core/constants/app_string.dart';
import '../../core/constants/const_text.dart';
import '../../core/utils/utils.dart';
import '../../extensions/context_extension.dart';
import 'otp_screen.dart';

class AppConstants {
  static const int phoneLength = 10;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtpPressed() {
    final phone = _phoneController.text.trim();
    if (phone.length == AppConstants.phoneLength) {
      // OtpScreen navigation with string prefix from AppStrings
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            phoneNumber: '${AppStrings.countryPrefix} $phone',
          ),
        ),
      );
    } else {
      // Centralized Error Message via Utils
      Utils.showErrorMessage(
        context,
        AppStrings.enterValidPhone,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic Responsive Dimensions
    final screenH = context.screenHeight;
    final screenW = context.screenWidth;

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenW * 0.06,
            vertical: screenH * 0.015,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenH * 0.01),

              // Exact Custom Logo Widget Provided
              Center(
                child: Container(
                  // Screen dimensions ke % par scaling (Heights: ~24% of screen height)
                  width: context.screenHeight * 0.24,
                  height: context.screenHeight * 0.24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0B0A0F),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF2B7A).withValues(alpha: 0.15),
                        blurRadius: context.screenHeight * 0.045, // Dynamic Blur Radius
                        spreadRadius: context.screenHeight * 0.011, // Dynamic Spread
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/logo2.png',
                      width: context.screenHeight * 0.16,  // Dynamic Inner Image Size
                      height: context.screenHeight * 0.16,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.favorite,
                        color: const Color(0xFFFF2A7A),
                        size: context.screenHeight * 0.085, // Dynamic Error Icon Size
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenH * 0.025),

              // Title Section
              CustomText.bold(
                AppStrings.enterPhoneNumberTitle,
                color: AppColors.textPrimaryLight,
                fontSize: screenW * 0.065,
              ),

              SizedBox(height: screenH * 0.008),

              CustomText.regular(
                AppStrings.loginSubtitle,
                color: AppColors.textSecondaryLight,
                fontSize: screenW * 0.036,
                height: 1.35,
              ),

              SizedBox(height: screenH * 0.025),

              // Phone Number Field Label
              CustomText.semiBold(
                AppStrings.phoneNumberLabel,
                color: AppColors.textPrimaryLight,
                fontSize: screenW * 0.035,
              ),

              SizedBox(height: screenH * 0.01),

              // Phone Input Field with Country Code
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardDarkBg,
                  borderRadius: BorderRadius.circular(screenW * 0.04),
                  border: Border.all(
                    color: AppColors.cardBorder,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Country Code Dropdown/Tile
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenW * 0.035,
                        vertical: screenH * 0.016,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: AppColors.cardBorder,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomText.bold(
                            AppStrings.countryCodeIndia,
                            color: AppColors.textPrimaryLight,
                            fontSize: screenW * 0.038,
                          ),
                          SizedBox(width: screenW * 0.01),
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            color: AppColors.textSecondaryDark,
                            size: screenW * 0.05,
                          ),
                        ],
                      ),
                    ),

                    // Phone Number Input
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        style: TextStyle(
                          color: AppColors.textPrimaryLight,
                          fontSize: screenW * 0.04,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(AppConstants.phoneLength),
                        ],
                        decoration: InputDecoration(
                          hintText: AppStrings.phoneHint,
                          hintStyle: TextStyle(
                            color: AppColors.textSecondaryDark,
                            fontSize: screenW * 0.035,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenW * 0.04,
                            vertical: screenH * 0.016,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenH * 0.028),

              // Send OTP Button using AppBtn
              AppBtn(
                title: AppStrings.sendOtpBtn,
                color: AppColors.primaryPink,
                borderRadius: screenW * 0.04,
                height: screenH * 0.062,
                onTap: _onSendOtpPressed,
              ),

              SizedBox(height: screenH * 0.025),

              // Footer Disclaimer / Terms Text
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenW * 0.04),
                  child: CustomText.regular(
                    AppStrings.termsDisclaimer,
                    color: AppColors.textSecondaryDark,
                    fontSize: screenW * 0.03,
                    textAlign: TextAlign.center,
                    height: 1.35,
                  ),
                ),
              ),

              SizedBox(height: screenH * 0.015),
            ],
          ),
        ),
      ),
    );
  }
}