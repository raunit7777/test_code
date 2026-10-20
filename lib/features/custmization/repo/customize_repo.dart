import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/network/api_clinet.dart';
import '../../../core/network/api_endpoints.dart';
import '../model/customize_model.dart';
import '../model/relationship_type_model.dart';

class CustomizeRepository {
  final ApiClient _apiClient;

  CustomizeRepository(this._apiClient);

  Future<CustomizeModel> getProfileVibeDetails(String userId) async {
    print('================ 🚀 [GET PROFILE ROLE MODEL STARTED] ================');
    print('👉 [1] User ID Passed: $userId');

    final String fullUrl = '${ApiEndpoints.getVideDetails}/$userId';
    print('👉 [2] Target Endpoint URL: $fullUrl');

    try {
      print('⌛ [3] Sending GET Request via ApiClient...');

      final response = await _apiClient.get(fullUrl);

      print('✅ [4] Response Received Successfully!');
      print('📊 [5] Status Code: ${response.statusCode}');
      print('📦 [6] Raw Response Data: ${response.data}');

      print('🔄 [7] Parsing Response to CustomizeModel...');
      final modelData = CustomizeModel.fromJson(response.data);

      print('================ 🏁 [GET PROFILE ROLE MODEL COMPLETED] ================');

      return modelData;
    } catch (e, stackTrace) {
      print('❌ [ERROR] Exception caught in getProfileVibeDetails(): $e');
      print('🚨 [TRACE] Stack Trace: $stackTrace');
      print('================ 💥 [GET PROFILE ROLE MODEL FAILED] ================');

      rethrow;
    }
  }
  Future<RelationshipTypeModel> getRelationShipType() async {


    final String fullUrl = '${ApiEndpoints.relationshipType}';
    print('👉 [2] Target Endpoint URL: $fullUrl');

    try {
      print('⌛ [3] Sending GET Request via ApiClient...');

      final response = await _apiClient.get(fullUrl);

      print('✅ [4] Response Received Successfully!');
      print('📊 [5] Status Code: ${response.statusCode}');
      print('📦 [6] Raw Response Data: ${response.data}');

      print('🔄 [7] Parsing Response to CustomizeModel...');
      final modelData = RelationshipTypeModel.fromJson(response.data);

      print('================ 🏁 [GET PROFILE ROLE MODEL COMPLETED] ================');

      return modelData;
    } catch (e, stackTrace) {
      print('❌ [ERROR] Exception caught in getProfileVibeDetails(): $e');
      print('🚨 [TRACE] Stack Trace: $stackTrace');
      print('================ 💥 [GET PROFILE ROLE MODEL FAILED] ================');

      rethrow;
    }
  }

  // 🟢 Updated updateVibe: Concatenates characterId to URL
  Future<Response> updateVibe({
    required String characterId,
    required List<Map<String, dynamic>> sliders,
    required List<String> additionalTraits,
  }) async {
    final String fullUrl = '${ApiEndpoints.vibeUpdate}/$characterId';

    print('================ 🚀 [UPDATE VIBE STARTED] ================');
    print('👉 [1] Target URL: $fullUrl');

    final Map<String, dynamic> body = {
      'sliders': sliders, // list of {traitId: String, value: num}
      'additionalTraits': additionalTraits, // list of string trait IDs
    };

    print('📦 [2] Request Body: $body');

    try {
      final response = await _apiClient.put(
        fullUrl,
        data: body,
      );
      print('✅ [3] Vibe Updated Successfully!');
      return response;
    } catch (e, stackTrace) {
      print('❌ [ERROR] Exception caught in updateVibe(): $e');
      print('🚨 [TRACE] Stack Trace: $stackTrace');
      rethrow;
    }
  }
}