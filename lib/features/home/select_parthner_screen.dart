import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/chat/provider/chat_provider.dart'; // 🟢 Added Chat Provider Import
import 'package:infinity_love/features/home/provider/features_provider.dart';

import '../../core/constants/const_text.dart';
import 'model/role_play_model.dart';

class SelectPartnerScreen extends ConsumerStatefulWidget {
  const SelectPartnerScreen({super.key});

  @override
  ConsumerState<SelectPartnerScreen> createState() =>
      _SelectPartnerScreenState();
}

class _SelectPartnerScreenState extends ConsumerState<SelectPartnerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _fetchPartners();
    });
  }

  Future<void> _fetchPartners() async {
    await ref.read(featuresProvider.notifier).rolePlayList();
  }

  @override
  Widget build(BuildContext context) {
    final rolePlayState = ref.watch(featuresProvider).rolePlayList;

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      appBar: AppBar(
        backgroundColor: AppColors.bgBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimaryLight,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: CustomText.bold(
          'Select Partner',
          color: AppColors.textPrimaryLight,
          fontSize: 22,
        ),
      ),
      body: SafeArea(
        child: rolePlayState.when(
          loading: () => const Center(
            child: CupertinoActivityIndicator(
              radius: 16,
              color: AppColors.primaryPink,
            ),
          ),
          error: (error, stack) => Center(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText.medium(
                    'Failed to load partners: $error',
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                    ),
                    onPressed: _fetchPartners,
                    child: const Text('Retry', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
          data: (rolePlayModel) {
            final roleplays = rolePlayModel?.data?.roleplays ?? [];

            if (roleplays.isEmpty) {
              return RefreshIndicator(
                color: AppColors.primaryPink,
                backgroundColor: AppColors.cardDarkBg,
                onRefresh: _fetchPartners,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: CustomText.medium(
                          'No partners available',
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.primaryPink,
              backgroundColor: AppColors.cardDarkBg,
              onRefresh: _fetchPartners,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                itemCount: roleplays.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final item = roleplays[index];
                  return _PartnerCard(rolePlayItem: item);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// 🟢 ConsumerWidget converted to pass ref inside onTap
class _PartnerCard extends ConsumerWidget {
  final Roleplays rolePlayItem;

  const _PartnerCard({
    required this.rolePlayItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String imageUrl = rolePlayItem.image ?? '';
    final String name = rolePlayItem.name ?? 'Unknown';
    final String roleTag = rolePlayItem.role ?? 'Partner';
    final String sId = rolePlayItem.sId ?? '';

    return GestureDetector(
      onTap: () {
        if (sId.isNotEmpty) {
          // 🟢 1. API Call Trigger with dynamic sId & imageUrl
          ref
              .read(chatNotifierProvider.notifier)
              .fetchChatListRole(sId, imageUrl: imageUrl);

          // 🟢 2. Direct Navigation
          // context.pushNamed(
          //   'chatScreen2',
          //   extra: {
          //     'sId': sId,
          //     'image': imageUrl,
          //   },
          // );
        }
      },
      child: Container(
        height: 440,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPink.withOpacity(0.25),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: -2,
            ),
          ],
          border: Border.all(
            color: AppColors.primaryPink.withOpacity(0.6),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Network Image Loader
              imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppColors.cardDarkBg,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const CupertinoActivityIndicator(
                          radius: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholder(),
              )
                  : _buildPlaceholder(),

              // Gradient Overlay
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black12,
                        Colors.black54,
                        Colors.black87,
                      ],
                      stops: [0.4, 0.65, 0.85, 1.0],
                    ),
                  ),
                ),
              ),

              // Partner Info Section
              Positioned(
                left: 20,
                bottom: 24,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryPink,
                            shadows: [
                              Shadow(
                                color: AppColors.primaryPink.withOpacity(0.9),
                                blurRadius: 20,
                              ),
                              Shadow(
                                color: AppColors.primaryPink.withOpacity(0.6),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        CustomText.bold(
                          name,
                          color: AppColors.textPrimaryLight,
                          fontSize: 32,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgBlack.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.textPrimaryLight.withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: CustomText.medium(
                        roleTag,
                        color: AppColors.textPrimaryLight,
                        fontSize: 14,
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

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.cardDarkBg,
      child: const Center(
        child: Icon(
          Icons.person,
          color: AppColors.textSecondaryLight,
          size: 60,
        ),
      ),
    );
  }
}