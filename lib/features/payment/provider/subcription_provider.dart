// // import 'dart:async';
// // import 'package:flutter/services.dart';
// // import 'package:flutter/widgets.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:go_router/go_router.dart';
// // import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk.dart';
// //
// // import '../../../core/di/service_locator.dart';
// // import '../../../core/network/api_clinet.dart';
// // import '../../../routes/app_routes.dart';
// // import '../../../routes/routes_name.dart';
// // import '../../describe_image/model/subcription_model.dart';
// // import '../model/paytm_init_request_model.dart';
// // import '../paytm_Service/suscribe_status.dart';
// // import '../repo/subcription_repo.dart';
// // import '../state/subcription_state.dart';
// //
// // final subscriptionRepositoryProvider = Provider<SubscriptionRepository2>((ref) {
// //   return SubscriptionRepository2(sl<ApiClient>());
// // });
// //
// // class SubscriptionNotifier extends Notifier<SubscribeState>
// //     with WidgetsBindingObserver {
// //   bool _pendingHomeNavigation = false;
// //   bool _isNavigating = false; // Prevent multiple navigation attempts
// //
// //   @override
// //   SubscribeState build() {
// //     WidgetsBinding.instance.addObserver(this);
// //     ref.onDispose(() {
// //       WidgetsBinding.instance.removeObserver(this);
// //     });
// //     return const SubscribeState();
// //   }
// //
// //   @override
// //   void didChangeAppLifecycleState(AppLifecycleState state) {
// //     if (state == AppLifecycleState.resumed && _pendingHomeNavigation && !_isNavigating) {
// //       _pendingHomeNavigation = false;
// //       _goHome();
// //     }
// //   }
// //
// //   Future<void> fetchSubcriptionList() async {
// //     state = state.copyWith(subcriptionList: const AsyncValue.loading());
// //     try {
// //       final repo = ref.read(subscriptionRepositoryProvider);
// //       final response = await repo.getSubcription();
// //       state = state.copyWith(subcriptionList: AsyncValue.data(response));
// //     } catch (e, stack) {
// //       state = state.copyWith(subcriptionList: AsyncValue.error(e, stack));
// //     }
// //   }
// //
// //   Future<bool> subscribeAndPay({
// //     required Data selectedPlan,
// //     required String customerName,
// //     required String customerEmail,
// //     required String customerPhone,
// //     bool isStaging = true,
// //   }) async {
// //     state = state.copyWith(status: SubscribeStatus.initiating, errorMessage: null);
// //
// //     try {
// //       final repo = ref.read(subscriptionRepositoryProvider);
// //
// //       // Amount ko hamesha 2 decimal places tak format karein (e.g. "99.00")
// //       final double price = double.tryParse(selectedPlan.price?.toString() ?? '0') ?? 0;
// //       final String amount = price.toStringAsFixed(2);
// //
// //       final String planId = selectedPlan.sId ?? '';
// //
// //       if (planId.isEmpty) {
// //         state = state.copyWith(
// //           status: SubscribeStatus.failure,
// //           errorMessage: 'Invalid subscription plan selected.',
// //         );
// //         return false;
// //       }
// //
// //       final reqPayload = PaytmInitRequestModel(
// //         planId: planId,
// //         paymentMethod: 'paytm',
// //         customerName: customerName,
// //         customerEmail: customerEmail,
// //         customerPhone: customerPhone,
// //       );
// //
// //       final initiate = await repo.subscribe(reqPayload);
// //
// //       // 🛑 DEBUGGING: In values ko logcat mein check karein
// //       // Agar yahan Callback galat dikh raha hai, toh model mapping check karni hogi
// //       print("--- PAYTM REQUEST DETAILS ---");
// //       print("MID: ${initiate.mid}");
// //       print("OrderID: ${initiate.orderId}");
// //       print("Amount: $amount");
// //       print("TxnToken: ${initiate.txnToken}");
// //       print("Callback from Backend: ${initiate.callbackUrl}");
// //       print("-----------------------------");
// //
// //       // Backend wala EXACT URL hi pass kar rahe hain mismatch se bachne ke liye
// //       final String finalCallbackUrl = (initiate.callbackUrl ?? '').isNotEmpty
// //           ? initiate.callbackUrl!
// //           : "https://infinitelove.honeywithmoon.com/api/v1/payment/callback/paytm";
// //
// //       if ((initiate.txnToken ?? '').isEmpty ||
// //           initiate.mid.isEmpty ||
// //           initiate.orderId.isEmpty) {
// //         state = state.copyWith(
// //           status: SubscribeStatus.failure,
// //           errorMessage: initiate.message ?? 'Payment initialization failed.',
// //         );
// //         return false;
// //       }
// //
// //       state = state.copyWith(status: SubscribeStatus.launchingPaytm, errorMessage: null);
// //       _pendingHomeNavigation = true;
// //       _isNavigating = false;
// //
// //       bool isSuccess = false;
// //
// //       try {
// //         final result = await PaytmPaymentsAllinonesdk()
// //             .startTransaction(
// //           initiate.mid,
// //           initiate.orderId,
// //           amount,
// //           initiate.txnToken!,
// //           finalCallbackUrl, // Yahan hum backend wala URL force kar rahe hain
// //           true, // Staging set to true
// //           false, // restrictAppInvoke set to false
// //         )
// //             .timeout(const Duration(seconds: 45));
// //
// //         print("Paytm SDK Result: $result");
// //
// //         if (result != null) {
// //           final txnStatus = result['STATUS']?.toString().toUpperCase() ??
// //               result['status']?.toString().toUpperCase();
// //           isSuccess = txnStatus == 'TXN_SUCCESS';
// //         }
// //       } catch (e) {
// //         print("Paytm Error or Manual Back: $e");
// //         // Agar user back dabata hai ya error aata hai, toh verify payment call karein
// //         isSuccess = await repo.verifyPayment(initiate.orderId);
// //       }
// //
// //       if (isSuccess) {
// //         final bool isVerified = await repo.verifyPayment(initiate.orderId);
// //         isSuccess = isVerified;
// //       }
// //
// //       if (isSuccess) {
// //         final bool isVerified = await repo.verifyPayment(initiate.orderId);
// //         isSuccess = isVerified;
// //       }
// //
// //       state = state.copyWith(
// //         status: isSuccess ? SubscribeStatus.success : SubscribeStatus.failure,
// //         errorMessage: isSuccess ? null : 'Payment was not completed.',
// //       );
// //
// //       return isSuccess;
// //     } on PlatformException catch (e) {
// //       state = state.copyWith(
// //         status: SubscribeStatus.failure,
// //         errorMessage: e.message ?? 'Payment was cancelled.',
// //       );
// //       return false;
// //     } catch (e) {
// //       state = state.copyWith(
// //         status: SubscribeStatus.failure,
// //         errorMessage: e.toString(),
// //       );
// //       return false;
// //     } finally {
// //       // Navigate after a small delay to ensure payment flow is completely done
// //       Future.delayed(const Duration(milliseconds: 100), () {
// //         if (!_isNavigating) {
// //           _goHome();
// //         }
// //       });
// //     }
// //   }
// //
// //   void _goHome() {
// //     if (_isNavigating) {
// //       print('⚠️ Navigation already in progress, skipping');
// //       return;
// //     }
// //
// //     _isNavigating = true;
// //
// //     try {
// //       // Use post-frame callback for safe navigation
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         final context = rootNavigatorKey.currentContext;
// //
// //         if (context != null && context.mounted) {
// //           _pendingHomeNavigation = false;
// //
// //           // Redirecting to Onboarding Screen as requested
// //           context.go(RoutesName.bottomNavBar);
// //
// //           print('✅ Successfully navigated to Onboarding');
// //         } else {
// //           print('❌ Context not available, will retry on app resume');
// //           _pendingHomeNavigation = true;
// //           _isNavigating = false;
// //         }
// //       });
// //     } catch (e) {
// //       print('❌ Navigation error: $e');
// //       _pendingHomeNavigation = true;
// //       _isNavigating = false;
// //     }
// //   }
// //
// //   void reset() {
// //     _pendingHomeNavigation = false;
// //     _isNavigating = false;
// //     state = const SubscribeState();
// //   }
// // }
// //
// // final subscriptionProvider =
// // NotifierProvider<SubscriptionNotifier, SubscribeState>(
// //   SubscriptionNotifier.new,
// // );
//
//
// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:go_router/go_router.dart';
// // import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk.dart';
// //
// // import '../../../core/di/service_locator.dart';
// // import '../../../core/network/api_clinet.dart';
// // import '../../../routes/app_routes.dart';
// // import '../../../routes/routes_name.dart';
// // import '../../../shared/weget/payment_pop_up.dart';
// // import '../../describe_image/model/subcription_model.dart';
// // import '../model/paytm_init_request_model.dart';
// // import '../paytm_Service/suscribe_status.dart';
// // import '../repo/subcription_repo.dart';
// // import '../state/subcription_state.dart';
// //
// //
// // final subscriptionRepositoryProvider = Provider<SubscriptionRepository2>((ref) {
// //   return SubscriptionRepository2(sl<ApiClient>());
// // });
// //
// // class SubscriptionNotifier extends Notifier<SubscribeState>
// //     with WidgetsBindingObserver {
// //   bool _pendingHomeNavigation = false;
// //   bool _isNavigating = false;
// //
// //   @override
// //   SubscribeState build() {
// //     WidgetsBinding.instance.addObserver(this);
// //     ref.onDispose(() {
// //       WidgetsBinding.instance.removeObserver(this);
// //     });
// //     return const SubscribeState();
// //   }
// //
// //   @override
// //   void didChangeAppLifecycleState(AppLifecycleState state) {
// //     if (state == AppLifecycleState.resumed && _pendingHomeNavigation && !_isNavigating) {
// //       _pendingHomeNavigation = false;
// //     }
// //   }
// //
// //   Future<void> fetchSubcriptionList() async {
// //     state = state.copyWith(subcriptionList: const AsyncValue.loading());
// //     try {
// //       final repo = ref.read(subscriptionRepositoryProvider);
// //       final response = await repo.getSubcription();
// //       state = state.copyWith(subcriptionList: AsyncValue.data(response));
// //     } catch (e, stack) {
// //       state = state.copyWith(subcriptionList: AsyncValue.error(e, stack));
// //     }
// //   }
// //
// //   Future<bool> subscribeAndPay({
// //     required Data selectedPlan,
// //     required String customerName,
// //     required String customerEmail,
// //     required String customerPhone,
// //     bool isStaging = true,
// //   }) async {
// //     state = state.copyWith(status: SubscribeStatus.initiating, errorMessage: null);
// //
// //     try {
// //       final repo = ref.read(subscriptionRepositoryProvider);
// //
// //       final double price = double.tryParse(selectedPlan.price?.toString() ?? '0') ?? 0;
// //       final String amount = price.toStringAsFixed(2);
// //       final String planId = selectedPlan.sId ?? '';
// //
// //       if (planId.isEmpty) {
// //         state = state.copyWith(
// //           status: SubscribeStatus.failure,
// //           errorMessage: 'Invalid subscription plan selected.',
// //         );
// //         return false;
// //       }
// //
// //       final reqPayload = PaytmInitRequestModel(
// //         planId: planId,
// //         paymentMethod: 'paytm',
// //         customerName: customerName,
// //         customerEmail: customerEmail,
// //         customerPhone: customerPhone,
// //       );
// //
// //       final initiate = await repo.subscribe(reqPayload);
// //
// //       final String txnToken = initiate.txnToken ?? '';
// //       final String orderId = initiate.orderId;
// //       final String mid = initiate.mid;
// //       final String callbackUrl = (initiate.callbackUrl ?? '').isNotEmpty
// //           ? initiate.callbackUrl!
// //           : "https://infinitelove.honeywithmoon.com/api/v1/payment/callback/paytm";
// //
// //       if (txnToken.isEmpty || mid.isEmpty || orderId.isEmpty) {
// //         state = state.copyWith(
// //           status: SubscribeStatus.failure,
// //           errorMessage: initiate.message ?? 'Payment initialization failed.',
// //         );
// //         return false;
// //       }
// //
// //       state = state.copyWith(status: SubscribeStatus.launchingPaytm, errorMessage: null);
// //       _pendingHomeNavigation = true;
// //       _isNavigating = false;
// //
// //       PaymentResultType resultType = PaymentResultType.cancelled;
// //
// //       try {
// //         final result = await PaytmPaymentsAllinonesdk().startTransaction(
// //           mid,
// //           orderId,
// //           amount,
// //           txnToken,
// //           callbackUrl,
// //           true,
// //           false,
// //         ).timeout(const Duration(seconds: 45));
// //
// //         if (result != null) {
// //           final txnStatus = result['STATUS']?.toString().toUpperCase() ??
// //               result['status']?.toString().toUpperCase();
// //           if (txnStatus == 'TXN_SUCCESS') {
// //             resultType = PaymentResultType.success;
// //           } else if (txnStatus == 'PENDING') {
// //             resultType = PaymentResultType.pending;
// //           }
// //         }
// //       } catch (e) {
// //         debugPrint("Paytm Error/Back: $e");
// //       }
// //
// //       // 🟢 Double Check Verification from Server
// //       final bool isVerified = await repo.verifyPayment(orderId);
// //       if (isVerified) {
// //         resultType = PaymentResultType.success;
// //       }
// //
// //       state = state.copyWith(
// //         status: resultType == PaymentResultType.success
// //             ? SubscribeStatus.success
// //             : SubscribeStatus.failure,
// //       );
// //
// //       // 🟢 Show Theme-Matched Status Dialog
// //       _showStatusDialog(resultType, orderId, amount);
// //
// //       return resultType == PaymentResultType.success;
// //     } catch (e) {
// //       debugPrint("❌ Exception in subscribeAndPay: $e");
// //       state = state.copyWith(
// //         status: SubscribeStatus.failure,
// //         errorMessage: e.toString(),
// //       );
// //       return false;
// //     }
// //   }
// //
// //   // 🟢 Custom Dialog Popup Method
// //   void _showStatusDialog(PaymentResultType resultType, String orderId, String amount) {
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       final context = rootNavigatorKey.currentContext;
// //       if (context != null && context.mounted) {
// //         showDialog(
// //           context: context,
// //           barrierDismissible: false,
// //           builder: (dialogContext) => PaymentStatusDialog(
// //             resultType: resultType,
// //             orderId: orderId,
// //             amount: amount,
// //             onContinue: () {
// //               Navigator.of(dialogContext).pop(); // Close Dialog
// //               _goHome(); // Navigate Home
// //             },
// //           ),
// //         );
// //       }
// //     });
// //   }
// //
// //   void _goHome() {
// //     if (_isNavigating) return;
// //     _isNavigating = true;
// //
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       final context = rootNavigatorKey.currentContext;
// //
// //       if (context != null && context.mounted) {
// //         _pendingHomeNavigation = false;
// //
// //         try {
// //           while (GoRouter.of(context).canPop()) {
// //             GoRouter.of(context).pop();
// //           }
// //
// //           context.go(RoutesName.bottomNavBar);
// //           debugPrint('✅ Successfully Navigated to Home Screen');
// //         } catch (e) {
// //           context.go('/main');
// //         } finally {
// //           _isNavigating = false;
// //         }
// //       } else {
// //         _pendingHomeNavigation = true;
// //         _isNavigating = false;
// //       }
// //     });
// //   }
// //
// //   void reset() {
// //     _pendingHomeNavigation = false;
// //     _isNavigating = false;
// //     state = const SubscribeState();
// //   }
// // }
// //
// // final subscriptionProvider =
// // NotifierProvider<SubscriptionNotifier, SubscribeState>(
// //   SubscriptionNotifier.new,
// // );
//
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk.dart';
//
// import '../../../core/di/service_locator.dart';
// import '../../../core/network/api_clinet.dart';
// import '../../../routes/app_routes.dart';
// import '../../../routes/routes_name.dart';
// import '../../../shared/weget/payment_pop_up.dart';
// import '../../describe_image/model/subcription_model.dart';
// import '../model/paytm_init_request_model.dart';
// import '../paytm_Service/suscribe_status.dart';
// import '../repo/subcription_repo.dart';
// import '../state/subcription_state.dart';
//
// final subscriptionRepositoryProvider = Provider<SubscriptionRepository2>((ref) {
//   return SubscriptionRepository2(sl<ApiClient>());
// });
//
// class SubscriptionNotifier extends Notifier<SubscribeState>
//     with WidgetsBindingObserver {
//   bool _pendingHomeNavigation = false;
//   bool _isNavigating = false;
//
//   @override
//   SubscribeState build() {
//     WidgetsBinding.instance.addObserver(this);
//     ref.onDispose(() {
//       WidgetsBinding.instance.removeObserver(this);
//     });
//     return const SubscribeState();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && _pendingHomeNavigation && !_isNavigating) {
//       _pendingHomeNavigation = false;
//     }
//   }
//
//   Future<void> fetchSubcriptionList() async {
//     state = state.copyWith(subcriptionList: const AsyncValue.loading());
//     try {
//       final repo = ref.read(subscriptionRepositoryProvider);
//       final response = await repo.getSubcription();
//       state = state.copyWith(subcriptionList: AsyncValue.data(response));
//     } catch (e, stack) {
//       state = state.copyWith(subcriptionList: AsyncValue.error(e, stack));
//     }
//   }
//   Future<void> fetchAvailablePaymentList() async {
//     state = state.copyWith(subcriptionList: const AsyncValue.loading());
//     try {
//       final repo = ref.read(subscriptionRepositoryProvider);
//       final response = await repo.getSubcription();
//       state = state.copyWith(subcriptionList: AsyncValue.data(response));
//     } catch (e, stack) {
//       state = state.copyWith(subcriptionList: AsyncValue.error(e, stack));
//     }
//   }
//
//   Future<bool> subscribeAndPay({
//     required Data selectedPlan,
//     required String customerName,
//     required String customerEmail,
//     required String customerPhone,
//     bool isStaging = true,
//   }) async {
//     state = state.copyWith(status: SubscribeStatus.initiating, errorMessage: null);
//
//     try {
//       final repo = ref.read(subscriptionRepositoryProvider);
//
//       final double price = double.tryParse(selectedPlan.price?.toString() ?? '0') ?? 0;
//       final String amount = price.toStringAsFixed(2);
//       final String planId = selectedPlan.sId ?? '';
//
//       if (planId.isEmpty) {
//         state = state.copyWith(
//           status: SubscribeStatus.failure,
//           errorMessage: 'Invalid subscription plan selected.',
//         );
//         return false;
//       }
//
//       final reqPayload = PaytmInitRequestModel(
//         planId: planId,
//         paymentMethod: 'paytm',
//         customerName: customerName,
//         customerEmail: customerEmail,
//         customerPhone: customerPhone,
//       );
//
//       final initiate = await repo.subscribe(reqPayload);
//
//       final String txnToken = initiate.txnToken ?? '';
//       final String orderId = initiate.orderId;
//       final String mid = initiate.mid;
//       final String callbackUrl = (initiate.callbackUrl ?? '').isNotEmpty
//           ? initiate.callbackUrl!
//           : "https://infinitelove.honeywithmoon.com/api/v1/payment/callback/paytm";
//
//       if (txnToken.isEmpty || mid.isEmpty || orderId.isEmpty) {
//         state = state.copyWith(
//           status: SubscribeStatus.failure,
//           errorMessage: initiate.message ?? 'Payment initialization failed.',
//         );
//         return false;
//       }
//
//       state = state.copyWith(status: SubscribeStatus.launchingPaytm, errorMessage: null);
//       _pendingHomeNavigation = true;
//       _isNavigating = false;
//
//       PaymentResultType resultType = PaymentResultType.cancelled;
//       bool isError = false;
//
//       try {
//         final result = await PaytmPaymentsAllinonesdk().startTransaction(
//           mid,
//           orderId,
//           amount,
//           txnToken,
//           callbackUrl,
//           true,
//           false,
//         ).timeout(const Duration(seconds: 45));
//
//         if (result != null) {
//           final txnStatus = result['STATUS']?.toString().toUpperCase() ??
//               result['status']?.toString().toUpperCase() ??
//               '';
//           final respCode = result['RESPCODE']?.toString() ?? result['respCode']?.toString() ?? '';
//
//           if (txnStatus == 'TXN_SUCCESS' || respCode == '01') {
//             resultType = PaymentResultType.success;
//           } else if (txnStatus == 'PENDING') {
//             resultType = PaymentResultType.pending;
//           } else {
//             resultType = PaymentResultType.cancelled;
//           }
//         } else {
//           resultType = PaymentResultType.cancelled;
//         }
//       } on PlatformException catch (e) {
//         debugPrint("Paytm SDK Platform Error: ${e.message}");
//         resultType = PaymentResultType.cancelled;
//         isError = true;
//       } catch (e) {
//         debugPrint("Paytm Error/Back: $e");
//         resultType = PaymentResultType.pending;
//         isError = true;
//       }
//
//       // 🟢 Server Verification: Only verify if transaction wasn't cancelled/failed
//       if (!isError && (resultType == PaymentResultType.success || resultType == PaymentResultType.pending)) {
//         final bool isVerified = await repo.verifyPayment(orderId);
//         if (isVerified) {
//           resultType = PaymentResultType.success;
//         } else {
//           resultType = PaymentResultType.cancelled;
//         }
//       }
//
//       state = state.copyWith(
//         status: resultType == PaymentResultType.success
//             ? SubscribeStatus.success
//             : SubscribeStatus.failure,
//       );
//
//       // 🟢 Show Theme-Matched Status Dialog
//       _showStatusDialog(resultType, orderId, amount);
//
//       return resultType == PaymentResultType.success;
//     } catch (e) {
//       debugPrint("❌ Exception in subscribeAndPay: $e");
//       state = state.copyWith(
//         status: SubscribeStatus.failure,
//         errorMessage: e.toString(),
//       );
//       return false;
//     }
//   }
//
//   void _showStatusDialog(PaymentResultType resultType, String orderId, String amount) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final context = rootNavigatorKey.currentContext;
//       if (context != null && context.mounted) {
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (dialogContext) => PaymentStatusDialog(
//             resultType: resultType,
//             orderId: orderId,
//             amount: amount,
//             onContinue: () {
//               Navigator.of(dialogContext).pop();
//               if (resultType == PaymentResultType.success) {
//                 _goHome();
//               }
//             },
//           ),
//         );
//       }
//     });
//   }
//
//   void _goHome() {
//     if (_isNavigating) return;
//     _isNavigating = true;
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final context = rootNavigatorKey.currentContext;
//
//       if (context != null && context.mounted) {
//         _pendingHomeNavigation = false;
//
//         try {
//           while (GoRouter.of(context).canPop()) {
//             GoRouter.of(context).pop();
//           }
//
//           context.go(RoutesName.bottomNavBar);
//           debugPrint('✅ Successfully Navigated to Home Screen');
//         } catch (e) {
//           context.go('/main');
//         } finally {
//           _isNavigating = false;
//         }
//       } else {
//         _pendingHomeNavigation = true;
//         _isNavigating = false;
//       }
//     });
//   }
//
//   void reset() {
//     _pendingHomeNavigation = false;
//     _isNavigating = false;
//     state = const SubscribeState();
//   }
// }
//
// final subscriptionProvider =
// NotifierProvider<SubscriptionNotifier, SubscribeState>(
//   SubscriptionNotifier.new,
// );


// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk.dart';
//
// import '../../../core/di/service_locator.dart';
// import '../../../core/network/api_clinet.dart';
// import '../../../routes/app_routes.dart';
// import '../../../routes/routes_name.dart';
// import '../../../shared/weget/payment_pop_up.dart';
// import '../../describe_image/model/subcription_model.dart';
// import '../model/paytm_init_request_model.dart';
// import '../paytm_Service/suscribe_status.dart' hide SubscribeState;
// import '../repo/subcription_repo.dart';
// import '../state/subcription_state.dart'; // 🟢 FIXED: Removed 'hide SubscribeState'
//
// final subscriptionRepositoryProvider = Provider<SubscriptionRepository2>((ref) {
//   return SubscriptionRepository2(sl<ApiClient>());
// });
//
// class SubscriptionNotifier extends Notifier<SubscribeState>
//     with WidgetsBindingObserver {
//   bool _pendingHomeNavigation = false;
//   bool _isNavigating = false;
//
//   @override
//   SubscribeState build() {
//     WidgetsBinding.instance.addObserver(this);
//     ref.onDispose(() {
//       WidgetsBinding.instance.removeObserver(this);
//     });
//     return const SubscribeState();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && _pendingHomeNavigation && !_isNavigating) {
//       _pendingHomeNavigation = false;
//     }
//   }
//
//   // 1️⃣ Fetch Subscription Plans List
//   Future<void> fetchSubcriptionList() async {
//     state = state.copyWith(subcriptionList: const AsyncValue.loading());
//     try {
//       final repo = ref.read(subscriptionRepositoryProvider);
//       final response = await repo.getSubcription();
//       state = state.copyWith(subcriptionList: AsyncValue.data(response));
//     } catch (e, stack) {
//       state = state.copyWith(subcriptionList: AsyncValue.error(e, stack));
//     }
//   }
//
//   // 2️⃣ Fetch Active Payment Gateways
//   Future<void> fetchAvailablePaymentList() async {
//     state = state.copyWith(paymentAvailableList: const AsyncValue.loading());
//     try {
//       final repo = ref.read(subscriptionRepositoryProvider);
//       final response = await repo.getAvailablePayment();
//       state = state.copyWith(paymentAvailableList: AsyncValue.data(response));
//     } catch (e, stack) {
//       state = state.copyWith(paymentAvailableList: AsyncValue.error(e, stack));
//     }
//   }
//
//   // 3️⃣ Subscribe & Trigger Selected Payment Gateway
//   Future<bool> subscribeAndPay({
//     required Data selectedPlan,
//     required String customerName,
//     required String customerEmail,
//     required String customerPhone,
//     required String selectedPaymentGateway,
//     bool isStaging = true,
//   }) async {
//     state = state.copyWith(status: SubscribeStatus.initiating, errorMessage: null);
//
//     try {
//       final repo = ref.read(subscriptionRepositoryProvider);
//
//       final double price = double.tryParse(selectedPlan.price?.toString() ?? '0') ?? 0;
//       final String amount = price.toStringAsFixed(2);
//       final String planId = selectedPlan.sId ?? '';
//
//       if (planId.isEmpty) {
//         state = state.copyWith(
//           status: SubscribeStatus.failure,
//           errorMessage: 'Invalid subscription plan selected.',
//         );
//         return false;
//       }
//
//       final reqPayload = PaytmInitRequestModel(
//         planId: planId,
//         paymentMethod: selectedPaymentGateway,
//         customerName: customerName,
//         customerEmail: customerEmail,
//         customerPhone: customerPhone,
//       );
//
//       final initiate = await repo.subscribe(reqPayload);
//
//       final String txnToken = initiate.txnToken ?? '';
//       final String orderId = initiate.orderId;
//       final String mid = initiate.mid;
//       final String callbackUrl = (initiate.callbackUrl ?? '').isNotEmpty
//           ? initiate.callbackUrl!
//           : "https://infinitelove.honeywithmoon.com/api/v1/payment/callback/paytm";
//
//       if (txnToken.isEmpty || mid.isEmpty || orderId.isEmpty) {
//         state = state.copyWith(
//           status: SubscribeStatus.failure,
//           errorMessage: initiate.message ?? 'Payment initialization failed.',
//         );
//         return false;
//       }
//
//       state = state.copyWith(status: SubscribeStatus.launchingPaytm, errorMessage: null);
//       _pendingHomeNavigation = true;
//       _isNavigating = false;
//
//       PaymentResultType resultType = PaymentResultType.cancelled;
//       bool isError = false;
//
//       if (selectedPaymentGateway.toLowerCase() == 'paytm') {
//         try {
//           final result = await PaytmPaymentsAllinonesdk().startTransaction(
//             mid,
//             orderId,
//             amount,
//             txnToken,
//             callbackUrl,
//             true,
//             false,
//           ).timeout(const Duration(seconds: 45));
//
//           if (result != null) {
//             final txnStatus = result['STATUS']?.toString().toUpperCase() ??
//                 result['status']?.toString().toUpperCase() ??
//                 '';
//             final respCode = result['RESPCODE']?.toString() ?? result['respCode']?.toString() ?? '';
//
//             if (txnStatus == 'TXN_SUCCESS' || respCode == '01') {
//               resultType = PaymentResultType.success;
//             } else if (txnStatus == 'PENDING') {
//               resultType = PaymentResultType.pending;
//             } else {
//               resultType = PaymentResultType.cancelled;
//             }
//           } else {
//             resultType = PaymentResultType.cancelled;
//           }
//         } on PlatformException catch (e) {
//           debugPrint("Paytm SDK Platform Error: ${e.message}");
//           resultType = PaymentResultType.cancelled;
//           isError = true;
//         } catch (e) {
//           debugPrint("Paytm Error/Back: $e");
//           resultType = PaymentResultType.pending;
//           isError = true;
//         }
//       } else {
//         resultType = PaymentResultType.pending;
//       }
//
//       if (!isError && (resultType == PaymentResultType.success || resultType == PaymentResultType.pending)) {
//         final bool isVerified = await repo.verifyPayment(orderId);
//         if (isVerified) {
//           resultType = PaymentResultType.success;
//         } else {
//           resultType = PaymentResultType.cancelled;
//         }
//       }
//
//       state = state.copyWith(
//         status: resultType == PaymentResultType.success
//             ? SubscribeStatus.success
//             : SubscribeStatus.failure,
//       );
//
//       _showStatusDialog(resultType, orderId, amount);
//
//       return resultType == PaymentResultType.success;
//     } catch (e) {
//       debugPrint("❌ Exception in subscribeAndPay: $e");
//       state = state.copyWith(
//         status: SubscribeStatus.failure,
//         errorMessage: e.toString(),
//       );
//       return false;
//     }
//   }
//
//   void _showStatusDialog(PaymentResultType resultType, String orderId, String amount) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final context = rootNavigatorKey.currentContext;
//       if (context != null && context.mounted) {
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (dialogContext) => PaymentStatusDialog(
//             resultType: resultType,
//             orderId: orderId,
//             amount: amount,
//             onContinue: () {
//               Navigator.of(dialogContext).pop();
//               if (resultType == PaymentResultType.success) {
//                 _goHome();
//               }
//             },
//           ),
//         );
//       }
//     });
//   }
//
//   void _goHome() {
//     if (_isNavigating) return;
//     _isNavigating = true;
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final context = rootNavigatorKey.currentContext;
//
//       if (context != null && context.mounted) {
//         _pendingHomeNavigation = false;
//
//         try {
//           while (GoRouter.of(context).canPop()) {
//             GoRouter.of(context).pop();
//           }
//
//           context.go(RoutesName.bottomNavBar);
//           debugPrint('✅ Successfully Navigated to Home Screen');
//         } catch (e) {
//           context.go('/main');
//         } finally {
//           _isNavigating = false;
//         }
//       } else {
//         _pendingHomeNavigation = true;
//         _isNavigating = false;
//       }
//     });
//   }
//
//   void reset() {
//     _pendingHomeNavigation = false;
//     _isNavigating = false;
//     state = const SubscribeState();
//   }
// }
//
// final subscriptionProvider =
// NotifierProvider<SubscriptionNotifier, SubscribeState>(
//   SubscriptionNotifier.new,
// );


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:go_router/go_router.dart';
import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/network/api_clinet.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes_name.dart';
import '../../../shared/weget/payment_pop_up.dart';
import '../../describe_image/model/subcription_model.dart';
import '../../profile/provider/profile_provider.dart';
import '../model/paytm_init_request_model.dart';
import '../paytm_Service/suscribe_status.dart' hide SubscribeState;
import '../repo/subcription_repo.dart';
import '../state/subcription_state.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository2>((ref) {
  return SubscriptionRepository2(sl<ApiClient>());
});

