import 'package:flutter/material.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/const_text.dart';
import '../streak/daily_streak_screen.dart';



// Data Model
class ProfileModel {
  final String name;
  final int age;
  final String location;
  final String imageUrl;

  ProfileModel({
    required this.name,
    required this.age,
    required this.location,
    required this.imageUrl,
  });
}

class ProfilesGridScreen extends StatelessWidget {
  const ProfilesGridScreen({super.key});

  static const Color pinkAccent = Color(0xFFE91E63);

  // Sample profiles list
  List<ProfileModel> get _profiles => [
    ProfileModel(
      name: 'Ayushi',
      age: 23,
      location: 'South Delhi, I...',
      imageUrl: 'https://picsum.photos/400/600?random=1',
    ),
    ProfileModel(
      name: 'Rishika',
      age: 25,
      location: 'Indore, Madh...',
      imageUrl: 'https://picsum.photos/400/600?random=2',
    ),
    ProfileModel(
      name: 'Riya',
      age: 20,
      location: 'Bangalore, K...',
      imageUrl: 'https://picsum.photos/400/600?random=3',
    ),
    ProfileModel(
      name: 'Nehal Bhabhi',
      age: 30,
      location: 'Raipur, Chha...',
      imageUrl: 'https://picsum.photos/400/600?random=4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: SafeArea(
        child: Column(
          children: [
            // --- Custom App Bar ---
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Header Title with CustomText Integration
                  Row(
                    children: [
                      CustomText.bold(
                        'Infinite ',
                        fontSize: 24,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      CustomText.bold(
                        'Love',
                        fontSize: 24,
                        color: pinkAccent,
                        letterSpacing: 0.5,
                      ),
                    ],
                  ),

                  // Coin / Flame Badge
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DailyStreakScreen(), // Apni screen ka exact class name yahan do
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText.bold(
                            '0',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          CustomText.regular(
                            '🔥',
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            // --- Profiles Grid ---
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.52,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: _profiles.length,
                itemBuilder: (context, index) {
                  return _buildProfileCard(_profiles[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- Profile Card Widget with Pink Glow Shadow ---
  Widget _buildProfileCard(ProfileModel profile) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          // Enhanced Hot Pink Glow Effect
          BoxShadow(
            color: pinkAccent.withValues(alpha: 0.55), // Increased Opacity for strong visibility
            blurRadius: 20,                            // Increased Blur Radius for wider spread
            spreadRadius: 3,                           // Increased Spread Radius for thicker border glow
            offset: const Offset(0, 6),                // Elevated Depth
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Profile Background Image
            Image.asset(
              "assets/22.png",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[900],
                child:
                const Icon(Icons.person, size: 50, color: Colors.white30),
              ),
            ),

            // Dark Gradient Overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Profile Information Section
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name using CustomText.bold
                  CustomText.bold(
                    profile.name,
                    fontSize: 20,
                    color: Colors.white,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Age & Location Row
                  Row(
                    children: [
                      // Age Icon & CustomText
                      const Icon(Icons.cake_outlined,
                          color: Colors.white70, size: 13),
                      const SizedBox(width: 4),
                      CustomText.regular(
                        '${profile.age}',
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 8),

                      // Location Icon & CustomText
                      const Icon(Icons.location_on_outlined,
                          color: Colors.white70, size: 13),
                      const SizedBox(width: 2),
                      Expanded(
                        child: CustomText.regular(
                          profile.location,
                          fontSize: 12,
                          color: Colors.white70,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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