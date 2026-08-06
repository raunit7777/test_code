import 'package:flutter/cupertino.dart';

import '../../../core/network/api_clinet.dart';
import '../../../core/network/api_endpoints.dart';
import '../../describe_image/model/subcription_model.dart';
import '../model/paytm_init_request_model.dart';

class SubscriptionRepository2 {
  final ApiClient _apiClient;

  SubscriptionRepository2(this._apiClient);

  Future<SubcriptionModel> getSubcription() async {
    final response = await _apiClient.get(
      ApiEndpoints.subscriptionPlan,
    );
    return SubcriptionModel.fromJson(response.data);
  }

  Future<PaytmInitData> subscribe(PaytmInitRequestModel request) async {
    final response = await _apiClient.post(
      ApiEndpoints.paymentInit,
      data: request.toJson(),
    );

    final parsedResponse = PaytmInitResponseModel.fromJson(response.data);
    return parsedResponse.data ??
        PaytmInitData.fromJson(response.data['data'] ?? {});
  }

  // 🟢 Payment Verification API Method
  Future<bool> verifyPayment(String orderId) async {
    final String fullUrl = '${ApiEndpoints.paymentVerify}/$orderId';
    debugPrint('🚀 [POST Verify Payment] Calling URL: $fullUrl');
    debugPrint('📦 [POST Verify Payment] Order ID: $orderId');

    try {
      final response = await _apiClient.post(fullUrl);

      debugPrint('📥 [POST Verify Payment] Status Code: ${response.statusCode}');
      debugPrint('📦 [POST Verify Payment] Raw Response Data: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        debugPrint('✅ [POST Verify Payment] Verification SUCCESS for Order ID: $orderId');
        return true;
      } else {
        debugPrint('⚠️ [POST Verify Payment] Verification FAILED or success is false');
        return false;
      }
    } catch (error, stackTrace) {
      debugPrint('❌ [POST Verify Payment Error]: $error');
      debugPrint('🚨 [POST Verify Payment StackTrace]: $stackTrace');
      return false;
    }
  }
}