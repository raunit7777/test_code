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
  TraitConfig? traitConfig;
  String? sId;
  String? name;
  int? age;
  String? image;
  String? imagePublicId;
  String? location;
  String? aboutMe;
  List<String>? personalityTraits;
  String? accessType;
  bool? allowCustomTraits;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.traitConfig,
        this.sId,
        this.name,
        this.age,
        this.image,
        this.imagePublicId,
        this.location,
        this.aboutMe,
        this.personalityTraits,
        this.accessType,
        this.allowCustomTraits,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    traitConfig = json['traitConfig'] != null
        ? new TraitConfig.fromJson(json['traitConfig'])
        : null;
    sId = json['_id'];
    name = json['name'];
    age = json['age'];
    image = json['image'];
    imagePublicId = json['imagePublicId'];
    location = json['location'];
    aboutMe = json['aboutMe'];
    personalityTraits = json['personalityTraits'].cast<String>();
    accessType = json['accessType'];
    allowCustomTraits = json['allowCustomTraits'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.traitConfig != null) {
      data['traitConfig'] = this.traitConfig!.toJson();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['age'] = this.age;
    data['image'] = this.image;
    data['imagePublicId'] = this.imagePublicId;
    data['location'] = this.location;
    data['aboutMe'] = this.aboutMe;
    data['personalityTraits'] = this.personalityTraits;
    data['accessType'] = this.accessType;
    data['allowCustomTraits'] = this.allowCustomTraits;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class TraitConfig {
  List<Sliders>? sliders;
  int? maxAdditionalTraits;

  TraitConfig({this.sliders, this.maxAdditionalTraits});

  TraitConfig.fromJson(Map<String, dynamic> json) {
    if (json['sliders'] != null) {
      sliders = <Sliders>[];
      json['sliders'].forEach((v) {
        sliders!.add(new Sliders.fromJson(v));
      });
    }
    maxAdditionalTraits = json['maxAdditionalTraits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sliders != null) {
      data['sliders'] = this.sliders!.map((v) => v.toJson()).toList();
    }
    data['maxAdditionalTraits'] = this.maxAdditionalTraits;
    return data;
  }
}

class Sliders {
  String? traitId;
  int? defaultValue;
  String? sId;

  Sliders({this.traitId, this.defaultValue, this.sId});

  Sliders.fromJson(Map<String, dynamic> json) {
    traitId = json['traitId'];
    defaultValue = json['defaultValue'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['traitId'] = this.traitId;
    data['defaultValue'] = this.defaultValue;
    data['_id'] = this.sId;
    return data;
  }
}
