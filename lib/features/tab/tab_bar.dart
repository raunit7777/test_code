import 'package:flutter/material.dart';

/// Custom Reusable Tab Pill Bar Widget
class CustomTabPillBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final Color activeColor;
  final Color inactiveBgColor;
  final Color inactiveBorderColor;

  const CustomTabPillBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.activeColor = const Color(0xFFE91E63),
    this.inactiveBgColor = const Color(0xFF121212),
    this.inactiveBorderColor = const Color(0xFF2A2A2A),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: EdgeInsets.only(
              right: index == tabs.length - 1 ? 0 : 12.0,
            ),
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.transparent : inactiveBgColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? activeColor : inactiveBorderColor,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected ? activeColor : Colors.white70,
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}