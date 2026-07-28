import 'package:flutter/material.dart';

import '../../core/constants/app_color.dart';

class InfiniteLoveScreen extends StatelessWidget {
  const InfiniteLoveScreen({super.key});

  // Custom Pink Accent Color
  static const Color pinkAccent = Color(0xFFE91E63);
  static const Color cardBg = Color(0xFF180E14);
  static const Color cardBorder = Color(0xFF321623);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.bgBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Header Title ---
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  children: [
                    TextSpan(
                      text: 'Infinite ',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: 'Love',
                      style: TextStyle(color: pinkAccent),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // --- Card 1: Create AI Partner ---
              _buildFeatureCard(
                icon: Icons.auto_awesome,
                title: 'CREATE YOUR OWN AI\nPARTNER',
                description:
                'Design your perfect companion. Customize its personality, voice, interests, and knowledge base for t...',
                buttonText: 'Start Building Now',
                onPressed: () {},
              ),
              const SizedBox(height: 20),

              // --- Card 2: Role-Play Mode ---
              _buildFeatureCard(
                icon: Icons.person,
                title: 'ROLE-PLAY MODE',
                description:
                'Practice conversations, simulate real-world scenarios, or explore fantastical roles with your AI for engaging a...',
                buttonText: 'Explore Roles',
                onPressed: () {},
              ),
              const SizedBox(height: 20),

              // --- Card 3: Play Games ---
              _buildFeatureCard(
                icon: Icons.sports_esports,
                title: 'PLAY GAMES WITH YOUR\nPARTNER',
                description:
                'Enjoy classic games like Ludo with your AI partner. Experience fun, interactive gameplay with playful ban...',
                buttonText: 'Play Now',
                onPressed: () {},
              ),
              const SizedBox(height: 32),

              // --- Footer Text ---
              const Text(
                'More Modes Coming Soon...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // --- Reusable Feature Card Component ---
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Icon(
            icon,
            color: pinkAccent,
            size: 28,
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.2,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Action Button
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: pinkAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}