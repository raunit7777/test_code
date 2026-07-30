import 'package:flutter/material.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/app_btn.dart';
import '../../core/constants/const_text.dart';



class ReviewScreen extends StatelessWidget {
   ReviewScreen({super.key});

  /// Method to trigger the Success Popup Dialog
  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (context) =>  _SuccessDialogPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      appBar: AppBar(
        backgroundColor: AppColors.bgBlack,
        elevation: 0,
        leading: Container(
          margin:  EdgeInsets.all(8),
          decoration:  BoxDecoration(
            color: AppColors.profileCardBg,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon:  Icon(Icons.arrow_back, color: AppColors.textPrimaryLight, size: 20),
            onPressed: () {},
          ),
        ),
        centerTitle: true,
        title:  CustomText.bold(
          'Review',
          color: AppColors.textPrimaryLight,
          fontSize: 22,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child:  CustomText.semiBold(
              'Create',
              color: AppColors.primaryPink,
              fontSize: 18,
            ),
          ),
           SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with Glow Effect & Name
              Center(
                child: Column(
                  children: [
                    Container(
                      padding:  EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPink.withOpacity(0.6),
                            blurRadius: 25,
                            spreadRadius: 4,
                          ),
                        ],
                        border: Border.all(color: AppColors.primaryPink, width: 2),
                      ),
                      child:  CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          'https://picsum.photos/200',
                        ),
                      ),
                    ),
                     SizedBox(height: 12),
                     CustomText.bold(
                      'j',
                      color: AppColors.textPrimaryLight,
                      fontSize: 24,
                    ),
                  ],
                ),
              ),
               SizedBox(height: 24),

              // Personality Insights Card
              Container(
                width: double.infinity,
                padding:  EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardDarkBg,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Row(
                      children: [
                        _InsightIconHeader(),
                        SizedBox(width: 14),
                        CustomText.bold(
                          'Personality Insights',
                          color: AppColors.textPrimaryLight,
                          fontSize: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    InsightRowWidget(
                      leftLabel: 'Shy',
                      rightLabel: 'Naughty',
                      percentage: '100%',
                      progress: 1.0,
                      isLeftActive: false,
                      isRightActive: true,
                    ),
                    SizedBox(height: 18),
                    InsightRowWidget(
                      leftLabel: 'Caring',
                      rightLabel: 'Playful',
                      percentage: '73%',
                      progress: 0.35,
                      isLeftActive: true,
                      isRightActive: false,
                    ),
                    SizedBox(height: 18),
                    InsightRowWidget(
                      leftLabel: 'Mature',
                      rightLabel: 'Childish',
                      percentage: '85%',
                      progress: 0.85,
                      isLeftActive: false,
                      isRightActive: true,
                    ),
                  ],
                ),
              ),
               SizedBox(height: 24),

              // Key Traits Section
               CustomText.bold(
                'Key Traits',
                color: AppColors.textPrimaryLight,
                fontSize: 20,
              ),
               SizedBox(height: 12),

              // Kind Chip
              Container(
                padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.cardDarkBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryPink.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    _CheckIconBadge(),
                    SizedBox(width: 12),
                    CustomText.medium(
                      'Kind',
                      color: AppColors.textPrimaryLight,
                      fontSize: 16,
                    ),
                  ],
                ),
              ),

               Spacer(),

              // Bottom Action Button triggers the Popup Dialog
              AppBtn(
                onTap: () => _showSuccessPopup(context),
                borderRadius: 18,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    CustomText.bold(
                      'Create My AI Partner',
                      color: AppColors.whiteSheetBg,
                      fontSize: 18,
                    ),
                    SizedBox(width: 8),
                    _ForwardIconBadge(),
                  ],
                ),
              ),
               SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= SUCCESS POPUP DIALOG WIDGET =================

class _SuccessDialogPopup extends StatelessWidget {
   _SuccessDialogPopup();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding:  EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          // Popup Body Container
          Container(
            padding:  EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardDarkBg,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppColors.primaryPink.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 SizedBox(height: 12),

                // Circle Check Icon
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryPink,
                      width: 3,
                    ),
                  ),
                  child:  Center(
                    child: Icon(
                      Icons.check_rounded,
                      color: AppColors.primaryPink,
                      size: 60,
                    ),
                  ),
                ),

                 SizedBox(height: 28),

                // Success Title
                 CustomText.bold(
                  'Success!',
                  color: AppColors.textPrimaryLight,
                  fontSize: 28,
                  textAlign: TextAlign.center,
                ),

                 SizedBox(height: 14),

                // Subtitle Text
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomText.regular(
                    'AI partner ready! Start chatting now.',
                    color: AppColors.textSecondaryLight,
                    fontSize: 16,
                    height: 1.35,
                    textAlign: TextAlign.center,
                  ),
                ),

                 SizedBox(height: 32),

                // Chat Now Button
                AppBtn(
                  title: 'Chat Now',
                  color: AppColors.primaryPink,
                  borderRadius: 16,
                  height: 54,
                  onTap: () {
                    Navigator.of(context).pop();
                    // Navigate to Chat Screen here
                  },
                ),

                 SizedBox(height: 22),

                // Page Dots Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    _PageDot(isActive: false),
                    SizedBox(width: 8),
                    _PageDot(isActive: true),
                    SizedBox(width: 8),
                    _PageDot(isActive: false),
                  ],
                ),

                 SizedBox(height: 4),
              ],
            ),
          ),

          // Floating Top Right 'X' Close Button
          Positioned(
            top: -12,
            right: -12,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryPink,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.textPrimaryLight,
                    width: 2,
                  ),
                ),
                child:  Icon(
                  Icons.close_rounded,
                  color: AppColors.textPrimaryLight,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Page Dot Widget for Indicator
class _PageDot extends StatelessWidget {
  final bool isActive;

   _PageDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isActive ? 10 : 8,
      height: isActive ? 10 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primaryPink
            : AppColors.primaryPink.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
    );
  }
}

// ================= ISOLATED  COMPONENTS =================

class _InsightIconHeader extends StatelessWidget {
   _InsightIconHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryPink.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child:  Icon(
        Icons.bar_chart,
        color: AppColors.primaryPink,
        size: 24,
      ),
    );
  }
}

class _CheckIconBadge extends StatelessWidget {
   _CheckIconBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(4),
      decoration:  BoxDecoration(
        color: AppColors.primaryPink,
        shape: BoxShape.circle,
      ),
      child:  Icon(
        Icons.check,
        color: AppColors.whiteSheetBg,
        size: 14,
      ),
    );
  }
}

class _ForwardIconBadge extends StatelessWidget {
   _ForwardIconBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.whiteSheetBg.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child:  Icon(
        Icons.arrow_forward,
        color: AppColors.whiteSheetBg,
        size: 18,
      ),
    );
  }
}

class InsightRowWidget extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final String percentage;
  final double progress;
  final bool isLeftActive;
  final bool isRightActive;

   InsightRowWidget({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.percentage,
    required this.progress,
    required this.isLeftActive,
    required this.isRightActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText.semiBold(
              leftLabel,
              color: isLeftActive ? AppColors.textPrimaryLight : AppColors.textSecondaryDark,
              fontSize: 16,
            ),
            Container(
              padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.profileDividerColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomText.bold(
                percentage,
                color: AppColors.primaryPink,
                fontSize: 12,
              ),
            ),
            CustomText.semiBold(
              rightLabel,
              color: isRightActive ? AppColors.textPrimaryLight : AppColors.textSecondaryDark,
              fontSize: 16,
            ),
          ],
        ),
         SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.primaryPink,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPink.withOpacity(0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}