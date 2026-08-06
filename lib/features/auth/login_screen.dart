// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:infinity_love/core/constants/app_color.dart';
//
// import '../../core/constants/app_btn.dart';
// import '../../core/constants/app_string.dart';
// import '../../core/constants/const_text.dart';
// import '../../core/constants/custom_text_feild.dart';
// import '../../core/utils/utils.dart';
// import '../../extensions/context_extension.dart';
// import 'otp_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _PhoneLoginScreenState();
// }
//
// class _PhoneLoginScreenState extends State<LoginScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//
//   @override
//   void dispose() {
//     _phoneController.dispose();
//     super.dispose();
//   }
//
//   void _onSendOtpPressed() {
//     final phone = _phoneController.text.trim();
//     if (phone.length == AppStrings.phoneLength) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => OtpScreen(
//             phoneNumber: '${AppStrings.countryPrefix} $phone',
//           ),
//         ),
//       );
//     } else {
//       Utils.showErrorMessage(
//         context,
//         AppStrings.enterValidPhone,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenH = context.screenHeight;
//     final screenW = context.screenWidth;
//
//     return Scaffold(
//       backgroundColor: AppColors.bgBlack,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(
//             horizontal: screenW * 0.06,
//             vertical: screenH * 0.02,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 1. Logo Header Section with Bottom Padding
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: screenH * 0.01,
//                   bottom: screenH * 0.025,
//                 ),
//                 child: Center(
//                   child: Container(
//                     width: screenH * 0.24,
//                     height: screenH * 0.24,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: const Color(0xFF0B0A0F),
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0xFFFF2B7A).withValues(alpha: 0.15),
//                           blurRadius: screenH * 0.045,
//                           spreadRadius: screenH * 0.011,
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: Image.asset(
//                         'assets/logo2.png',
//                         width: screenH * 0.16,
//                         height: screenH * 0.16,
//                         fit: BoxFit.contain,
//                         errorBuilder: (context, error, stackTrace) => Icon(
//                           Icons.favorite,
//                           color: const Color(0xFFFF2A7A),
//                           size: screenH * 0.085,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // 2. Title Section
//               CustomText.bold(
//                 AppStrings.enterPhoneNumberTitle,
//                 color: AppColors.textPrimaryLight,
//                 fontSize: screenW * 0.065,
//               ),
//
//               // 3. Subtitle Section with Bottom Padding
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: screenH * 0.008,
//                   bottom: screenH * 0.025,
//                 ),
//                 child: CustomText.regular(
//                   AppStrings.loginSubtitle,
//                   color: AppColors.textSecondaryLight,
//                   fontSize: screenW * 0.036,
//                   height: 1.35,
//                 ),
//               ),
//
//               // 4. Phone Input Label
//               CustomText.semiBold(
//                 AppStrings.phoneNumberLabel,
//                 color: AppColors.textPrimaryLight,
//                 fontSize: screenW * 0.035,
//               ),
//
//               // 5. CustomTextField Integration for Phone Number Entry
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: screenH * 0.01,
//                   bottom: screenH * 0.028,
//                 ),
//                 child: CustomTextField(
//                   width: double.infinity,
//                   height: screenH * 0.068,
//                   controller: _phoneController,
//                   keyboardType: TextInputType.phone,
//                   fillColor: AppColors.cardDarkBg,
//                   fieldRadius: BorderRadius.circular(screenW * 0.04),
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: screenW * 0.035,
//                     vertical: screenH * 0.014,
//                   ),
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(AppStrings.phoneLength),
//                   ],
//                   hintText: AppStrings.phoneHint,
//                   hintSize: screenW * 0.035,
//                   style: TextStyle(
//                     color: AppColors.textPrimaryLight,
//                     fontSize: screenW * 0.04,
//                     letterSpacing: 1.2,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   prefixIcon: Container(
//                     margin: EdgeInsets.only(right: screenW * 0.02),
//                     padding: EdgeInsets.symmetric(
//                       horizontal: screenW * 0.035,
//                     ),
//                     decoration: const BoxDecoration(
//                       border: Border(
//                         right: BorderSide(
//                           color: AppColors.cardBorder,
//                           width: 1,
//                         ),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         CustomText.bold(
//                           AppStrings.countryCodeIndia,
//                           color: AppColors.textPrimaryLight,
//                           fontSize: screenW * 0.038,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(left: screenW * 0.01),
//                           child: Icon(
//                             Icons.arrow_drop_down_rounded,
//                             color: AppColors.textSecondaryDark,
//                             size: screenW * 0.05,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // 6. Action Button with Bottom Padding
//               Padding(
//                 padding: EdgeInsets.only(bottom: screenH * 0.025),
//                 child: AppBtn(
//                   title: AppStrings.sendOtpBtn,
//                   color: AppColors.primaryPink,
//                   borderRadius: screenW * 0.04,
//                   height: screenH * 0.062,
//                   onTap: _onSendOtpPressed,
//                 ),
//               ),
//
//               // 7. Footer Disclaimer Text
//               Padding(
//                 padding: EdgeInsets.only(
//                   left: screenW * 0.04,
//                   right: screenW * 0.04,
//                   bottom: screenH * 0.015,
//                 ),
//                 child: Center(
//                   child: CustomText.regular(
//                     AppStrings.termsDisclaimer,
//                     color: AppColors.textSecondaryDark,
//                     fontSize: screenW * 0.03,
//                     textAlign: TextAlign.center,
//                     height: 1.35,
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
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added Riverpod
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/auth/provider/auth_provider.dart';

import '../../core/constants/app_btn.dart';
import '../../core/constants/app_string.dart';
import '../../core/constants/const_text.dart';
import '../../core/constants/custom_text_feild.dart';
import '../../core/utils/utils.dart';
import '../../extensions/context_extension.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtpPressed() {
    final phone = _phoneController.text.trim();
    if (phone.length == AppStrings.phoneLength) {
      // API Trigger via Riverpod Provider
      ref.read(authProvider.notifier).otpSentApi(phone, context);

    } else {
      Utils.showErrorMessage(
        context,
        AppStrings.enterValidPhone,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenH = context.screenHeight;
    final screenW = context.screenWidth;

    // Auth State watch kar rahe hain loading handle karne ke liye
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenW * 0.06,
            vertical: screenH * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Logo Header Section
              Padding(
                padding: EdgeInsets.only(
                  top: screenH * 0.01,
                  bottom: screenH * 0.025,
                ),
                child: Center(
                  child: Container(
                    width: screenH * 0.24,
                    height: screenH * 0.24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF0B0A0F),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF2B7A).withValues(alpha: 0.15),
                          blurRadius: screenH * 0.045,
                          spreadRadius: screenH * 0.011,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/logo2.png',
                        width: screenH * 0.16,
                        height: screenH * 0.16,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.favorite,
                          color: const Color(0xFFFF2A7A),
                          size: screenH * 0.085,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Title Section
              CustomText.bold(
                AppStrings.enterPhoneNumberTitle,
                color: AppColors.textPrimaryLight,
                fontSize: screenW * 0.065,
              ),

              // 3. Subtitle Section
              Padding(
                padding: EdgeInsets.only(
                  top: screenH * 0.008,
                  bottom: screenH * 0.025,
                ),
                child: CustomText.regular(
                  AppStrings.loginSubtitle,
                  color: AppColors.textSecondaryLight,
                  fontSize: screenW * 0.036,
                  height: 1.35,
                ),
              ),

              // 4. Phone Input Label
              CustomText.semiBold(
                AppStrings.phoneNumberLabel,
                color: AppColors.textPrimaryLight,
                fontSize: screenW * 0.035,
              ),

              // 5. CustomTextField Integration
              Padding(
                padding: EdgeInsets.only(
                  top: screenH * 0.01,
                  bottom: screenH * 0.028,
                ),
                child: CustomTextField(
                  width: double.infinity,
                  height: screenH * 0.068,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  fillColor: AppColors.cardDarkBg,
                  fieldRadius: BorderRadius.circular(screenW * 0.04),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenW * 0.035,
                    vertical: screenH * 0.014,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(AppStrings.phoneLength),
                  ],
                  hintText: AppStrings.phoneHint,
                  hintSize: screenW * 0.035,
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: screenW * 0.04,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                  prefixIcon: Container(
                    margin: EdgeInsets.only(right: screenW * 0.02),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenW * 0.035,
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText.bold(
                          AppStrings.countryCodeIndia,
                          color: AppColors.textPrimaryLight,
                          fontSize: screenW * 0.038,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: screenW * 0.01),
                          child: Icon(
                            Icons.arrow_drop_down_rounded,
                            color: AppColors.textSecondaryDark,
                            size: screenW * 0.05,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 6. Action Button (Loading handling integrated)
              Padding(
                padding: EdgeInsets.only(bottom: screenH * 0.025),
                child: AppBtn(
                  title: AppStrings.sendOtpBtn,
                  color: AppColors.primaryPink,
                  borderRadius: screenW * 0.04,
                  height: screenH * 0.062,
                  loading: authState.loading, // Pass loading state to button if supported
                  onTap: authState.loading ? () {} : _onSendOtpPressed,
                ),
              ),

              // 7. Footer Disclaimer Text
              Padding(
                padding: EdgeInsets.only(
                  left: screenW * 0.04,
                  right: screenW * 0.04,
                  bottom: screenH * 0.015,
                ),
                child: Center(
                  child: CustomText.regular(
                    AppStrings.termsDisclaimer,
                    color: AppColors.textSecondaryDark,
                    fontSize: screenW * 0.03,
                    textAlign: TextAlign.center,
                    height: 1.35,
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