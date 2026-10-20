//
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:infinity_love/core/constants/app_color.dart';
// import 'package:infinity_love/core/constants/app_string.dart';
// import 'package:infinity_love/features/streak/provider/streak_provider.dart';
//
// import '../../core/constants/aniamtion.dart';
// import '../../core/constants/app_btn.dart';
// import '../../core/constants/const_text.dart';
// import 'model/streak_model.dart';
//
// class DailyStreakScreen extends ConsumerStatefulWidget {
//   const DailyStreakScreen({super.key});
//
//   @override
//   ConsumerState<DailyStreakScreen> createState() => _DailyStreakScreenState();
// }
//
// class _DailyStreakScreenState extends ConsumerState<DailyStreakScreen>
//     with SingleTickerProviderStateMixin {
//   // Countdown Timer Variables
//   Timer? _countdownTimer;
//   Duration _remainingTime = Duration.zero;
//   bool _isClaiming = false;
//   int? _claimingMilestoneDay;
//
//   // Track last parsed timestamp to avoid duplicate timer resets
//   String? _lastParsedDateStr;
//
//   // Entrance Controller & Animations
//   late AnimationController _entranceController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // 1. Fetch Streak API Data on Screen Load
//     Future.microtask(() {
//       ref.read(streakProvider.notifier).fetchStreak();
//     });
//
//     // 2. Setup Entrance Animation
//     _entranceController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.15),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _entranceController,
//         curve: Curves.easeOutCubic,
//       ),
//     );
//
//     _fadeAnimation = CurvedAnimation(
//       parent: _entranceController,
//       curve: Curves.easeIn,
//     );
//
//     _entranceController.forward();
//   }
//
//   @override
//   void dispose() {
//     _countdownTimer?.cancel();
//     _entranceController.dispose();
//     super.dispose();
//   }
//
//   void _setupTimerFromNextClaimAt(String? nextClaimAtStr) {
//     if (nextClaimAtStr == null || nextClaimAtStr.isEmpty) return;
//
//     if (_lastParsedDateStr == nextClaimAtStr && _countdownTimer?.isActive == true) {
//       return;
//     }
//
//     _lastParsedDateStr = nextClaimAtStr;
//
//     try {
//       // 🟢 Proper UTC parsing fix
//       String formattedStr = nextClaimAtStr.endsWith('Z')
//           ? nextClaimAtStr
//           : '${nextClaimAtStr}Z';
//
//       final DateTime nextClaimTime = DateTime.parse(formattedStr).toLocal();
//       final Duration diff = nextClaimTime.difference(DateTime.now());
//
//       if (diff.isNegative || diff.inSeconds <= 0) {
//         _countdownTimer?.cancel();
//         _remainingTime = Duration.zero;
//         _lastParsedDateStr = null;
//         if (mounted) {
//           setState(() {});
//         }
//       } else {
//         _remainingTime = diff;
//         _startCountdown();
//       }
//     } catch (e) {
//       debugPrint("Error parsing nextClaimAt: $e");
//     }
//   }
//
//   // --- Live Countdown Timer ---
//   void _startCountdown() {
//     _countdownTimer?.cancel();
//
//     _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_remainingTime.inSeconds > 0) {
//         if (mounted) {
//           setState(() {
//             _remainingTime = _remainingTime - const Duration(seconds: 1);
//           });
//         }
//       } else {
//         timer.cancel();
//         _onTimerFinished();
//       }
//     });
//   }
//
//   // 🚀 Time finish handler
//   void _onTimerFinished() {
//     if (!mounted) return;
//     _countdownTimer?.cancel();
//     _lastParsedDateStr = null;
//     ref.read(streakProvider.notifier).fetchStreak();
//   }
//
//   // --- Handle Daily Claim Reward API Action ---
//   Future<void> _handleClaimReward() async {
//     if (_isClaiming) return;
//
//     setState(() {
//       _isClaiming = true;
//     });
//
//     try {
//       final notifier = ref.read(streakProvider.notifier);
//       final success = await notifier.claimStreak();
//
//       if (success && mounted) {
//         _countdownTimer?.cancel();
//         _lastParsedDateStr = null;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: CustomText.medium(
//               AppStrings.msgDailyStreakClaimed,
//               color: AppColors.whiteSheetBg,
//             ),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: CustomText.medium(
//               '${AppStrings.msgFailedToClaimStreak}${e.toString()}',
//               color: AppColors.whiteSheetBg,
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isClaiming = false;
//         });
//       }
//     }
//   }
//
//   // --- Handle Milestone Reward Claim Action ---
//   Future<void> _handleClaimMilestone(Milestones milestone) async {
//     final int day = milestone.day ?? 0;
//     if (_claimingMilestoneDay != null || _isClaiming) return;
//
//     setState(() {
//       _claimingMilestoneDay = day;
//     });
//
//     try {
//       final notifier = ref.read(streakProvider.notifier);
//       final success = await notifier.claimStreak();
//
//       if (success && mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: CustomText.medium(
//               AppStrings.milestoneUnlockedMsg(day),
//               color: AppColors.whiteSheetBg,
//             ),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: CustomText.medium(
//               '${AppStrings.msgFailedToClaimMilestone}${e.toString()}',
//               color: AppColors.whiteSheetBg,
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _claimingMilestoneDay = null;
//         });
//       }
//     }
//   }
//
//   // Duration Formatter (HH:MM:SS)
//   String _formatDuration(Duration duration) {
//     String hours = duration.inHours.toString().padLeft(2, '0');
//     String minutes =
//     duration.inMinutes.remainder(60).toString().padLeft(2, '0');
//     String seconds =
//     duration.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return '$hours:$minutes:$seconds';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // 🟢 Riverpod State Listener
//     ref.listen(streakProvider, (previous, next) {
//       final data = next.streak.value?.data;
//       if (data != null) {
//         final bool canClaim = data.canClaim ?? false;
//
//         // Read nextClaimAt from API model
//         final String? nextClaimAt = data.nextClaimAt;
//
//         if (canClaim) {
//           _countdownTimer?.cancel();
//           _lastParsedDateStr = null;
//         } else if (nextClaimAt != null) {
//           _setupTimerFromNextClaimAt(nextClaimAt);
//         }
//       }
//     });
//
//     final streakState = ref.watch(streakProvider);
//     final streakAsync = streakState.streak;
//
//     return Scaffold(
//       backgroundColor: AppColors.bgBlack,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const HugeIcon(
//             icon: HugeIcons.strokeRoundedArrowLeft01,
//             color: AppColors.textPrimaryLight,
//             size: 24.0,
//           ),
//           onPressed: () => Navigator.maybePop(context),
//         ),
//         title: CustomText.bold(
//           AppStrings.dailyStreakTitle,
//           fontSize: 20,
//           color: AppColors.textPrimaryLight,
//         ),
//         centerTitle: true,
//       ),
//       body: SlideTransition(
//         position: _slideAnimation,
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: streakAsync.when(
//             data: (streakModel) {
//               final streakData = streakModel?.data;
//               final int currentStreak = streakData?.currentStreak ?? 0;
//               final int bestStreak = streakData?.bestStreak ?? 0;
//               final bool canClaim = streakData?.canClaim ?? false;
//               final List<Milestones> milestones = streakData?.milestones ?? [];
//
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 20.0, vertical: 12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // --- 1. Streak Main Card ---
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 36.0, horizontal: 20.0),
//                       decoration: BoxDecoration(
//                         color: AppColors.profileCardBg,
//                         borderRadius: BorderRadius.circular(28),
//                         border: Border.all(
//                           color: AppColors.cardBorder,
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           AnimatedFlameBadge(
//                             canClaim: canClaim, // ya showClaimUI agar aapne purna flag rakha tha
//                             streakBreak: streakData?.streakBreak ?? false,
//                           ),
//                           const SizedBox(height: 24),
//                           CustomText.bold(
//                             '$currentStreak',
//                             fontSize: 72,
//                             color: AppColors.textPrimaryLight,
//                             height: 1.0,
//                           ),
//                           const SizedBox(height: 8),
//                           CustomText.bold(
//                             AppStrings.dayStreakLabel,
//                             fontSize: 14,
//                             letterSpacing: 3.0,
//                             color: AppColors.textSecondaryLight,
//                           ),
//                           const SizedBox(height: 14),
//                           CustomText.regular(
//                             AppStrings.bestStreakText(bestStreak),
//                             fontSize: 14,
//                             color: AppColors.lightPink,
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // --- 2. Dynamic Claim Button OR 24h Countdown Timer ---
//                     if (canClaim)
//                       AppBtn(
//                         height: 62,
//                         borderRadius: 20,
//                         gradient: AppColors.buttonGradient,
//                         loading: _isClaiming,
//                         onTap: _handleClaimReward,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const HugeIcon(
//                               icon: HugeIcons.strokeRoundedGift,
//                               color: AppColors.whiteSheetBg,
//                               size: 24,
//                             ),
//                             const SizedBox(width: 8),
//                             CustomText.bold(
//                               AppStrings.claimRewardBtn,
//                               fontSize: 18,
//                               color: AppColors.whiteSheetBg,
//                               letterSpacing: 2.0,
//                             ),
//                           ],
//                         ),
//                       )
//                     else
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(vertical: 20.0),
//                         decoration: BoxDecoration(
//                           color: AppColors.profileCardBg,
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(
//                             color: AppColors.cardBorder,
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             CustomText.regular(
//                               AppStrings.nextClaimInLabel,
//                               fontSize: 14,
//                               color: AppColors.textSecondaryLight,
//                             ),
//                             const SizedBox(height: 6),
//                             CustomText.bold(
//                               _formatDuration(_remainingTime),
//                               fontSize: 36,
//                               color: AppColors.primaryPink,
//                               letterSpacing: 1.5,
//                             ),
//                           ],
//                         ),
//                       ),
//
//                     // --- 3. Milestone Rewards Section ---
//                     if (milestones.isNotEmpty) ...[
//                       const SizedBox(height: 28),
//                       CustomText.bold(
//                         AppStrings.milestoneRewardsHeader,
//                         fontSize: 20,
//                         color: AppColors.textPrimaryLight,
//                       ),
//                       const SizedBox(height: 16),
//                       ListView.separated(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: milestones.length,
//                         separatorBuilder: (context, index) =>
//                         const SizedBox(height: 12),
//                         itemBuilder: (context, index) {
//                           final milestone = milestones[index];
//                           return _buildDynamicMilestoneTile(milestone);
//                         },
//                       ),
//                     ],
//
//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               );
//             },
//             loading: () => const Center(
//               child: CircularProgressIndicator(
//                 color: AppColors.primaryPink,
//               ),
//             ),
//             error: (error, stack) => Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CustomText.medium(
//                     error.toString().replaceAll('Exception: ', ''),
//                     color: AppColors.textSecondaryLight,
//                     fontSize: 14,
//                   ),
//                   const SizedBox(height: 12),
//                   AppBtn(
//                     width: 120,
//                     height: 44,
//                     color: AppColors.primaryPink,
//                     title: AppStrings.retry,
//                     onTap: () {
//                       _lastParsedDateStr = null;
//                       ref.read(streakProvider.notifier).fetchStreak();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- Dynamic Milestone Tile Widget ---
//   Widget _buildDynamicMilestoneTile(Milestones milestone) {
//     final bool isUnlocked = milestone.unlocked ?? false;
//     final bool isClaimed = milestone.claimed ?? false;
//     final bool isClaimable = isUnlocked && !isClaimed;
//     final bool isLoadingThisMilestone =
//         _claimingMilestoneDay == milestone.day;
//
//     String rewardTitle = AppStrings.dayRewardText(milestone.day ?? 0);
//     String rewardEmoji = '🎁';
//
//     final type = milestone.rewardType ?? '';
//
//     if (type == 'DIAMOND' ||
//         type == 'DIAMONDS' ||
//         type == 'COIN' ||
//         type == 'COINS') {
//       rewardTitle = '${milestone.rewardValue ?? 0} $type';
//       rewardEmoji = '💎';
//     } else if (type == 'CHARACTER') {
//       rewardTitle = AppStrings.rewardUnlockCharacter;
//       rewardEmoji = '👤';
//     } else if (type == 'ROLEPLAY') {
//       rewardTitle = AppStrings.rewardUnlockRoleplay;
//       rewardEmoji = '🎭';
//     }
//
//     final String? imgUrl = milestone.imageUrl;
//     final bool hasImage = imgUrl != null && imgUrl.isNotEmpty;
//
//     return Container(
//       padding: const EdgeInsets.all(14.0),
//       decoration: BoxDecoration(
//         color: AppColors.profileCardBg,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: isClaimable
//               ? AppColors.primaryPink
//               : (isClaimed
//               ? Colors.green.withOpacity(0.3)
//               : AppColors.cardBorder),
//           width: isClaimable ? 1.5 : 1.0,
//         ),
//       ),
//       child: Row(
//         children: [
//           // 🟢 Network Image with Fallback Emoji Badge
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: AppColors.cardDarkBg,
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: isUnlocked ? AppColors.primaryPink : Colors.transparent,
//               ),
//             ),
//             child: ClipOval(
//               child: hasImage
//                   ? Image.network(
//                 imgUrl,
//                 fit: BoxFit.contain,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return const Center(
//                     child: SizedBox(
//                       width: 18,
//                       height: 18,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: AppColors.primaryPink,
//                       ),
//                     ),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return Center(
//                     child: CustomText.bold(
//                       rewardEmoji,
//                       fontSize: 20,
//                     ),
//                   );
//                 },
//               )
//                   : Center(
//                 child: CustomText.bold(
//                   rewardEmoji,
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 14),
//
//           // Titles
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText.regular(
//                   AppStrings.dayLabel(milestone.day ?? 0),
//                   fontSize: 12,
//                   color: AppColors.textSecondaryLight,
//                 ),
//                 const SizedBox(height: 2),
//                 CustomText.bold(
//                   rewardTitle,
//                   fontSize: 15,
//                   color: AppColors.textPrimaryLight,
//                 ),
//               ],
//             ),
//           ),
//
//           // Dynamic Status / Claim Button
//           AppBtn(
//             width: 85,
//             height: 36,
//             borderRadius: 12,
//             loading: isLoadingThisMilestone,
//             gradient: isClaimable ? AppColors.buttonGradient : null,
//             color: isClaimable
//                 ? null
//                 : (isClaimed
//                 ? Colors.green.withOpacity(0.2)
//                 : AppColors.cardDarkBg),
//             onTap: isClaimable && !isLoadingThisMilestone
//                 ? () => _handleClaimMilestone(milestone)
//                 : null,
//             child: CustomText.bold(
//               isClaimed
//                   ? AppStrings.statusClaimed
//                   : (isClaimable
//                   ? AppStrings.statusClaim
//                   : AppStrings.statusLocked),
//               fontSize: 12,
//               color: isClaimable
//                   ? AppColors.whiteSheetBg
//                   : (isClaimed ? Colors.green : AppColors.textSecondaryLight),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:infinity_love/core/constants/app_color.dart';
// import 'package:infinity_love/core/constants/app_string.dart';
// import 'package:infinity_love/features/streak/provider/streak_provider.dart';
//
// import '../../core/constants/aniamtion.dart';
// import '../../core/constants/app_btn.dart';
// import '../../core/constants/const_text.dart';
// import 'model/streak_model.dart';
//
// class DailyStreakScreen extends ConsumerStatefulWidget {
//   const DailyStreakScreen({super.key});
//
//   @override
//   ConsumerState<DailyStreakScreen> createState() => _DailyStreakScreenState();
// }
//
// class _DailyStreakScreenState extends ConsumerState<DailyStreakScreen>
//     with SingleTickerProviderStateMixin {
//   // Countdown Timer Variables
//   Timer? _countdownTimer;
//   Duration _remainingTime = Duration.zero;
//   bool _isClaiming = false;
//   int? _claimingMilestoneDay;
//
//   // Track last parsed timestamp to avoid duplicate timer resets
//   String? _lastParsedDateStr;
//
//   // Entrance Controller & Animations
//   late AnimationController _entranceController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // 1. Fetch Streak API Data on Screen Load
//     Future.microtask(() {
//       ref.read(streakProvider.notifier).fetchStreak();
//     });
//
//     // 2. Setup Entrance Animation
//     _entranceController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.15),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _entranceController,
//         curve: Curves.easeOutCubic,
//       ),
//     );
//
//     _fadeAnimation = CurvedAnimation(
//       parent: _entranceController,
//       curve: Curves.easeIn,
//     );
//
//     _entranceController.forward();
//   }
//
//   @override
//   void dispose() {
//     _countdownTimer?.cancel();
//     _entranceController.dispose();
//     super.dispose();
//   }
//
//   void _setupTimerFromNextClaimAt(String? nextClaimAtStr) {
//     if (nextClaimAtStr == null || nextClaimAtStr.isEmpty) return;
//
//     if (_lastParsedDateStr == nextClaimAtStr && _countdownTimer?.isActive == true) {
//       return;
//     }
//
//     _lastParsedDateStr = nextClaimAtStr;
//
//     try {
//       // 🟢 Proper UTC parsing fix
//       String formattedStr = nextClaimAtStr.endsWith('Z')
//           ? nextClaimAtStr
//           : '${nextClaimAtStr}Z';
//
//       final DateTime nextClaimTime = DateTime.parse(formattedStr).toLocal();
//       final Duration diff = nextClaimTime.difference(DateTime.now());
//
//       if (diff.isNegative || diff.inSeconds <= 0) {
//         _countdownTimer?.cancel();
//         _remainingTime = Duration.zero;
//         _lastParsedDateStr = null;
//         if (mounted) {
//           setState(() {});
//         }
//       } else {
//         _remainingTime = diff;
//         _startCountdown();
//       }
//     } catch (e) {
//       debugPrint("Error parsing nextClaimAt: $e");
//     }
//   }
//
//   // --- Live Countdown Timer ---
//   void _startCountdown() {
//     _countdownTimer?.cancel();
//
//     _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_remainingTime.inSeconds > 0) {
//         if (mounted) {
//           setState(() {
//             _remainingTime = _remainingTime - const Duration(seconds: 1);
//           });
//         }
//       } else {
//         timer.cancel();
//         _onTimerFinished();
//       }
//     });
//   }
//
//   // 🚀 Time finish handler
//   void _onTimerFinished() {
//     if (!mounted) return;
//     _countdownTimer?.cancel();
//     _lastParsedDateStr = null;
//     ref.read(streakProvider.notifier).fetchStreak();
//   }
//
//   // --- Handle Daily Claim Reward API Action ---
//   Future<void> _handleClaimReward() async {
//     if (_isClaiming) return;
//
//     setState(() {
//       _isClaiming = true;
//     });
//
//     try {
//       final notifier = ref.read(streakProvider.notifier);
//       final success = await notifier.claimStreak();
//
//       if (success && mounted) {
//         _countdownTimer?.cancel();
//         _lastParsedDateStr = null;
//
//         // 🟢 FIX: refresh streak data so ref.listen picks up the new
//         // nextClaimAt / canClaim and (re)starts the countdown timer.
//         await notifier.fetchStreak();
//
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: CustomText.medium(
//                 AppStrings.msgDailyStreakClaimed,
//                 color: AppColors.whiteSheetBg,
//               ),
//               backgroundColor: Colors.green,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: CustomText.medium(
//               '${AppStrings.msgFailedToClaimStreak}${e.toString()}',
//               color: AppColors.whiteSheetBg,
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isClaiming = false;
//         });
//       }
//     }
//   }
//
//   // --- Handle Milestone Reward Claim Action ---
//   Future<void> _handleClaimMilestone(Milestones milestone) async {
//     final int day = milestone.day ?? 0;
//     if (_claimingMilestoneDay != null || _isClaiming) return;
//
//     setState(() {
//       _claimingMilestoneDay = day;
//     });
//
//     try {
//       final notifier = ref.read(streakProvider.notifier);
//       final success = await notifier.claimStreak();
//
//       if (success && mounted) {
//         // 🟢 FIX: refresh here too, otherwise timer/canClaim state
//         // stays stale after claiming a milestone.
//         _countdownTimer?.cancel();
//         _lastParsedDateStr = null;
//         await notifier.fetchStreak();
//
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: CustomText.medium(
//                 AppStrings.milestoneUnlockedMsg(day),
//                 color: AppColors.whiteSheetBg,
//               ),
//               backgroundColor: Colors.green,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: CustomText.medium(
//               '${AppStrings.msgFailedToClaimMilestone}${e.toString()}',
//               color: AppColors.whiteSheetBg,
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _claimingMilestoneDay = null;
//         });
//       }
//     }
//   }
//
//   // Duration Formatter (HH:MM:SS)
//   String _formatDuration(Duration duration) {
//     String hours = duration.inHours.toString().padLeft(2, '0');
//     String minutes =
//     duration.inMinutes.remainder(60).toString().padLeft(2, '0');
//     String seconds =
//     duration.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return '$hours:$minutes:$seconds';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // 🟢 Riverpod State Listener
//     ref.listen(streakProvider, (previous, next) {
//       final data = next.streak.value?.data;
//       if (data != null) {
//         final bool canClaim = data.canClaim ?? false;
//
//         // Read nextClaimAt from API model
//         final String? nextClaimAt = data.nextClaimAt;
//
//         if (canClaim) {
//           _countdownTimer?.cancel();
//           _lastParsedDateStr = null;
//         } else if (nextClaimAt != null) {
//           _setupTimerFromNextClaimAt(nextClaimAt);
//         }
//       }
//     });
//
//     final streakState = ref.watch(streakProvider);
//     final streakAsync = streakState.streak;
//
//     return Scaffold(
//       backgroundColor: AppColors.bgBlack,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const HugeIcon(
//             icon: HugeIcons.strokeRoundedArrowLeft01,
//             color: AppColors.textPrimaryLight,
//             size: 24.0,
//           ),
//           onPressed: () => Navigator.maybePop(context),
//         ),
//         title: CustomText.bold(
//           AppStrings.dailyStreakTitle,
//           fontSize: 20,
//           color: AppColors.textPrimaryLight,
//         ),
//         centerTitle: true,
//       ),
//       body: SlideTransition(
//         position: _slideAnimation,
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: streakAsync.when(
//             data: (streakModel) {
//               final streakData = streakModel?.data;
//               final int currentStreak = streakData?.currentStreak ?? 0;
//               final int bestStreak = streakData?.bestStreak ?? 0;
//               final bool canClaim = streakData?.canClaim ?? false;
//               final List<Milestones> milestones = streakData?.milestones ?? [];
//
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 20.0, vertical: 12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // --- 1. Streak Main Card ---
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 36.0, horizontal: 20.0),
//                       decoration: BoxDecoration(
//                         color: AppColors.profileCardBg,
//                         borderRadius: BorderRadius.circular(28),
//                         border: Border.all(
//                           color: AppColors.cardBorder,
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           AnimatedFlameBadge(
//                             canClaim: canClaim, // ya showClaimUI agar aapne purna flag rakha tha
//                             streakBreak: streakData?.streakBreak ?? false,
//                           ),
//                           const SizedBox(height: 24),
//                           CustomText.bold(
//                             '$currentStreak',
//                             fontSize: 72,
//                             color: AppColors.textPrimaryLight,
//                             height: 1.0,
//                           ),
//                           const SizedBox(height: 8),
//                           CustomText.bold(
//                             AppStrings.dayStreakLabel,
//                             fontSize: 14,
//                             letterSpacing: 3.0,
//                             color: AppColors.textSecondaryLight,
//                           ),
//                           const SizedBox(height: 14),
//                           CustomText.regular(
//                             AppStrings.bestStreakText(bestStreak),
//                             fontSize: 14,
//                             color: AppColors.lightPink,
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // --- 2. Dynamic Claim Button OR 24h Countdown Timer ---
//                     if (canClaim)
//                       AppBtn(
//                         height: 62,
//                         borderRadius: 20,
//                         gradient: AppColors.buttonGradient,
//                         loading: _isClaiming,
//                         onTap: _handleClaimReward,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const HugeIcon(
//                               icon: HugeIcons.strokeRoundedGift,
//                               color: AppColors.whiteSheetBg,
//                               size: 24,
//                             ),
//                             const SizedBox(width: 8),
//                             CustomText.bold(
//                               AppStrings.claimRewardBtn,
//                               fontSize: 18,
//                               color: AppColors.whiteSheetBg,
//                               letterSpacing: 2.0,
//                             ),
//                           ],
//                         ),
//                       )
//                     else
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(vertical: 20.0),
//                         decoration: BoxDecoration(
//                           color: AppColors.profileCardBg,
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(
//                             color: AppColors.cardBorder,
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             CustomText.regular(
//                               AppStrings.nextClaimInLabel,
//                               fontSize: 14,
//                               color: AppColors.textSecondaryLight,
//                             ),
//                             const SizedBox(height: 6),
//                             CustomText.bold(
//                               _formatDuration(_remainingTime),
//                               fontSize: 36,
//                               color: AppColors.primaryPink,
//                               letterSpacing: 1.5,
//                             ),
//                           ],
//                         ),
//                       ),
//
//                     // --- 3. Milestone Rewards Section ---
//                     if (milestones.isNotEmpty) ...[
//                       const SizedBox(height: 28),
//                       CustomText.bold(
//                         AppStrings.milestoneRewardsHeader,
//                         fontSize: 20,
//                         color: AppColors.textPrimaryLight,
//                       ),
//                       const SizedBox(height: 16),
//                       ListView.separated(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: milestones.length,
//                         separatorBuilder: (context, index) =>
//                         const SizedBox(height: 12),
//                         itemBuilder: (context, index) {
//                           final milestone = milestones[index];
//                           return _buildDynamicMilestoneTile(milestone);
//                         },
//                       ),
//                     ],
//
//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               );
//             },
//             loading: () => const Center(
//               child: CircularProgressIndicator(
//                 color: AppColors.primaryPink,
//               ),
//             ),
//             error: (error, stack) => Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CustomText.medium(
//                     error.toString().replaceAll('Exception: ', ''),
//                     color: AppColors.textSecondaryLight,
//                     fontSize: 14,
//                   ),
//                   const SizedBox(height: 12),
//                   AppBtn(
//                     width: 120,
//                     height: 44,
//                     color: AppColors.primaryPink,
//                     title: AppStrings.retry,
//                     onTap: () {
//                       _lastParsedDateStr = null;
//                       ref.read(streakProvider.notifier).fetchStreak();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- Dynamic Milestone Tile Widget ---
//   Widget _buildDynamicMilestoneTile(Milestones milestone) {
//     final bool isUnlocked = milestone.unlocked ?? false;
//     final bool isClaimed = milestone.claimed ?? false;
//     final bool isClaimable = isUnlocked && !isClaimed;
//     final bool isLoadingThisMilestone =
//         _claimingMilestoneDay == milestone.day;
//
//     String rewardTitle = AppStrings.dayRewardText(milestone.day ?? 0);
//     String rewardEmoji = '🎁';
//
//     final type = milestone.rewardType ?? '';
//
//     if (type == 'DIAMOND' ||
//         type == 'DIAMONDS' ||
//         type == 'COIN' ||
//         type == 'COINS') {
//       rewardTitle = '${milestone.rewardValue ?? 0} $type';
//       rewardEmoji = '💎';
//     } else if (type == 'CHARACTER') {
//       rewardTitle = AppStrings.rewardUnlockCharacter;
//       rewardEmoji = '👤';
//     } else if (type == 'ROLEPLAY') {
//       rewardTitle = AppStrings.rewardUnlockRoleplay;
//       rewardEmoji = '🎭';
//     }
//
//     final String? imgUrl = milestone.imageUrl;
//     final bool hasImage = imgUrl != null && imgUrl.isNotEmpty;
//
//     return Container(
//       padding: const EdgeInsets.all(14.0),
//       decoration: BoxDecoration(
//         color: AppColors.profileCardBg,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: isClaimable
//               ? AppColors.primaryPink
//               : (isClaimed
//               ? Colors.green.withOpacity(0.3)
//               : AppColors.cardBorder),
//           width: isClaimable ? 1.5 : 1.0,
//         ),
//       ),
//       child: Row(
//         children: [
//           // 🟢 Network Image with Fallback Emoji Badge
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: AppColors.cardDarkBg,
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: isUnlocked ? AppColors.primaryPink : Colors.transparent,
//               ),
//             ),
//             child: ClipOval(
//               child: hasImage
//                   ? Image.network(
//                 imgUrl,
//                 fit: BoxFit.contain,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return const Center(
//                     child: SizedBox(
//                       width: 18,
//                       height: 18,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: AppColors.primaryPink,
//                       ),
//                     ),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return Center(
//                     child: CustomText.bold(
//                       rewardEmoji,
//                       fontSize: 20,
//                     ),
//                   );
//                 },
//               )
//                   : Center(
//                 child: CustomText.bold(
//                   rewardEmoji,
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 14),
//
//           // Titles
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText.regular(
//                   AppStrings.dayLabel(milestone.day ?? 0),
//                   fontSize: 12,
//                   color: AppColors.textSecondaryLight,
//                 ),
//                 const SizedBox(height: 2),
//                 CustomText.bold(
//                   rewardTitle,
//                   fontSize: 15,
//                   color: AppColors.textPrimaryLight,
//                 ),
//               ],
//             ),
//           ),
//
//           // Dynamic Status / Claim Button
//           AppBtn(
//             width: 85,
//             height: 36,
//             borderRadius: 12,
//             loading: isLoadingThisMilestone,
//             gradient: isClaimable ? AppColors.buttonGradient : null,
//             color: isClaimable
//                 ? null
//                 : (isClaimed
//                 ? Colors.green.withOpacity(0.2)
//                 : AppColors.cardDarkBg),
//             onTap: isClaimable && !isLoadingThisMilestone
//                 ? () => _handleClaimMilestone(milestone)
//                 : null,
//             child: CustomText.bold(
//               isClaimed
//                   ? AppStrings.statusClaimed
//                   : (isClaimable
//                   ? AppStrings.statusClaim
//                   : AppStrings.statusLocked),
//               fontSize: 12,
//               color: isClaimable
//                   ? AppColors.whiteSheetBg
//                   : (isClaimed ? Colors.green : AppColors.textSecondaryLight),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/core/constants/app_string.dart';
import 'package:infinity_love/features/streak/provider/streak_provider.dart';

import '../../core/constants/aniamtion.dart';
import '../../core/constants/app_btn.dart';
import '../../core/constants/const_text.dart';
import 'model/streak_model.dart';

class DailyStreakScreen extends ConsumerStatefulWidget {
  const DailyStreakScreen({super.key});

  @override
  ConsumerState<DailyStreakScreen> createState() => _DailyStreakScreenState();
}

class _DailyStreakScreenState extends ConsumerState<DailyStreakScreen>
    with SingleTickerProviderStateMixin {
  // Countdown Timer Variables
  Timer? _countdownTimer;
  Duration _remainingTime = Duration.zero;
  bool _isClaiming = false;
  int? _claimingMilestoneDay;

  // Track last parsed timestamp to avoid duplicate timer resets
  String? _lastParsedDateStr;

  // Entrance Controller & Animations
  late AnimationController _entranceController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Fetch Streak API Data on Screen Load
    Future.microtask(() {
      ref.read(streakProvider.notifier).fetchStreak();
    });

    // 2. Setup Entrance Animation
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

  void _setupTimerFromNextClaimAt(String? nextClaimAtStr) {
    if (nextClaimAtStr == null || nextClaimAtStr.isEmpty) return;

    if (_lastParsedDateStr == nextClaimAtStr && _countdownTimer?.isActive == true) {
      return;
    }

    _lastParsedDateStr = nextClaimAtStr;

    try {
      // 🟢 Proper UTC parsing fix
      String formattedStr = nextClaimAtStr.endsWith('Z')
          ? nextClaimAtStr
          : '${nextClaimAtStr}Z';

      final DateTime nextClaimTime = DateTime.parse(formattedStr).toLocal();
      final Duration diff = nextClaimTime.difference(DateTime.now());

      if (diff.isNegative || diff.inSeconds <= 0) {
        _countdownTimer?.cancel();
        _remainingTime = Duration.zero;
        _lastParsedDateStr = null;
        if (mounted) {
          setState(() {});
        }
      } else {
        _remainingTime = diff;
        _startCountdown();
      }
    } catch (e) {
      debugPrint("Error parsing nextClaimAt: $e");
    }
  }

  // --- Live Countdown Timer ---
  void _startCountdown() {
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingTime = _remainingTime - const Duration(seconds: 1);
          });
        }
      } else {
        timer.cancel();
        _onTimerFinished();
      }
    });
  }

  // 🚀 Time finish handler
  void _onTimerFinished() {
    if (!mounted) return;
    _countdownTimer?.cancel();
    _lastParsedDateStr = null;
    ref.read(streakProvider.notifier).fetchStreak();
  }

  // --- Handle Daily Claim Reward API Action ---
  Future<void> _handleClaimReward() async {
    if (_isClaiming) return;

    setState(() {
      _isClaiming = true;
    });

    try {
      final notifier = ref.read(streakProvider.notifier);
      final success = await notifier.claimStreak();

      if (success && mounted) {
        _countdownTimer?.cancel();
        _lastParsedDateStr = null;

        // 🟢 FIX: refresh streak data so ref.listen picks up the new
        // nextClaimAt / canClaim and (re)starts the countdown timer.
        await notifier.fetchStreak();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomText.medium(
                AppStrings.msgDailyStreakClaimed,
                color: AppColors.whiteSheetBg,
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText.medium(
              '${AppStrings.msgFailedToClaimStreak}${e.toString()}',
              color: AppColors.whiteSheetBg,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isClaiming = false;
        });
      }
    }
  }

  // --- Handle Milestone Reward Claim Action ---
  Future<void> _handleClaimMilestone(Milestones milestone) async {
    final int day = milestone.day ?? 0;
    // 🟢 Milestone ki _id (ya sId) extract kar rahe hain
    final String milestoneId = milestone.sId ?? '';

    if (_claimingMilestoneDay != null || _isClaiming) return;

    if (milestoneId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: CustomText.medium(
            'Milestone ID not found!',
            color: AppColors.whiteSheetBg,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _claimingMilestoneDay = day;
    });

    try {
      final notifier = ref.read(streakProvider.notifier);
      // 🟢 claimReward me milestone _id pass ho rahi hai
      final success = await notifier.claimReward(milestoneId);

      if (success && mounted) {
        _countdownTimer?.cancel();
        _lastParsedDateStr = null;
        await notifier.fetchStreak();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomText.medium(
                AppStrings.milestoneUnlockedMsg(day),
                color: AppColors.whiteSheetBg,
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText.medium(
              '${AppStrings.msgFailedToClaimMilestone}${e.toString()}',
              color: AppColors.whiteSheetBg,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _claimingMilestoneDay = null;
        });
      }
    }
  }

  // Duration Formatter (HH:MM:SS)
  String _formatDuration(Duration duration) {
    String hours = duration.inHours.toString().padLeft(2, '0');
    String minutes =
    duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
    duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    // 🟢 Riverpod State Listener
    ref.listen(streakProvider, (previous, next) {
      final data = next.streak.value?.data;
      if (data != null) {
        final bool canClaim = data.canClaim ?? false;

        // Read nextClaimAt from API model
        final String? nextClaimAt = data.nextClaimAt;

        if (canClaim) {
          _countdownTimer?.cancel();
          _lastParsedDateStr = null;
        } else if (nextClaimAt != null) {
          _setupTimerFromNextClaimAt(nextClaimAt);
        }
      }
    });

    final streakState = ref.watch(streakProvider);
    final streakAsync = streakState.streak;

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
          AppStrings.dailyStreakTitle,
          fontSize: 20,
          color: AppColors.textPrimaryLight,
        ),
        centerTitle: true,
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: streakAsync.when(
            data: (streakModel) {
              final streakData = streakModel?.data;
              final int currentStreak = streakData?.currentStreak ?? 0;
              final int bestStreak = streakData?.bestStreak ?? 0;
              final bool canClaim = streakData?.canClaim ?? false;
              final List<Milestones> milestones = streakData?.milestones ?? [];

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 1. Streak Main Card ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 36.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: AppColors.profileCardBg,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: AppColors.cardBorder,
                        ),
                      ),
                      child: Column(
                        children: [
                          AnimatedFlameBadge(
                            canClaim: canClaim,
                            streakBreak: streakData?.streakBreak ?? false,
                          ),
                          const SizedBox(height: 24),
                          CustomText.bold(
                            '$currentStreak',
                            fontSize: 72,
                            color: AppColors.textPrimaryLight,
                            height: 1.0,
                          ),
                          const SizedBox(height: 8),
                          CustomText.bold(
                            AppStrings.dayStreakLabel,
                            fontSize: 14,
                            letterSpacing: 3.0,
                            color: AppColors.textSecondaryLight,
                          ),
                          const SizedBox(height: 14),
                          CustomText.regular(
                            AppStrings.bestStreakText(bestStreak),
                            fontSize: 14,
                            color: AppColors.lightPink,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- 2. Dynamic Claim Button OR 24h Countdown Timer ---
                    if (canClaim)
                      AppBtn(
                        height: 62,
                        borderRadius: 20,
                        gradient: AppColors.buttonGradient,
                        loading: _isClaiming,
                        onTap: _handleClaimReward,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedGift,
                              color: AppColors.whiteSheetBg,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            CustomText.bold(
                              AppStrings.claimRewardBtn,
                              fontSize: 18,
                              color: AppColors.whiteSheetBg,
                              letterSpacing: 2.0,
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        decoration: BoxDecoration(
                          color: AppColors.profileCardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.cardBorder,
                          ),
                        ),
                        child: Column(
                          children: [
                            CustomText.regular(
                              AppStrings.nextClaimInLabel,
                              fontSize: 14,
                              color: AppColors.textSecondaryLight,
                            ),
                            const SizedBox(height: 6),
                            CustomText.bold(
                              _formatDuration(_remainingTime),
                              fontSize: 36,
                              color: AppColors.primaryPink,
                              letterSpacing: 1.5,
                            ),
                          ],
                        ),
                      ),

                    // --- 3. Milestone Rewards Section ---
                    if (milestones.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      CustomText.bold(
                        AppStrings.milestoneRewardsHeader,
                        fontSize: 20,
                        color: AppColors.textPrimaryLight,
                      ),
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: milestones.length,
                        separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final milestone = milestones[index];
                          return _buildDynamicMilestoneTile(milestone);
                        },
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryPink,
              ),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText.medium(
                    error.toString().replaceAll('Exception: ', ''),
                    color: AppColors.textSecondaryLight,
                    fontSize: 14,
                  ),
                  const SizedBox(height: 12),
                  AppBtn(
                    width: 120,
                    height: 44,
                    color: AppColors.primaryPink,
                    title: AppStrings.retry,
                    onTap: () {
                      _lastParsedDateStr = null;
                      ref.read(streakProvider.notifier).fetchStreak();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Dynamic Milestone Tile Widget ---
  Widget _buildDynamicMilestoneTile(Milestones milestone) {
    final bool isUnlocked = milestone.unlocked ?? false;
    final bool isClaimed = milestone.claimed ?? false;
    final bool isClaimable = isUnlocked && !isClaimed;
    final bool isLoadingThisMilestone =
        _claimingMilestoneDay == milestone.day;

    String rewardTitle = AppStrings.dayRewardText(milestone.day ?? 0);
    String rewardEmoji = '🎁';

    final type = milestone.rewardType ?? '';

    if (type == 'DIAMOND' ||
        type == 'DIAMONDS' ||
        type == 'COIN' ||
        type == 'COINS') {
      rewardTitle = '${milestone.rewardValue ?? 0} $type';
      rewardEmoji = '💎';
    } else if (type == 'CHARACTER') {
      rewardTitle = AppStrings.rewardUnlockCharacter;
      rewardEmoji = '👤';
    } else if (type == 'ROLEPLAY') {
      rewardTitle = AppStrings.rewardUnlockRoleplay;
      rewardEmoji = '🎭';
    }

    final String? imgUrl = milestone.imageUrl;
    final bool hasImage = imgUrl != null && imgUrl.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppColors.profileCardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isClaimable
              ? AppColors.primaryPink
              : (isClaimed
              ? Colors.green.withOpacity(0.3)
              : AppColors.cardBorder),
          width: isClaimable ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          // 🟢 Network Image with Fallback Emoji Badge
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.cardDarkBg,
              shape: BoxShape.circle,
              border: Border.all(
                color: isUnlocked ? AppColors.primaryPink : Colors.transparent,
              ),
            ),
            child: ClipOval(
              child: hasImage
                  ? Image.network(
                imgUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryPink,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: CustomText.bold(
                      rewardEmoji,
                      fontSize: 20,
                    ),
                  );
                },
              )
                  : Center(
                child: CustomText.bold(
                  rewardEmoji,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Titles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.regular(
                  AppStrings.dayLabel(milestone.day ?? 0),
                  fontSize: 12,
                  color: AppColors.textSecondaryLight,
                ),
                const SizedBox(height: 2),
                CustomText.bold(
                  rewardTitle,
                  fontSize: 15,
                  color: AppColors.textPrimaryLight,
                ),
              ],
            ),
          ),

          // Dynamic Status / Claim Button
          AppBtn(
            width: 85,
            height: 36,
            borderRadius: 12,
            loading: isLoadingThisMilestone,
            gradient: isClaimable ? AppColors.buttonGradient : null,
            color: isClaimable
                ? null
                : (isClaimed
                ? Colors.green.withOpacity(0.2)
                : AppColors.cardDarkBg),
            onTap: isClaimable && !isLoadingThisMilestone
                ? () => _handleClaimMilestone(milestone)
                : null,
            child: CustomText.bold(
              isClaimed
                  ? AppStrings.statusClaimed
                  : (isClaimable
                  ? AppStrings.statusClaim
                  : AppStrings.statusLocked),
              fontSize: 12,
              color: isClaimable
                  ? AppColors.whiteSheetBg
                  : (isClaimed ? Colors.green : AppColors.textSecondaryLight),
            ),
          ),
        ],
      ),
    );
  }
}