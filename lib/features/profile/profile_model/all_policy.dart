class AllPolicy {
  bool? success;
  List<Data>? data;
  String? message;

  AllPolicy({this.success, this.data, this.message});

  AllPolicy.fromJson(Map<String, dynamic> json) {
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
  String? pageType;
  String? title;
  String? content;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? supportEmail;

  Data(
      {this.sId,
        this.pageType,
        this.title,
        this.content,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.supportEmail});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    pageType = json['pageType'];
    title = json['title'];
    content = json['content'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    supportEmail = json['supportEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['pageType'] = this.pageType;
    data['title'] = this.title;
    data['content'] = this.content;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['supportEmail'] = this.supportEmail;
    return data;
  }
}
