// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import '../../../core/di/service_locator.dart';
// import '../profile_model/all_policy.dart';
// import '../profile_model/profile_model.dart';
// import '../profile_repo/profile_repo.dart';
//
// // 👤 Profile Provider (User Data state)
// final profileProvider =
// StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileModel2?>>((ref) {
//   return ProfileNotifier(sl<ProfileRepository>());
// });
//
// // 📜 Policy Provider (AllPolicy Data state - Prevents state conflict!)
// final policyProvider =
// StateNotifierProvider<PolicyNotifier, AsyncValue<AllPolicy?>>((ref) {
//   return PolicyNotifier(sl<ProfileRepository>());
// });
//
// class ProfileNotifier extends StateNotifier<AsyncValue<ProfileModel2?>> {
//   final ProfileRepository _repository;
//
//   ProfileNotifier(this._repository) : super(const AsyncValue.data(null));
//
//   // 🟢 1. Fetch User Profile
//   Future<void> fetchProfile() async {
//     state = const AsyncValue.loading();
//     try {
//       final response = await _repository.getProfile();
//       state = AsyncValue.data(response);
//     } catch (e, stack) {
//       debugPrint('❌ Fetch Profile Error: $e');
//       state = AsyncValue.error(e, stack);
//     }
//   }
//
//   // 🟢 2. Update Profile Method
//   Future<bool> updateProfile({
//     required String name,
//     String avatar = "",
//     Map<String, dynamic>? preferences,
//     void Function(String message)? onSuccess,
//     void Function(String errorMessage)? onError,
//   }) async {
//     final previousState = state;
//     state = const AsyncValue.loading();
//
//     try {
//       final Map<String, dynamic> payload = {
//         "name": name,
//         if (avatar.isNotEmpty) "avatar": avatar,
//         if (preferences != null) "preferences": preferences,
//       };
//
//       debugPrint('🚀 Updating Profile with Payload: $payload');
//
//       final response = await _repository.updateProfileData(payload);
//
//       final int statusCode = response.statusCode ?? 0;
//       debugPrint('📥 Update Profile Status Code: $statusCode');
//
//       if (statusCode == 200 || statusCode == 201) {
//         final String successMsg =
//             response.data?['message']?.toString() ?? "Profile updated successfully!";
//         onSuccess?.call(successMsg);
//         await fetchProfile();
//         return true;
//       } else {
//         final String errorMsg =
//             response.data?['message']?.toString() ?? "Failed to update profile ($statusCode)";
//         state = previousState;
//         onError?.call(errorMsg);
//         return false;
//       }
//     } catch (e, stack) {
//       debugPrint('❌ Update Profile Exception: $e');
//       state = previousState;
//
//       final String errorMsg = e.toString().contains('DioException')
//           ? "Network error while updating profile"
//           : e.toString();
//
//       onError?.call(errorMsg);
//       return false;
//     }
//   }
//
//   // 🟢 3. Update Avatar Method
//   Future<bool> updateAvatar({
//     required File image,
//     void Function(String message)? onSuccess,
//     void Function(String errorMessage)? onError,
//   }) async {
//     final previousState = state;
//
//     try {
//       debugPrint('🚀 Uploading Avatar File: ${image.path}');
//
//       final response = await _repository.uploadAvatar(image);
//
//       final int statusCode = response.statusCode ?? 0;
//       debugPrint('📥 Upload Avatar Status Code: $statusCode');
//
//       if (statusCode == 200 || statusCode == 201) {
//         final String successMsg =
//             response.data?['message']?.toString() ?? "Avatar updated successfully!";
//         onSuccess?.call(successMsg);
//         await fetchProfile();
//         return true;
//       } else {
//         final String errorMsg =
//             response.data?['message']?.toString() ?? "Failed to update avatar ($statusCode)";
//         state = previousState;
//         onError?.call(errorMsg);
//         return false;
//       }
//     } catch (e, stack) {
//       debugPrint('❌ Update Avatar Exception: $e');
//       state = previousState;
//
//       final String errorMsg = e.toString().contains('DioException')
//           ? "Network error while uploading avatar"
//           : e.toString();
//
//       onError?.call(errorMsg);
//       return false;
//     }
//   }
// }
//
// // 📜 Dedicated Policy Notifier
// class PolicyNotifier extends StateNotifier<AsyncValue<AllPolicy?>> {
//   final ProfileRepository _repository;
//
//   PolicyNotifier(this._repository) : super(const AsyncValue.data(null));
//
//   Future<void> term() async {
//     state = const AsyncValue.loading();
//     try {
//       final response = await _repository.allPolicy();
//       state = AsyncValue.data(response);
//     } catch (e, stack) {
//       debugPrint('❌ Fetch Policy Error: $e');
//       state = AsyncValue.error(e, stack);
//     }
//   }
// }

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/di/service_locator.dart';
import '../profile_model/all_policy.dart';
import '../profile_model/profile_model.dart';
import '../profile_repo/profile_repo.dart';

