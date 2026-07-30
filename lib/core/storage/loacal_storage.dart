import 'package:hive_flutter/hive_flutter.dart';

import '../constants/hive_keys.dart';
import '../constants/storage_keys.dart';


class LocalStorage {
  static Future<void> saveUserId(dynamic userId) async {
    if (userId == null) return;
    final box = Hive.box(HiveKeys.settingsBox);
    await box.put(StorageKeys.userId, userId.toString());
  }

  static String? getUserId() {
    final box = Hive.box(HiveKeys.settingsBox);
    return box.get(StorageKeys.userId);
  }

  static Future<void> clear() async {
    final box = Hive.box(HiveKeys.settingsBox);
    await box.clear();
  }
}