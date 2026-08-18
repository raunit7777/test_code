class AlarmModel {
  bool? success;
  Data? data;
  String? message;

  AlarmModel({this.success, this.data, this.message});

  AlarmModel.fromJson(Map<String, dynamic> json) {
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
  List<Items>? items;
  Pagination? pagination;

  Data({this.items, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Items {
  String? sId;
  String? userId;
  List<String>? days;
  String? time;
  String? message;
  String? timezone;
  String? nextRunAt;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Items(
      {this.sId,
        this.userId,
        this.days,
        this.time,
        this.message,
        this.timezone,
        this.nextRunAt,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Items.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    days = json['days'].cast<String>();
    time = json['time'];
    message = json['message'];
    timezone = json['timezone'];
    nextRunAt = json['nextRunAt'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['days'] = this.days;
    data['time'] = this.time;
    data['message'] = this.message;
    data['timezone'] = this.timezone;
    data['nextRunAt'] = this.nextRunAt;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Pagination {
  int? total;
  int? page;
  int? limit;

  Pagination({this.total, this.page, this.limit});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    return data;
  }
}
