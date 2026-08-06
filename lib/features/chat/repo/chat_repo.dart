// import 'package:flutter/cupertino.dart';
//
// import '../../../core/network/api_clinet.dart';
// import '../../../core/network/api_endpoints.dart';
// import '../model/chat_init_model.dart';
// import '../model/chat_init_role_model.dart';
// import '../model/massage_model.dart';
//
// class ChatRepository {
//   final ApiClient _apiClient;
//
//   ChatRepository(this._apiClient);
//
//   // 1️⃣ Simple Chat Initial Fetch
//   Future<ChatInitModel> chatInit(String userId) async {
//     try {
//       final response = await _apiClient.get(
//         '${ApiEndpoints.chatInti}/$userId',
//       );
//       return ChatInitModel.fromJson(response.data);
//     } catch (e) {
//       // Agar ApiClient exception custom throw kar raha hai par status 402 tha:
//       if (e.toString().contains('402') ||
//           e.toString().contains('PAYMENT_REQUIRED') ||
//           e.toString().toLowerCase().contains('subscribed')) {
//         throw Exception('PAYMENT_REQUIRED_402');
//       }
//       rethrow;
//     }
//   }
//
//
//   Future<ChatInitModel> chatInitCreated(String userId) async {
//     final String fullUrl = '${ApiEndpoints.companionChatInit}/$userId';
//     debugPrint('🚀 [GET Companion ChatInit] Fetching from: $fullUrl');
//
//     try {
//       final response = await _apiClient.get(fullUrl);
//
//       debugPrint('📥 [GET Companion ChatInit] Status Code: ${response.statusCode}');
//       debugPrint('📦 [GET Companion ChatInit] Raw Response: ${response.data}');
//
//       final parsedModel = ChatInitModel.fromJson(response.data);
//       debugPrint('✅ [GET Companion ChatInit] Successfully parsed ChatInitModel');
//
//       return parsedModel;
//     } catch (error, stackTrace) {
//       debugPrint('❌ [GET Companion ChatInit Error]: $error');
//       debugPrint('🚨 [GET Companion ChatInit StackTrace]: $stackTrace');
//       rethrow;
//     }
//   }
//   // 2️⃣ RolePlay Chat Initial Fetch
//   Future<ChatInitRoleModel> chatInitRole(String userId) async {
//     final response = await _apiClient.get(
//       '${ApiEndpoints.startRolePlayChatInit}/$userId',
//     );
//     return ChatInitRoleModel.fromJson(response.data);
//   }
//
//   // 3️⃣ Simple Chat Send Message
//   Future<dynamic> sendMsg(dynamic data) async {
//     final response = await _apiClient.post(
//       ApiEndpoints.sendMsg,
//       data: data,
//     );
//     return response.data;
//   }
//
//
//   Future<dynamic> sendMsgCreated(dynamic data) async {
//     final response = await _apiClient.post(
//       ApiEndpoints.companionSendMsg,
//       data: data,
//     );
//     return response.data;
//   }
//
//
//   // 4️⃣ RolePlay Send Message
//   Future<MassageRoleModel> sendMsgRoll(dynamic data) async {
//     debugPrint('================ 🌐 [API CALL: sendMsgRoll STARTED] ================');
//     debugPrint('🔗 Target Endpoint: ${ApiEndpoints.chatRolePlaySendMsg}');
//     debugPrint('📦 Outgoing Request Data: $data');
//
//     try {
//       debugPrint('⏳ Sending POST Request via ApiClient...');
//       final response = await _apiClient.post(
//         ApiEndpoints.chatRolePlaySendMsg,
//         data: data,
//       );
//
//       debugPrint('✅ Response Received from Server!');
//       debugPrint('📊 HTTP Status Code: ${response.statusCode}');
//       debugPrint('📄 Raw Response Body Data: ${response.data}');
//
//       debugPrint('⚙️ Parsing Response JSON into MassageRoleModel...');
//       final parsedModel = MassageRoleModel.fromJson(response.data);
//
//       debugPrint('🎉 Model Parsed Successfully!');
//       debugPrint('🔍 Parsed Data Summary -> Success: ${parsedModel.success} | Message: "${parsedModel.message}" | ConvID: ${parsedModel.data?.conversationId}');
//       debugPrint('================ 🏁 [API CALL: sendMsgRoll SUCCESS] ================');
//
//       return parsedModel;
//     } catch (e, stackTrace) {
//       debugPrint('❌ [API EXCEPTION] Error in sendMsgRoll API Call: $e');
//       debugPrint('🚨 [API STACKTRACE] $stackTrace');
//       debugPrint('================ 🏁 [API CALL: sendMsgRoll FAILED] ================');
//       rethrow;
//     }
//   }
// }

