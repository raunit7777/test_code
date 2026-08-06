import 'package:flutter/material.dart' hide Characters;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/home/provider/features_provider.dart';

import '../../core/constants/app_string.dart';
import '../../core/constants/const_text.dart';
import '../../extensions/context_extension.dart';
import '../streak/daily_streak_screen.dart';
import 'model/featurs_model.dart';
import 'package:go_router/go_router.dart';

class ProfilesGridScreen extends ConsumerStatefulWidget {
  const ProfilesGridScreen({super.key});

  @override
  ConsumerState<ProfilesGridScreen> createState() => _ProfilesGridScreenState();
}

class _ProfilesGridScreenState extends ConsumerState<ProfilesGridScreen> {
  static const Color pinkAccent = Color(0xFFE91E63);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(featuresProvider.notifier).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(featuresProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: SafeArea(
        child: Column(
          children: [
            // --- Custom App Bar ---
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.screenWidth * 0.05,
                vertical: context.screenHeight * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Header Title
                  Row(
                    children: [
                      CustomText.bold(
                        AppStrings.headerInfinite,
                        fontSize: context.screenWidth * 0.06,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      CustomText.bold(
                        AppStrings.headerLove,
                        fontSize: context.screenWidth * 0.06,
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
                          builder: (context) => const DailyStreakScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.035,
                        vertical: context.screenHeight * 0.007,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(context.screenWidth * 0.05),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText.bold(
                            AppStrings.defaultStreakCount,
                            fontSize: context.screenWidth * 0.04,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: context.screenWidth * 0.015),
                            child: CustomText.regular(
                              AppStrings.flameEmoji,
                              fontSize: context.screenWidth * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            // --- Profiles Grid Section ---
            Expanded(
              child: profileState.profileList.when(
                // 1️⃣ Loading State
                loading: () => const Center(
                  child: CircularProgressIndicator(color: pinkAccent),
                ),

                // 2️⃣ Error State
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText.regular(
                        AppStrings.failedToLoadProfiles,
                        color: Colors.white70,
                        fontSize: context.screenWidth * 0.04,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: context.screenHeight * 0.012),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pinkAccent,
                            padding: EdgeInsets.symmetric(
                              horizontal: context.screenWidth * 0.06,
                              vertical: context.screenHeight * 0.012,
                            ),
                          ),
                          onPressed: () {
                            ref.read(featuresProvider.notifier).fetchProfile();
                          },
                          child: Text(
                            AppStrings.retry,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: context.screenWidth * 0.035,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // 3️⃣ Data Success State
                data: (FeatureModel? featureModel) {
                  final characters = featureModel?.data?.characters ?? [];

                  if (characters.isEmpty) {
                    return Center(
                      child: CustomText.regular(
                        AppStrings.noProfilesAvailable,
                        color: Colors.white54,
                        fontSize: context.screenWidth * 0.04,
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.04,
                      vertical: context.screenHeight * 0.01,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.52,
                      crossAxisSpacing: context.screenWidth * 0.035,
                      mainAxisSpacing: context.screenHeight * 0.016,
                    ),
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      final character = characters[index];
                      return _buildProfileCard(character, context);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- Dynamic Profile Card Widget ---
  Widget _buildProfileCard(Characters character, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('modelProfile', extra: character.sId);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.screenWidth * 0.05),
          boxShadow: [
            BoxShadow(
              color: pinkAccent.withValues(alpha: 0.55),
              blurRadius: context.screenWidth * 0.05,
              spreadRadius: context.screenWidth * 0.007,
              offset: Offset(0, context.screenHeight * 0.007),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.screenWidth * 0.05),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Profile Background Image
              if (character.image != null && character.image!.isNotEmpty)
                Image.network(
                  character.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildFallbackImage(),
                )
              else
                _buildFallbackImage(),

              // Dark Gradient Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.9),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Profile Information Section
              Positioned(
                left: context.screenWidth * 0.035,
                right: context.screenWidth * 0.035,
                bottom: context.screenHeight * 0.016,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name
                    CustomText.bold(
                      character.name ?? AppStrings.defaultUnknown,
                      fontSize: context.screenWidth * 0.048,
                      color: Colors.white,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Age & Location Info
                    Padding(
                      padding: EdgeInsets.only(top: context.screenHeight * 0.007),
                      child: Row(
                        children: [
                          // Age Icon & Text
                          Icon(
                            Icons.cake_outlined,
                            color: Colors.white70,
                            size: context.screenWidth * 0.032,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: context.screenWidth * 0.01),
                            child: CustomText.regular(
                              '${character.age ?? AppStrings.defaultNotAvailable}',
                              fontSize: context.screenWidth * 0.03,
                              color: Colors.white70,
                            ),
                          ),

                          // Location Icon & Text
                          Padding(
                            padding: EdgeInsets.only(left: context.screenWidth * 0.02),
                            child: Icon(
                              Icons.location_on_outlined,
                              color: Colors.white70,
                              size: context.screenWidth * 0.032,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: context.screenWidth * 0.005),
                              child: CustomText.regular(
                                character.location ?? AppStrings.defaultUnknown,
                                fontSize: context.screenWidth * 0.03,
                                color: Colors.white70,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Local Image Fallback
  Widget _buildFallbackImage() {
    return Image.asset(
      "assets/22.png",
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[900],
        child: Icon(
          Icons.person,
          size: context.screenWidth * 0.12,
          color: Colors.white30,
        ),
      ),
    );
  }
}