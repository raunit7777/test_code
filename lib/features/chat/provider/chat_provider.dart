// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:go_router/go_router.dart';
// import 'package:infinity_love/features/chat/model/chat_init_model.dart';
// import 'package:infinity_love/features/chat/model/chat_init_role_model.dart';
// import '../../../../core/di/service_locator.dart';
// import '../../../routes/app_routes.dart';
// import '../../home/state/features_state.dart';
// import '../model/massage_model.dart';
// import '../repo/chat_repo.dart';
//
// final chatNotifierProvider =
// StateNotifierProvider<ChatNotifier, FeaturesState>((ref) {
//   return ChatNotifier(sl<ChatRepository>());
// });
//
// class ChatNotifier extends StateNotifier<FeaturesState> {
//   final ChatRepository _repository;
//
//   ChatNotifier(this._repository) : super(const FeaturesState());
//
//   // 1️⃣ Simple Chat Initial Fetch
//   Future<void> fetchChatList(dynamic sId, dynamic name,
//       {String? imageUrl}) async {
//     debugPrint('================ 🚀 [fetchChatList STARTED] ================');
//     state = state.copyWith(chatInit: const AsyncValue.loading());
//
//     try {
//       final response = await _repository.chatInit(sId.toString());
//
//       state = state.copyWith(chatInit: AsyncValue.data(response));
//       debugPrint('✅ [fetchChatList SUCCESS]');
//
//       if (response != null &&
//           (response.success == true || response.data != null)) {
//         debugPrint(
//             '🔀 [SUCCESS 200/201] Navigating to chatScreen via Global Key...');
//
//         final BuildContext? globalContext = rootNavigatorKey.currentContext;
//
//         if (globalContext != null && globalContext.mounted) {
//           globalContext.pushNamed(
//             'chatScreen',
//             extra: {
//               'sId': sId.toString(),
//               'image': imageUrl ?? '',
//               'name': name,
//             },
//           );
//           debugPrint('🎉 Navigation to chatScreen completed successfully!');
//         } else {
//           debugPrint('⚠️ Global Context unmounted or null!');
//         }
//       }
//     } catch (e, stack) {
//       debugPrint('❌ [fetchChatList ERROR]: $e');
//       state = state.copyWith(chatInit: AsyncValue.error(e, stack));
//
//       final String errText = e.toString().toUpperCase();
//       final bool is402 = errText.contains('402') ||
//           errText.contains('PAYMENT_REQUIRED') ||
//           errText.contains('SUBSCRIBED') ||
//           errText.contains('SOMETHING WENT WRONG');
//
//       if (is402) {
//         debugPrint(
//             '🔒 402 Payment Required match found! Global Key Redirecting...');
//         rootNavigatorKey.currentContext?.pushNamed('premium');
//       }
//     }
//   }
//
//   // Fetch Companion Chat List
// // Fetch Companion Chat List
//   Future<void> fetchChatListCompanion(dynamic sId,
//       {BuildContext? context}) async {
//     state = state.copyWith(chatInit: const AsyncValue.loading());
//     try {
//       final response3 = await _repository.chatInitCreated(sId.toString());
//
//       // 🟢 Fail-safe conversion via Json
//       final mappedResponse = ChatInitModel.fromJson(response3.toJson());
//
//       state = state.copyWith(chatInit: AsyncValue.data(mappedResponse));
//     } catch (e, stack) {
//       state = state.copyWith(chatInit: AsyncValue.error(e, stack));
//
//       final String errText = e.toString().toUpperCase();
//       if (errText.contains('402') ||
//           errText.contains('PAYMENT_REQUIRED') ||
//           errText.contains('SUBSCRIBED')) {
//         if (context != null && context.mounted) {
//           context.pushNamed('premium');
//         }
//       }
//     }
//   }
//   // 2️⃣ RolePlay Chat Initial Fetch
//   Future<void> fetchChatListRole(dynamic sId,
//       {String? imageUrl, BuildContext? context}) async {
//     debugPrint(
//         '================ 🚀 [fetchChatListRole STARTED] ================');
//     state = state.copyWith(roleChatInit: const AsyncValue.loading());
//
//     try {
//       final response = await _repository.chatInitRole(sId.toString());
//
//       if (response.data?.messages != null) {
//         for (final msg in response.data!.messages!) {
//           msg.content = _extractReplyText(msg.content);
//         }
//       }
//
//       state = state.copyWith(roleChatInit: AsyncValue.data(response));
//
//       if (response.success == true || response.data != null) {
//         final BuildContext? globalContext = rootNavigatorKey.currentContext;
//
//         if (globalContext != null && globalContext.mounted) {
//           globalContext.pushNamed(
//             'chatScreen2',
//             extra: {
//               'sId': sId.toString(),
//               'image': imageUrl ?? '',
//             },
//           );
//           debugPrint('🎉 Navigation to chatScreen2 completed successfully!');
//         } else {
//           debugPrint('⚠️ Global Context unmounted or null!');
//         }
//       }
//     } catch (e, stack) {
//       debugPrint('❌ [fetchChatListRole ERROR]: $e');
//       state = state.copyWith(roleChatInit: AsyncValue.error(e, stack));
//
//       final String errText = e.toString().toUpperCase();
//       final bool is402 = errText.contains('402') ||
//           errText.contains('PAYMENT_REQUIRED') ||
//           errText.contains('SUBSCRIBED') ||
//           errText.contains('SOMETHING WENT WRONG');
//
//       if (is402) {
//         debugPrint(
//             '🔒 402 Payment Required match found! Global Key Redirecting...');
//         rootNavigatorKey.currentContext?.pushNamed('premium');
//       }
//     }
//   }
//
//   void addMessageLocally(Messages newMessage) {
//     state.chatInit.whenData((chatData) {
//       if (chatData != null && chatData.data != null) {
//         final currentMessages =
//         List<Messages>.from(chatData.data!.messages ?? []);
//
//         final exists = currentMessages
//             .any((msg) => msg.sId == newMessage.sId && msg.sId != null);
//         if (!exists) {
//           currentMessages.add(newMessage);
//         }
//
//         chatData.data!.messages = currentMessages;
//
//         state = state.copyWith(
//           chatInit: AsyncValue.data(chatData),
//         );
//       }
//     });
//   }
//
//   // 🟢 Helper to remove temp simple message if API fails
//   void _removeLocalMessage(String tempId) {
//     state.chatInit.whenData((chatData) {
//       if (chatData?.data?.messages != null) {
//         final updatedList =
//         chatData!.data!.messages!.where((m) => m.sId != tempId).toList();
//         chatData.data!.messages = updatedList;
//         state = state.copyWith(
//           chatInit: AsyncValue.data(chatData),
//         );
//         debugPrint('🗑️ Removed temp message ($tempId) from simple chat UI');
//       }
//     });
//   }
//
//   void addRoleMessageLocally(dynamic newMessage) {
//     state.roleChatInit.whenData((roleData) {
//       if (roleData != null && roleData.data != null) {
//         final currentMessages =
//         List<RoleChatMessage>.from(roleData.data!.messages ?? []);
//
//         final RoleChatMessage newMsg = _toRoleChatMessage(newMessage);
//
//         final bool exists = currentMessages.any((msg) =>
//         (msg.sId ?? '').isNotEmpty && msg.sId == newMsg.sId);
//
//         if (!exists) {
//           currentMessages.add(newMsg);
//         }
//
//         final updatedData = RoleChatData(
//           conversationId: roleData.data!.conversationId,
//           sessionId: roleData.data!.sessionId,
//           messages: currentMessages,
//           total: roleData.data!.total,
//           isNew: roleData.data!.isNew,
//         );
//
//         final updatedModel = ChatInitRoleModel(
//           success: roleData.success,
//           data: updatedData,
//           message: roleData.message,
//         );
//
//         state = state.copyWith(
//           roleChatInit: AsyncValue.data(updatedModel),
//         );
//
//         debugPrint(
//             '📲 [STATE RE-EMITTED] Total Messages in State: ${currentMessages.length}');
//       }
//     });
//   }
//
//   RoleChatMessage _toRoleChatMessage(dynamic msg) {
//     if (msg is RoleChatMessage) {
//       return msg;
//     } else if (msg is Messages) {
//       return RoleChatMessage(
//         sId: msg.sId,
//         conversationId: msg.conversationId,
//         role: msg.role,
//         content: msg.content,
//         createdAt: msg.createdAt,
//       );
//     } else if (msg is Map) {
//       return RoleChatMessage(
//         sId: (msg['sId'] ?? msg['id'] ?? msg['_id'])?.toString(),
//         conversationId: msg['conversationId']?.toString(),
//         userId: msg['userId']?.toString(),
//         role: msg['role']?.toString(),
//         content: msg['content']?.toString(),
//         createdAt: msg['createdAt']?.toString(),
//       );
//     } else {
//       try {
//         return RoleChatMessage(
//           sId: msg.sId?.toString() ?? msg.id?.toString(),
//           conversationId: msg.conversationId?.toString(),
//           role: msg.role?.toString(),
//           content: msg.content?.toString(),
//           createdAt: msg.createdAt?.toString(),
//         );
//       } catch (_) {
//         return RoleChatMessage(
//           sId: DateTime.now().millisecondsSinceEpoch.toString(),
//           role: 'assistant',
//           content: '',
//         );
//       }
//     }
//   }
//
//   String _extractReplyText(String? rawContent) {
//     if (rawContent == null || rawContent.trim().isEmpty) return rawContent ?? '';
//
//     final String content = rawContent.trim();
//     String extractedResult = rawContent;
//
//     if (content.contains('"reply"')) {
//       final RegExp replyPattern = RegExp(
//         r'"reply"\s*:\s*"(.*?)"\s*,\s*"(?:language|intent)"',
//         dotAll: true,
//       );
//
//       RegExpMatch? match = replyPattern.firstMatch(content);
//       match ??= RegExp(r'"reply"\s*:\s*"(.*?)"\s*}\s*$', dotAll: true)
//           .firstMatch(content);
//
//       if (match != null && match.group(1) != null) {
//         String reply = match.group(1)!;
//         reply = reply
//             .replaceAll(r'\"', '"')
//             .replaceAll(r'\n', '\n')
//             .replaceAll(r'\t', '\t')
//             .replaceAll(r'\\', r'\');
//         extractedResult = reply.trim();
//       }
//     }
//
//     return _extractDialogueOnly(extractedResult);
//   }
//
//   String _extractDialogueOnly(String fullText) {
//     if (fullText.isEmpty) return fullText;
//
//     String cleanedText = fullText.replaceAll(
//       RegExp(r'\*.*?\*', dotAll: true),
//       '',
//     );
//
//     cleanedText = cleanedText
//         .split('\n')
//         .map((line) => line.trim())
//         .where((line) => line.isNotEmpty)
//         .join('\n\n');
//
//     return cleanedText.trim();
//   }
//
//   // 5️⃣ Simple Send Message API Call
//   Future<void> sendMessage({
//     required String characterId,
//     required String conversationId,
//     required String messageText,
//   }) async {
//     debugPrint('================ 🚀 [sendMessage STARTED] ================');
//
//     if (messageText.trim().isEmpty) return;
//
//     final String tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
//     final userMessage = Messages(
//       sId: tempId,
//       conversationId: conversationId,
//       content: messageText,
//       role: 'user',
//       createdAt: DateTime.now().toIso8601String(),
//     );
//
//     // 1️⃣ Local Update
//     addMessageLocally(userMessage);
//     state = state.copyWith(isSending: true);
//
//     final Map<String, dynamic> requestData = {
//       "characterId": characterId,
//       "conversationId": conversationId,
//       "message": messageText,
//     };
//
//     try {
//       final response = await _repository.sendMsg(requestData);
//
//       final int? statusCode = response is Response
//           ? response.statusCode
//           : (response?['statusCode'] ?? 200);
//       final dynamic responseData =
//       response is Response ? response.data : response;
//
//       if ((statusCode == 200 || statusCode == 201) &&
//           responseData != null &&
//           responseData['success'] == true) {
//         final companionData = responseData['data']?['companionMessage'];
//
//         if (companionData != null) {
//           final aiMessage = Messages(
//             sId: companionData['id'] ??
//                 companionData['_id'] ??
//                 DateTime.now().millisecondsSinceEpoch.toString(),
//             conversationId:
//             responseData['data']?['conversationId'] ?? conversationId,
//             content: _extractReplyText(companionData['content']?.toString()),
//             role: companionData['role'] ?? 'assistant',
//             createdAt: companionData['createdAt'] ??
//                 DateTime.now().toIso8601String(),
//           );
//
//           addMessageLocally(aiMessage);
//         }
//       } else {
//         _removeLocalMessage(tempId);
//       }
//     } catch (e, stack) {
//       debugPrint('❌ Exception Caught in sendMessage: $e');
//       _removeLocalMessage(tempId);
//
//       int? statusCode;
//       String rawResponseText = '';
//
//       if (e is DioException) {
//         statusCode = e.response?.statusCode;
//         rawResponseText = e.response?.data?.toString() ?? '';
//       }
//
//       final String fullErrorString =
//       '${e.toString()} $rawResponseText'.toUpperCase();
//
//       debugPrint('🔍 Extracted StatusCode: $statusCode');
//       debugPrint('📄 Full Error Text: $fullErrorString');
//
//       final bool isLimitOrSubscriptionError = statusCode == 403 ||
//           statusCode == 402 ||
//           fullErrorString.contains('403') ||
//           fullErrorString.contains('402') ||
//           fullErrorString.contains('DAILY_LIMIT_REACHED') ||
//           fullErrorString.contains('PAYMENT_REQUIRED') ||
//           fullErrorString.contains('SUBSCRIBE') ||
//           fullErrorString.contains('SUBSCRIPTION_REQUIRED_403') ||
//           fullErrorString.contains('SOMETHING WENT WRONG') ||
//           fullErrorString.contains('LIMIT');
//
//       if (isLimitOrSubscriptionError) {
//         debugPrint(
//             '🔒 [LIMIT REACHED / 403 DETECTED] Redirecting to Subscription Screen...');
//
//         final BuildContext? globalContext = rootNavigatorKey.currentContext;
//         if (globalContext != null && globalContext.mounted) {
//           globalContext.pushNamed('premium');
//           debugPrint('✅ Navigated to Premium screen successfully!');
//         } else {
//           debugPrint('⚠️ Global context null or unmounted!');
//         }
//       } else {
//         debugPrint('ℹ️ Generic error (Not a subscription or limit error).');
//       }
//     } finally {
//       state = state.copyWith(isSending: false);
//       debugPrint('================ 🏁 [sendMessage FINISHED] ================');
//     }
//   }
//
//   // Companion Send Message API Call
//   Future<void> sendMessageCompanion({
//     required String characterId,
//     required String conversationId,
//     required String messageText,
//   }) async {
//     if (messageText.trim().isEmpty) return;
//
//     final String tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
//
//     final userMessage = Messages(
//       sId: tempId,
//       conversationId: conversationId,
//       content: messageText,
//       role: 'user',
//       createdAt: DateTime.now().toIso8601String(),
//     );
//
//     addMessageLocally(userMessage);
//     state = state.copyWith(isSending: true);
//
//     final Map<String, dynamic> requestData = {
//       "companionId": characterId,
//       "conversationId": conversationId,
//       "message": messageText,
//     };
//
//     try {
//       final response = await _repository.sendMsgCreated(requestData);
//
//       final int? statusCode = response is Response
//           ? response.statusCode
//           : (response?['statusCode'] ?? 200);
//       final dynamic responseData =
//       response is Response ? response.data : response;
//
//       if ((statusCode == 200 || statusCode == 201) &&
//           responseData != null &&
//           responseData['success'] == true) {
//         final companionData = responseData['data']?['companionMessage'];
//
//         if (companionData != null) {
//           final aiMessage = Messages(
//             sId: companionData['id'] ??
//                 companionData['_id'] ??
//                 DateTime.now().millisecondsSinceEpoch.toString(),
//             conversationId:
//             responseData['data']?['conversationId'] ?? conversationId,
//             content: _extractReplyText(companionData['content']?.toString()),
//             role: companionData['role'] ?? 'assistant',
//             createdAt: companionData['createdAt'] ??
//                 DateTime.now().toIso8601String(),
//           );
//
//           addMessageLocally(aiMessage);
//         }
//       } else {
//         _removeLocalMessage(tempId);
//       }
//     } catch (e) {
//       debugPrint("❌ Error sending companion message: $e");
//       _removeLocalMessage(tempId);
//
//       int? statusCode;
//       String rawResponseText = '';
//
//       if (e is DioException) {
//         statusCode = e.response?.statusCode;
//         rawResponseText = e.response?.data?.toString() ?? '';
//       }
//
//       final String fullErrorString =
//       '${e.toString()} $rawResponseText'.toUpperCase();
//
//       final bool isLimitOrSubscriptionError = statusCode == 403 ||
//           statusCode == 402 ||
//           fullErrorString.contains('403') ||
//           fullErrorString.contains('402') ||
//           fullErrorString.contains('DAILY_LIMIT_REACHED') ||
//           fullErrorString.contains('PAYMENT_REQUIRED') ||
//           fullErrorString.contains('SUBSCRIBE') ||
//           fullErrorString.contains('SUBSCRIPTION_REQUIRED_403') ||
//           fullErrorString.contains('SOMETHING WENT WRONG');
//
//       if (isLimitOrSubscriptionError) {
//         debugPrint(
//             '🔒 [LIMIT REACHED / 403] Redirecting Companion Chat to Premium Screen...');
//
//         final BuildContext? globalContext = rootNavigatorKey.currentContext;
//         if (globalContext != null && globalContext.mounted) {
//           globalContext.pushNamed('premium');
//           debugPrint('✅ Navigated to Premium screen successfully!');
//         } else {
//           debugPrint('⚠️ Global context null or unmounted!');
//         }
//       }
//     } finally {
//       state = state.copyWith(isSending: false);
//     }
//   }
//
//   // 🟢 Helper method: API failure ke case me temporary message local list se hatane ke liye
//   void _removeRoleLocalMessage(String tempId) {
//     state.roleChatInit.whenData((roleData) {
//       if (roleData?.data?.messages != null) {
//         final updatedList =
//         roleData!.data!.messages!.where((m) => m.sId != tempId).toList();
//         roleData.data!.messages = updatedList;
//         state = state.copyWith(
//           roleChatInit: AsyncValue.data(roleData),
//         );
//         debugPrint('🗑️ Removed temp message with ID: $tempId from UI state');
//       }
//     });
//   }
//
//   // 6️⃣ RolePlay Send Message API Call
//   Future<void> sendMessageRoll({
//     required String roleplayId,
//     required String conversationId,
//     required String sessionId,
//     required String messageText,
//   }) async {
//     debugPrint(
//         '================ 🚀 [SEND MESSAGE ROLL STARTED] ================');
//
//     if (messageText.trim().isEmpty) return;
//
//     final String tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
//
//     final userMessage = Messages(
//       sId: tempId,
//       conversationId: conversationId,
//       content: messageText,
//       role: 'user',
//       createdAt: DateTime.now().toIso8601String(),
//     );
//
//     // 1️⃣ Optimistic Local Update
//     addRoleMessageLocally(userMessage);
//     state = state.copyWith(isSending: true);
//
//     final Map<String, dynamic> requestData = {
//       "conversationId": conversationId,
//       "message": messageText,
//       "roleplayId": roleplayId,
//       "sessionId": sessionId,
//     };
//
//     try {
//       final MassageRoleModel responseModel =
//       await _repository.sendMsgRoll(requestData);
//
//       if (responseModel.success == true && responseModel.data != null) {
//         final companion = responseModel.data!.companionMessage;
//
//         if (companion != null) {
//           final String parsedContent = _extractReplyText(companion.content);
//
//           final aiMessage = Messages(
//             sId: companion.id ??
//                 DateTime.now().millisecondsSinceEpoch.toString(),
//             conversationId:
//             responseModel.data!.conversationId ?? conversationId,
//             content: parsedContent,
//             role: companion.role ?? 'assistant',
//             createdAt: companion.createdAt,
//           );
//
//           debugPrint('🤖 AI Response Added: "${aiMessage.content}"');
//           addRoleMessageLocally(aiMessage);
//         }
//       } else {
//         _removeRoleLocalMessage(tempId);
//       }
//     } catch (e, stack) {
//       debugPrint('❌ Error sending message in sendMessageRoll: $e');
//       debugPrint('🚨 StackTrace: $stack');
//
//       _removeRoleLocalMessage(tempId);
//
//       int? statusCode;
//       String rawResponseText = '';
//
//       if (e is DioException) {
//         statusCode = e.response?.statusCode;
//         rawResponseText = e.response?.data?.toString() ?? '';
//       }
//
//       final String fullErrorString =
//       '${e.toString()} $rawResponseText'.toUpperCase();
//
//       final bool isLimitOrSubscriptionError = statusCode == 403 ||
//           statusCode == 402 ||
//           fullErrorString.contains('403') ||
//           fullErrorString.contains('402') ||
//           fullErrorString.contains('DAILY_LIMIT_REACHED') ||
//           fullErrorString.contains('PAYMENT_REQUIRED') ||
//           fullErrorString.contains('SUBSCRIBE') ||
//           fullErrorString.contains('SUBSCRIPTION_REQUIRED_403') ||
//           fullErrorString.contains('SOMETHING WENT WRONG');
//
//       if (isLimitOrSubscriptionError) {
//         debugPrint(
//             '🔒 [ROLEPLAY LIMIT REACHED / 403] Redirecting to Premium Screen...');
//
//         final BuildContext? globalContext = rootNavigatorKey.currentContext;
//         if (globalContext != null && globalContext.mounted) {
//           globalContext.pushNamed('premium');
//           debugPrint('✅ Navigated to Premium screen successfully!');
//         } else {
//           debugPrint('⚠️ Global context null or unmounted!');
//         }
//       }
//     } finally {
//       state = state.copyWith(isSending: false);
//       debugPrint(
//           '================ 🏁 [SEND MESSAGE ROLL ENDED] ================');
//     }
//   }
//
//
//
//
//
//   // 7️⃣ Delete Single Chat Message / Conversation by ID
//   Future<bool> deleteChat() async {
//     debugPrint('================ 🚀 [deleteChat STARTED] ================');
//     try {
//       final response = await _repository.deleteChat();
//       final int? statusCode = response.statusCode;
//
//       if (statusCode == 200 || statusCode == 201) {
//         debugPrint('✅ [deleteChat SUCCESS]');
//         ref.read(featuresProvider.notifier).fetchConversationList();
//         // Local state reset / clean up
//         state = state.copyWith(
//           chatInit: const AsyncValue.data(null),
//         );
//         return true;
//       }
//       return false;
//     } catch (e) {
//       debugPrint('❌ [deleteChat ERROR]: $e');
//       return false;
//     }
//   }
//
// // 8️⃣ Delete All Chats by Entity & ChatType (e.g. CHARACTER, ROLEPLAY, COMPANION)
//   Future<bool> deleteAllChatByEntity({
//     required String entityId,
//     required String chatType,
//   }) async {
//     debugPrint('================ 🚀 [deleteAllChatByEntity STARTED] ================');
//     try {
//       final response = await _repository.deleteChatAll(
//         entityId: entityId,
//         chatType: chatType,
//       );
//
//       final int? statusCode = response.statusCode;
//
//       if (statusCode == 200 || statusCode == 201) {
//         debugPrint('✅ [deleteAllChatByEntity SUCCESS]');
//         ref.read(featuresProvider.notifier).fetchConversationList();
//         // Clear corresponding local UI state
//         if (chatType.toUpperCase() == 'ROLEPLAY') {
//           state = state.copyWith(roleChatInit: const AsyncValue.data(null));
//         } else {
//           state = state.copyWith(chatInit: const AsyncValue.data(null));
//         }
//         return true;
//       }
//       return false;
//     } catch (e) {
//       debugPrint('❌ [deleteAllChatByEntity ERROR]: $e');
//       return false;
//     }
//   }
//
// }


