// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk.dart';
//
// import '../../../core/di/service_locator.dart';
// import '../../../core/network/api_clinet.dart';
// import '../../describe_image/model/subcription_model.dart';
//
// import '../model/paytm_init_request_model.dart';
// import '../paytm_Service/suscribe_status.dart';
// import '../repo/subcription_repo.dart';
// import '../state/subcription_state.dart';
//
// final subscriptionRepositoryProvider = Provider<SubscriptionRepository2>((ref) {
//   return SubscriptionRepository2(sl<ApiClient>());
// });
//
// class SubscriptionNotifier extends Notifier<SubscribeState> {
//   @override
//   SubscribeState build() => const SubscribeState();
//
//   // 1️⃣ Fetch Subscription List
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
//   // 2️⃣ Fully Dynamic Paytm Payment Execution
//   Future<bool> subscribeAndPay({
//     required Data selectedPlan,
//     required String customerName,
//     required String customerEmail,
//     required String customerPhone,
//     bool isStaging = true, // Set false for production/live
//   }) async {
//     state = state.copyWith(status: SubscribeStatus.initiating, errorMessage: null);
//
//     try {
//       final repo = ref.read(subscriptionRepositoryProvider);
//
//       // Extracting plan details dynamically from model
//       final String planId = selectedPlan.sId ?? '';
//       final String amount = selectedPlan.price?.toString() ?? '0';
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
//       // Initiate Payment API Call
//       final initiate = await repo.subscribe(reqPayload);
//
//       if ((initiate.txnToken ?? '').isEmpty ||
//           initiate.mid.isEmpty ||
//           initiate.orderId.isEmpty) {
//         state = state.copyWith(
//           status: SubscribeStatus.failure,
//           errorMessage: initiate.message ?? 'Payment initialization failed.',
//         );
//         return false;
//       }
//
//       state = state.copyWith(status: SubscribeStatus.launchingPaytm, errorMessage: null);
//
//       // 🟢 Trigger Paytm SDK dynamically
//       final result = await PaytmPaymentsAllinonesdk().startTransaction(
//         initiate.mid,
//         initiate.orderId,
//         amount,
//         initiate.txnToken!,
//         initiate.callbackUrl,
//         true,
//         true, // restrictAppInvoke = false allows UPI / Paytm / PhonePe app switches
//       );
//
//       final txnStatus = result?['STATUS']?.toString().toUpperCase() ??
//           result?['status']?.toString().toUpperCase();
//       final isSuccess = txnStatus == 'TXN_SUCCESS';
//
//       state = state.copyWith(
//         status: isSuccess ? SubscribeStatus.success : SubscribeStatus.failure,
//         errorMessage: isSuccess
//             ? null
//             : result?['RESPMSG']?.toString() ?? 'Payment was not completed.',
//       );
//
//       return isSuccess;
//     } on PlatformException catch (e) {
//       state = state.copyWith(
//         status: SubscribeStatus.failure,
//         errorMessage: e.message ?? 'Payment was cancelled.',
//       );
//       return false;
//     } catch (e) {
//       state = state.copyWith(
//         status: SubscribeStatus.failure,
//         errorMessage: e.toString(),
//       );
//       return false;
//     }
//   }
//
//   void reset() {
//     state = const SubscribeState();
//   }
// }
//
// final subscriptionProvider =
// NotifierProvider<SubscriptionNotifier, SubscribeState>(
//   SubscriptionNotifier.new,
// );

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/network/api_clinet.dart';
import '../../describe_image/model/subcription_model.dart';

import '../model/paytm_init_request_model.dart';
import '../paytm_Service/suscribe_status.dart';
import '../repo/subcription_repo.dart';
import '../state/subcription_state.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository2>((ref) {
  return SubscriptionRepository2(sl<ApiClient>());
});

class SubscriptionNotifier extends Notifier<SubscribeState> {
  @override
  SubscribeState build() => const SubscribeState();

  // 1️⃣ Fetch Subscription List
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

  // 2️⃣ Fully Dynamic Paytm Payment Execution & Verification
  Future<bool> subscribeAndPay({
    required Data selectedPlan,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    bool isStaging = true,
  }) async {
    state = state.copyWith(status: SubscribeStatus.initiating, errorMessage: null);

    try {
      final repo = ref.read(subscriptionRepositoryProvider);

      final String planId = selectedPlan.sId ?? '';
      final String amount = selectedPlan.price?.toString() ?? '0';

      if (planId.isEmpty) {
        state = state.copyWith(
          status: SubscribeStatus.failure,
          errorMessage: 'Invalid subscription plan selected.',
        );
        return false;
      }

      final reqPayload = PaytmInitRequestModel(
        planId: planId,
        paymentMethod: 'paytm',
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
      );

      // Initiate Payment API Call
      final initiate = await repo.subscribe(reqPayload);

      if ((initiate.txnToken ?? '').isEmpty ||
          initiate.mid.isEmpty ||
          initiate.orderId.isEmpty) {
        state = state.copyWith(
          status: SubscribeStatus.failure,
          errorMessage: initiate.message ?? 'Payment initialization failed.',
        );
        return false;
      }

      state = state.copyWith(status: SubscribeStatus.launchingPaytm, errorMessage: null);

      // 🟢 Trigger Paytm SDK dynamically
      final result = await PaytmPaymentsAllinonesdk().startTransaction(
        initiate.mid,
        initiate.orderId,
        amount,
        initiate.txnToken!,
        initiate.callbackUrl,
        true,
        true,
      );

      final txnStatus = result?['STATUS']?.toString().toUpperCase() ??
          result?['status']?.toString().toUpperCase();
      final isSuccess = txnStatus == 'TXN_SUCCESS';

      if (!isSuccess) {
        state = state.copyWith(
          status: SubscribeStatus.failure,
          errorMessage:
          result?['RESPMSG']?.toString() ?? 'Payment was not completed.',
        );
        return false;
      }

      // 🟢 3️⃣ Payment Success hone par Backend Verification
      state = state.copyWith(status: SubscribeStatus.success, errorMessage: null);

      final bool isVerified = await repo.verifyPayment(initiate.orderId);

      if (isVerified) {
        state = state.copyWith(
          status: SubscribeStatus.success,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          status: SubscribeStatus.failure,
          errorMessage: 'Payment verification failed on server.',
        );
        return false;
      }
    } on PlatformException catch (e) {
      state = state.copyWith(
        status: SubscribeStatus.failure,
        errorMessage: e.message ?? 'Payment was cancelled.',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: SubscribeStatus.failure,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void reset() {
    state = const SubscribeState();
  }
}

final subscriptionProvider =
NotifierProvider<SubscriptionNotifier, SubscribeState>(
  SubscriptionNotifier.new,
);