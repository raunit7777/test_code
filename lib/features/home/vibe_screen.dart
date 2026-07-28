import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/const_text.dart';
import '../describe_image/describe_image_screen.dart';
import '../describe_image/subcription_screen.dart';

// --- Data Model for Model Profile ---
class VibeModel {
  final String name;
  final String imagePath;

  const VibeModel({
    required this.name,
    required this.imagePath,
  });
}

class VibeScreen extends StatefulWidget {
  const VibeScreen({super.key});

  @override
  State<VibeScreen> createState() => _VibeScreenState();
}

class _VibeScreenState extends State<VibeScreen> {
  // 10 Models with same image asset & different names
  final List<VibeModel> _models = const [
    VibeModel(name: 'Savita', imagePath: 'assets/22.png'),
    VibeModel(name: 'Ananya', imagePath: 'assets/22.png'),
    VibeModel(name: 'Priya', imagePath: 'assets/22.png'),
    VibeModel(name: 'Riya', imagePath: 'assets/22.png'),
    VibeModel(name: 'Kavya', imagePath: 'assets/22.png'),
    VibeModel(name: 'Sneha', imagePath: 'assets/22.png'),
    VibeModel(name: 'Pooja', imagePath: 'assets/22.png'),
    VibeModel(name: 'Nisha', imagePath: 'assets/22.png'),
    VibeModel(name: 'Meera', imagePath: 'assets/22.png'),
    VibeModel(name: 'Tanvi', imagePath: 'assets/22.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // --- Top Banner Card ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.cardDarkBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder, width: 0.8),
                ),
                child: Row(
                  children: [
                    // Gradient Star Badge Container
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFA832E8),
                            Color(0xFFFF2B6D),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedStar,
                          color: AppColors.textPrimaryLight,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Title & Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.bold(
                            'Create Custom Model',
                            fontSize: 15,
                            color: AppColors.textPrimaryLight,
                          ),
                          const SizedBox(height: 2),
                          CustomText.regular(
                            'Image',
                            fontSize: 12,
                            color: AppColors.textSecondaryLight,
                          ),
                        ],
                      ),
                    ),

                    // + Create Button
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DescribeImageScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPink,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedAdd01,
                              color: AppColors.textPrimaryLight,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            CustomText.bold(
                              'Create',
                              fontSize: 13,
                              color: AppColors.textPrimaryLight,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Chevron Up Arrow Indicator
              const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowUp01,
                color: AppColors.textSecondaryDark,
                size: 20,
              ),

              const SizedBox(height: 10),

              // --- Main Smooth ListView with Bottom Padding ---
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 28.0),
                  itemCount: _models.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final model = _models[index];
                    return _buildModelCard(context, model, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Single Card Item Widget ---
  Widget _buildModelCard(BuildContext context, VibeModel model, int index) {
    final cardHeight = MediaQuery.of(context).size.height * 0.65;
    final bool isLocked = index >= 2; // Pehle 2 ko chhod kar baaki locked rahenge

    return Container(
      height: cardHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Model Full Background Image
            Image.asset(
              model.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.cardDarkBg,
                child: const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    size: 50,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ),
            ),

            // Gradient Overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                      Colors.black.withOpacity(0.4),
                    ],
                    stops: const [0.0, 0.3, 1.0],
                  ),
                ),
              ),
            ),

            // Top Left: Avatar + Dynamic Name Overlay
            Positioned(
              top: 16,
              left: 16,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryPink,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(model.imagePath),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomText.bold(
                    model.name,
                    fontSize: 18,
                    color: AppColors.textPrimaryLight,
                  ),
                ],
              ),
            ),

            // Top Right: Plus / Chat Icon Button
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: HugeIcon(
                    icon: isLocked
                        ? HugeIcons.strokeRoundedAdd01
                        : HugeIcons.strokeRoundedComment01,
                    color: AppColors.textPrimaryLight,
                    size: 22,
                  ),
                ),
              ),
            ),

            // --- Locked Premium Overlay (Extra Dark Black) ---
            if (isLocked)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to destination screen on click
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PremiumSubscriptionScreen(),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.95), // 40% aur zyada dark black
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Lock Icon Badge Container
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryPink,
                          ),
                          child: const Center(
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedLockKey,
                              color: AppColors.textPrimaryLight,
                              size: 38,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Title
                        CustomText.bold(
                          'Premium Content',
                          fontSize: 24,
                          color: AppColors.textPrimaryLight,
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        CustomText.regular(
                          'Tap to unlock full feed view',
                          fontSize: 14,
                          color: AppColors.textSecondaryLight,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}