import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:infinity_love/features/chat/model/chat_init_model.dart';
import 'package:infinity_love/features/chat/model/chat_init_role_model.dart';
import '../../../../core/di/service_locator.dart';
import '../../../routes/app_routes.dart';
import '../../home/provider/features_provider.dart';
import '../../home/state/features_state.dart';
import '../model/massage_model.dart';
import '../repo/chat_repo.dart';

final chatNotifierProvider =
StateNotifierProvider<ChatNotifier, FeaturesState>((ref) {
  return ChatNotifier(sl<ChatRepository>(), ref);
});

class ChatNotifier extends StateNotifier<FeaturesState> {
  final ChatRepository _repository;
  final Ref _ref;

  ChatNotifier(this._repository, this._ref) : super(const FeaturesState());

  // 1️⃣ Simple Chat Initial Fetch
  Future<void> fetchChatList(dynamic sId, dynamic name,
      {String? imageUrl}) async {
    debugPrint('================ 🚀 [fetchChatList STARTED] ================');
    state = state.copyWith(chatInit: const AsyncValue.loading());

    try {
      final response = await _repository.chatInit(sId.toString());

      state = state.copyWith(chatInit: AsyncValue.data(response));
      debugPrint('✅ [fetchChatList SUCCESS]');

      if (response != null &&
          (response.success == true || response.data != null)) {
        debugPrint(
            '🔀 [SUCCESS 200/201] Navigating to chatScreen via Global Key...');

        final BuildContext? globalContext = rootNavigatorKey.currentContext;

        if (globalContext != null && globalContext.mounted) {
          globalContext.pushNamed(
            'chatScreen',
            extra: {
              'sId': sId.toString(),
              'image': imageUrl ?? '',
              'name': name,
            },
          );
          debugPrint('🎉 Navigation to chatScreen completed successfully!');
        } else {
          debugPrint('⚠️ Global Context unmounted or null!');
        }
      }
    } catch (e, stack) {
      debugPrint('❌ [fetchChatList ERROR]: $e');
      state = state.copyWith(chatInit: AsyncValue.error(e, stack));

      final String errText = e.toString().toUpperCase();
      final bool is402 = errText.contains('402') ||
          errText.contains('PAYMENT_REQUIRED') ||
          errText.contains('SUBSCRIBED') ||
          errText.contains('SOMETHING WENT WRONG');

      if (is402) {
        debugPrint(
            '🔒 402 Payment Required match found! Global Key Redirecting...');
        rootNavigatorKey.currentContext?.pushNamed('premium');
      }
    }
  }

