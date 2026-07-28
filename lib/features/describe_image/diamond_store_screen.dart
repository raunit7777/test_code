import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/const_text.dart'; // Apna CustomText import path verify kar lena

// Data Model for Diamond Pack Item
class DiamondPackModel {
  final int count;
  final String originalPrice;
  final String discountedPrice;
  final String discountTag;
  final String imagePath;

  const DiamondPackModel({
    required this.count,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountTag,
    required this.imagePath,
  });
}

class DiamondStoreScreen extends StatelessWidget {
  const DiamondStoreScreen({super.key});

  // Packs Data List
  List<DiamondPackModel> get _diamondPacks => const [
    DiamondPackModel(
      count: 20,
      originalPrice: '₹40',
      discountedPrice: '₹19',
      discountTag: '50% OFF',
      imagePath: 'assets/22.png',
    ),
    DiamondPackModel(
      count: 80,
      originalPrice: '₹98',
      discountedPrice: '₹49',
      discountTag: '50% OFF',
      imagePath: 'assets/22.png',
    ),
    DiamondPackModel(
      count: 400,
      originalPrice: '₹298',
      discountedPrice: '₹149',
      discountTag: '50% OFF',
      imagePath: 'assets/22.png',
    ),
    DiamondPackModel(
      count: 800,
      originalPrice: '₹498',
      discountedPrice: '₹249',
      discountTag: '50% OFF',
      imagePath: 'assets/22.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const blueAccentColor = Color(0xFF3B82F6);

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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedDiamond,
              color: blueAccentColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            CustomText.bold(
              'Diamond Store',
              fontSize: 20,
              color: AppColors.textPrimaryLight,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Watch Ad FREE Banner ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                color: blueAccentColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  // Play Icon Circle Badge
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Text Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.bold(
                          'Watch Ad for 2\nDiamonds',
                          fontSize: 18,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        const SizedBox(height: 6),
                        CustomText.regular(
                          'Watch a short ad to\nearn diamonds',
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.2,
                        ),
                      ],
                    ),
                  ),

                  // FREE Button Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomText.bold(
                      'FREE',
                      fontSize: 15,
                      color: blueAccentColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // --- 2. Premium Section Header ---
            CustomText.bold(
              'Premium Diamond Packs',
              fontSize: 20,
              color: AppColors.textPrimaryLight,
            ),
            const SizedBox(height: 16),

            // --- 3. Grid View of Diamond Packs ---
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: _diamondPacks.length,
              itemBuilder: (context, index) {
                return _buildPackCard(_diamondPacks[index], blueAccentColor);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helper Widget: Single Pack Card ---
  Widget _buildPackCard(DiamondPackModel pack, Color blueAccentColor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF18181C), // Dark Card Background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          // Top Portion with Image & Discount Tag
          Expanded(
            child: Stack(
              children: [
                // Pack Preview Image
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(
                    pack.imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF222228),
                      child: const Center(
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedDiamond,
                          color: Colors.white24,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),

                // Top Right Discount Badge (50% OFF)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF3B30), // Red Accent
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomText.bold(
                      pack.discountTag,
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Details Portion
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Diamond Count Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedDiamond,
                      color: Color(0xFF60A5FA),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    CustomText.bold(
                      '${pack.count}',
                      fontSize: 18,
                      color: AppColors.textPrimaryLight,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Blue Buy Action Button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: blueAccentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Original Price (Line-Through)
                      CustomText.regular(
                        pack.originalPrice,
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                        showLineThrough: true,
                        underlineOrLineColor: Colors.white.withOpacity(0.7),
                      ),
                      const SizedBox(width: 6),

                      // Discounted Final Price
                      CustomText.bold(
                        pack.discountedPrice,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}