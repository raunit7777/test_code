class AvailablePaymentModel {
  bool? success;
  Data? data;
  String? message;

  AvailablePaymentModel({this.success, this.data, this.message});

  AvailablePaymentModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  bool? cashfree;
  bool? paytm;

  Data({this.cashfree, this.paytm});

  Data.fromJson(Map<String, dynamic> json) {
    cashfree = json['cashfree'];
    paytm = json['paytm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cashfree'] = this.cashfree;
    data['paytm'] = this.paytm;
    return data;
  }
}