  // Fetch Companion Chat List
  Future<void> fetchChatListCompanion(dynamic sId,
      {BuildContext? context}) async {
    state = state.copyWith(chatInit: const AsyncValue.loading());
    try {
      final response3 = await _repository.chatInitCreated(sId.toString());

      // 🟢 Fail-safe conversion via Json
      final mappedResponse = ChatInitModel.fromJson(response3.toJson());

      state = state.copyWith(chatInit: AsyncValue.data(mappedResponse));
    } catch (e, stack) {
      state = state.copyWith(chatInit: AsyncValue.error(e, stack));

      final String errText = e.toString().toUpperCase();
      if (errText.contains('402') ||
          errText.contains('PAYMENT_REQUIRED') ||
          errText.contains('SUBSCRIBED')) {
        if (context != null && context.mounted) {
          context.pushNamed('premium');
        }
      }
    }
  }

  // 2️⃣ RolePlay Chat Initial Fetch
  Future<void> fetchChatListRole(dynamic sId,
      {String? imageUrl, BuildContext? context}) async {
    debugPrint(
        '================ 🚀 [fetchChatListRole STARTED] ================');
    state = state.copyWith(roleChatInit: const AsyncValue.loading());

    try {
      final response = await _repository.chatInitRole(sId.toString());

      if (response.data?.messages != null) {
        for (final msg in response.data!.messages!) {
          msg.content = _extractReplyText(msg.content);
        }
      }

      state = state.copyWith(roleChatInit: AsyncValue.data(response));

      if (response.success == true || response.data != null) {
        final BuildContext? globalContext = rootNavigatorKey.currentContext;

        if (globalContext != null && globalContext.mounted) {
          globalContext.pushNamed(
            'chatScreen2',
            extra: {
              'sId': sId.toString(),
              'image': imageUrl ?? '',
            },
          );
          debugPrint('🎉 Navigation to chatScreen2 completed successfully!');
        } else {
          debugPrint('⚠️ Global Context unmounted or null!');
        }
      }
    } catch (e, stack) {
      debugPrint('❌ [fetchChatListRole ERROR]: $e');
      state = state.copyWith(roleChatInit: AsyncValue.error(e, stack));

      final String errText = e.toString().toUpperCase();
      final bool is402 = errText.contains('402') ||
          errText.contains('PAYMENT_REQUIRED') ||
          errText.contains('SUBSCRIBED') ||
          errText.contains('SOMETHING WENT WRONG');

      if (is402) {
        debugPrint(
            '🔒 402 Payment Required match found! Global Key Redirecting...');
        rootNavigatorKey.currentContext?.pushNamed('premium');
      }
    }
  }

