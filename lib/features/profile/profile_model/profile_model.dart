// -----------------------------------------------------------------------------
// Pure Manual ProfileModel2 (No .g.dart or Generator Required)
// -----------------------------------------------------------------------------

class ProfileModel2 {
  final bool? success;
  final Data? data;
  final String? message;

  ProfileModel2({
    this.success,
    this.data,
    this.message,
  });

  factory ProfileModel2.fromJson(Map<String, dynamic> json) {
    return ProfileModel2(
      success: json['success'] as bool?,
      data: json['data'] != null
          ? Data.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class Data {
  final Preferences? preferences;
  final String? sId;
  final String? mobileNumber;
  final String? name;
  final String? role;
  final bool? isAnonymous;
  final String? lastActiveAt;
  final String? createdAt;
  final String? updatedAt;
  final int? iV;

  Data({
    this.preferences,
    this.sId,
    this.mobileNumber,
    this.name,
    this.role,
    this.isAnonymous,
    this.lastActiveAt,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      preferences: json['preferences'] != null
          ? Preferences.fromJson(json['preferences'] as Map<String, dynamic>)
          : null,
      sId: json['_id'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      name: json['name'] as String?,
      role: json['role'] as String?,
      isAnonymous: json['isAnonymous'] as bool?,
      lastActiveAt: json['lastActiveAt'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      iV: (json['__v'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferences': preferences?.toJson(),
      '_id': sId,
      'mobileNumber': mobileNumber,
      'name': name,
      'role': role,
      'isAnonymous': isAnonymous,
      'lastActiveAt': lastActiveAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
    };
  }
}

class Preferences {
  final String? language;
  final bool? notifications;
  final int? maxDailyNotifications;

  Preferences({
    this.language,
    this.notifications,
    this.maxDailyNotifications,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      language: json['language'] as String?,
      notifications: json['notifications'] as bool?,
      maxDailyNotifications: (json['maxDailyNotifications'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'notifications': notifications,
      'maxDailyNotifications': maxDailyNotifications,
    };
  }
}