// 👤 Profile Provider (User Data state)
final profileProvider =
StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileModel2?>>((ref) {
  return ProfileNotifier(sl<ProfileRepository>());
});

// 📜 Policy Provider (AllPolicy Data state)
final policyProvider =
StateNotifierProvider<PolicyNotifier, AsyncValue<AllPolicy?>>((ref) {
  return PolicyNotifier(sl<ProfileRepository>());
});

class ProfileNotifier extends StateNotifier<AsyncValue<ProfileModel2?>> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(const AsyncValue.data(null));

  // 🟢 1. Fetch User Profile
  Future<void> fetchProfile() async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.getProfile();
      state = AsyncValue.data(response);
    } catch (e, stack) {
      debugPrint('❌ Fetch Profile Error: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  // 🟢 2. Update Profile Method
  Future<bool> updateProfile({
    required String name,
    String avatar = "",
    Map<String, dynamic>? preferences,
    void Function(String message)? onSuccess,
    void Function(String errorMessage)? onError,
  }) async {
    final previousState = state;
    state = const AsyncValue.loading();

    try {
      final Map<String, dynamic> payload = {
        "name": name,
        if (avatar.isNotEmpty) "avatar": avatar,
        if (preferences != null) "preferences": preferences,
      };

      debugPrint('🚀 Updating Profile with Payload: $payload');

      final response = await _repository.updateProfileData(payload);

      final int statusCode = response.statusCode ?? 0;
      debugPrint('📥 Update Profile Status Code: $statusCode');

      if (statusCode == 200 || statusCode == 201) {
        final String successMsg =
            response.data?['message']?.toString() ?? "Profile updated successfully!";
        onSuccess?.call(successMsg);
        await fetchProfile();
        return true;
      } else {
        final String errorMsg =
            response.data?['message']?.toString() ?? "Failed to update profile ($statusCode)";
        state = previousState;
        onError?.call(errorMsg);
        return false;
      }
    } catch (e, stack) {
      debugPrint('❌ Update Profile Exception: $e');
      state = previousState;

      final String errorMsg = e.toString().contains('DioException')
          ? "Network error while updating profile"
          : e.toString();

      onError?.call(errorMsg);
      return false;
    }
  }

  // 🟢 3. Update Avatar Method
  Future<bool> updateAvatar({
    required File image,
    void Function(String message)? onSuccess,
    void Function(String errorMessage)? onError,
  }) async {
    final previousState = state;

    try {
      debugPrint('🚀 Uploading Avatar File: ${image.path}');

      final response = await _repository.uploadAvatar(image);

      final int statusCode = response.statusCode ?? 0;
      debugPrint('📥 Upload Avatar Status Code: $statusCode');

      if (statusCode == 200 || statusCode == 201) {
        final String successMsg =
            response.data?['message']?.toString() ?? "Avatar updated successfully!";
        onSuccess?.call(successMsg);
        await fetchProfile();
        return true;
      } else {
        final String errorMsg =
            response.data?['message']?.toString() ?? "Failed to update avatar ($statusCode)";
        state = previousState;
        onError?.call(errorMsg);
        return false;
      }
    } catch (e, stack) {
      debugPrint('❌ Update Avatar Exception: $e');
      state = previousState;

      final String errorMsg = e.toString().contains('DioException')
          ? "Network error while uploading avatar"
          : e.toString();

      onError?.call(errorMsg);
      return false;
    }
  }
}

// 📜 Dedicated Policy Notifier
class PolicyNotifier extends StateNotifier<AsyncValue<AllPolicy?>> {
  final ProfileRepository _repository;

  PolicyNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> term() async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.allPolicy();
      state = AsyncValue.data(response);
    } catch (e, stack) {
      debugPrint('❌ Fetch Policy Error: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  // 🟢 Direct Fetch & Return Policy Model for Splash/Version Check
  Future<AllPolicy?> fetchPolicyData() async {
    try {
      final response = await _repository.allPolicy();
      state = AsyncValue.data(response);
      return response;
    } catch (e, stack) {
      debugPrint('❌ Fetch Policy Data Error: $e');
      state = AsyncValue.error(e, stack);
      return null;
    }
  }
}