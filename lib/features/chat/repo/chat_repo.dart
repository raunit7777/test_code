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

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/network/api_clinet.dart';
import '../../../core/network/api_endpoints.dart';
import '../model/chat_created_model.dart';
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
  Future<ChatInitModel3> chatInitCreated(String userId) async {
    final String fullUrl = '${ApiEndpoints.companionChatInit}/$userId';
    debugPrint('🚀 [GET Companion ChatInit] Fetching from: $fullUrl');

    try {
      final response = await _apiClient.get(fullUrl);

      debugPrint('📥 [GET Companion ChatInit] Status Code: ${response.statusCode}');
      debugPrint('📦 [GET Companion ChatInit] Raw Response: ${response.data}');

      final parsedModel = ChatInitModel3.fromJson(response.data);
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
    try {
      final response = await _apiClient.post(
        ApiEndpoints.sendMsg,
        data: data,
      );
      return response.data;
    } catch (e) {
      debugPrint('❌ [ChatRepository sendMsg Error]: $e');

      final String errText = e.toString().toUpperCase();

      // 🟢 Status Code 403 / 402 / Limit Reached / Subscription Error Detection
      final bool isSubscriptionRequired = errText.contains('403') ||
          errText.contains('402') ||
          errText.contains('DAILY_LIMIT_REACHED') ||
          errText.contains('PAYMENT_REQUIRED') ||
          errText.contains('SUBSCRIBED') ||
          errText.contains('SOMETHING WENT WRONG'); // ApiClient fallback match

      if (isSubscriptionRequired) {
        debugPrint('🔒 [ChatRepository sendMsg] Daily limit reached or subscription required (403/402)');
        throw Exception('SUBSCRIPTION_REQUIRED_403');
      }

      rethrow;
    }
  }

  // Companion Send Message
  Future<dynamic> sendMsgCreated(dynamic data) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.companionSendMsg,
        data: data,
      );
      return response.data;
    } catch (e) {
      debugPrint('❌ [ChatRepository sendMsgCreated Error]: $e');

      final String errText = e.toString().toUpperCase();

      // 🟢 Status Code 403 / 402 / Limit Reached / Subscription Error Detection
      final bool isSubscriptionRequired = errText.contains('403') ||
          errText.contains('402') ||
          errText.contains('DAILY_LIMIT_REACHED') ||
          errText.contains('PAYMENT_REQUIRED') ||
          errText.contains('SUBSCRIBED') ||
          errText.contains('SOMETHING WENT WRONG');

      if (isSubscriptionRequired) {
        debugPrint('🔒 [sendMsgCreated] Subscription or daily limit reached (403/402)');
        throw Exception('SUBSCRIPTION_REQUIRED_403');
      }

      rethrow;
    }
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

      final String errText = e.toString().toUpperCase();

      // 🟢 403 / 402 / DAILY_LIMIT_REACHED / ApiClient fallback matching
      final bool isSubscriptionRequired = errText.contains('403') ||
          errText.contains('402') ||
          errText.contains('DAILY_LIMIT_REACHED') ||
          errText.contains('PAYMENT_REQUIRED') ||
          errText.contains('SUBSCRIBED') ||
          errText.contains('SOMETHING WENT WRONG');

      if (isSubscriptionRequired) {
        debugPrint('🔒 [sendMsgRoll] Limit reached / 403 status detected -> Throwing SUBSCRIPTION_REQUIRED_403');
        throw Exception('SUBSCRIPTION_REQUIRED_403');
      }

      debugPrint('================ 🏁 [API CALL: sendMsgRoll FAILED] ================');
      rethrow;
    }
  }
// 5️⃣ Delete Single Chat by ID
  Future<Response> deleteChat() async {
    final String fullUrl = '${ApiEndpoints.deleteChat}';
    debugPrint('================ 🚀 [DELETE CHAT STARTED] ================');
    debugPrint('👉 Target URL: $fullUrl');

    try {
      final response = await _apiClient.delete(fullUrl);
      debugPrint('✅ Chat Deleted Successfully!');
      return response;
    } catch (e) {
      debugPrint('❌ Error deleting chat: $e');
      rethrow;
    }
  }

// 6️⃣ Delete Chat All / By Entity Type
  Future<Response> deleteChatAll({
    required String entityId,
    required String chatType,
  }) async {
    final String fullUrl = '${ApiEndpoints.deleteChatParticular}/delete-by-entity/$chatType/$entityId';

    debugPrint('================ 🚀 [DELETE CHAT ALL STARTED] ================');
    debugPrint('👉 Target URL: $fullUrl');

    try {
      final response = await _apiClient.delete(fullUrl);
      debugPrint('✅ All Chats Deleted Successfully!');
      return response;
    } catch (e) {
      debugPrint('❌ Error deleting all chats: $e');
      rethrow;
    }
  }
}