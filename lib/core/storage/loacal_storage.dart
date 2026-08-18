// import 'package:flutter/cupertino.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import '../constants/hive_keys.dart';
// import '../constants/storage_keys.dart';
//
// class LocalStorage {
//   // Save Tokens & User Data
//   static Future<void> saveAuthData({
//     required String token,
//     required String refreshToken,
//     String? userId,
//   }) async {
//     final box = Hive.box(HiveKeys.settingsBox);
//     await box.put(StorageKeys.token, token);
//     await box.put(StorageKeys.refreshToken, refreshToken);
//     if (userId != null) {
//       await box.put(StorageKeys.userId, userId.toString());
//     }
//   }
//
//   // Get Access Token
//   static String? getToken() {
//     final box = Hive.box(HiveKeys.settingsBox);
//     final token = box.get(StorageKeys.token);
//
//     debugPrint('🔑 [LocalStorage] Retrieved Token: $token');
//
//     return token;
//   }
//
//   // Get Refresh Token
//   static String? getRefreshToken() {
//     final box = Hive.box(HiveKeys.settingsBox);
//     return box.get(StorageKeys.refreshToken);
//   }
//
//   // Get User ID
//   static String? getUserId() {
//     final box = Hive.box(HiveKeys.settingsBox);
//     return box.get(StorageKeys.userId);
//   }
//
//   // Clear Storage on Logout
//   static Future<void> clear() async {
//     final box = Hive.box(HiveKeys.settingsBox);
//     await box.clear();
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/hive_keys.dart';
import '../constants/storage_keys.dart';

class LocalStorage {
  // Save Tokens & User Data
  static Future<void> saveAuthData({
    required String token,
    required String refreshToken,
    String? userId,
  }) async {
    final box = Hive.box(HiveKeys.settingsBox);
    await box.put(StorageKeys.token, token);
    await box.put(StorageKeys.refreshToken, refreshToken);
    if (userId != null) {
      await box.put(StorageKeys.userId, userId.toString());
    }
  }

  // Get Access Token
  static String? getToken() {
    final box = Hive.box(HiveKeys.settingsBox);
    final token = box.get(StorageKeys.token);
    debugPrint('🔑 [LocalStorage] Retrieved Token: $token');
    return token;
  }

  // Get Refresh Token
  static String? getRefreshToken() {
    final box = Hive.box(HiveKeys.settingsBox);
    return box.get(StorageKeys.refreshToken);
  }

  // Get User ID
  static String? getUserId() {
    final box = Hive.box(HiveKeys.settingsBox);
    return box.get(StorageKeys.userId);
  }


  static Future<void> saveThemeColor(int colorValue) async {
    final box = Hive.box(HiveKeys.settingsBox);
    await box.put(StorageKeys.themeColor, colorValue);
  }

  // 🟢 Get Theme Color (Returns null if not saved yet)
  static Color? getThemeColor() {
    final box = Hive.box(HiveKeys.settingsBox);
    final int? colorInt = box.get(StorageKeys.themeColor);
    if (colorInt != null) {
      return Color(colorInt);
    }
    return null;
  }

  // Clear Storage on Logout
  static Future<void> clear() async {
    final box = Hive.box(HiveKeys.settingsBox);
    await box.clear();
  }
}