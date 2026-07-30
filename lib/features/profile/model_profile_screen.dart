import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import '../../core/constants/const_text.dart';
import '../chat_screen.dart';

class ModelProfileDetailScreen extends StatelessWidget {
  const ModelProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String imagePath = 'assets/21.png'; // Aapni image ka asset path rakhein

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TOP HEADER WITH BACKGROUND IMAGE & AVATAR ---
            SizedBox(
              height: 480,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // 1. Cover Image
                  Positioned.fill(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.cardDarkBg,
                        child: const Center(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedUser,
                            size: 60,
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 2. Bottom Dark Gradient Fade
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                            AppColors.bgBlack.withOpacity(0.8),
                            AppColors.bgBlack,
                          ],
                          stops: const [0.0, 0.4, 0.85, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // 3. Top Back Button
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 4. Circular Avatar Profile Picture Overlay
                  Positioned(
                    bottom: 10,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        color: AppColors.bgBlack,
                      ),
                      child: const CircleAvatar(
                        radius: 68,
                        backgroundImage: AssetImage(imagePath),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- USER INFO & DETAILS SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Age Chip Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText.bold(
                        'Ayushi',
                        fontSize: 28,
                        color: AppColors.textPrimaryLight,
                      ),

                      // Age Badge Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedBirthdayCake,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            CustomText.medium(
                              '23',
                              fontSize: 13,
                              color: AppColors.textPrimaryLight,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Location Row
                  Row(
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedLocation01,
                        color: AppColors.textSecondaryLight,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      CustomText.regular(
                        'South Delhi, India',
                        fontSize: 14,
                        color: AppColors.textSecondaryLight,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- CHAT BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatScreen(), // Apne route ka naam yahan likhein
                          ),
                        );

                        // Chat Button Action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedComment01,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          CustomText.bold(
                            'Chat with Ayushi',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // --- ABOUT ME SECTION ---
                  CustomText.bold(
                    'About Me',
                    fontSize: 20,
                    color: AppColors.textPrimaryLight,
                  ),
                  const SizedBox(height: 10),
                  CustomText.regular(
                    'Hi, I\'m Ayushi—23, born and raised in South Delhi. '
                        'I believe in long conversations, warm hugs, and the kind of love that makes your heart race. '
                        'Text me when you miss me... I promise I\'ll make you smile.',
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.5,
                  ),

                  const SizedBox(height: 24),

                  // --- CHIPS / TAGS ROW ---
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildChip(
                        icon: HugeIcons.strokeRoundedBirthdayCake,
                        label: '23',
                      ),
                      _buildChip(
                        icon: HugeIcons.strokeRoundedFavourite,
                        label: 'Shy Girl',
                      ),
                      _buildChip(
                        icon: HugeIcons.strokeRoundedMusicNote01,
                        label: 'Indie Pop',
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Category Tags / Chips
  Widget _buildChip({dynamic icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: icon,
            color: Colors.white70,
            size: 15,
          ),
          const SizedBox(width: 6),
          CustomText.medium(
            label,
            fontSize: 13,
            color: AppColors.textPrimaryLight,
          ),
        ],
      ),
    );
  }
}