class FeatureModel {
  bool? success;
  Data? data;
  String? message;

  FeatureModel({this.success, this.data, this.message});

  FeatureModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  List<Characters>? characters;
  int? total;

  Data({this.characters, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['characters'] != null) {
      characters = <Characters>[];
      json['characters'].forEach((v) {
        characters!.add(Characters.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (characters != null) {
      data['characters'] = characters!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    return data;
  }
}

class Characters {
  String? sId;
  String? name;
  int? age;
  String? location;
  List<String>? personalityTraits;
  String? image;
  String? accessType;
  int? isSubscribed;

  Characters(
      {this.sId,
        this.name,
        this.age,
        this.location,
        this.personalityTraits,
        this.image,
        this.accessType,
        this.isSubscribed});

  Characters.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    age = json['age'];
    location = json['location'];
    personalityTraits = json['personalityTraits'].cast<String>();
    image = json['image'];
    accessType = json['accessType'];
    isSubscribed = json['isSubscribed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['age'] = age;
    data['location'] = location;
    data['personalityTraits'] = personalityTraits;
    data['image'] = image;
    data['accessType'] = accessType;
    data['isSubscribed'] = isSubscribed;
    return data;
  }
}