  void addMessageLocally(Messages newMessage) {
    state.chatInit.whenData((chatData) {
      if (chatData != null && chatData.data != null) {
        final currentMessages =
        List<Messages>.from(chatData.data!.messages ?? []);

        final exists = currentMessages
            .any((msg) => msg.sId == newMessage.sId && msg.sId != null);
        if (!exists) {
          currentMessages.add(newMessage);
        }

        chatData.data!.messages = currentMessages;

        state = state.copyWith(
          chatInit: AsyncValue.data(chatData),
        );
      }
    });
  }

  // 🟢 Helper to remove temp simple message if API fails
  void _removeLocalMessage(String tempId) {
    state.chatInit.whenData((chatData) {
      if (chatData?.data?.messages != null) {
        final updatedList =
        chatData!.data!.messages!.where((m) => m.sId != tempId).toList();
        chatData.data!.messages = updatedList;
        state = state.copyWith(
          chatInit: AsyncValue.data(chatData),
        );
        debugPrint('🗑️ Removed temp message ($tempId) from simple chat UI');
      }
    });
  }

  void addRoleMessageLocally(dynamic newMessage) {
    state.roleChatInit.whenData((roleData) {
      if (roleData != null && roleData.data != null) {
        final currentMessages =
        List<RoleChatMessage>.from(roleData.data!.messages ?? []);

        final RoleChatMessage newMsg = _toRoleChatMessage(newMessage);

        final bool exists = currentMessages.any((msg) =>
        (msg.sId ?? '').isNotEmpty && msg.sId == newMsg.sId);

        if (!exists) {
          currentMessages.add(newMsg);
        }

        final updatedData = RoleChatData(
          conversationId: roleData.data!.conversationId,
          sessionId: roleData.data!.sessionId,
          messages: currentMessages,
          total: roleData.data!.total,
          isNew: roleData.data!.isNew,
        );

        final updatedModel = ChatInitRoleModel(
          success: roleData.success,
          data: updatedData,
          message: roleData.message,
        );

        state = state.copyWith(
          roleChatInit: AsyncValue.data(updatedModel),
        );

        debugPrint(
            '📲 [STATE RE-EMITTED] Total Messages in State: ${currentMessages.length}');
      }
    });
  }

