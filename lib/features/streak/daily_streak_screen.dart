import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/const_text.dart';

class DailyStreakScreen extends StatefulWidget {
  const DailyStreakScreen({super.key});

  @override
  State<DailyStreakScreen> createState() => _DailyStreakScreenState();
}

class _DailyStreakScreenState extends State<DailyStreakScreen>
    with SingleTickerProviderStateMixin {
  // Streak State Variables
  int _currentStreak = 0;
  int _bestStreak = 0;
  bool _isClaimed = false;

  // Countdown Timer Variables
  Timer? _countdownTimer;
  Duration _remainingTime = const Duration(hours: 24);

  // Entrance Controller & Animations
  late AnimationController _entranceController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Setup Initial Page Entrance Animation
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeIn,
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _entranceController.dispose();
    super.dispose();
  }

  // --- Claim Action Handler ---
  void _onClaimPressed() {
    setState(() {
      _isClaimed = true;
      _currentStreak += 1;
      if (_currentStreak > _bestStreak) {
        _bestStreak = _currentStreak;
      }
      _remainingTime = const Duration(hours: 24);
    });

    _startCountdown();
  }

  // --- Live 24h Countdown Logic ---
  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        setState(() {
          _isClaimed = false;
        });
      }
    });
  }

  // Duration Formatter (HH:MM:SS)
  String _formatDuration(Duration duration) {
    String hours = duration.inHours.remainder(24).toString().padLeft(2, '0');
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    const cardBgColor = Color(0xFF22150F);

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
          'Daily Streak',
          fontSize: 20,
          color: AppColors.textPrimaryLight,
        ),
        centerTitle: true,
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. Streak Main Card ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 36.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Flame Badge Circle
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF331D12),
                          border: Border.all(
                            color: _isClaimed
                                ? const Color(0xFFFF6A00)
                                : const Color(0xFF552D1B),
                            width: 3.5,
                          ),
                        ),
                        child: Center(
                          child: CustomText.bold(
                            '🔥',
                            fontSize: 70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Big Streak Count Number
                      CustomText.bold(
                        '$_currentStreak',
                        fontSize: 72,
                        color: AppColors.textPrimaryLight,
                        height: 1.0,
                      ),
                      const SizedBox(height: 8),

                      // DAY STREAK Label
                      CustomText.bold(
                        'DAY STREAK',
                        fontSize: 14,
                        letterSpacing: 3.0,
                        color: const Color(0xFFBCAAA4),
                      ),
                      const SizedBox(height: 14),

                      // Best Streak Info
                      CustomText.regular(
                        'Best Streak: $_bestStreak days',
                        fontSize: 14,
                        color: const Color(0xFFDF955B),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- 2. Dynamic Claim Button OR 24h Countdown Timer ---
                if (!_isClaimed)
                  GestureDetector(
                    onTap: _onClaimPressed,
                    child: Container(
                      width: double.infinity,
                      height: 62,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF6B2B), // Orange Accent
                            Color(0xFFFF2A7A), // Hot Pink Accent
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF2A7A).withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRounded0Square,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          CustomText.bold(
                            'CLAIM',
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 2.0,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomText.regular(
                          'Next claim in',
                          fontSize: 14,
                          color: const Color(0xFFBCAAA4),
                        ),
                        const SizedBox(height: 6),
                        CustomText.bold(
                          _formatDuration(_remainingTime),
                          fontSize: 36,
                          color: const Color(0xFFFF6A00),
                          letterSpacing: 1.5,
                        ),
                      ],
                    ),
                  ),

                // --- 3. Milestone Rewards Section (ALWAYS VISIBLE NOW) ---
                const SizedBox(height: 28),
                CustomText.bold(
                  'Milestone Rewards',
                  fontSize: 20,
                  color: AppColors.textPrimaryLight,
                ),
                const SizedBox(height: 16),

                // Day 7
                _buildMilestoneTile(
                  dayText: 'Day 7',
                  title: '7 Day Streak!',
                  subtitle: '20 Diamonds',
                  leadingWidget: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1B1412),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomText.bold(
                        '💎',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Day 14
                _buildMilestoneTile(
                  dayText: 'Day 14',
                  title: 'Riya Unlocked',
                  leadingWidget: const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/22.png'),
                  ),
                ),
                const SizedBox(height: 12),

                // Day 28
                _buildMilestoneTile(
                  dayText: 'Day 28',
                  title: 'Aarohi Unlocked',
                  leadingWidget: const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/22.png'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widget: Milestone Tile ---
  Widget _buildMilestoneTile({
    required String dayText,
    required String title,
    String? subtitle,
    required Widget leadingWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(0xFF22150F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
        ),
      ),
      child: Row(
        children: [
          leadingWidget,
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText.regular(
                dayText,
                fontSize: 12,
                color: const Color(0xFF8D7B75),
              ),
              const SizedBox(height: 2),
              CustomText.bold(
                title,
                fontSize: 16,
                color: AppColors.textPrimaryLight,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                CustomText.regular(
                  subtitle,
                  fontSize: 12,
                  color: const Color(0xFFBCAAA4),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}