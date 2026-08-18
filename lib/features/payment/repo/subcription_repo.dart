// import 'package:flutter/cupertino.dart';
// import 'package:infinity_love/routes/routes_name.dart';
//
// import '../../../core/network/api_clinet.dart';
// import '../../../core/network/api_endpoints.dart';
// import '../../describe_image/model/subcription_model.dart';
// import '../model/paytm_init_request_model.dart';
// import 'package:go_router/go_router.dart';
// import '../../../routes/app_routes.dart';
//
// class SubscriptionRepository2 {
//   final ApiClient _apiClient;
//
//   SubscriptionRepository2(this._apiClient);
//
//   Future<SubcriptionModel> getSubcription() async {
//     final response = await _apiClient.get(
//       ApiEndpoints.subscriptionPlan,
//     );
//     return SubcriptionModel.fromJson(response.data);
//   }
//
//   Future<PaytmInitData> subscribe(PaytmInitRequestModel request) async {
//     final response = await _apiClient.post(
//       ApiEndpoints.paymentInit,
//       data: request.toJson(),
//     );
//
//     final parsedResponse = PaytmInitResponseModel.fromJson(response.data);
//     return parsedResponse.data ??
//         PaytmInitData.fromJson(response.data['data'] ?? {});
//   }
//
//   // 🟢 Payment Verification API Method
//   Future<bool> verifyPayment(String orderId) async {
//     final String fullUrl = '${ApiEndpoints.paymentVerify}/$orderId';
//     debugPrint('🚀 [Verify Payment] Calling URL: $fullUrl');
//     debugPrint('📦 [Verify Payment] Order ID: $orderId');
//
//     try {
//       final response = await _apiClient.get(fullUrl);
//
//       final int statusCode = response.statusCode ?? 0;
//       debugPrint('📥 [Verify Payment] Status Code: $statusCode');
//       debugPrint('📦 [Verify Payment] Raw Response Data: ${response.data}');
//
//       if (statusCode == 200 &&
//           response.data != null &&
//           response.data['success'] == true) {
//         debugPrint('✅ [Verify Payment] Verification SUCCESS for Order ID: $orderId');
//
//         // 🟢 Frame complete hone ke baad Navigation execute karein
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           final BuildContext? globalContext = rootNavigatorKey.currentContext;
//
//           if (globalContext != null && globalContext.mounted) {
//             debugPrint('🔀 Resetting stack and going to Main Navigation Screen...');
//
//             // GoRouter stack reset
//             globalContext.goNamed('mainNav');
//           } else {
//             debugPrint('⚠️ Global context unmounted or null!');
//           }
//         });
//
//         return true;
//       } else {
//         debugPrint('⚠️ [Verify Payment] Verification FAILED or success is false');
//         return false;
//       }
//     } catch (error, stackTrace) {
//       debugPrint('❌ [Verify Payment Error]: $error');
//       debugPrint('🚨 [Verify Payment StackTrace]: $stackTrace');
//       return false;
//     }
//   }}


// import 'package:flutter/cupertino.dart';
// import '../../../core/network/api_clinet.dart';
// import '../../../core/network/api_endpoints.dart';
// import '../../describe_image/model/subcription_model.dart';
// import '../model/avilable_model.dart';
// import '../model/paytm_init_request_model.dart';
//
// class SubscriptionRepository2 {
//   final ApiClient _apiClient;
//
//   SubscriptionRepository2(this._apiClient);
//
//   Future<SubcriptionModel> getSubcription() async {
//     final response = await _apiClient.get(
//       ApiEndpoints.subscriptionPlan,
//     );
//     return SubcriptionModel.fromJson(response.data);
//   }
//   Future<AvailablePaymentModel> availablePayment() async {
//     final response = await _apiClient.get(
//       ApiEndpoints.availablePayment,
//  // 🟢 Pass request data in query parameters
//     );
//
//     // 🟢 Handles both root-level response and nested response.data safely
//     if (response.data is Map<String, dynamic>) {
//       final Map<String, dynamic> data = response.data['data'] != null && response.data['data'] is Map<String, dynamic>
//           ? response.data['data'] as Map<String, dynamic>
//           : response.data as Map<String, dynamic>;
//
//       return AvailablePaymentModel.fromJson(data);
//     }
//
//     throw Exception('Failed to parse available payment data');
//   }
//   Future<PaytmInitData> subscribe(PaytmInitRequestModel request) async {
//     final response = await _apiClient.post(
//       ApiEndpoints.paymentInit,
//       data: request.toJson(),
//     );
//
//     final parsedResponse = PaytmInitResponseModel.fromJson(response.data);
//     return parsedResponse.data ??
//         PaytmInitData.fromJson(response.data['data'] ?? {});
//   }
//
//   // 🟢 Pure Backend Payment Verification (No Side Effects)
//   Future<bool> verifyPayment(String orderId) async {
//     final String fullUrl = '${ApiEndpoints.paymentVerify}/$orderId';
//     debugPrint('🚀 [Verify Payment] Calling URL: $fullUrl');
//
//     try {
//       final response = await _apiClient.get(fullUrl);
//       final int statusCode = response.statusCode ?? 0;
//
//       debugPrint('📥 [Verify Payment] Status Code: $statusCode');
//       debugPrint('📦 [Verify Payment] Raw Data: ${response.data}');
//
//       if (statusCode == 200 &&
//           response.data != null &&
//           response.data['success'] == true) {
//         debugPrint('✅ [Verify Payment] SUCCESS for Order ID: $orderId');
//         return true;
//       } else {
//         debugPrint('⚠️ [Verify Payment] FAILED or success is false');
//         return false;
//       }
//     } catch (error, stackTrace) {
//       debugPrint('❌ [Verify Payment Error]: $error');
//       return false;
//     }
//   }
// }

import 'package:flutter/cupertino.dart';
import '../../../core/network/api_clinet.dart';
import '../../../core/network/api_endpoints.dart';
import '../../describe_image/model/subcription_model.dart';
import '../model/avilable_model.dart';
import '../model/paytm_init_request_model.dart';

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

  // 🟢 Available Payment Gateways Fetch (Fixed Parsing Logic)
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

  // 🟢 Payment Initiate (Supports Dynamic Gateway Payload)
  Future<PaytmInitData> subscribe(PaytmInitRequestModel request) async {
    final response = await _apiClient.post(
      ApiEndpoints.paymentInit,
      data: request.toJson(),
    );

    final parsedResponse = PaytmInitResponseModel.fromJson(response.data);
    return parsedResponse.data ??
        PaytmInitData.fromJson(response.data['data'] ?? {});
  }

  // 🟢 Pure Backend Payment Verification
  Future<bool> verifyPayment(String orderId) async {
    final String fullUrl = '${ApiEndpoints.paymentVerify}/$orderId';
    debugPrint('🚀 [Verify Payment] Calling URL: $fullUrl');

    try {
      final response = await _apiClient.get(fullUrl);
      final int statusCode = response.statusCode ?? 0;

      debugPrint('📥 [Verify Payment] Status Code: $statusCode');
      debugPrint('📦 [Verify Payment] Raw Data: ${response.data}');

      if (statusCode == 200 &&
          response.data != null &&
          response.data['success'] == true) {
        debugPrint('✅ [Verify Payment] SUCCESS for Order ID: $orderId');
        return true;
      } else {
        debugPrint('⚠️ [Verify Payment] FAILED or success is false');
        return false;
      }
    } catch (error, stackTrace) {
      debugPrint('❌ [Verify Payment Error]: $error');
      return false;
    }
  }
}