  RoleChatMessage _toRoleChatMessage(dynamic msg) {
    if (msg is RoleChatMessage) {
      return msg;
    } else if (msg is Messages) {
      return RoleChatMessage(
        sId: msg.sId,
        conversationId: msg.conversationId,
        role: msg.role,
        content: msg.content,
        createdAt: msg.createdAt,
      );
    } else if (msg is Map) {
      return RoleChatMessage(
        sId: (msg['sId'] ?? msg['id'] ?? msg['_id'])?.toString(),
        conversationId: msg['conversationId']?.toString(),
        userId: msg['userId']?.toString(),
        role: msg['role']?.toString(),
        content: msg['content']?.toString(),
        createdAt: msg['createdAt']?.toString(),
      );
    } else {
      try {
        return RoleChatMessage(
          sId: msg.sId?.toString() ?? msg.id?.toString(),
          conversationId: msg.conversationId?.toString(),
          role: msg.role?.toString(),
          content: msg.content?.toString(),
          createdAt: msg.createdAt?.toString(),
        );
      } catch (_) {
        return RoleChatMessage(
          sId: DateTime.now().millisecondsSinceEpoch.toString(),
          role: 'assistant',
          content: '',
        );
      }
    }
  }

  String _extractReplyText(String? rawContent) {
    if (rawContent == null || rawContent.trim().isEmpty) return rawContent ?? '';

    final String content = rawContent.trim();
    String extractedResult = rawContent;

    if (content.contains('"reply"')) {
      final RegExp replyPattern = RegExp(
        r'"reply"\s*:\s*"(.*?)"\s*,\s*"(?:language|intent)"',
        dotAll: true,
      );

      RegExpMatch? match = replyPattern.firstMatch(content);
      match ??= RegExp(r'"reply"\s*:\s*"(.*?)"\s*}\s*$', dotAll: true)
          .firstMatch(content);

      if (match != null && match.group(1) != null) {
        String reply = match.group(1)!;
        reply = reply
            .replaceAll(r'\"', '"')
            .replaceAll(r'\n', '\n')
            .replaceAll(r'\t', '\t')
            .replaceAll(r'\\', r'\');
        extractedResult = reply.trim();
      }
    }

    return _extractDialogueOnly(extractedResult);
  }

  String _extractDialogueOnly(String fullText) {
    if (fullText.isEmpty) return fullText;

    String cleanedText = fullText.replaceAll(
      RegExp(r'\*.*?\*', dotAll: true),
      '',
    );

    cleanedText = cleanedText
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .join('\n\n');

    return cleanedText.trim();
  }

  // 5️⃣ Simple Send Message API Call
  Future<void> sendMessage({
    required String characterId,
    required String conversationId,
    required String messageText,
  }) async {
    debugPrint('================ 🚀 [sendMessage STARTED] ================');

    if (messageText.trim().isEmpty) return;

    final String tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final userMessage = Messages(
      sId: tempId,
      conversationId: conversationId,
      content: messageText,
      role: 'user',
      createdAt: DateTime.now().toIso8601String(),
    );

    // 1️⃣ Local Update
    addMessageLocally(userMessage);
    state = state.copyWith(isSending: true);

    final Map<String, dynamic> requestData = {
      "characterId": characterId,
      "conversationId": conversationId,
      "message": messageText,
    };

    try {
      final response = await _repository.sendMsg(requestData);

      final int? statusCode = response is Response
          ? response.statusCode
          : (response?['statusCode'] ?? 200);
      final dynamic responseData =
      response is Response ? response.data : response;

      if ((statusCode == 200 || statusCode == 201) &&
          responseData != null &&
          responseData['success'] == true) {
        final companionData = responseData['data']?['companionMessage'];

        if (companionData != null) {
          final aiMessage = Messages(
            sId: companionData['id'] ??
                companionData['_id'] ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            conversationId:
            responseData['data']?['conversationId'] ?? conversationId,
            content: _extractReplyText(companionData['content']?.toString()),
            role: companionData['role'] ?? 'assistant',
            createdAt: companionData['createdAt'] ??
                DateTime.now().toIso8601String(),
          );

          addMessageLocally(aiMessage);
        }
      } else {
        _removeLocalMessage(tempId);
      }
    } catch (e, stack) {
      debugPrint('❌ Exception Caught in sendMessage: $e');
      _removeLocalMessage(tempId);

      int? statusCode;
      String rawResponseText = '';

      if (e is DioException) {
        statusCode = e.response?.statusCode;
        rawResponseText = e.response?.data?.toString() ?? '';
      }

      final String fullErrorString =
      '${e.toString()} $rawResponseText'.toUpperCase();

      debugPrint('🔍 Extracted StatusCode: $statusCode');
      debugPrint('📄 Full Error Text: $fullErrorString');

      final bool isLimitOrSubscriptionError = statusCode == 403 ||
          statusCode == 402 ||
          fullErrorString.contains('403') ||
          fullErrorString.contains('402') ||
          fullErrorString.contains('DAILY_LIMIT_REACHED') ||
          fullErrorString.contains('PAYMENT_REQUIRED') ||
          fullErrorString.contains('SUBSCRIBE') ||
          fullErrorString.contains('SUBSCRIPTION_REQUIRED_403') ||
          fullErrorString.contains('SOMETHING WENT WRONG') ||
          fullErrorString.contains('LIMIT');

      if (isLimitOrSubscriptionError) {
        debugPrint(
            '🔒 [LIMIT REACHED / 403 DETECTED] Redirecting to Subscription Screen...');

        final BuildContext? globalContext = rootNavigatorKey.currentContext;
        if (globalContext != null && globalContext.mounted) {
          globalContext.pushNamed('premium');
          debugPrint('✅ Navigated to Premium screen successfully!');
        } else {
          debugPrint('⚠️ Global context null or unmounted!');
        }
      } else {
        debugPrint('ℹ️ Generic error (Not a subscription or limit error).');
      }
    } finally {
      state = state.copyWith(isSending: false);
      debugPrint('================ 🏁 [sendMessage FINISHED] ================');
    }
  }

  // Companion Send Message API Call
  Future<void> sendMessageCompanion({
    required String characterId,
    required String conversationId,
    required String messageText,
  }) async {
    if (messageText.trim().isEmpty) return;

    final String tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    final userMessage = Messages(
      sId: tempId,
      conversationId: conversationId,
      content: messageText,
      role: 'user',
      createdAt: DateTime.now().toIso8601String(),
    );

    addMessageLocally(userMessage);
    state = state.copyWith(isSending: true);

    final Map<String, dynamic> requestData = {
      "companionId": characterId,
      "conversationId": conversationId,
      "message": messageText,
    };

    try {
      final response = await _repository.sendMsgCreated(requestData);

      final int? statusCode = response is Response
          ? response.statusCode
          : (response?['statusCode'] ?? 200);
      final dynamic responseData =
      response is Response ? response.data : response;

      if ((statusCode == 200 || statusCode == 201) &&
          responseData != null &&
          responseData['success'] == true) {
        final companionData = responseData['data']?['companionMessage'];

        if (companionData != null) {
          final aiMessage = Messages(
            sId: companionData['id'] ??
                companionData['_id'] ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            conversationId:
            responseData['data']?['conversationId'] ?? conversationId,
            content: _extractReplyText(companionData['content']?.toString()),
            role: companionData['role'] ?? 'assistant',
            createdAt: companionData['createdAt'] ??
                DateTime.now().toIso8601String(),
          );

          addMessageLocally(aiMessage);
        }
      } else {
        _removeLocalMessage(tempId);
      }
    } catch (e) {
      debugPrint("❌ Error sending companion message: $e");
      _removeLocalMessage(tempId);

      int? statusCode;
      String rawResponseText = '';

      if (e is DioException) {
        statusCode = e.response?.statusCode;
        rawResponseText = e.response?.data?.toString() ?? '';
      }

      final String fullErrorString =
      '${e.toString()} $rawResponseText'.toUpperCase();

      final bool isLimitOrSubscriptionError = statusCode == 403 ||
          statusCode == 402 ||
          fullErrorString.contains('403') ||
          fullErrorString.contains('402') ||
          fullErrorString.contains('DAILY_LIMIT_REACHED') ||
          fullErrorString.contains('PAYMENT_REQUIRED') ||
          fullErrorString.contains('SUBSCRIBE') ||
          fullErrorString.contains('SUBSCRIPTION_REQUIRED_403') ||
          fullErrorString.contains('SOMETHING WENT WRONG');

      if (isLimitOrSubscriptionError) {
        debugPrint(
            '🔒 [LIMIT REACHED / 403] Redirecting Companion Chat to Premium Screen...');

        final BuildContext? globalContext = rootNavigatorKey.currentContext;
        if (globalContext != null && globalContext.mounted) {
          globalContext.pushNamed('premium');
          debugPrint('✅ Navigated to Premium screen successfully!');
        } else {
          debugPrint('⚠️ Global context null or unmounted!');
        }
      }
    } finally {
      state = state.copyWith(isSending: false);
    }
  }

  // 🟢 Helper method: API failure ke case me temporary message local list se hatane ke liye
  void _removeRoleLocalMessage(String tempId) {
    state.roleChatInit.whenData((roleData) {
      if (roleData?.data?.messages != null) {
        final updatedList =
        roleData!.data!.messages!.where((m) => m.sId != tempId).toList();
        roleData.data!.messages = updatedList;
        state = state.copyWith(
          roleChatInit: AsyncValue.data(roleData),
        );
        debugPrint('🗑️ Removed temp message with ID: $tempId from UI state');
      }
    });
  }

  // 6️⃣ RolePlay Send Message API Call
  Future<void> sendMessageRoll({
    required String roleplayId,
    required String conversationId,
    required String sessionId,
    required String messageText,
  }) async {
    debugPrint(
        '================ 🚀 [SEND MESSAGE ROLL STARTED] ================');

    if (messageText.trim().isEmpty) return;

    final String tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    final userMessage = Messages(
      sId: tempId,
      conversationId: conversationId,
      content: messageText,
      role: 'user',
      createdAt: DateTime.now().toIso8601String(),
    );

    // 1️⃣ Optimistic Local Update
    addRoleMessageLocally(userMessage);
    state = state.copyWith(isSending: true);

    final Map<String, dynamic> requestData = {
      "conversationId": conversationId,
      "message": messageText,
      "roleplayId": roleplayId,
      "sessionId": sessionId,
    };

    try {
      final MassageRoleModel responseModel =
      await _repository.sendMsgRoll(requestData);

      if (responseModel.success == true && responseModel.data != null) {
        final companion = responseModel.data!.companionMessage;

        if (companion != null) {
          final String parsedContent = _extractReplyText(companion.content);

          final aiMessage = Messages(
            sId: companion.id ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            conversationId:
            responseModel.data!.conversationId ?? conversationId,
            content: parsedContent,
            role: companion.role ?? 'assistant',
            createdAt: companion.createdAt,
          );

          debugPrint('🤖 AI Response Added: "${aiMessage.content}"');
          addRoleMessageLocally(aiMessage);
        }
      } else {
        _removeRoleLocalMessage(tempId);
      }
    } catch (e, stack) {
      debugPrint('❌ Error sending message in sendMessageRoll: $e');
      debugPrint('🚨 StackTrace: $stack');

      _removeRoleLocalMessage(tempId);

      int? statusCode;
      String rawResponseText = '';

      if (e is DioException) {
        statusCode = e.response?.statusCode;
        rawResponseText = e.response?.data?.toString() ?? '';
      }

      final String fullErrorString =
      '${e.toString()} $rawResponseText'.toUpperCase();

      final bool isLimitOrSubscriptionError = statusCode == 403 ||
          statusCode == 402 ||
          fullErrorString.contains('403') ||
          fullErrorString.contains('402') ||
          fullErrorString.contains('DAILY_LIMIT_REACHED') ||
          fullErrorString.contains('PAYMENT_REQUIRED') ||
          fullErrorString.contains('SUBSCRIBE') ||
          fullErrorString.contains('SUBSCRIPTION_REQUIRED_403') ||
          fullErrorString.contains('SOMETHING WENT WRONG');

      if (isLimitOrSubscriptionError) {
        debugPrint(
            '🔒 [ROLEPLAY LIMIT REACHED / 403] Redirecting to Premium Screen...');

        final BuildContext? globalContext = rootNavigatorKey.currentContext;
        if (globalContext != null && globalContext.mounted) {
          globalContext.pushNamed('premium');
          debugPrint('✅ Navigated to Premium screen successfully!');
        } else {
          debugPrint('⚠️ Global context null or unmounted!');
        }
      }
    } finally {
      state = state.copyWith(isSending: false);
      debugPrint(
          '================ 🏁 [SEND MESSAGE ROLL ENDED] ================');
    }
  }

  // 7️⃣ Delete Single Chat Message / Conversation by ID
  Future<bool> deleteChat() async {
    debugPrint('================ 🚀 [deleteChat STARTED] ================');
    try {
      final response = await _repository.deleteChat();
      final int? statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        debugPrint('✅ [deleteChat SUCCESS]');
        _ref.read(featuresProvider.notifier).fetchConversationList();
        // Local state reset / clean up
        state = state.copyWith(
          chatInit: const AsyncValue.data(null),
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ [deleteChat ERROR]: $e');
      return false;
    }
  }

  // 8️⃣ Delete All Chats by Entity & ChatType (e.g. CHARACTER, ROLEPLAY, COMPANION)
  Future<bool> deleteAllChatByEntity({
    required String entityId,
    required String chatType,
  }) async {
    debugPrint(
        '================ 🚀 [deleteAllChatByEntity STARTED] ================');
    try {
      final response = await _repository.deleteChatAll(
        entityId: entityId,
        chatType: chatType,
      );

      final int? statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        debugPrint('✅ [deleteAllChatByEntity SUCCESS]');
        _ref.read(featuresProvider.notifier).fetchConversationList();
        // Clear corresponding local UI state
        if (chatType.toUpperCase() == 'ROLEPLAY') {
          state = state.copyWith(roleChatInit: const AsyncValue.data(null));
        } else {
          state = state.copyWith(chatInit: const AsyncValue.data(null));
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ [deleteAllChatByEntity ERROR]: $e');
      return false;
    }
  }
}