import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_btn.dart'; // 🟢 AppBtn Import
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/const_text.dart';
import '../describe_image/model/subcription_model.dart';
import '../payment/paytm_Service/suscribe_status.dart';
import '../payment/provider/subcription_provider.dart';

class PremiumSubscriptionScreen extends ConsumerStatefulWidget {
  const PremiumSubscriptionScreen({super.key});

  @override
  ConsumerState<PremiumSubscriptionScreen> createState() =>
      _PremiumSubscriptionScreenState();
}

class _PremiumSubscriptionScreenState
    extends ConsumerState<PremiumSubscriptionScreen> {
  int _selectedPlanIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(subscriptionProvider.notifier).fetchSubcriptionList();
    });
  }

  // Helper method to format currency symbol (INR -> ₹)
  String _formatCurrency(String? rawCurrency) {
    if (rawCurrency == null || rawCurrency.isEmpty) return '₹';
    final upper = rawCurrency.toUpperCase();
    if (upper == 'INR' || upper == 'RS' || upper == 'RS.') {
      return '₹';
    }
    return rawCurrency;
  }

  // 🚀 Paytm Payment Process (100% Dynamic Params)
  Future<void> _handlePaymentProcess(Data selectedPlan) async {
    const String currentUserName = 'Vishal';
    const String currentUserEmail = 'vishaltest1@gmail.com';
    const String currentUserPhone = '7570006440';

    final success = await ref
        .read(subscriptionProvider.notifier)
        .subscribeAndPay(
      selectedPlan: selectedPlan,
      customerName: currentUserName,
      customerEmail: currentUserEmail,
      customerPhone: currentUserPhone,
      isStaging: false,
    );

    if (mounted) {
      final state = ref.read(subscriptionProvider);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subscription Activated Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: subscriptionState.subcriptionList.when(
        loading: () => const Center(
          child: CupertinoActivityIndicator(
            radius: 18,
            color: AppColors.primaryPink,
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText.medium(
                'Failed to load plans',
                color: AppColors.textSecondaryLight,
                fontSize: 16,
              ),
              const SizedBox(height: 12),
              // 🟢 Retry button using AppBtn
              AppBtn(
                title: 'Retry',
                width: 120,
                height: 40,
                borderRadius: 20,
                color: AppColors.primaryPink,
                onTap: () {
                  ref
                      .read(subscriptionProvider.notifier)
                      .fetchSubcriptionList();
                },
              ),
            ],
          ),
        ),
        data: (subscriptionModel) {
          final allPlans = subscriptionModel?.data ?? [];

          // 🟢 Filter out plans with price 0 or null
          final plans = allPlans.where((plan) {
            final price = plan.price ?? 0;
            return price > 0;
          }).toList();

          if (plans.isEmpty) {
            return Center(
              child: CustomText.medium(
                'No subscription plans available',
                color: AppColors.textSecondaryLight,
                fontSize: 16,
              ),
            );
          }

          final safeIndex =
          _selectedPlanIndex < plans.length ? _selectedPlanIndex : 0;
          final selectedPlan = plans[safeIndex];

          final String? bgImageUrl = selectedPlan.sId;

          final List<String> features = selectedPlan.features ?? [];
          final midIndex = (features.length / 2).ceil();
          final featuresLeft = features.take(midIndex).toList();
          final featuresRight = features.skip(midIndex).toList();

          return Stack(
            children: [
              // --- 1. Background Image ---
              Positioned.fill(
                child: bgImageUrl != null && bgImageUrl.isNotEmpty
                    ? Image.network(
                  bgImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset('assets/45.png', fit: BoxFit.cover),
                )
                    : Image.asset(
                  'assets/21.png',
                  fit: BoxFit.cover,
                ),
              ),

              // Bottom Overlay Gradient
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.bgBlack.withOpacity(0.95),
                        AppColors.bgBlack.withOpacity(0.70),
                        AppColors.bgBlack.withOpacity(0.20),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.15, 0.35, 0.55],
                    ),
                  ),
                ),
              ),

              // --- 2. Screen Content ---
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Close Button
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedCancel01,
                              color: AppColors.textPrimaryLight,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // --- 3. Features Grid ---
                      if (features.isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: featuresLeft
                                    .map((text) => _buildFeatureRow(text))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: featuresRight
                                    .map((text) => _buildFeatureRow(text))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 28),

                      // --- 4. Dynamic Paid Cards ---
                      Row(
                        children: List.generate(plans.length, (index) {
                          final plan = plans[index];
                          final isSelected = safeIndex == index;

                          final planTitle = plan.name ?? 'Plan';

                          final symbol = _formatCurrency(plan.currency);
                          final planPrice = '$symbol${plan.price}';

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedPlanIndex = index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 120,
                                margin: EdgeInsets.only(
                                  right: index == plans.length - 1 ? 0 : 10,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  // 🟢 Unselected par background transparent aur selected par AppColors.primaryPink
                                  color: isSelected
                                      ? AppColors.primaryPink
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryPink
                                        : Colors.white.withOpacity(0.25), // Translucent subtle border
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                    BoxShadow(
                                      color: AppColors.primaryPink.withOpacity(0.45),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                      : [],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText.bold(
                                      planTitle,
                                      fontSize: 12,
                                      color: AppColors.textPrimaryLight,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    CustomText.bold(
                                      planPrice,
                                      fontSize: 15,
                                      color: AppColors.textPrimaryLight,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 24),

                      // --- 5. Continue Button using AppBtn ---
                      AppBtn(
                        height: 58,
                        borderRadius: 28,
                        color: AppColors.primaryPink,
                        loading: subscriptionState.isBusy,
                        onTap: () => _handlePaymentProcess(selectedPlan),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            CustomText.bold(
                              'Continue',
                              fontSize: 18,
                              color: AppColors.textPrimaryLight,
                            ),
                            SizedBox(width: 8),
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowRight01,
                              color: AppColors.textPrimaryLight,
                              size: 22,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // --- 6. Footer Legal Links ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: CustomText.regular(
                              'Privacy Policy',
                              fontSize: 11,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: CustomText.regular(
                              'Restore Subscription',
                              fontSize: 11,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: CustomText.regular(
                              'Terms & Conditions',
                              fontSize: 11,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedCheckmarkCircle02,
              color: AppColors.textPrimaryLight,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CustomText.bold(
              text,
              fontSize: 13,
              color: AppColors.textPrimaryLight,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}