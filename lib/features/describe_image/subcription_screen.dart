import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/const_text.dart'; // Apna CustomText import path adjust kar lena

class PremiumSubscriptionScreen extends StatefulWidget {
  const PremiumSubscriptionScreen({super.key});

  @override
  State<PremiumSubscriptionScreen> createState() =>
      _PremiumSubscriptionScreenState();
}

class _PremiumSubscriptionScreenState
    extends State<PremiumSubscriptionScreen> {
  // Default selected plan index (0: Weekly, 1: Monthly, 2: Yearly)
  int _selectedPlanIndex = 1;

  final List<Map<String, String>> _plans = const [
    {'title': 'Weekly', 'price': '₹99'},
    {'title': 'Monthly', 'price': '₹299'},
    {'title': 'Yearly', 'price': '₹2,600'},
  ];

  final List<String> _featuresLeft = const [
    'No Ads',
    'Unlock All Chat Models',
    'Unlock Role Play Mode',
    'Unlock Spicy Chat',
  ];

  final List<String> _featuresRight = const [
    'Customize Models',
    'Create Custom AI',
    'Ultimate Photos',
    'Play Interactive Games',
  ];

  @override
  Widget build(BuildContext context) {
    const hotPinkColor = Color(0xFFFF2A7A);

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: Stack(
        children: [
          // --- 1. Background Image with Gradient Overlay ---
          Positioned.fill(
            child: Image.asset(
              'assets/21.png', // Apni model background image path update kar lena
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF130D18),
              ),
            ),
          ),

          // Dark Overlay for Contrast & Readability
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.95),
                  ],
                  stops: const [0.0, 0.4, 0.85],
                ),
              ),
            ),
          ),

          // --- 2. Screen Content ---
          SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Close Button
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedCancel01,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // --- 3. Features Grid (2 Columns) ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column Features
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _featuresLeft
                              .map((feature) => _buildFeatureRow(feature))
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Right Column Features
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _featuresRight
                              .map((feature) => _buildFeatureRow(feature))
                              .toList(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // --- 4. Subscription Plan Selectable Cards ---
                  Row(
                    children: List.generate(_plans.length, (index) {
                      final plan = _plans[index];
                      final isSelected = _selectedPlanIndex == index;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPlanIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: EdgeInsets.only(
                              right: index == _plans.length - 1 ? 0 : 10,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? hotPinkColor
                                  : const Color(0xFF222226).withOpacity(0.85),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? hotPinkColor
                                    : Colors.white.withOpacity(0.12),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                BoxShadow(
                                  color: hotPinkColor.withOpacity(0.45),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                                  : [],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText.bold(
                                  plan['title']!,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 8),
                                CustomText.bold(
                                  plan['price']!,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 24),

                  // --- 5. Continue Action Button ---
                  GestureDetector(
                    onTap: () {
                      // Purchase action
                    },
                    child: Container(
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        color: hotPinkColor,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: hotPinkColor.withOpacity(0.4),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText.bold(
                            'Continue',
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowRight01,
                            color: Colors.white,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- 6. Bottom Legal Footer Links ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: CustomText.regular(
                          'Privacy Policy',
                          fontSize: 11,
                          color: Colors.white60,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: CustomText.regular(
                          'Restore Subscription',
                          fontSize: 11,
                          color: Colors.white60,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: CustomText.regular(
                          'Terms & Conditions',
                          fontSize: 11,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widget: Checkmark Feature Row ---
  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: HugeIcon(
              icon: HugeIcons.strokeRounded0Square,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CustomText.bold(
              text,
              fontSize: 13,
              color: Colors.white,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}