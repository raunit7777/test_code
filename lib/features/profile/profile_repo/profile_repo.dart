import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/network/api_clinet.dart'; // Apna exact file path verify kar lein
import '../../../core/network/api_endpoints.dart';
import '../profile_model/all_policy.dart';
import '../profile_model/profile_model.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository(this._apiClient);

  // 🟢 Fetch Profile
  Future<ProfileModel2> getProfile() async {
    final response = await _apiClient.get(
      ApiEndpoints.profile,
    );
    return ProfileModel2.fromJson(response.data);
  }
  Future<AllPolicy> allPolicy() async {
    final String url = ApiEndpoints.allPolicy;

    print('================ 🚀 [ALL POLICY API START] ================');
    print('🌐 URL: $url');

    try {
      final response = await _apiClient.get(url);

      print('📥 Status Code: ${response.statusCode}');

      // 🟢 log() function kitna bhi bada String/JSON ho, pure response ko terminal me bina kate print karta hai
      log('📦 FULL RESPONSE DATA:\n${jsonEncode(response.data)}');

      final parsedModel = AllPolicy.fromJson(response.data);

      print('✅ AllPolicy Model Parsed Successfully!');
      print('================ 🏁 [ALL POLICY API END] ================');

      return parsedModel;
    } catch (error, stackTrace) {
      print('❌ Error in allPolicy: $error');
      log('🚨 FULL STACKTRACE:', error: error, stackTrace: stackTrace);
      print('================ 🏁 [ALL POLICY API FAILED] ================');
      rethrow;
    }
  }

  // 🟢 Update Profile (Name/Preferences — Text Data)
  Future<Response> updateProfileData(Map<String, dynamic> body) async {
    final response = await _apiClient.put(
      ApiEndpoints.profile,
      data: body,
    );
    return response;
  }

  // 🟢 Update Avatar (Multipart Image Upload — NAYA)
  Future<Response> uploadAvatar(File image) async {
    final formData = FormData.fromMap({
      "avatar": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });

    final response = await _apiClient.put(
      ApiEndpoints.profile, // ⚠️ same endpoint use kiya, neeche note dekho
      data: formData,
    );
    return response;
  }
}