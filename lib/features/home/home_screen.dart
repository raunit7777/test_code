// import 'package:flutter/cupertino.dart' hide Characters;
// import 'package:flutter/material.dart' hide Characters;
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:infinity_love/core/constants/app_color.dart';
// import 'package:infinity_love/features/home/provider/features_provider.dart';
//
// import '../../core/constants/app_string.dart';
// import '../../core/constants/const_text.dart';
// import '../../extensions/context_extension.dart';
// import '../streak/daily_streak_screen.dart';
// import 'model/featurs_model.dart';
// import 'package:go_router/go_router.dart';
//
// class ProfilesGridScreen extends ConsumerStatefulWidget {
//   const ProfilesGridScreen({super.key});
//
//   @override
//   ConsumerState<ProfilesGridScreen> createState() => _ProfilesGridScreenState();
// }
//
// class _ProfilesGridScreenState extends ConsumerState<ProfilesGridScreen> {
//   static const Color pinkAccent = Color(0xFFE91E63);
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(featuresProvider.notifier).fetchProfile();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final profileState = ref.watch(featuresProvider);
//
//     return Scaffold(
//       backgroundColor: AppColors.bgBlack,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // --- Custom App Bar ---
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: context.screenWidth * 0.05,
//                 vertical: context.screenHeight * 0.02,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Header Title
//                   Row(
//                     children: [
//                       CustomText.bold(
//                         AppStrings.headerInfinite,
//                         fontSize: context.screenWidth * 0.06,
//                         color: Colors.white,
//                         letterSpacing: 0.5,
//                       ),
//                       CustomText.bold(
//                         AppStrings.headerLove,
//                         fontSize: context.screenWidth * 0.06,
//                         color: pinkAccent,
//                         letterSpacing: 0.5,
//                       ),
//                     ],
//                   ),
//
//                   // Coin / Flame Badge
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const DailyStreakScreen(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: context.screenWidth * 0.035,
//                         vertical: context.screenHeight * 0.007,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF141414),
//                         borderRadius: BorderRadius.circular(context.screenWidth * 0.05),
//                         border: Border.all(color: Colors.white12),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           CustomText.bold(
//                             AppStrings.defaultStreakCount,
//                             fontSize: context.screenWidth * 0.04,
//                             color: Colors.white,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(left: context.screenWidth * 0.015),
//                             child: CustomText.regular(
//                               AppStrings.flameEmoji,
//                               fontSize: context.screenWidth * 0.035,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//
//             // --- Profiles Grid Section ---
//             Expanded(
//               child: profileState.profileList.when(
//                 // 1️⃣ Loading State
//                 loading: () =>  Center(
//                   child: CupertinoActivityIndicator(color: pinkAccent),
//                 ),
//
//                 // 2️⃣ Error State
//                 error: (error, stack) => Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CustomText.regular(
//                         AppStrings.failedToLoadProfiles,
//                         color: Colors.white70,
//                         fontSize: context.screenWidth * 0.04,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(top: context.screenHeight * 0.012),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: pinkAccent,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: context.screenWidth * 0.06,
//                               vertical: context.screenHeight * 0.012,
//                             ),
//                           ),
//                           onPressed: () {
//                             ref.read(featuresProvider.notifier).fetchProfile();
//                           },
//                           child: Text(
//                             AppStrings.retry,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: context.screenWidth * 0.035,
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//
//                 // 3️⃣ Data Success State
//                 data: (FeatureModel? featureModel) {
//                   final characters = featureModel?.data?.characters ?? [];
//
//                   if (characters.isEmpty) {
//                     return Center(
//                       child: CustomText.regular(
//                         AppStrings.noProfilesAvailable,
//                         color: Colors.white54,
//                         fontSize: context.screenWidth * 0.04,
//                       ),
//                     );
//                   }
//
//                   return GridView.builder(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: context.screenWidth * 0.04,
//                       vertical: context.screenHeight * 0.01,
//                     ),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 0.52,
//                       crossAxisSpacing: context.screenWidth * 0.035,
//                       mainAxisSpacing: context.screenHeight * 0.016,
//                     ),
//                     itemCount: characters.length,
//                     itemBuilder: (context, index) {
//                       final character = characters[index];
//                       return _buildProfileCard(character, context);
//                     },
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   // --- Dynamic Profile Card Widget ---
//   Widget _buildProfileCard(Characters character, BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         context.pushNamed('modelProfile', extra: character.sId);
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(context.screenWidth * 0.05),
//           boxShadow: [
//             BoxShadow(
//               color: pinkAccent.withValues(alpha: 0.55),
//               blurRadius: context.screenWidth * 0.05,
//               spreadRadius: context.screenWidth * 0.007,
//               offset: Offset(0, context.screenHeight * 0.007),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(context.screenWidth * 0.05),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               // Profile Background Image
//               if (character.image != null && character.image!.isNotEmpty)
//                 Image.network(
//                   character.image!,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) =>
//                       _buildFallbackImage(),
//                 )
//               else
//                 _buildFallbackImage(),
//
//               // Dark Gradient Overlay
//               Positioned.fill(
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withValues(alpha: 0.1),
//                         Colors.black.withValues(alpha: 0.9),
//                       ],
//                       stops: const [0.0, 0.5, 1.0],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Profile Information Section
//               Positioned(
//                 left: context.screenWidth * 0.035,
//                 right: context.screenWidth * 0.035,
//                 bottom: context.screenHeight * 0.016,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Name
//                     CustomText.bold(
//                       character.name ?? AppStrings.defaultUnknown,
//                       fontSize: context.screenWidth * 0.048,
//                       color: Colors.white,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//
//                     // Age & Location Info
//                     Padding(
//                       padding: EdgeInsets.only(top: context.screenHeight * 0.007),
//                       child: Row(
//                         children: [
//                           // Age Icon & Text
//                           Icon(
//                             Icons.cake_outlined,
//                             color: Colors.white70,
//                             size: context.screenWidth * 0.032,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(left: context.screenWidth * 0.01),
//                             child: CustomText.regular(
//                               '${character.age ?? AppStrings.defaultNotAvailable}',
//                               fontSize: context.screenWidth * 0.03,
//                               color: Colors.white70,
//                             ),
//                           ),
//
//                           // Location Icon & Text
//                           Padding(
//                             padding: EdgeInsets.only(left: context.screenWidth * 0.02),
//                             child: Icon(
//                               Icons.location_on_outlined,
//                               color: Colors.white70,
//                               size: context.screenWidth * 0.032,
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: EdgeInsets.only(left: context.screenWidth * 0.005),
//                               child: CustomText.regular(
//                                 character.location ?? AppStrings.defaultUnknown,
//                                 fontSize: context.screenWidth * 0.03,
//                                 color: Colors.white70,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Local Image Fallback
//   Widget _buildFallbackImage() {
//     return Image.asset(
//       "assets/22.png",
//       fit: BoxFit.cover,
//       errorBuilder: (context, error, stackTrace) => Container(
//         color: Colors.grey[900],
//         child: Icon(
//           Icons.person,
//           size: context.screenWidth * 0.12,
//           color: Colors.white30,
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/cupertino.dart' hide Characters;
// import 'package:flutter/material.dart' hide Characters;
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:infinity_love/core/constants/app_color.dart';
// import 'package:infinity_love/features/home/provider/features_provider.dart';
// import 'package:infinity_love/features/streak/provider/streak_provider.dart'; // 👈 Streak provider import
//
// import '../../core/constants/app_string.dart';
// import '../../core/constants/const_text.dart';
// import '../../extensions/context_extension.dart';
// import '../streak/daily_streak_screen.dart';
// import 'model/featurs_model.dart';
// import 'package:go_router/go_router.dart';
//
// class ProfilesGridScreen extends ConsumerStatefulWidget {
//   const ProfilesGridScreen({super.key});
//
//   @override
//   ConsumerState<ProfilesGridScreen> createState() => _ProfilesGridScreenState();
// }
//
// class _ProfilesGridScreenState extends ConsumerState<ProfilesGridScreen> {
//   static const Color pinkAccent = Color(0xFFE91E63);
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadInitialData();
//     });
//   }
//
//   // 🚀 Profiles aur Streak dono ka Initial Fetch
//   void _loadInitialData() {
//     ref.read(featuresProvider.notifier).fetchProfile();
//     ref.read(streakProvider.notifier).fetchStreak();
//   }
//
//   // 🔄 Pull-To-Refresh Event Handler
//   Future<void> _handleRefresh() async {
//     await Future.wait([
//       ref.read(featuresProvider.notifier).fetchProfile(),
//       ref.read(streakProvider.notifier).fetchStreak(),
//     ]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final profileState = ref.watch(featuresProvider);
//     final streakState = ref.watch(streakProvider);
//
//     // 🟢 Dynamic streak value fetch
//     final String streakCount = streakState.streak.when(
//       data: (streakModel) =>
//       '${streakModel?.data?.currentStreak ?? AppStrings.defaultStreakCount}',
//       loading: () => '...',
//       error: (_, __) => '${AppStrings.defaultStreakCount}',
//     );
//
//     return Scaffold(
//       backgroundColor: AppColors.bgBlack,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // --- Custom App Bar ---
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: context.screenWidth * 0.05,
//                 vertical: context.screenHeight * 0.02,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Header Title
//                   Row(
//                     children: [
//                       CustomText.bold(
//                         AppStrings.headerInfinite,
//                         fontSize: context.screenWidth * 0.06,
//                         color: Colors.white,
//                         letterSpacing: 0.5,
//                       ),
//                       CustomText.bold(
//                         AppStrings.headerLove,
//                         fontSize: context.screenWidth * 0.06,
//                         color: pinkAccent,
//                         letterSpacing: 0.5,
//                       ),
//                     ],
//                   ),
//
//                   // Coin / Flame Badge (Dynamic Count)
//                   GestureDetector(
//                     onTap: () async {
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const DailyStreakScreen(),
//                         ),
//                       );
//                       // 🔄 Daily streak screen se wapas aane par re-sync
//                       ref.read(streakProvider.notifier).fetchStreak();
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: context.screenWidth * 0.035,
//                         vertical: context.screenHeight * 0.007,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF141414),
//                         borderRadius: BorderRadius.circular(context.screenWidth * 0.05),
//                         border: Border.all(color: Colors.white12),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           CustomText.bold(
//                             streakCount, // 👈 Realtime Streak Value
//                             fontSize: context.screenWidth * 0.04,
//                             color: Colors.white,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(left: context.screenWidth * 0.015),
//                             child: CustomText.regular(
//                               AppStrings.flameEmoji,
//                               fontSize: context.screenWidth * 0.035,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//
//             // --- Profiles Grid Section with Pull To Refresh ---
//             Expanded(
//               child: RefreshIndicator(
//                 onRefresh: _handleRefresh,
//                 color: pinkAccent,
//                 backgroundColor: const Color(0xFF1E1E20),
//                 child: profileState.profileList.when(
//                   // 1️⃣ Loading State
//                   loading: () => const Center(
//                     child: CupertinoActivityIndicator(color: pinkAccent),
//                   ),
//
//                   // 2️⃣ Error State
//                   error: (error, stack) => SingleChildScrollView(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     child: SizedBox(
//                       height: context.screenHeight * 0.7,
//                       child: Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CustomText.regular(
//                               AppStrings.failedToLoadProfiles,
//                               color: Colors.white70,
//                               fontSize: context.screenWidth * 0.04,
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(top: context.screenHeight * 0.012),
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: pinkAccent,
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: context.screenWidth * 0.06,
//                                     vertical: context.screenHeight * 0.012,
//                                   ),
//                                 ),
//                                 onPressed: _handleRefresh,
//                                 child: Text(
//                                   AppStrings.retry,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: context.screenWidth * 0.035,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   // 3️⃣ Data Success State
//                   data: (FeatureModel? featureModel) {
//                     final characters = featureModel?.data?.characters ?? [];
//
//                     if (characters.isEmpty) {
//                       return SingleChildScrollView(
//                         physics: const AlwaysScrollableScrollPhysics(),
//                         child: SizedBox(
//                           height: context.screenHeight * 0.7,
//                           child: Center(
//                             child: CustomText.regular(
//                               AppStrings.noProfilesAvailable,
//                               color: Colors.white54,
//                               fontSize: context.screenWidth * 0.04,
//                             ),
//                           ),
//                         ),
//                       );
//                     }
//
//                     return GridView.builder(
//                       physics: const AlwaysScrollableScrollPhysics(), // Pull gesture activation ke liye
//                       padding: EdgeInsets.symmetric(
//                         horizontal: context.screenWidth * 0.04,
//                         vertical: context.screenHeight * 0.01,
//                       ),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         childAspectRatio: 0.52,
//                         crossAxisSpacing: context.screenWidth * 0.035,
//                         mainAxisSpacing: context.screenHeight * 0.016,
//                       ),
//                       itemCount: characters.length,
//                       itemBuilder: (context, index) {
//                         final character = characters[index];
//                         return _buildProfileCard(character, context);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   // --- Dynamic Profile Card Widget ---
//   Widget _buildProfileCard(Characters character, BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         context.pushNamed('modelProfile', extra: character.sId);
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(context.screenWidth * 0.05),
//           boxShadow: [
//             BoxShadow(
//               color: pinkAccent.withValues(alpha: 0.55),
//               blurRadius: context.screenWidth * 0.05,
//               spreadRadius: context.screenWidth * 0.007,
//               offset: Offset(0, context.screenHeight * 0.007),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(context.screenWidth * 0.05),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               // Profile Background Image
//               if (character.image != null && character.image!.isNotEmpty)
//                 Image.network(
//                   character.image!,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) =>
//                       _buildFallbackImage(),
//                 )
//               else
//                 _buildFallbackImage(),
//
//               // Dark Gradient Overlay
//               Positioned.fill(
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withValues(alpha: 0.1),
//                         Colors.black.withValues(alpha: 0.9),
//                       ],
//                       stops: const [0.0, 0.5, 1.0],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Profile Information Section
//               Positioned(
//                 left: context.screenWidth * 0.035,
//                 right: context.screenWidth * 0.035,
//                 bottom: context.screenHeight * 0.016,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Name
//                     CustomText.bold(
//                       character.name ?? AppStrings.defaultUnknown,
//                       fontSize: context.screenWidth * 0.048,
//                       color: Colors.white,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//
//                     // Age & Location Info
//                     Padding(
//                       padding: EdgeInsets.only(top: context.screenHeight * 0.007),
//                       child: Row(
//                         children: [
//                           // Age Icon & Text
//                           Icon(
//                             Icons.cake_outlined,
//                             color: Colors.white70,
//                             size: context.screenWidth * 0.032,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(left: context.screenWidth * 0.01),
//                             child: CustomText.regular(
//                               '${character.age ?? AppStrings.defaultNotAvailable}',
//                               fontSize: context.screenWidth * 0.03,
//                               color: Colors.white70,
//                             ),
//                           ),
//
//                           // Location Icon & Text
//                           Padding(
//                             padding: EdgeInsets.only(left: context.screenWidth * 0.02),
//                             child: Icon(
//                               Icons.location_on_outlined,
//                               color: Colors.white70,
//                               size: context.screenWidth * 0.032,
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: EdgeInsets.only(left: context.screenWidth * 0.005),
//                               child: CustomText.regular(
//                                 character.location ?? AppStrings.defaultUnknown,
//                                 fontSize: context.screenWidth * 0.03,
//                                 color: Colors.white70,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Local Image Fallback
//   Widget _buildFallbackImage() {
//     return Image.asset(
//       "assets/22.png",
//       fit: BoxFit.cover,
//       errorBuilder: (context, error, stackTrace) => Container(
//         color: Colors.grey[900],
//         child: Icon(
//           Icons.person,
//           size: context.screenWidth * 0.12,
//           color: Colors.white30,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/cupertino.dart' hide Characters;
import 'package:flutter/material.dart' hide Characters;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/home/provider/features_provider.dart';
import 'package:infinity_love/features/streak/provider/streak_provider.dart';

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
      _loadInitialData();
    });
  }

  // 🚀 Initial Fetch for Profiles and Streak
  void _loadInitialData() {
    ref.read(featuresProvider.notifier).fetchProfile();
    ref.read(streakProvider.notifier).fetchStreak();
  }

  // 🔄 Pull-To-Refresh Event Handler
  Future<void> _handleRefresh() async {
    await Future.wait([
      ref.read(featuresProvider.notifier).fetchProfile(),
      ref.read(streakProvider.notifier).fetchStreak(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(featuresProvider);
    final streakState = ref.watch(streakProvider);

    // 🟢 Dynamic streak count fetch
    final String streakCount = streakState.streak.when(
      data: (streakModel) =>
      '${streakModel?.data?.currentStreak ?? AppStrings.defaultStreakCount}',
      loading: () => '...',
      error: (_, __) => '${AppStrings.defaultStreakCount}',
    );

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
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DailyStreakScreen(),
                        ),
                      );
                      ref.read(streakProvider.notifier).fetchStreak();
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
                            streakCount,
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
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: pinkAccent,
                backgroundColor: const Color(0xFF1E1E20),
                child: profileState.profileList.when(
                  loading: () => const Center(
                    child: CupertinoActivityIndicator(color: pinkAccent),
                  ),

                  error: (error, stack) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: context.screenHeight * 0.7,
                      child: Center(
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
                                onPressed: _handleRefresh,
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
                    ),
                  ),

                  data: (FeatureModel? featureModel) {
                    final characters = featureModel?.data?.characters ?? [];

                    if (characters.isEmpty) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: context.screenHeight * 0.7,
                          child: Center(
                            child: CustomText.regular(
                              AppStrings.noProfilesAvailable,
                              color: Colors.white54,
                              fontSize: context.screenWidth * 0.04,
                            ),
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
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
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- Dynamic Profile Card Widget ---
  Widget _buildProfileCard(Characters character, BuildContext context) {
    // 🟢 Managed strictly via character.accessType
    final String accessType = character.accessType?.toUpperCase() ?? 'FREE';

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
                        Colors.black.withValues(alpha: 0.2),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.9),
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
              ),

              // 🟢 ACCESS TYPE BADGE OVERLAY (TOP-RIGHT CORNER)
              Positioned(
                top: context.screenHeight * 0.012,
                right: context.screenWidth * 0.025,
                child: _buildCardBadge(accessType, context),
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

  // 🟢 ACCESS TYPE BADGE WIDGET
  Widget _buildCardBadge(String accessType, BuildContext context) {
    final bool isSubscription = accessType == 'SUBSCRIPTION';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.screenWidth * 0.02,
        vertical: context.screenHeight * 0.004,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.screenWidth * 0.03),
        gradient: isSubscription
            ? const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFF8C00)], // Gold Badge
        )
            : const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)], // Green Badge
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: isSubscription
                ? HugeIcons.strokeRoundedCrown
                : HugeIcons.strokeRoundedGift,
            color: Colors.white,
            size: context.screenWidth * 0.03,
          ),
          SizedBox(width: context.screenWidth * 0.01),
          CustomText.bold(
            isSubscription ? 'PAID' : 'FREE',
            fontSize: context.screenWidth * 0.026,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ],
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