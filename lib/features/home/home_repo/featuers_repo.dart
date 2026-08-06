import 'package:flutter/cupertino.dart';

import '../../../core/network/api_clinet.dart'; // File path check kar lein (api_client.dart)
import '../../../core/network/api_endpoints.dart';
import '../model/conversation_model.dart';
import '../model/featurs_model.dart';
import '../model/profile_detail_model.dart';
import '../model/role_play_deatails.dart';
import '../model/role_play_model.dart';


class FeatuerRepository {
  final ApiClient _apiClient;

  FeatuerRepository(this._apiClient);

  // ✅ ProfileModel2 return type & ProfileRepository name
  Future<FeatureModel> getProfile() async {
    final response = await _apiClient.get(
      ApiEndpoints.modelList,
    );
    return FeatureModel.fromJson(response.data);
  }



  Future<ConversationModel> getConversationList() async {
    debugPrint('🚀 [GET ConversationList] Fetching from: ${ApiEndpoints.conversationList}');

    try {
      final response = await _apiClient.get(
        ApiEndpoints.conversationList,
      );

      debugPrint('📥 [GET ConversationList] Status Code: ${response.statusCode}');
      debugPrint('📦 [GET@@@ ConversationList] Raw Response: ${response.data}');

      final parsedModel = ConversationModel.fromJson(response.data);
      debugPrint('✅ [GET ConversationList] Successfully parsed ConversationModel');

      return parsedModel;
    } catch (error, stackTrace) {
      debugPrint('❌ [GET ConversationList Error]: $error');
      debugPrint('🚨 [GET ConversationList StackTrace]: $stackTrace');
      rethrow;
    }
  }
  Future<RolePlayModel> getRolePlay() async {
    final response = await _apiClient.get(
      ApiEndpoints.roleModelList,
    );
    return RolePlayModel.fromJson(response.data);
  }
// 1. Function me userId parameter add karein
  Future<ProfileDeatilModel> getProfileDetails(String userId) async {
    final response = await _apiClient.get(
      // Path parameter: URL ke end me ID combine ho jayegi
      '${ApiEndpoints.modelDetails}/$userId',
    );
    return ProfileDeatilModel.fromJson(response.data);
  }
  Future<RolePlayDetailsModel> getProfileRoleModel(String userId) async {
    print('================ 🚀 [GET PROFILE ROLE MODEL STARTED] ================');
    print('👉 [1] User ID Passed: $userId');

    final String fullUrl = '${ApiEndpoints.roleModelDetails}/$userId';
    print('👉 [2] Target Endpoint URL: $fullUrl');

    try {
      print('⌛ [3] Sending GET Request via ApiClient...');

      final response = await _apiClient.get(fullUrl);

      print('✅ [4] Response Received Successfully!');
      print('📊 [5] Status Code: ${response.statusCode}');
      print('📦 [6] Raw Response Data: ${response.data}');

      print('🔄 [7] Parsing Response to ProfileDeatilModel...');
      final modelData = RolePlayDetailsModel.fromJson(response.data);

      print('🎉 [8] ProfileDeatilModel Parsed Successfully! (Name: ${modelData.data?.name})');
      print('================ 🏁 [GET PROFILE ROLE MODEL COMPLETED] ================');

      return modelData;
    } catch (e, stackTrace) {
      print('❌ [ERROR] Exception caught in getProfileRoleModel(): $e');
      print('🚨 [TRACE] Stack Trace: $stackTrace');
      print('================ 💥 [GET PROFILE ROLE MODEL FAILED] ================');

      rethrow; // Error ko caller (Notifier/Provider) tak notify karne ke liye
    }
  }
}