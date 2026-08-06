class RolePlayDetailsModel {
  bool? success;
  Data? data;
  String? message;

  RolePlayDetailsModel({this.success, this.data, this.message});

  RolePlayDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? role;
  List<String>? personalityTraits;
  String? storyIntro;
  String? aiRole;
  String? userRole;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? image;
  String? imagePublicId;

  Data(
      {this.sId,
        this.name,
        this.role,
        this.personalityTraits,
        this.storyIntro,
        this.aiRole,
        this.userRole,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.image,
        this.imagePublicId});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    role = json['role'];
    personalityTraits = json['personalityTraits'].cast<String>();
    storyIntro = json['storyIntro'];
    aiRole = json['aiRole'];
    userRole = json['userRole'];
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
    data['role'] = this.role;
    data['personalityTraits'] = this.personalityTraits;
    data['storyIntro'] = this.storyIntro;
    data['aiRole'] = this.aiRole;
    data['userRole'] = this.userRole;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['image'] = this.image;
    data['imagePublicId'] = this.imagePublicId;
    return data;
  }
}