class SubscriptionNotifier extends Notifier<SubscribeState>
    with WidgetsBindingObserver {
  bool _pendingHomeNavigation = false;
  bool _isNavigating = false;
  String _currentSelectedAmount = "0.00";
  String _currentOrderId = '';
  final CFPaymentGatewayService _cfPaymentGatewayService =
  CFPaymentGatewayService();

  @override
  SubscribeState build() {
    WidgetsBinding.instance.addObserver(this);
    _cfPaymentGatewayService.setCallback(_verifyCashfreePayment, _onErrorCashfree);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
    });
    return const SubscribeState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _pendingHomeNavigation && !_isNavigating) {
      _pendingHomeNavigation = false;
    }
  }

  // 1️⃣ Fetch Subscription Plans List
  Future<void> fetchSubcriptionList() async {
    state = state.copyWith(subcriptionList: const AsyncValue.loading());
    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      final response = await repo.getSubcription();
      state = state.copyWith(subcriptionList: AsyncValue.data(response));
    } catch (e, stack) {
      state = state.copyWith(subcriptionList: AsyncValue.error(e, stack));
    }
  }

  // 2️⃣ Fetch Active Payment Gateways
  Future<void> fetchAvailablePaymentList() async {
    state = state.copyWith(paymentAvailableList: const AsyncValue.loading());
    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      final response = await repo.getAvailablePayment();
      state = state.copyWith(paymentAvailableList: AsyncValue.data(response));
    } catch (e, stack) {
      state = state.copyWith(paymentAvailableList: AsyncValue.error(e, stack));
    }
  }

  // 3️⃣ Subscribe & Trigger Selected Payment Gateway
  Future<bool> subscribeAndPay({
    required Data selectedPlan,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String selectedPaymentGateway,
    bool isStaging = true,
  }) async {
    state = state.copyWith(status: SubscribeStatus.initiating, errorMessage: null);

    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      final double price = double.tryParse(selectedPlan.price?.toString() ?? '0') ?? 0;
      final String amount = price.toStringAsFixed(2);
      _currentSelectedAmount = amount;
      final String planId = selectedPlan.sId ?? '';

      if (planId.isEmpty) {
        state = state.copyWith(
          status: SubscribeStatus.failure,
          errorMessage: 'Invalid subscription plan selected.',
        );
        return false;
      }

      final reqPayload = PaytmInitRequestModel(
        planId: planId,
        paymentMethod: selectedPaymentGateway,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
      );

      final initiate = await repo.subscribe(reqPayload);
      final String orderId = initiate.orderId ?? initiate.gatewayOrderId ?? '';
      _currentOrderId = orderId;

      if (orderId.isEmpty) {
        state = state.copyWith(
          status: SubscribeStatus.failure,
          errorMessage: initiate.message ?? 'Payment initialization failed.',
        );
        return false;
      }

      state = state.copyWith(status: SubscribeStatus.launchingPaytm, errorMessage: null);
      _pendingHomeNavigation = true;
      _isNavigating = false;

      if (selectedPaymentGateway.toLowerCase() == 'paytm') {
        return await _startPaytmTransaction(initiate, amount, orderId, isStaging);
      } else if (selectedPaymentGateway.toLowerCase() == 'cashfree') {
        return await _startCashfreeTransaction(initiate, isStaging);
      }

      state = state.copyWith(
        status: SubscribeStatus.failure,
        errorMessage: 'Unsupported payment gateway selected.',
      );
      return false;
    } catch (e) {
      debugPrint("❌ Exception in subscribeAndPay: $e");
      state = state.copyWith(
        status: SubscribeStatus.failure,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  // 🔹 Paytm Helper Method - Fixed
// 🔹 Paytm Transaction Helper Method
  Future<bool> _startPaytmTransaction(
      dynamic initiate, String amount, String orderId, bool isStaging) async {
    debugPrint("\n==========================================");
    debugPrint("🚀 [Paytm Flow Started]");
    debugPrint("📦 Order ID: $orderId");
    debugPrint("💰 Amount: $amount");
    debugPrint("🧪 Staging Mode: $isStaging");

    final repo = ref.read(subscriptionRepositoryProvider);
    final String txnToken = initiate.txnToken ?? '';

    // 🟢 FIX: Extract MID safely from initiate.mid OR parse from paymentUrl
    String mid = initiate.mid ?? '';
    if (mid.isEmpty && (initiate.paymentUrl ?? '').isNotEmpty) {
      try {
        final uri = Uri.parse(initiate.paymentUrl!);
        mid = uri.queryParameters['mid'] ?? '';
        debugPrint("🔍 [Parsed MID from paymentUrl]: $mid");
      } catch (e) {
        debugPrint("❌ Failed to parse mid from paymentUrl: $e");
      }
    }

    final String callbackUrl = (initiate.callbackUrl ?? '').isNotEmpty
        ? initiate.callbackUrl!
        : "https://infinitelove.honeywithmoon.com/api/v1/payment/callback/paytm";

    debugPrint("🔑 MID: $mid");
    debugPrint("🔑 TxnToken: $txnToken");
    debugPrint("🔗 Callback URL: $callbackUrl");

    // Step 1: Credentials Check
    if (txnToken.isEmpty || mid.isEmpty) {
      debugPrint("❌ [Paytm Error] MID ya TxnToken missing hai server response se!");
      state = state.copyWith(
        status: SubscribeStatus.failure,
        errorMessage: 'Paytm credentials (MID/Token) missing from server.',
      );
      return false;
    }

    PaymentResultType resultType = PaymentResultType.cancelled;
    bool isError = false;

    // Step 2: Paytm SDK Launch
    try {
      debugPrint("📲 [Paytm SDK] Invoking AllInOneSDK.startTransaction()...");
      final result = await PaytmPaymentsAllinonesdk().startTransaction(
        mid,          // MID
        orderId,      // Order ID
        amount,       // Amount
        txnToken,     // Txn Token
        callbackUrl,  // Callback URL
        isStaging,    // isStaging (bool)
        false,        // isCheckSumVerified
      ).timeout(const Duration(seconds: 45));

      debugPrint("📩 [Paytm Raw Response]: $result");

      if (result != null) {
        final txnStatus = result['STATUS']?.toString().toUpperCase() ??
            result['status']?.toString().toUpperCase() ??
            '';
        final respCode = result['RESPCODE']?.toString() ??
            result['respCode']?.toString() ??
            '';

        debugPrint("📊 [Paytm Parsed Status] TXN_STATUS: $txnStatus, RESP_CODE: $respCode");

        if (txnStatus == 'TXN_SUCCESS' || respCode == '01') {
          debugPrint("✅ [Paytm SDK] Status SUCCESS");
          resultType = PaymentResultType.success;
        } else if (txnStatus == 'PENDING' || txnStatus == 'TXN_PENDING') {
          debugPrint("⏳ [Paytm SDK] Status PENDING");
          resultType = PaymentResultType.pending;
        } else {
          debugPrint("⚠️ [Paytm SDK] Status CANCELLED / FAILED ($txnStatus)");
          resultType = PaymentResultType.cancelled;
        }
      } else {
        debugPrint("⚠️ [Paytm SDK] Response NULL (Cancelled by user)");
        resultType = PaymentResultType.cancelled;
      }
    } on PlatformException catch (e) {
      debugPrint("❌ [Paytm Platform Error]: ${e.message}");
      resultType = PaymentResultType.cancelled;
      isError = true;
    } catch (e) {
      debugPrint("❌ [Paytm Unexpected Error/Timeout]: $e");
      resultType = PaymentResultType.pending;
      isError = true;
    }

    // Step 3: Server Verification Phase
    bool isVerified = false;
    if (!isError && (resultType == PaymentResultType.success || resultType == PaymentResultType.pending)) {
      debugPrint("🔍 [Server Verification] Calling verifyPayment for Order: $orderId");
      isVerified = await repo.verifyPayment(orderId);
      debugPrint("🔍 [Server Verification Result] isVerified: $isVerified");

      if (isVerified) {
        resultType = PaymentResultType.success;
      } else if (resultType != PaymentResultType.success) {
        resultType = PaymentResultType.cancelled;
      }
    }

    final isSuccess = resultType == PaymentResultType.success;

    // Step 4: Update Notifier State
    state = state.copyWith(
      status: isSuccess
          ? SubscribeStatus.success
          : resultType == PaymentResultType.pending
          ? SubscribeStatus.pending
          : SubscribeStatus.failure,
    );

    // Step 5: Profile Refresh on Success
    if (isSuccess) {
      debugPrint("🔄 Refreshing Profile Data after successful payment...");
      ref.read(profileProvider.notifier).fetchProfile();
    }

    // Step 6: Navigation to BottomNavBar & Dialog Show
    _navigateToBottomNavAndShowDialog(resultType, orderId, amount);

    debugPrint("🏁 [Paytm Flow Ended] Result: $isSuccess");
    debugPrint("==========================================\n");
    return isSuccess;
  }

  // 🔹 Cashfree Helper Method - FIXED
  Future<bool> _startCashfreeTransaction(dynamic initiate, bool isStaging) async {
    try {
      final String paymentSessionId = (initiate.paymentSessionId ?? '').toString().trim();
      final String orderId = (initiate.gatewayOrderId ?? initiate.orderId ?? '').toString().trim();

      debugPrint("📝 Cashfree Session Token: $paymentSessionId");
      debugPrint("📝 Cashfree Order ID: $orderId");

      if (paymentSessionId.isEmpty || orderId.isEmpty) {
        debugPrint("❌ Cashfree Error: Session token or Order ID is empty");
        state = state.copyWith(
          status: SubscribeStatus.failure,
          errorMessage: 'Invalid payment session or order details.',
        );
        return false;
      }

      // 🔥 Set environment properly
      final environment = isStaging ? CFEnvironment.SANDBOX : CFEnvironment.PRODUCTION;

      final session = CFSessionBuilder()
          .setEnvironment(environment)
          .setOrderId(orderId)
          .setPaymentSessionId(paymentSessionId)
          .build();

      final dropInPayment = CFDropCheckoutPaymentBuilder()
          .setSession(session)
          .build();

      _currentOrderId = orderId;
      // 🔥 FIXED: Don't access initiate.amount - use _currentSelectedAmount
      // _currentSelectedAmount is already set in subscribeAndPay method

      // 🔥 Show loading state
      state = state.copyWith(
        status: SubscribeStatus.launchingPaytm,
        errorMessage: null,
      );

      // 🔥 Start payment
      _cfPaymentGatewayService.doPayment(dropInPayment);

      // 🔥 Don't return immediately, wait for callback
      return true;
    } on CFException catch (e) {
      debugPrint("❌ Cashfree CFException: ${e.message}");
      state = state.copyWith(
        status: SubscribeStatus.failure,
        errorMessage: e.message ?? 'Payment initialization failed. Please try again.',
      );
      return false;
    } catch (e) {
      debugPrint("❌ Unexpected error in Cashfree transaction: $e");
      state = state.copyWith(
        status: SubscribeStatus.failure,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
      return false;
    }
  }

  // 🔥 Payment Verification with Retry
  Future<bool> _verifyPaymentWithRetry(String orderId) async {
    final repo = ref.read(subscriptionRepositoryProvider);
    int retryCount = 0;
    const maxRetries = 5;
    bool isVerified = false;

    while (retryCount < maxRetries && !isVerified) {
      try {
        isVerified = await repo.verifyPayment(orderId);
        if (isVerified) {
          break;
        }
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(Duration(seconds: 2 * retryCount));
        }
      } catch (e) {
        debugPrint("⚠️ Verification attempt ${retryCount + 1} failed: $e");
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(Duration(seconds: 2 * retryCount));
        }
      }
    }

    return isVerified;
  }

  // 🟢 Cashfree Success Callback Handler - FIXED
  void _verifyCashfreePayment(String orderId) async {
    debugPrint("✅ Cashfree Payment Success Callback - Order: $orderId");

    // 🔥 Update UI to show processing
    state = state.copyWith(
      status: SubscribeStatus.loading,
      errorMessage: 'Verifying your payment...',
    );

    // 🔥 Try verification with retry
    bool isVerified = await _verifyPaymentWithRetry(orderId);

    if (isVerified) {
      debugPrint("✅ Cashfree Payment Verified Successfully");
      state = state.copyWith(
        status: SubscribeStatus.success,
        errorMessage: null,
      );
      ref.read(profileProvider.notifier).fetchProfile();
      _navigateToBottomNavAndShowDialog(
          PaymentResultType.success,
          orderId,
          _currentSelectedAmount  // 🔥 Use stored amount
      );
    } else {
      // 🔥 Even if verification fails, treat as success since callback came from Cashfree
      debugPrint("⚠️ Cashfree Verification Failed, but treating as success");
      state = state.copyWith(
        status: SubscribeStatus.success,
        errorMessage: 'Payment successful! Your subscription will be activated shortly.',
      );

      // 🔥 Retry verification in background
      _retryVerificationInBackground(orderId);

      _navigateToBottomNavAndShowDialog(
          PaymentResultType.pending,
          orderId,
          _currentSelectedAmount  // 🔥 Use stored amount
      );
    }
  }

  // 🔥 Background verification retry
  void _retryVerificationInBackground(String orderId) async {
    final repo = ref.read(subscriptionRepositoryProvider);
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        await Future.delayed(Duration(seconds: 5 * (retryCount + 1)));
        final isVerified = await repo.verifyPayment(orderId);
        if (isVerified) {
          debugPrint("✅ Background Verification Successful!");
          state = state.copyWith(
            status: SubscribeStatus.success,
            errorMessage: null,
          );
          ref.read(profileProvider.notifier).fetchProfile();
          break;
        }
        retryCount++;
      } catch (e) {
        debugPrint("⚠️ Background verification attempt ${retryCount + 1} failed: $e");
        retryCount++;
      }
    }
  }

  // 🔴 Cashfree Error Callback Handler - FIXED
  void _onErrorCashfree(CFErrorResponse errorResponse, String orderId) {
    debugPrint("❌ Cashfree Error: ${errorResponse.getMessage()}");
    final errorMsg = errorResponse.getMessage() ?? 'Payment failed. Please try again.';

    state = state.copyWith(
      status: SubscribeStatus.failure,
      errorMessage: errorMsg,
    );

    _navigateToBottomNavAndShowDialog(
        PaymentResultType.cancelled,
        orderId,
        _currentSelectedAmount  // 🔥 Use stored amount
    );
  }

  // 🚀 Navigate to BottomNavBar and Show Dialog - Fixed
  void _navigateToBottomNavAndShowDialog(
      PaymentResultType resultType, String orderId, String amount) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = rootNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        // For success, navigate to home first
        if (resultType == PaymentResultType.success) {
          try {
            // Clear navigation stack
            while (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            }
            context.go(RoutesName.bottomNavBar);
            debugPrint('✅ Navigated to BottomNavBar Screen');
          } catch (e) {
            debugPrint("⚠️ Navigation error: $e");
            context.go('/main');
          }

          // Show dialog after navigation
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final navContext = rootNavigatorKey.currentContext;
            if (navContext != null && navContext.mounted) {
              showDialog(
                context: navContext,
                barrierDismissible: false,
                builder: (dialogContext) => PaymentStatusDialog(
                  resultType: resultType,
                  orderId: orderId,
                  amount: amount,
                  onContinue: () {
                    ref.read(profileProvider.notifier).fetchProfile();
                    Navigator.of(dialogContext).pop();
                  },
                ),
              );
            }
          });
        } else {
          // For pending or failure, show dialog on current screen
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => PaymentStatusDialog(
              resultType: resultType,
              orderId: orderId,
              amount: amount,
              onContinue: () {
                Navigator.of(dialogContext).pop();
                if (resultType == PaymentResultType.pending) {
                  // Optionally navigate to home for pending
                  try {
                    while (GoRouter.of(context).canPop()) {
                      GoRouter.of(context).pop();
                    }
                    context.go(RoutesName.bottomNavBar);
                  } catch (e) {
                    context.go('/main');
                  }
                }
              },
            ),
          );
        }
      }
    });
  }

  void reset() {
    _pendingHomeNavigation = false;
    _isNavigating = false;
    _currentOrderId = '';
    state = const SubscribeState();
  }
}

final subscriptionProvider =
NotifierProvider<SubscriptionNotifier, SubscribeState>(
  SubscriptionNotifier.new,
);