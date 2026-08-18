// class PaytmInitRequestModel {
//   final String planId;
//   final String paymentMethod;
//   final String customerName;
//   final String? customerEmail;
//   final String? customerPhone;
//
//   PaytmInitRequestModel({
//     required this.planId,
//     this.paymentMethod = 'paytm',
//     required this.customerName,
//     this.customerEmail,
//     this.customerPhone,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       "planId": planId,
//       "paymentMethod": paymentMethod,
//       "customerName": customerName,
//       if (customerEmail != null) "customerEmail": customerEmail,
//       if (customerPhone != null) "customerPhone": customerPhone,
//     };
//   }
// }
//
// class PaytmInitResponseModel {
//   final bool? success;
//   final PaytmInitData? data;
//   final String? message;
//
//   PaytmInitResponseModel({this.success, this.data, this.message});
//
//   factory PaytmInitResponseModel.fromJson(Map<String, dynamic> json) {
//     return PaytmInitResponseModel(
//       success: json['success'],
//       data: json['data'] != null ? PaytmInitData.fromJson(json['data']) : null,
//       message: json['message'],
//     );
//   }
// }
//
// class PaytmInitData {
//   final String orderId;
//   final String mid;
//   final String? txnToken;
//   final String? callbackUrl;
//   final String? message;
//   final String? paymentSessionId; // 🟢 ADD THIS
//   final String? paymentUrl;       // 🟢 ADD THIS
//   final String? gatewayOrderId;   // 🟢 ADD THIS
//
//   PaytmInitData({
//     required this.orderId,
//     required this.mid,
//     this.txnToken,
//     this.callbackUrl,
//     this.message,
//     this.paymentSessionId,
//     this.paymentUrl,
//     this.gatewayOrderId,
//   });
//
//   factory PaytmInitData.fromJson(Map<String, dynamic> json) {
//     return PaytmInitData(
//       orderId: json['orderId'] ?? json['paymentId'] ?? json['gatewayOrderId'] ?? '',
//       mid: json['mid'] ?? '',
//       txnToken: json['txnToken'],
//       callbackUrl: json['callbackUrl'],
//       message: json['message'],
//       // 🟢 Handles both session ID and fallback from paymentUrl or txnToken
//       paymentSessionId: json['paymentSessionId'] ?? json['payment_session_id'] ?? json['txnToken'],
//       paymentUrl: json['paymentUrl'],
//       gatewayOrderId: json['gatewayOrderId'] ?? json['paymentId'],
//     );
//   }
// }

class PaytmInitRequestModel {
  final String planId;
  final String paymentMethod;
  final String customerName;
  final String? customerEmail;
  final String? customerPhone;

  PaytmInitRequestModel({
    required this.planId,
    this.paymentMethod = 'paytm',
    required this.customerName,
    this.customerEmail,
    this.customerPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      "planId": planId,
      "paymentMethod": paymentMethod,
      "customerName": customerName,
      if (customerEmail != null) "customerEmail": customerEmail,
      if (customerPhone != null) "customerPhone": customerPhone,
    };
  }
}

class PaytmInitResponseModel {
  final bool? success;
  final PaytmInitData? data;
  final String? message;

  PaytmInitResponseModel({this.success, this.data, this.message});

  factory PaytmInitResponseModel.fromJson(Map<String, dynamic> json) {
    return PaytmInitResponseModel(
      success: json['success'],
      data: json['data'] != null ? PaytmInitData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class PaytmInitData {
  final String orderId;
  final String mid;
  final String? txnToken;
  final String? callbackUrl;
  final String? message;
  final String? paymentSessionId; // 🟢 Cashfree session id
  final String? paymentUrl;       // 🟢 Hosted checkout / redirect URL
  final String? gatewayOrderId;   // 🟢 Cashfree gateway order id

  PaytmInitData({
    required this.orderId,
    required this.mid,
    this.txnToken,
    this.callbackUrl,
    this.message,
    this.paymentSessionId,
    this.paymentUrl,
    this.gatewayOrderId,
  });

  factory PaytmInitData.fromJson(Map<String, dynamic> json) {
    return PaytmInitData(
      orderId: json['orderId'] ?? json['paymentId'] ?? json['gatewayOrderId'] ?? '',
      mid: json['mid'] ?? '',
      txnToken: json['txnToken'],
      callbackUrl: json['callbackUrl'],
      message: json['message'],
      // 🟢 FIXED: sirf actual Cashfree session-id fields se lo.
      // txnToken fallback hata diya gaya hai — wo Paytm ka field hai,
      // Cashfree session id ke liye use karna galat value de sakta hai.
      paymentSessionId: json['paymentSessionId'] ?? json['payment_session_id'],
      paymentUrl: json['paymentUrl'],
      gatewayOrderId: json['gatewayOrderId'] ?? json['paymentId'],
    );
  }
}