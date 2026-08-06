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
  final bool? success;
  final String? paymentId;
  final String? gatewayOrderId;
  final String? txnToken;
  final String? paymentUrl;
  final String? message;

  PaytmInitData({
    this.success,
    this.paymentId,
    this.gatewayOrderId,
    this.txnToken,
    this.paymentUrl,
    this.message,
  });

  factory PaytmInitData.fromJson(Map<String, dynamic> json) {
    return PaytmInitData(
      success: json['success'],
      paymentId: json['paymentId'],
      gatewayOrderId: json['gatewayOrderId'],
      txnToken: json['txnToken'],
      paymentUrl: json['paymentUrl'],
      message: json['message'],
    );
  }

  // 🟢 Helper Getters to extract values directly from backend response
  String get mid {
    if (paymentUrl != null && paymentUrl!.isNotEmpty) {
      try {
        final uri = Uri.parse(paymentUrl!);
        return uri.queryParameters['mid'] ?? 'FAEClA31908078249088';
      } catch (_) {}
    }
    return 'FAEClA31908078249088';
  }

  String get orderId => gatewayOrderId ?? paymentId ?? '';

  String get callbackUrl =>
      'https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId';
}