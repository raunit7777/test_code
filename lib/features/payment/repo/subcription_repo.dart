import 'package:flutter/foundation.dart';
import '../../../core/network/api_clinet.dart';
import '../../../core/network/api_endpoints.dart';
import '../../describe_image/model/subcription_model.dart';
import '../model/avilable_model.dart';
import '../model/paytm_init_request_model.dart';

class PaymentVerificationResult {
  final bool isPaid;
  final bool isPending;
  final bool isFailed;
  final bool isExpired;
  final String? message;
  final dynamic rawData;

  const PaymentVerificationResult({
    required this.isPaid,
    this.isPending = false,
    this.isFailed = false,
    this.isExpired = false,
    this.message,
    this.rawData,
  });

  factory PaymentVerificationResult.inconclusive({String? message}) =>
      PaymentVerificationResult(
        isPaid: false,
        isPending: true,
        message: message ?? 'Payment verification is still pending.',
      );

  factory PaymentVerificationResult.paid({dynamic rawData}) =>
      PaymentVerificationResult(
        isPaid: true,
        rawData: rawData,
        message: 'Payment verified successfully.',
      );

  factory PaymentVerificationResult.failed({String? message}) =>
      PaymentVerificationResult(
        isPaid: false,
        isFailed: true,
        message: message ?? 'Payment failed or was cancelled.',
      );

  factory PaymentVerificationResult.expired({String? message}) =>
      PaymentVerificationResult(
        isPaid: false,
        isExpired: true,
        message: message ?? 'Payment session expired.',
      );
}

class SubscriptionRepository2 {
  final ApiClient _apiClient;

  SubscriptionRepository2(this._apiClient);

  // 🟢 Subscription Plans Fetch
  Future<SubcriptionModel> getSubcription() async {
    final response = await _apiClient.get(
      ApiEndpoints.subscriptionPlan,
    );
    return SubcriptionModel.fromJson(response.data);
  }

  // 🟢 Available Payment Gateways Fetch
  Future<AvailablePaymentModel> getAvailablePayment() async {
    final response = await _apiClient.get(
      ApiEndpoints.availablePayment,
    );

    if (response.data is Map<String, dynamic>) {
      return AvailablePaymentModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    }

    throw Exception('Failed to parse available payment data');
  }

  // 🟢 Payment Initiate
  Future<PaytmInitData> subscribe(PaytmInitRequestModel request) async {
    final response = await _apiClient.post(
      ApiEndpoints.paymentInit,
      data: request.toJson(),
    );

    final parsedResponse = PaytmInitResponseModel.fromJson(response.data);
    return parsedResponse.data ??
        PaytmInitData.fromJson(response.data['data'] ?? {});
  }

  // 🟢 Comprehensive Backend Order Status Verification
  Future<PaymentVerificationResult> checkOrderStatus(String orderId) async {
    final String fullUrl = '${ApiEndpoints.paymentVerify}/$orderId';
    if (kDebugMode) {
      debugPrint('🚀 [Verify Payment] Calling verification URL for Order ID: $orderId');
    }

    try {
      final response = await _apiClient.get(fullUrl);
      final int statusCode = response.statusCode ?? 0;
      final dynamic body = response.data;

      if (kDebugMode) {
        debugPrint('📥 [Verify Payment] Response Code: $statusCode');
      }

      if (statusCode == 200 && body is Map<String, dynamic>) {
        final bool success = body['success'] == true;
        final String statusStr = (body['data']?['status'] ??
                body['status'] ??
                body['paymentStatus'] ??
                '')
            .toString()
            .toUpperCase();

        if (success && (statusStr == 'PAID' || statusStr == 'SUCCESS' || statusStr.isEmpty)) {
          return PaymentVerificationResult.paid(rawData: body);
        } else if (statusStr == 'PENDING' || statusStr == 'TXN_PENDING') {
          return PaymentVerificationResult.inconclusive(
            message: body['message']?.toString() ?? 'Waiting for bank confirmation.',
          );
        } else if (statusStr == 'EXPIRED') {
          return PaymentVerificationResult.expired(
            message: body['message']?.toString() ?? 'Payment expired.',
          );
        } else if (!success && (statusStr == 'FAILED' || statusStr == 'CANCELLED')) {
          return PaymentVerificationResult.failed(
            message: body['message']?.toString() ?? 'Payment failed.',
          );
        } else if (success) {
          return PaymentVerificationResult.paid(rawData: body);
        }
      }

      // If inconclusive response
      return PaymentVerificationResult.inconclusive();
    } catch (error) {
      if (kDebugMode) {
        debugPrint('⚠️ [Verify Payment] Network or timeout error during verification: $error');
      }
      return PaymentVerificationResult.inconclusive(
        message: 'Network issue verifying payment. Status will be checked on resume.',
      );
    }
  }

  // 🟢 Pure Backend Payment Verification (boolean convenience)
  Future<bool> verifyPayment(String orderId) async {
    final result = await checkOrderStatus(orderId);
    return result.isPaid;
  }
}
