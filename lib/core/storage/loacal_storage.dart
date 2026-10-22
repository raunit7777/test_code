import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/hive_keys.dart';
import '../constants/storage_keys.dart';

/// Secure token storage backed by Android Keystore and iOS Keychain via FlutterSecureStorage.
/// Non-sensitive settings (like themeColor) remain in Hive.
class LocalStorage {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // In-memory cache for fast synchronous access
  static String? _cachedToken;
  static String? _cachedRefreshToken;
  static String? _cachedUserId;
  static bool _initialized = false;

  /// Initializes secure storage, performs migration from legacy Hive boxes if needed,
  /// and warms up the in-memory cache.
  static Future<void> init() async {
    if (_initialized) return;

    try {
      // 1. Read tokens from secure storage
      _cachedToken = await _secureStorage.read(key: StorageKeys.token);
      _cachedRefreshToken = await _secureStorage.read(key: StorageKeys.refreshToken);
      _cachedUserId = await _secureStorage.read(key: StorageKeys.userId);

      // 2. Migration from legacy unencrypted Hive box if needed
      await _migrateFromHiveIfNeeded();

      _initialized = true;
    } catch (e) {
      // Defensive fallback: If secure storage fails, attempt recovery from Hive
      await _migrateFromHiveIfNeeded();
      _initialized = true;
    }
  }

  /// Migrates legacy plaintext tokens from Hive settings box to FlutterSecureStorage.
  /// After copying to secure storage, plaintext tokens are deleted from the Hive box.
  static Future<void> _migrateFromHiveIfNeeded() async {
    try {
      if (!Hive.isBoxOpen(HiveKeys.settingsBox)) {
        await Hive.openBox(HiveKeys.settingsBox);
      }
      final box = Hive.box(HiveKeys.settingsBox);

      final legacyToken = box.get(StorageKeys.token)?.toString();
      final legacyRefreshToken = box.get(StorageKeys.refreshToken)?.toString();
      final legacyUserId = box.get(StorageKeys.userId)?.toString();

      bool migrated = false;

      if ((_cachedToken == null || _cachedToken!.isEmpty) &&
          legacyToken != null &&
          legacyToken.isNotEmpty) {
        _cachedToken = legacyToken;
        await _secureStorage.write(key: StorageKeys.token, value: legacyToken);
        migrated = true;
      }

      if ((_cachedRefreshToken == null || _cachedRefreshToken!.isEmpty) &&
          legacyRefreshToken != null &&
          legacyRefreshToken.isNotEmpty) {
        _cachedRefreshToken = legacyRefreshToken;
        await _secureStorage.write(key: StorageKeys.refreshToken, value: legacyRefreshToken);
        migrated = true;
      }

      if ((_cachedUserId == null || _cachedUserId!.isEmpty) &&
          legacyUserId != null &&
          legacyUserId.isNotEmpty) {
        _cachedUserId = legacyUserId;
        await _secureStorage.write(key: StorageKeys.userId, value: legacyUserId);
        migrated = true;
      }

      // Purge plaintext tokens from unencrypted Hive box
      if (box.containsKey(StorageKeys.token)) {
        await box.delete(StorageKeys.token);
      }
      if (box.containsKey(StorageKeys.refreshToken)) {
        await box.delete(StorageKeys.refreshToken);
      }
      if (box.containsKey(StorageKeys.userId)) {
        await box.delete(StorageKeys.userId);
      }

      if (migrated) {
        debugPrint('🔒 [LocalStorage] Successfully migrated auth tokens from Hive to SecureStorage.');
      }
    } catch (e) {
      debugPrint('⚠️ [LocalStorage] Token migration warning: $e');
    }
  }

  /// Save Auth Tokens & User ID securely into Android Keystore / iOS Keychain.
  static Future<void> saveAuthData({
    required String token,
    required String refreshToken,
    String? userId,
  }) async {
    _cachedToken = token;
    _cachedRefreshToken = refreshToken;
    _cachedUserId = userId;

    await _secureStorage.write(key: StorageKeys.token, value: token);
    await _secureStorage.write(key: StorageKeys.refreshToken, value: refreshToken);

    if (userId != null && userId.isNotEmpty) {
      await _secureStorage.write(key: StorageKeys.userId, value: userId);
    } else {
      await _secureStorage.delete(key: StorageKeys.userId);
    }

    // Ensure Hive box has no sensitive plaintext copies
    try {
      if (Hive.isBoxOpen(HiveKeys.settingsBox)) {
        final box = Hive.box(HiveKeys.settingsBox);
        await box.delete(StorageKeys.token);
        await box.delete(StorageKeys.refreshToken);
        await box.delete(StorageKeys.userId);
      }
    } catch (_) {}
  }

  /// Synchronously retrieve cached Access Token.
  static String? getToken() {
    return _cachedToken;
  }

  /// Asynchronously retrieve Access Token from secure storage.
  static Future<String?> getSecureToken() async {
    _cachedToken = await _secureStorage.read(key: StorageKeys.token);
    return _cachedToken;
  }

  /// Synchronously retrieve cached Refresh Token.
  static String? getRefreshToken() {
    return _cachedRefreshToken;
  }

  /// Asynchronously retrieve Refresh Token from secure storage.
  static Future<String?> getSecureRefreshToken() async {
    _cachedRefreshToken = await _secureStorage.read(key: StorageKeys.refreshToken);
    return _cachedRefreshToken;
  }

  /// Synchronously retrieve cached User ID.
  static String? getUserId() {
    return _cachedUserId;
  }

  /// Asynchronously retrieve User ID from secure storage.
  static Future<String?> getSecureUserId() async {
    _cachedUserId = await _secureStorage.read(key: StorageKeys.userId);
    return _cachedUserId;
  }

  // --- Non-sensitive UI preferences stored in Hive ---

  static Future<void> saveThemeColor(int colorValue) async {
    if (!Hive.isBoxOpen(HiveKeys.settingsBox)) {
      await Hive.openBox(HiveKeys.settingsBox);
    }
    final box = Hive.box(HiveKeys.settingsBox);
    await box.put(StorageKeys.themeColor, colorValue);
  }

  static Color? getThemeColor() {
    try {
      if (!Hive.isBoxOpen(HiveKeys.settingsBox)) {
        return null;
      }
      final box = Hive.box(HiveKeys.settingsBox);
      final int? colorInt = box.get(StorageKeys.themeColor);
      if (colorInt != null) {
        return Color(colorInt);
      }
    } catch (_) {}
    return null;
  }

  /// Clear all secure storage and cached authentication state on Logout.
  static Future<void> clear() async {
    _cachedToken = null;
    _cachedRefreshToken = null;
    _cachedUserId = null;

    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      debugPrint('⚠️ [LocalStorage] SecureStorage delete warning: $e');
    }

    try {
      if (Hive.isBoxOpen(HiveKeys.settingsBox)) {
        final box = Hive.box(HiveKeys.settingsBox);
        await box.delete(StorageKeys.token);
        await box.delete(StorageKeys.refreshToken);
        await box.delete(StorageKeys.userId);
      }
    } catch (_) {}
  }
}