import 'package:flutter/cupertino.dart';

import '../../../core/network/api_clinet.dart';
import '../../../core/network/api_endpoints.dart';
import '../model/chat_init_model.dart';
import '../model/chat_init_role_model.dart';
import '../model/massage_model.dart';

class ChatRepository {
  final ApiClient _apiClient;

  ChatRepository(this._apiClient);

  // 1️⃣ Simple Chat Initial Fetch
  Future<ChatInitModel> chatInit(String userId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.chatInti}/$userId',
      );
      return ChatInitModel.fromJson(response.data);
    } catch (e) {
      if (e.toString().contains('402') ||
          e.toString().contains('PAYMENT_REQUIRED') ||
          e.toString().toLowerCase().contains('subscribed')) {
        throw Exception('PAYMENT_REQUIRED_402');
      }
      rethrow;
    }
  }

  // Companion Chat Initial Fetch
  Future<ChatInitModel> chatInitCreated(String userId) async {
    final String fullUrl = '${ApiEndpoints.companionChatInit}/$userId';
    debugPrint('🚀 [GET Companion ChatInit] Fetching from: $fullUrl');

    try {
      final response = await _apiClient.get(fullUrl);

      debugPrint('📥 [GET Companion ChatInit] Status Code: ${response.statusCode}');
      debugPrint('📦 [GET Companion ChatInit] Raw Response: ${response.data}');

      final parsedModel = ChatInitModel.fromJson(response.data);
      debugPrint('✅ [GET Companion ChatInit] Successfully parsed ChatInitModel');

      return parsedModel;
    } catch (error, stackTrace) {
      debugPrint('❌ [GET Companion ChatInit Error]: $error');
      debugPrint('🚨 [GET Companion ChatInit StackTrace]: $stackTrace');

      if (error.toString().contains('402') ||
          error.toString().contains('PAYMENT_REQUIRED') ||
          error.toString().toLowerCase().contains('subscribed')) {
        throw Exception('PAYMENT_REQUIRED_402');
      }
      rethrow;
    }
  }

  // 2️⃣ RolePlay Chat Initial Fetch
  Future<ChatInitRoleModel> chatInitRole(String userId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.startRolePlayChatInit}/$userId',
      );
      return ChatInitRoleModel.fromJson(response.data);
    } catch (e) {
      if (e.toString().contains('402') ||
          e.toString().contains('PAYMENT_REQUIRED') ||
          e.toString().toLowerCase().contains('subscribed')) {
        throw Exception('PAYMENT_REQUIRED_402');
      }
      rethrow;
    }
  }

  // 3️⃣ Simple Chat Send Message
  Future<dynamic> sendMsg(dynamic data) async {
    final response = await _apiClient.post(
      ApiEndpoints.sendMsg,
      data: data,
    );
    return response.data;
  }

  // Companion Send Message
  Future<dynamic> sendMsgCreated(dynamic data) async {
    final response = await _apiClient.post(
      ApiEndpoints.companionSendMsg,
      data: data,
    );
    return response.data;
  }

  // 4️⃣ RolePlay Send Message
  Future<MassageRoleModel> sendMsgRoll(dynamic data) async {
    debugPrint('================ 🌐 [API CALL: sendMsgRoll STARTED] ================');
    debugPrint('🔗 Target Endpoint: ${ApiEndpoints.chatRolePlaySendMsg}');
    debugPrint('📦 Outgoing Request Data: $data');

    try {
      debugPrint('⏳ Sending POST Request via ApiClient...');
      final response = await _apiClient.post(
        ApiEndpoints.chatRolePlaySendMsg,
        data: data,
      );

      debugPrint('✅ Response Received from Server!');
      debugPrint('📊 HTTP Status Code: ${response.statusCode}');
      debugPrint('📄 Raw Response Body Data: ${response.data}');

      debugPrint('⚙️ Parsing Response JSON into MassageRoleModel...');
      final parsedModel = MassageRoleModel.fromJson(response.data);

      debugPrint('🎉 Model Parsed Successfully!');
      debugPrint(
          '🔍 Parsed Data Summary -> Success: ${parsedModel.success} | Message: "${parsedModel.message}" | ConvID: ${parsedModel.data?.conversationId}');
      debugPrint('================ 🏁 [API CALL: sendMsgRoll SUCCESS] ================');

      return parsedModel;
    } catch (e, stackTrace) {
      debugPrint('❌ [API EXCEPTION] Error in sendMsgRoll API Call: $e');
      debugPrint('🚨 [API STACKTRACE] $stackTrace');
      debugPrint('================ 🏁 [API CALL: sendMsgRoll FAILED] ================');
      rethrow;
    }
  }
}