import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/create_parthner/repo/create_partner_repo.dart';

import '../../core/constants/app_btn.dart';
import '../../core/constants/const_text.dart';


class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (context) => const _SuccessDialogPopup(),
    );
  }

  Future<void> _handleCreatePartner(WidgetRef ref, BuildContext context) async {
    final success = await ref
        .read(createPartnerProvider.notifier)
        .submitCreatePartner(context);

    if (success && context.mounted) {
      _showSuccessPopup(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createPartnerProvider);
    final partner = state.partnerData;

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      appBar: AppBar(
        backgroundColor: AppColors.bgBlack,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppColors.profileCardBg,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimaryLight, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        centerTitle: true,
        title: CustomText.bold(
          'Review',
          color: AppColors.textPrimaryLight,
          fontSize: 22,
        ),
        actions: [
          TextButton(
            onPressed: state.isLoading ? null : () => _handleCreatePartner(ref, context),
            child: CustomText.semiBold(
              'Create',
              color: AppColors.primaryPink,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView( // 🟢 Fixes RenderFlex Overflow Issue
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPink.withOpacity(0.6),
                            blurRadius: 25,
                            spreadRadius: 4,
                          ),
                        ],
                        border: Border.all(color: AppColors.primaryPink, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('https://picsum.photos/200'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomText.bold(
                      partner.name.isEmpty ? 'AI Partner' : partner.name,
                      color: AppColors.textPrimaryLight,
                      fontSize: 24,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardDarkBg,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const _InsightIconHeader(),
                        const SizedBox(width: 14),
                        CustomText.bold(
                          'Personality Insights',
                          color: AppColors.textPrimaryLight,
                          fontSize: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    InsightRowWidget(
                      leftLabel: 'Shy',
                      rightLabel: 'Naughty',
                      percentage: '${(partner.shyNaughty * 100).round()}%',
                      progress: partner.shyNaughty,
                      isLeftActive: partner.shyNaughty <= 0.5,
                      isRightActive: partner.shyNaughty > 0.5,
                    ),
                    const SizedBox(height: 18),
                    InsightRowWidget(
                      leftLabel: 'Caring',
                      rightLabel: 'Playful',
                      percentage: '${(partner.caringPlayful * 100).round()}%',
                      progress: partner.caringPlayful,
                      isLeftActive: partner.caringPlayful <= 0.5,
                      isRightActive: partner.caringPlayful > 0.5,
                    ),
                    const SizedBox(height: 18),
                    InsightRowWidget(
                      leftLabel: 'Mature',
                      rightLabel: 'Childish',
                      percentage: '${(partner.matureChildish * 100).round()}%',
                      progress: partner.matureChildish,
                      isLeftActive: partner.matureChildish <= 0.5,
                      isRightActive: partner.matureChildish > 0.5,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              CustomText.bold(
                'Key Traits',
                color: AppColors.textPrimaryLight,
                fontSize: 20,
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: partner.traits.map((trait) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardDarkBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryPink.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _CheckIconBadge(),
                        const SizedBox(width: 12),
                        CustomText.medium(
                          trait,
                          color: AppColors.textPrimaryLight,
                          fontSize: 16,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              state.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primaryPink))
                  : AppBtn(
                onTap: () => _handleCreatePartner(ref, context),
                borderRadius: 18,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText.bold(
                      'Create My AI Partner',
                      color: AppColors.whiteSheetBg,
                      fontSize: 18,
                    ),
                    const SizedBox(width: 8),
                    const _ForwardIconBadge(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessDialogPopup extends StatelessWidget {
  const _SuccessDialogPopup();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardDarkBg,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppColors.primaryPink.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryPink, width: 3),
                  ),
                  child: const Center(
                    child: Icon(Icons.check_rounded, color: AppColors.primaryPink, size: 60),
                  ),
                ),
                const SizedBox(height: 28),
                CustomText.bold(
                  'Success!',
                  color: AppColors.textPrimaryLight,
                  fontSize: 28,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomText.regular(
                    'AI partner ready! Start chatting now.',
                    color: AppColors.textSecondaryLight,
                    fontSize: 16,
                    height: 1.35,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                AppBtn(
                  title: 'Chat Now',
                  color: AppColors.primaryPink,
                  borderRadius: 16,
                  height: 54,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
          Positioned(
            top: -12,
            right: -12,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryPink,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.textPrimaryLight, width: 2),
                ),
                child: const Icon(Icons.close_rounded, color: AppColors.textPrimaryLight, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightIconHeader extends StatelessWidget {
  const _InsightIconHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryPink.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.bar_chart, color: AppColors.primaryPink, size: 24),
    );
  }
}

class _CheckIconBadge extends StatelessWidget {
  const _CheckIconBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(color: AppColors.primaryPink, shape: BoxShape.circle),
      child: const Icon(Icons.check, color: AppColors.whiteSheetBg, size: 14),
    );
  }
}

class _ForwardIconBadge extends StatelessWidget {
  const _ForwardIconBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.whiteSheetBg.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.arrow_forward, color: AppColors.whiteSheetBg, size: 18),
    );
  }
}

class InsightRowWidget extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final String percentage;
  final double progress;
  final bool isLeftActive;
  final bool isRightActive;

  const InsightRowWidget({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.percentage,
    required this.progress,
    required this.isLeftActive,
    required this.isRightActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText.semiBold(
              leftLabel,
              color: isLeftActive ? AppColors.textPrimaryLight : AppColors.textSecondaryDark,
              fontSize: 16,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.profileDividerColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomText.bold(
                percentage,
                color: AppColors.primaryPink,
                fontSize: 12,
              ),
            ),
            CustomText.semiBold(
              rightLabel,
              color: isRightActive ? AppColors.textPrimaryLight : AppColors.textSecondaryDark,
              fontSize: 16,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.primaryPink,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPink.withOpacity(0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}