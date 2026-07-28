import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/app_btn.dart';
import '../../core/constants/const_text.dart';


class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimaryLight,
            size: 24.0,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: CustomText.bold(
          'Help & Support',
          fontSize: 18,
          color: AppColors.textPrimaryLight,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // --- Circular Question Mark Icon Badge ---
                    Center(
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryPink,
                            width: 2.5,
                          ),
                        ),
                        child:  Center(
                          child: CustomText.bold(
                            '?',
                            fontSize: 32,
                            color: AppColors.primaryPink,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- Heading & Description ---
                    CustomText.bold(
                      'How can we help?',
                      fontSize: 24,
                      color: AppColors.textPrimaryLight,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    CustomText.regular(
                      'Our support team is here to help you with any questions or issues you might have.',
                      fontSize: 14,
                      height: 1.4,
                      color: AppColors.textSecondaryLight,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // --- Email Support Card ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: AppColors.cardDarkBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.cardBorder,
                          width: 0.8,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row (Icon + Title)
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2C1523),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: HugeIcon(
                                    icon: HugeIcons.strokeRoundedMail01,
                                    color: AppColors.primaryPink,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              CustomText.bold(
                                'Email Support',
                                fontSize: 18,
                                color: AppColors.textPrimaryLight,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Subtitle Description
                          CustomText.regular(
                            'Send us an email and we\'ll get back to you as soon as possible.',
                            fontSize: 13.5,
                            height: 1.4,
                            color: AppColors.textSecondaryLight,
                          ),
                          const SizedBox(height: 20),

                          // AppBtn Action Button
                          AppBtn(
                            title: 'Email Us',
                            borderRadius: 12,
                            height: 50,
                            onTap: () {
                              // Action to send email
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // --- Response Time Card ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardDarkBg.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.cardBorder,
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C1523),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedClock01,
                                color: AppColors.primaryPink,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText.bold(
                                  'Response Time',
                                  fontSize: 14,
                                  color: AppColors.textPrimaryLight,
                                ),
                                const SizedBox(height: 4),
                                CustomText.regular(
                                  'We typically respond to all inquiries within 24-48 hours.',
                                  fontSize: 12.5,
                                  color: AppColors.textSecondaryLight,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // --- Footer Copyright ---
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 8.0),
              child: CustomText.regular(
                '© 2026 Infinite love , All rights reserved.',
                fontSize: 12,
                color: AppColors.textSecondaryDark,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}