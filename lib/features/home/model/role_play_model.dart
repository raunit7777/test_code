class RolePlayModel {
  bool? success;
  Data? data;
  String? message;

  RolePlayModel({this.success, this.data, this.message});

  RolePlayModel.fromJson(Map<String, dynamic> json) {
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
  List<Roleplays>? roleplays;
  int? total;
  dynamic isSubscriber; // 👈 Global status check

  Data({this.roleplays, this.total, this.isSubscriber});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['roleplays'] != null) {
      roleplays = <Roleplays>[];
      json['roleplays'].forEach((v) {
        roleplays!.add(Roleplays.fromJson(v));
      });
    }
    total = json['total'];
    isSubscriber = json['isSubscriber'] ?? json['isSubscribed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (roleplays != null) {
      data['roleplays'] = roleplays!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['isSubscriber'] = isSubscriber;
    return data;
  }
}

class Roleplays {
  String? sId;
  String? name;
  String? role;
  List<String>? personalityTraits;
  String? storyIntro;
  String? aiRole;
  String? userRole;
  String? image;
  String? accessType;
  int? isSubscribed; // 👈 1 = Unlocked, 0/null = Locked

  Roleplays({
    this.sId,
    this.name,
    this.role,
    this.personalityTraits,
    this.storyIntro,
    this.aiRole,
    this.userRole,
    this.image,
    this.accessType,
    this.isSubscribed,
  });

  Roleplays.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    role = json['role'];

    // 🛡️ Safe List Parsing (Crash Prevention)
    if (json['personalityTraits'] != null) {
      personalityTraits = List<String>.from(json['personalityTraits']);
    } else {
      personalityTraits = [];
    }

    storyIntro = json['storyIntro'];
    aiRole = json['aiRole'];
    userRole = json['userRole'];
    image = json['image'];
    accessType = json['accessType'];
    isSubscribed = json['isSubscribed'] ?? json['isSubscriber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['role'] = role;
    data['personalityTraits'] = personalityTraits;
    data['storyIntro'] = storyIntro;
    data['aiRole'] = aiRole;
    data['userRole'] = userRole;
    data['image'] = image;
    data['accessType'] = accessType;
    data['isSubscribed'] = isSubscribed;
    return data;
  }
}