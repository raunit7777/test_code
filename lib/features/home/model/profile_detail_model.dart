class ProfileDeatilModel {
  bool? success;
  Data? data;
  String? message;

  ProfileDeatilModel({this.success, this.data, this.message});

  ProfileDeatilModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? name;
  int? age;
  String? location;
  String? aboutMe;
  List<String>? personalityTraits;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? image;
  String? imagePublicId;

  Data(
      {this.sId,
        this.name,
        this.age,
        this.location,
        this.aboutMe,
        this.personalityTraits,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.image,
        this.imagePublicId});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    age = json['age'];
    location = json['location'];
    aboutMe = json['aboutMe'];
    personalityTraits = json['personalityTraits'].cast<String>();
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    image = json['image'];
    imagePublicId = json['imagePublicId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['age'] = this.age;
    data['location'] = this.location;
    data['aboutMe'] = this.aboutMe;
    data['personalityTraits'] = this.personalityTraits;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['image'] = this.image;
    data['imagePublicId'] = this.imagePublicId;
    return data;
  }
}
