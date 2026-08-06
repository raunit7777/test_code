class SubcriptionModel {
  bool? success;
  List<Data>? data;
  String? message;

  SubcriptionModel({this.success, this.data, this.message});

  SubcriptionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? sId;
  String? name;
  String? description;
  int? price;
  String? currency;
  int? durationDays;
  int? dailyMessageLimit;
  List<String>? features;
  bool? isActive;
  bool? isDefault;
  int? sortOrder;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
        this.name,
        this.description,
        this.price,
        this.currency,
        this.durationDays,
        this.dailyMessageLimit,
        this.features,
        this.isActive,
        this.isDefault,
        this.sortOrder,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    currency = json['currency'];
    durationDays = json['durationDays'];
    dailyMessageLimit = json['dailyMessageLimit'];
    features = json['features'].cast<String>();
    isActive = json['isActive'];
    isDefault = json['isDefault'];
    sortOrder = json['sortOrder'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['currency'] = this.currency;
    data['durationDays'] = this.durationDays;
    data['dailyMessageLimit'] = this.dailyMessageLimit;
    data['features'] = this.features;
    data['isActive'] = this.isActive;
    data['isDefault'] = this.isDefault;
    data['sortOrder'] = this.sortOrder;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
