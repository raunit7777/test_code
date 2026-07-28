import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/const_text.dart';
import 'diamond_store_screen.dart'; // Apna exact CustomText path adjust kar lena

class DescribeImageScreen extends StatefulWidget {
  const DescribeImageScreen({super.key});

  @override
  State<DescribeImageScreen> createState() => _DescribeImageScreenState();
}

class _DescribeImageScreenState extends State<DescribeImageScreen> {
  final TextEditingController _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pinkAccent = Color(0xFFFF2A7A);

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Left: Back Button Square Tile
            GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: pinkAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowLeft01,
                    color: Colors.white,
                    size: 22.0,
                  ),
                ),
              ),
            ),

            // Top Right: History Button & Diamond Balance Pill
            Row(
              children: [
                // History Square Tile
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1A28),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedClock01,
                      color: AppColors.textPrimaryLight,
                      size: 20.0,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Diamond Balance Pill (0 +)
                GestureDetector(onTap: (){


                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DiamondStoreScreen(),
                    ),
                  );

                },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1A28),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedDiamond,
                          color: AppColors.textPrimaryLight,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        CustomText.bold(
                          '0',
                          fontSize: 15,
                          color: AppColors.textPrimaryLight,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedAdd01,
                              color: AppColors.textPrimaryLight,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // --- Main Describe Card with Glow Border ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color(0xFF140D1B), // Dark Purple-Black BG
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: pinkAccent.withOpacity(0.4),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: pinkAccent.withOpacity(0.12),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heading Title
                  CustomText.bold(
                    'Describe your image',
                    fontSize: 22,
                    color: AppColors.textPrimaryLight,
                  ),
                  const SizedBox(height: 20),

                  // Prompt Text Area Box
                  Container(
                    height: 180,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1324),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: pinkAccent.withOpacity(0.5),
                        width: 1.0,
                      ),
                    ),
                    child: TextField(
                      controller: _promptController,
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(
                        color: AppColors.textPrimaryLight,
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'e.g She is wearing a hot pink Color dress....',
                        hintStyle: TextStyle(
                          color: Color(0xFF6B5D7A),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Gradient Create Image Action Button
                  GestureDetector(
                    onTap: () {
                      // Generate image logic
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF409A),
                            Color(0xFFFF2A7A),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: pinkAccent.withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedMagicWand01,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            CustomText.bold(
                              'Create Image',
                              fontSize: 17,
                              color: Colors.white,
                            ),
                            const Spacer(),

                            // Diamond Cost Badge (◆ 20)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  const HugeIcon(
                                    icon: HugeIcons.strokeRoundedDiamond,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  CustomText.bold(
                                    '20',
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}