import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/profile/profile_screen.dart';

import '../../core/constants/const_text.dart';
import 'home/featrues_screen.dart';
import 'home/home_screen.dart';
import 'home/massage_screen.dart';
import 'home/vibe_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ProfilesGridScreen(),
    const InfiniteLoveScreen(),
    const MessagesScreen(),
     VibeScreen(),
    const MyProfileScreen(),
  ];

  /// Show Exit Confirmation Dialog
  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.cardDarkBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primaryPink.withOpacity(0.4),
                width: 1.2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning / Exit Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.power_settings_new_rounded,
                    color: AppColors.primaryPink,
                    size: 30,
                  ),
                ),

                const SizedBox(height: 16),

                // Title
                CustomText.bold(
                  'Exit App?',
                  color: AppColors.textPrimaryLight,
                  fontSize: 20,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Description
                CustomText.regular(
                  'Are you sure you want to exit the application?',
                  color: AppColors.textSecondaryLight,
                  fontSize: 14,
                  textAlign: TextAlign.center,
                  height: 1.3,
                ),

                const SizedBox(height: 24),

                // Action Buttons (Cancel / Exit)
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: AppColors.textSecondaryDark.withOpacity(0.4),
                            ),
                          ),
                        ),
                        child: CustomText.medium(
                          'Cancel',
                          color: AppColors.textPrimaryLight,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Exit Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPink,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: CustomText.bold(
                          'Exit',
                          color: AppColors.whiteSheetBg,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // 🟢 Step 1: Agar kisi doosre tab (1, 2, 3, 4) par ho, to pehle Home tab (0) par redirect karo
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return;
        }

        // 🟢 Step 2: Agar pehle se Home Tab (0) par ho, tab Exit Dialog dikhao
        final shouldExit = await _showExitConfirmationDialog(context);

        if (shouldExit && context.mounted) {
          // Close the app completely
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgBlack,
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> navItems = [
      {
        'title': 'Home',
        'icon': HugeIcons.strokeRoundedHome01,
      },
      {
        'title': 'Features',
        'icon': HugeIcons.strokeRoundedStar,
      },
      {
        'title': 'Messages',
        'icon': HugeIcons.strokeRoundedComment01,
      },
      {
        'title': 'Vibes',
        'icon': HugeIcons.strokeRoundedFlash,
      },
      {
        'title': 'Profile',
        'icon': HugeIcons.strokeRoundedUser,
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgDarkestPurple,
        border: Border(
          top: BorderSide(
            color: AppColors.cardBorder,
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              navItems.length,
                  (index) => _buildNavItem(
                context: context,
                index: index,
                item: navItems[index],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required Map<String, dynamic> item,
  }) {
    final bool isSelected = currentIndex == index;
    final Color activeColor = AppColors.textPrimaryLight;
    final Color inactiveColor = AppColors.textSecondaryDark;

    final bool isHomeTab = index == 0;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isHomeTab)
              Icon(
                Icons.home_rounded,
                color: isSelected ? activeColor : inactiveColor,
                size: 25,
              )
            else
              HugeIcon(
                icon: item['icon'],
                color: isSelected ? activeColor : inactiveColor,
                size: 23,
              ),
            const SizedBox(height: 5),
            CustomText.medium(
              item['title'],
              color: isSelected ? activeColor : inactiveColor,
              fontSize: 11,
            ),
          ],
        ),
      ),
    );
  }
}