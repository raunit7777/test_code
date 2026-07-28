import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/features/profile/profile_screen.dart';

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
    ProfilesGridScreen(),
    InfiniteLoveScreen(),
    MessagesScreen(),
    VibeScreen(),
    MyProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B11),
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
        color: Color(0xFF07050A),
        border: Border(
          top: BorderSide(
            color: Color(0xFF181420),
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
    final Color activeColor = Colors.white;
    final Color inactiveColor = const Color(0xFF716A7C);

    bool isHomeTab = index == 0;

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
            // HugeIcon Widget use karne se TypeError TypeCast issue solve ho jayega
              HugeIcon(
                icon: item['icon'],
                color: isSelected ? activeColor : inactiveColor,
                size: 23,
              ),
            const SizedBox(height: 5),
            Text(
              item['title'],
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}