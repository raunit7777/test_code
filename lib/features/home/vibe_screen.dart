
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/home/provider/features_provider.dart';

import '../../core/constants/const_text.dart';
import '../describe_image/subcription_screen.dart';
import 'model/vibe_model.dart';

class VibeScreen extends ConsumerStatefulWidget {
  const VibeScreen({super.key});

  @override
  ConsumerState<VibeScreen> createState() => _VibeScreenState();
}

class _VibeScreenState extends ConsumerState<VibeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 🚀 Initial API Load
    Future.microtask(() {
      ref.read(featuresProvider.notifier).fetchVibeList();
    });

    // 📜 Scroll Listener for Pagination
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final vibeModel = ref.read(featuresProvider).vibeList.asData?.value;
    final vibesList = vibeModel?.data?.vibes ?? [];
    final totalAvailable = vibeModel?.data?.total ?? vibesList.length;

    // 🎯 Trigger loadMore only if there are more items to fetch
    if (vibesList.length < totalAvailable) {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(featuresProvider.notifier).fetchMoreVibeList();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featuresState = ref.watch(featuresProvider);
    final vibeAsyncValue = featuresState.vibeList;

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Chevron Up Indicator
              const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowUp01,
                color: AppColors.textSecondaryDark,
                size: 20,
              ),

              const SizedBox(height: 10),

              // --- Main Feed Area ---
              Expanded(
                child: vibeAsyncValue.when(
                  data: (vibeModel) {
                    final vibesList = vibeModel?.data?.vibes ?? [];
                    final totalAvailable = vibeModel?.data?.total ?? vibesList.length;
                    final bool hasMoreData = vibesList.length < totalAvailable;

                    if (vibesList.isEmpty) {
                      return Center(
                        child: CustomText.medium(
                          'No Vibes Available',
                          color: AppColors.textSecondaryLight,
                          fontSize: 16,
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.primaryPink,
                      onRefresh: () async {
                        await ref
                            .read(featuresProvider.notifier)
                            .fetchVibeList();
                      },
                      child: ListView.separated(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 28.0),
                        itemCount: hasMoreData ? vibesList.length + 1 : vibesList.length,
                        separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          if (index < vibesList.length) {
                            final vibe = vibesList[index];
                            return _buildModelCard(context, vibe);
                          } else {
                            // Bottom Pagination Loader
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryPink,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }
                        },
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPink,
                          ),
                          onPressed: () {
                            ref
                                .read(featuresProvider.notifier)
                                .fetchVibeList();
                          },
                          child: CustomText.bold(
                            'Retry',
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Single Card Item Widget ---
  Widget _buildModelCard(BuildContext context, Vibes vibe) {
    final cardHeight = MediaQuery.of(context).size.height * 0.65;

    // 🔄 Reversed Lock Check:
    // isSubscribe == true  -> Locked (Requires Subscription action)
    // isSubscribe == false -> Unlocked
    final bool isSubscribe = vibe.isSubscribe ?? false;
    final bool isLocked = isSubscribe;

    final imageUrl = vibe.image ?? '';

    return Container(
      height: cardHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Network Background Image
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.cardDarkBg,
                child: const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    size: 50,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.cardDarkBg,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryPink,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
            ),

            // Gradient Overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                      Colors.black.withOpacity(0.4),
                    ],
                    stops: const [0.0, 0.3, 1.0],
                  ),
                ),
              ),
            ),

            // Top Left: Avatar + Name
            Positioned(
              top: 16,
              left: 16,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryPink,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.cardDarkBg,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomText.bold(
                    vibe.name ?? 'Unknown',
                    fontSize: 18,
                    color: AppColors.textPrimaryLight,
                  ),
                ],
              ),
            ),

            // Top Right: Lock/Comment Action Button
            Positioned(
              top: 16,
              right: 16,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (isLocked) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PremiumSubscriptionScreen(),
                      ),
                    );
                  } else {
                    Navigator.maybePop(context);
                  }
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: HugeIcon(
                      icon: isLocked
                          ? HugeIcons.strokeRoundedLockKey
                          : HugeIcons.strokeRoundedComment01,
                      color: AppColors.textPrimaryLight,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),

            // 🔒 Locked Dark Overlay
            if (isLocked)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const PremiumSubscriptionScreen(),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.92),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryPink,
                          ),
                          child: const Center(
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedLockKey,
                              color: AppColors.textPrimaryLight,
                              size: 38,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomText.bold(
                          'Premium Content',
                          fontSize: 24,
                          color: AppColors.textPrimaryLight,
                        ),
                        const SizedBox(height: 8),
                        CustomText.regular(
                          'Tap to unlock full feed view',
                          fontSize: 14,
                          color: AppColors.textSecondaryLight,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}