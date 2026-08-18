// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:infinity_love/core/constants/app_btn.dart'; // 🟢 AppBtn Import
// import 'package:infinity_love/core/constants/app_color.dart';
//
// import '../../core/constants/const_text.dart';
// import '../describe_image/model/subcription_model.dart';
// import '../payment/paytm_Service/suscribe_status.dart';
// import '../payment/provider/subcription_provider.dart';
//
// class PremiumSubscriptionScreen extends ConsumerStatefulWidget {
//   const PremiumSubscriptionScreen({super.key});
//
//   @override
//   ConsumerState<PremiumSubscriptionScreen> createState() =>
//       _PremiumSubscriptionScreenState();
// }
//
// class _PremiumSubscriptionScreenState
//     extends ConsumerState<PremiumSubscriptionScreen> {
//   int _selectedPlanIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       ref.read(subscriptionProvider.notifier).fetchSubcriptionList();
//     });
//   }
//
//   // Helper method to format currency symbol (INR -> ₹)
//   String _formatCurrency(String? rawCurrency) {
//     if (rawCurrency == null || rawCurrency.isEmpty) return '₹';
//     final upper = rawCurrency.toUpperCase();
//     if (upper == 'INR' || upper == 'RS' || upper == 'RS.') {
//       return '₹';
//     }
//     return rawCurrency;
//   }
//
//   // 🚀 Paytm Payment Process (100% Dynamic Params)
//   Future<void> _handlePaymentProcess(Data selectedPlan) async {
//     const String currentUserName = 'Vishal';
//     const String currentUserEmail = 'vishaltest1@gmail.com';
//     const String currentUserPhone = '7570006440';
//
//     final success = await ref
//         .read(subscriptionProvider.notifier)
//         .subscribeAndPay(
//       selectedPlan: selectedPlan,
//       customerName: currentUserName,
//       customerEmail: currentUserEmail,
//       customerPhone: currentUserPhone,
//       isStaging: false,
//     );
//
//     if (mounted) {
//       final state = ref.read(subscriptionProvider);
//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Subscription Activated Successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } else if (state.errorMessage != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(state.errorMessage!),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final subscriptionState = ref.watch(subscriptionProvider);
//
//     return Scaffold(
//       backgroundColor: AppColors.bgBlack,
//       body: subscriptionState.subcriptionList.when(
//         loading: () => const Center(
//           child: CupertinoActivityIndicator(
//             radius: 18,
//             color: AppColors.primaryPink,
//           ),
//         ),
//         error: (error, stack) => Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CustomText.medium(
//                 'Failed to load plans',
//                 color: AppColors.textSecondaryLight,
//                 fontSize: 16,
//               ),
//               const SizedBox(height: 12),
//               // 🟢 Retry button using AppBtn
//               AppBtn(
//                 title: 'Retry',
//                 width: 120,
//                 height: 40,
//                 borderRadius: 20,
//                 color: AppColors.primaryPink,
//                 onTap: () {
//                   ref
//                       .read(subscriptionProvider.notifier)
//                       .fetchSubcriptionList();
//                 },
//               ),
//             ],
//           ),
//         ),
//         data: (subscriptionModel) {
//           final allPlans = subscriptionModel?.data ?? [];
//
//           // 🟢 Filter out plans with price 0 or null
//           final plans = allPlans.where((plan) {
//             final price = plan.price ?? 0;
//             return price > 0;
//           }).toList();
//
//           if (plans.isEmpty) {
//             return Center(
//               child: CustomText.medium(
//                 'No subscription plans available',
//                 color: AppColors.textSecondaryLight,
//                 fontSize: 16,
//               ),
//             );
//           }
//
//           final safeIndex =
//           _selectedPlanIndex < plans.length ? _selectedPlanIndex : 0;
//           final selectedPlan = plans[safeIndex];
//
//           final String? bgImageUrl = selectedPlan.sId;
//
//           final List<String> features = selectedPlan.features ?? [];
//           final midIndex = (features.length / 2).ceil();
//           final featuresLeft = features.take(midIndex).toList();
//           final featuresRight = features.skip(midIndex).toList();
//
//           return Stack(
//             children: [
//               // --- 1. Background Image ---
//               Positioned.fill(
//                 child: bgImageUrl != null && bgImageUrl.isNotEmpty
//                     ? Image.network(
//                   bgImageUrl,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) =>
//                       Image.asset('assets/45.png', fit: BoxFit.cover),
//                 )
//                     : Image.asset(
//                   'assets/21.png',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//
//               // Bottom Overlay Gradient
//               Positioned.fill(
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter,
//                       colors: [
//                         AppColors.bgBlack.withOpacity(0.95),
//                         AppColors.bgBlack.withOpacity(0.70),
//                         AppColors.bgBlack.withOpacity(0.20),
//                         Colors.transparent,
//                       ],
//                       stops: const [0.0, 0.15, 0.35, 0.55],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // --- 2. Screen Content ---
//               SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 20.0, vertical: 12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Top Close Button
//                       GestureDetector(
//                         onTap: () => Navigator.maybePop(context),
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.4),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Center(
//                             child: HugeIcon(
//                               icon: HugeIcons.strokeRoundedCancel01,
//                               color: AppColors.textPrimaryLight,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       const Spacer(),
//
//                       // --- 3. Features Grid ---
//                       if (features.isNotEmpty)
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: featuresLeft
//                                     .map((text) => _buildFeatureRow(text))
//                                     .toList(),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: featuresRight
//                                     .map((text) => _buildFeatureRow(text))
//                                     .toList(),
//                               ),
//                             ),
//                           ],
//                         ),
//
//                       const SizedBox(height: 28),
//
//                       // --- 4. Dynamic Paid Cards ---
//                       Row(
//                         children: List.generate(plans.length, (index) {
//                           final plan = plans[index];
//                           final isSelected = safeIndex == index;
//
//                           final planTitle = plan.name ?? 'Plan';
//
//                           final symbol = _formatCurrency(plan.currency);
//                           final planPrice = '$symbol${plan.price}';
//
//                           return Expanded(
//                             child: GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _selectedPlanIndex = index;
//                                 });
//                               },
//                               child: AnimatedContainer(
//                                 duration: const Duration(milliseconds: 200),
//                                 height: 120,
//                                 margin: EdgeInsets.only(
//                                   right: index == plans.length - 1 ? 0 : 10,
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 8, horizontal: 4),
//                                 decoration: BoxDecoration(
//                                   // 🟢 Unselected par background transparent aur selected par AppColors.primaryPink
//                                   color: isSelected
//                                       ? AppColors.primaryPink
//                                       : Colors.transparent,
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(
//                                     color: isSelected
//                                         ? AppColors.primaryPink
//                                         : Colors.white.withOpacity(0.25), // Translucent subtle border
//                                     width: isSelected ? 2 : 1,
//                                   ),
//                                   boxShadow: isSelected
//                                       ? [
//                                     BoxShadow(
//                                       color: AppColors.primaryPink.withOpacity(0.45),
//                                       blurRadius: 12,
//                                       offset: const Offset(0, 4),
//                                     ),
//                                   ]
//                                       : [],
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     CustomText.bold(
//                                       planTitle,
//                                       fontSize: 12,
//                                       color: AppColors.textPrimaryLight,
//                                       textAlign: TextAlign.center,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     const SizedBox(height: 4),
//                                     CustomText.bold(
//                                       planPrice,
//                                       fontSize: 15,
//                                       color: AppColors.textPrimaryLight,
//                                       textAlign: TextAlign.center,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//                       ),
//
//                       const SizedBox(height: 24),
//
//                       // --- 5. Continue Button using AppBtn ---
//                       AppBtn(
//                         height: 58,
//                         borderRadius: 28,
//                         color: AppColors.primaryPink,
//                         loading: subscriptionState.isBusy,
//                         onTap: () => _handlePaymentProcess(selectedPlan),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children:  [
//                             CustomText.bold(
//                               'Continue',
//                               fontSize: 18,
//                               color: AppColors.textPrimaryLight,
//                             ),
//                             SizedBox(width: 8),
//                             HugeIcon(
//                               icon: HugeIcons.strokeRoundedArrowRight01,
//                               color: AppColors.textPrimaryLight,
//                               size: 22,
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 24),
//
//                       // --- 6. Footer Legal Links ---
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           GestureDetector(
//                             onTap: () {},
//                             child: CustomText.regular(
//                               'Privacy Policy',
//                               fontSize: 11,
//                               color: AppColors.textSecondaryLight,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {},
//                             child: CustomText.regular(
//                               'Restore Subscription',
//                               fontSize: 11,
//                               color: AppColors.textSecondaryLight,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {},
//                             child: CustomText.regular(
//                               'Terms & Conditions',
//                               fontSize: 11,
//                               color: AppColors.textSecondaryLight,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildFeatureRow(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.only(top: 2.0),
//             child: HugeIcon(
//               icon: HugeIcons.strokeRoundedCheckmarkCircle02,
//               color: AppColors.textPrimaryLight,
//               size: 16,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: CustomText.bold(
//               text,
//               fontSize: 13,
//               color: AppColors.textPrimaryLight,
//               height: 1.25,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_btn.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/const_text.dart';
import '../../core/utils/utils.dart';
import '../describe_image/model/subcription_model.dart';
import '../payment/model/avilable_model.dart' hide Data;
import '../payment/provider/subcription_provider.dart';
import '../profile/provider/profile_provider.dart'; // 🟢 Added Profile Provider for Dynamic User Data

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
      ref.read(profileProvider.notifier).fetchProfile(); // 🟢 Fetch User Profile
      ref.read(subscriptionProvider.notifier).fetchSubcriptionList();
      ref.read(subscriptionProvider.notifier).fetchAvailablePaymentList();
    });
  }

  String _formatCurrency(String? rawCurrency) {
    if (rawCurrency == null || rawCurrency.isEmpty) return '₹';
    final upper = rawCurrency.toUpperCase();
    if (upper == 'INR' || upper == 'RS' || upper == 'RS.') {
      return '₹';
    }
    return rawCurrency;
  }

  // 🟢 Show Dynamic Payment Method Selection Sheet
  void _openPaymentSelectionSheet(Data selectedPlan) {
    final paymentState = ref.read(subscriptionProvider).paymentAvailableList;

    paymentState.when(
      data: (availableModel) {
        final data = availableModel?.data;

        if (data == null || (data.paytm != true && data.cashfree != true)) {
          if (mounted) {
            Utils.showErrorMessage(context, 'No active payment gateway available.');
          }
          return;
        }

        if (mounted) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (dialogContext) => PaymentMethodSelectionSheet(
              availablePayments: availableModel!,
              onGatewaySelected: (selectedGateway) {
                _handlePaymentProcess(selectedPlan, selectedGateway);
              },
            ),
          );
        }
      },
      loading: () {
        if (mounted) {
          Utils.showErrorMessage(context, 'Loading payment methods...');
        }
      },
      error: (e, _) {
        if (mounted) {
          Utils.showErrorMessage(context, 'Failed to fetch payment methods');
        }
      },
    );
  }

  // 🚀 Initiate Selected Payment (100% Dynamic User Info)
  Future<void> _handlePaymentProcess(Data selectedPlan, String selectedGateway) async {
    // 🟢 Read live dynamic user data from profileProvider
    final profileModel = ref.read(profileProvider).value;
    final userData = profileModel?.data;

    final String dynamicName = userData?.name?.trim() ?? '';
    final String dynamicEmail =  'raunitn@gmail.com';
    final String dynamicPhone = (userData?.mobileNumber ??  '').toString().trim();

    final success = await ref
        .read(subscriptionProvider.notifier)
        .subscribeAndPay(
      selectedPlan: selectedPlan,
      customerName: dynamicName,
      customerEmail: dynamicEmail,
      customerPhone: dynamicPhone,
      selectedPaymentGateway: selectedGateway,
      isStaging: true,
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
              AppBtn(
                title: 'Retry',
                width: 120,
                height: 40,
                borderRadius: 20,
                color: AppColors.primaryPink,
                onTap: () {
                  ref.read(subscriptionProvider.notifier).fetchSubcriptionList();
                  ref.read(subscriptionProvider.notifier).fetchAvailablePaymentList();
                },
              ),
            ],
          ),
        ),
        data: (subscriptionModel) {
          final allPlans = subscriptionModel?.data ?? [];

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

          final safeIndex = _selectedPlanIndex < plans.length ? _selectedPlanIndex : 0;
          final selectedPlan = plans[safeIndex];

          final String? bgImageUrl = selectedPlan.sId;
          final List<String> features = selectedPlan.features ?? [];
          final midIndex = (features.length / 2).ceil();
          final featuresLeft = features.take(midIndex).toList();
          final featuresRight = features.skip(midIndex).toList();

          return Stack(
            children: [
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
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryPink
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryPink
                                        : Colors.white.withOpacity(0.25),
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
                      AppBtn(
                        height: 58,
                        borderRadius: 28,
                        color: AppColors.primaryPink,
                        loading: subscriptionState.isBusy,
                        onTap: () => _openPaymentSelectionSheet(selectedPlan),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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

class PaymentMethodSelectionSheet extends StatefulWidget {
  final AvailablePaymentModel availablePayments;
  final Function(String selectedGateway) onGatewaySelected;

  const PaymentMethodSelectionSheet({
    super.key,
    required this.availablePayments,
    required this.onGatewaySelected,
  });

  @override
  State<PaymentMethodSelectionSheet> createState() =>
      _PaymentMethodSelectionSheetState();
}

class _PaymentMethodSelectionSheetState
    extends State<PaymentMethodSelectionSheet> {
  String? _selectedGateway;

  @override
  void initState() {
    super.initState();
    final data = widget.availablePayments.data;
    if (data?.paytm == true) {
      _selectedGateway = 'paytm';
    } else if (data?.cashfree == true) {
      _selectedGateway = 'cashfree';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.availablePayments.data;
    final bool isPaytmAvailable = data?.paytm == true;
    final bool isCashfreeAvailable = data?.cashfree == true;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.cardDarkBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText.bold('Select Payment Method',
                  fontSize: 18, color: AppColors.textPrimaryLight),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (isPaytmAvailable)
            _buildOptionTile(
              id: 'paytm',
              title: 'Paytm / UPI',
              icon: Icons.account_balance_wallet,
            ),

          if (isCashfreeAvailable)
            _buildOptionTile(
              id: 'cashfree',
              title: 'Cashfree Payments',
              icon: Icons.credit_card,
            ),

          const SizedBox(height: 20),

          AppBtn(
            title: 'Proceed to Pay',
            color: AppColors.primaryPink,
            height: 50,
            borderRadius: 25,
            onTap: _selectedGateway == null
                ? null
                : () {
              Navigator.pop(context);
              widget.onGatewaySelected(_selectedGateway!);
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required String id,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _selectedGateway == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGateway = id;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgBlack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryPink : Colors.white12,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryPink, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: CustomText.bold(title, fontSize: 15, color: Colors.white),
            ),
            Radio<String>(
              value: id,
              groupValue: _selectedGateway,
              activeColor: AppColors.primaryPink,
              onChanged: (val) {
                if (val != null) setState(() => _selectedGateway = val);
              },
            ),
          ],
        ),
      ),
    );
  }
}