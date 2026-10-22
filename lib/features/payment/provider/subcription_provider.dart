import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/network/api_clinet.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes_name.dart';
import '../../../shared/weget/payment_pop_up.dart';
import '../../describe_image/model/subcription_model.dart';
import '../../profile/provider/profile_provider.dart';
import '../model/paytm_init_request_model.dart';
import '../repo/subcription_repo.dart';
import '../state/subcription_state.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository2>((ref) {
  return SubscriptionRepository2(sl<ApiClient>());
});

class SubscriptionNotifier extends Notifier<SubscribeState>
    with WidgetsBindingObserver {
  bool _isNavigating = false;
  bool _isDialogVisible = false;
  String _currentSelectedAmount = "0.00";
  String _currentOrderId = '';
  final CFPaymentGatewayService _cfPaymentGatewayService =
      CFPaymentGatewayService();

  @override
  SubscribeState build() {
    WidgetsBinding.instance.addObserver(this);
    _cfPaymentGatewayService.setCallback(
      _onCashfreeIntentCompleted,
      _onErrorCashfree,
    );
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
    });
    return const SubscribeState();
  }

  // ---------------------------------------------------------------------------
  // Lifecycle Observer: Payment Reconciliation on App Resume
  // ---------------------------------------------------------------------------
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_currentOrderId.isNotEmpty &&
          (this.state.paymentState == PaymentState.verifying ||
              this.state.paymentState == PaymentState.pending ||
              this.state.paymentState == PaymentState.initiated)) {
        debugPrint("🔄 [Payment Reconciliation] App resumed with active Order: $_currentOrderId. Rechecking backend...");
        reconcilePayment();
      }
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
    state = state.copyWith(
      paymentState: PaymentState.initiated,
      errorMessage: null,
    );

    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      final double price = double.tryParse(selectedPlan.price?.toString() ?? '0') ?? 0;
      final String amount = price.toStringAsFixed(2);
      _currentSelectedAmount = amount;
      final String planId = selectedPlan.sId ?? '';

      if (planId.isEmpty) {
        state = state.copyWith(
          paymentState: PaymentState.failed,
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
      final String orderId = initiate.orderId.isNotEmpty ? initiate.orderId : (initiate.gatewayOrderId ?? '');
      _currentOrderId = orderId;

      if (orderId.isEmpty) {
        state = state.copyWith(
          paymentState: PaymentState.failed,
          errorMessage: initiate.message ?? 'Payment initialization failed.',
        );
        return false;
      }

      state = state.copyWith(
        paymentState: PaymentState.initiated,
        activeOrderId: orderId,
        errorMessage: null,
      );

      if (selectedPaymentGateway.toLowerCase() == 'paytm') {
        return await _startPaytmTransaction(initiate, amount, orderId, isStaging);
      } else if (selectedPaymentGateway.toLowerCase() == 'cashfree') {
        return await _startCashfreeTransaction(initiate, isStaging);
      }

      state = state.copyWith(
        paymentState: PaymentState.failed,
        errorMessage: 'Unsupported payment gateway selected.',
      );
      return false;
    } catch (e) {
      debugPrint("❌ Exception in subscribeAndPay: $e");
      state = state.copyWith(
        paymentState: PaymentState.failed,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Paytm SDK Handler
  // ---------------------------------------------------------------------------
  Future<bool> _startPaytmTransaction(
    dynamic initiate,
    String amount,
    String orderId,
    bool isStaging,
  ) async {
    final String txnToken = initiate.txnToken ?? '';
    String mid = initiate.mid ?? '';

    if (mid.isEmpty && (initiate.paymentUrl ?? '').isNotEmpty) {
      try {
        final uri = Uri.parse(initiate.paymentUrl!);
        mid = uri.queryParameters['mid'] ?? '';
      } catch (_) {}
    }

    final String callbackUrl = (initiate.callbackUrl ?? '').isNotEmpty
        ? initiate.callbackUrl!
        : "https://infinitelove.honeywithmoon.com/api/v1/payment/callback/paytm";

    if (txnToken.isEmpty || mid.isEmpty) {
      state = state.copyWith(
        paymentState: PaymentState.failed,
        errorMessage: 'Payment credentials missing from server.',
      );
      return false;
    }

    // Launch Paytm SDK
    try {
      final result = await PaytmPaymentsAllinonesdk().startTransaction(
        mid,
        orderId,
        amount,
        txnToken,
        callbackUrl,
        isStaging,
        false,
      ).timeout(const Duration(seconds: 45));

      debugPrint("📲 [Paytm SDK Intent Completed]: $result");
    } on PlatformException catch (e) {
      debugPrint("⚠️ [Paytm Platform Warning]: ${e.message}");
    } catch (e) {
      debugPrint("⚠️ [Paytm SDK Notice]: $e");
    }

    // Rule: SDK callback is treated purely as intent completion.
    // Transition to verifying state immediately.
    state = state.copyWith(
      paymentState: PaymentState.verifying,
      activeOrderId: orderId,
      errorMessage: 'Verifying payment with bank...',
    );

    // Explicitly verify order status with backend API
    return await _verifyOrderWithBackend(orderId, amount);
  }

  // ---------------------------------------------------------------------------
  // Cashfree SDK Handler
  // ---------------------------------------------------------------------------
  Future<bool> _startCashfreeTransaction(dynamic initiate, bool isStaging) async {
    try {
      final String paymentSessionId = (initiate.paymentSessionId ?? '').toString().trim();
      final String orderId = (initiate.gatewayOrderId ?? initiate.orderId ?? '').toString().trim();

      if (paymentSessionId.isEmpty || orderId.isEmpty) {
        state = state.copyWith(
          paymentState: PaymentState.failed,
          errorMessage: 'Invalid payment session or order details.',
        );
        return false;
      }

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
      state = state.copyWith(
        paymentState: PaymentState.initiated,
        activeOrderId: orderId,
        errorMessage: null,
      );

      _cfPaymentGatewayService.doPayment(dropInPayment);
      return true;
    } on CFException catch (e) {
      state = state.copyWith(
        paymentState: PaymentState.failed,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        paymentState: PaymentState.failed,
        errorMessage: 'An unexpected error occurred.',
      );
      return false;
    }
  }

  // Cashfree SDK intent completion callback
  void _onCashfreeIntentCompleted(String orderId) async {
    debugPrint("📲 [Cashfree Intent Completed] Order: $orderId");

    // SDK callback is purely intent completion: set UI to verifying state
    state = state.copyWith(
      paymentState: PaymentState.verifying,
      activeOrderId: orderId,
      errorMessage: 'Verifying payment confirmation...',
    );

    await _verifyOrderWithBackend(orderId, _currentSelectedAmount);
  }

  // Cashfree SDK Error/Cancellation
  void _onErrorCashfree(CFErrorResponse errorResponse, String orderId) {
    debugPrint("❌ Cashfree SDK Error: ${errorResponse.getMessage()}");
    final errorMsg = errorResponse.getMessage() ?? 'Payment was cancelled or failed.';

    state = state.copyWith(
      paymentState: PaymentState.failed,
      errorMessage: errorMsg,
    );

    _showStatusDialog(
      PaymentResultType.cancelled,
      orderId,
      _currentSelectedAmount,
    );
  }

  // ---------------------------------------------------------------------------
  // Backend Verification & Robust Inconclusive Resolution
  // ---------------------------------------------------------------------------
  Future<bool> _verifyOrderWithBackend(String orderId, String amount) async {
    final repo = ref.read(subscriptionRepositoryProvider);
    PaymentVerificationResult result = PaymentVerificationResult.inconclusive();

    const int maxRetries = 3;
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        result = await repo.checkOrderStatus(orderId);
        if (result.isPaid || result.isFailed || result.isExpired) {
          break;
        }
      } catch (_) {}

      if (attempt < maxRetries - 1) {
        await Future.delayed(Duration(seconds: 2 * (attempt + 1)));
      }
    }

    if (result.isPaid) {
      debugPrint("✅ [Payment Verified] Server confirmed PAID for Order: $orderId");
      state = state.copyWith(
        paymentState: PaymentState.paid,
        activeOrderId: orderId,
        errorMessage: null,
      );

      ref.read(profileProvider.notifier).fetchProfile();

      _showStatusDialog(PaymentResultType.success, orderId, amount);
      return true;
    } else if (result.isFailed) {
      debugPrint("❌ [Payment Failed] Server confirmed FAILED for Order: $orderId");
      state = state.copyWith(
        paymentState: PaymentState.failed,
        activeOrderId: orderId,
        errorMessage: result.message ?? 'Payment failed.',
      );

      _showStatusDialog(PaymentResultType.cancelled, orderId, amount);
      return false;
    } else if (result.isExpired) {
      debugPrint("⚠️ [Payment Expired] Server confirmed EXPIRED for Order: $orderId");
      state = state.copyWith(
        paymentState: PaymentState.expired,
        activeOrderId: orderId,
        errorMessage: result.message ?? 'Payment session expired.',
      );

      _showStatusDialog(PaymentResultType.cancelled, orderId, amount);
      return false;
    } else {
      // Inconclusive or retries exhausted: KEEP status as pending.
      // Do NOT downgrade to cancelled or promote to success.
      debugPrint("⏳ [Payment Inconclusive] Status kept as PENDING for Order: $orderId");
      state = state.copyWith(
        paymentState: PaymentState.pending,
        activeOrderId: orderId,
        errorMessage: 'Payment is being processed by your bank.',
      );

      _showStatusDialog(PaymentResultType.pending, orderId, amount);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Payment Reconciliation on App Resume
  // ---------------------------------------------------------------------------
  Future<void> reconcilePayment() async {
    if (_currentOrderId.isEmpty) return;

    final repo = ref.read(subscriptionRepositoryProvider);
    try {
      final result = await repo.checkOrderStatus(_currentOrderId);

      if (result.isPaid && state.paymentState != PaymentState.paid) {
        debugPrint("🎉 [Reconciliation SUCCESS] Order $_currentOrderId confirmed paid on resume!");
        state = state.copyWith(
          paymentState: PaymentState.paid,
          errorMessage: null,
        );

        ref.read(profileProvider.notifier).fetchProfile();
        _showStatusDialog(
          PaymentResultType.success,
          _currentOrderId,
          _currentSelectedAmount,
        );
      } else if (result.isFailed && state.paymentState != PaymentState.failed) {
        state = state.copyWith(
          paymentState: PaymentState.failed,
          errorMessage: result.message,
        );
      }
    } catch (e) {
      debugPrint("⚠️ [Reconciliation Error]: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // Single, Non-Conflicting Status Dialog Presentation
  // ---------------------------------------------------------------------------
  void _showStatusDialog(
    PaymentResultType resultType,
    String orderId,
    String amount,
  ) {
    if (_isDialogVisible) {
      debugPrint("⚠️ Status dialog already visible, skipping duplicate.");
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = rootNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        _isDialogVisible = true;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => PaymentStatusDialog(
            resultType: resultType,
            orderId: orderId,
            amount: amount,
            onContinue: () {
              _isDialogVisible = false;
              Navigator.of(dialogContext).pop();

              if (resultType == PaymentResultType.success) {
                _navigateToHome();
              }
            },
          ),
        ).then((_) {
          _isDialogVisible = false;
        });
      }
    });
  }

  void _navigateToHome() {
    if (_isNavigating) return;
    _isNavigating = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = rootNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        try {
          while (GoRouter.of(context).canPop()) {
            GoRouter.of(context).pop();
          }
          context.go(RoutesName.bottomNavBar);
        } catch (_) {
          context.go('/main');
        } finally {
          _isNavigating = false;
        }
      } else {
        _isNavigating = false;
      }
    });
  }

  void reset() {
    _isNavigating = false;
    _isDialogVisible = false;
    _currentOrderId = '';
    state = const SubscribeState();
  }
}

final subscriptionProvider =
    NotifierProvider<SubscriptionNotifier, SubscribeState>(
  SubscriptionNotifier.new,
);
