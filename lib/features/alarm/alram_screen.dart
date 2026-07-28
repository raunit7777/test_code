import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/app_btn.dart';
import '../../core/constants/const_text.dart';


class AlarmsScreen extends StatelessWidget {
  const AlarmsScreen({super.key});

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
          'Alarms',
          fontSize: 18,
          color: AppColors.textPrimaryLight,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              // --- Center Empty State Illustration ---
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedClock01,
                      color: AppColors.textSecondaryLight,
                      size: 90.0,
                    ),
                    const SizedBox(height: 20),
                    CustomText.medium(
                      'No alarms set',
                      fontSize: 16,
                      color: AppColors.textSecondaryLight,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // --- Bottom Action Button ---
              AppBtn(
                onTap: () {
                  // Add Alarm action
                },
                borderRadius: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedAddCircle,
                      color: AppColors.textPrimaryLight,
                      size: 20.0,
                    ),
                    const SizedBox(width: 8),
                    CustomText.semiBold(
                      'Add Alarm',
                      fontSize: 16,
                      color: AppColors.textPrimaryLight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}