class VibeModel {
  bool? success;
  Data? data;
  String? message;

  VibeModel({this.success, this.data, this.message});

  VibeModel.fromJson(Map<String, dynamic> json) {
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
  List<Vibes>? vibes;
  int? total;

  Data({this.vibes, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['vibes'] != null) {
      vibes = <Vibes>[];
      json['vibes'].forEach((v) {
        vibes!.add(new Vibes.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vibes != null) {
      data['vibes'] = this.vibes!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Vibes {
  bool? isSubscriptionRequired;
  String? sId;
  String? name;
  String? image;
  String? description;
  bool? isActive;
  bool? isPinned;
  int? sortOrder;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isSubscribe;
  bool? isShown;

  Vibes(
      {this.isSubscriptionRequired,
        this.sId,
        this.name,
        this.image,
        this.description,
        this.isActive,
        this.isPinned,
        this.sortOrder,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.isSubscribe,
        this.isShown});

  Vibes.fromJson(Map<String, dynamic> json) {
    isSubscriptionRequired = json['isSubscriptionRequired'];
    sId = json['_id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    isActive = json['isActive'];
    isPinned = json['isPinned'];
    sortOrder = json['sortOrder'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isSubscribe = json['isSubscribe'];
    isShown = json['isShown'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSubscriptionRequired'] = this.isSubscriptionRequired;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['isPinned'] = this.isPinned;
    data['sortOrder'] = this.sortOrder;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['isSubscribe'] = this.isSubscribe;
    data['isShown'] = this.isShown;
    return data;
  }
}
