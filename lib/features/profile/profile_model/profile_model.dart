class ProfileModel2 {
  bool? success;
  Data? data;
  String? message;

  ProfileModel2({this.success, this.data, this.message});

  ProfileModel2.fromJson(Map<String, dynamic> json) {
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
  Preferences? preferences;
  String? sId;
  String? mobileNumber;
  String? name;
  String? role;
  bool? isAnonymous;
  bool? isSubscribed;
  String? subscriptionType;
  String? lastActiveAt;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? avatar;

  Data(
      {this.preferences,
        this.sId,
        this.mobileNumber,
        this.name,
        this.role,
        this.isAnonymous,
        this.isSubscribed,
        this.subscriptionType,
        this.lastActiveAt,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.avatar});

  Data.fromJson(Map<String, dynamic> json) {
    preferences = json['preferences'] != null
        ? new Preferences.fromJson(json['preferences'])
        : null;
    sId = json['_id'];
    mobileNumber = json['mobileNumber'];
    name = json['name'];
    role = json['role'];
    isAnonymous = json['isAnonymous'];
    isSubscribed = json['isSubscribed'];
    subscriptionType = json['subscriptionType'];
    lastActiveAt = json['lastActiveAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.preferences != null) {
      data['preferences'] = this.preferences!.toJson();
    }
    data['_id'] = this.sId;
    data['mobileNumber'] = this.mobileNumber;
    data['name'] = this.name;
    data['role'] = this.role;
    data['isAnonymous'] = this.isAnonymous;
    data['isSubscribed'] = this.isSubscribed;
    data['subscriptionType'] = this.subscriptionType;
    data['lastActiveAt'] = this.lastActiveAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['avatar'] = this.avatar;
    return data;
  }
}

class Preferences {
  String? language;
  bool? notifications;
  int? maxDailyNotifications;

  Preferences({this.language, this.notifications, this.maxDailyNotifications});

  Preferences.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    notifications = json['notifications'];
    maxDailyNotifications = json['maxDailyNotifications'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['language'] = this.language;
    data['notifications'] = this.notifications;
    data['maxDailyNotifications'] = this.maxDailyNotifications;
    return data;
  }
}
