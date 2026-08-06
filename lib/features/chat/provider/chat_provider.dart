// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:infinity_love/features/chat/model/chat_init_model.dart';
// import 'package:infinity_love/features/chat/model/chat_init_role_model.dart';
// import '../../../../core/di/service_locator.dart';
// import '../../home/state/features_state.dart';
// import '../model/massage_model.dart';
// import '../repo/chat_repo.dart';
// import 'package:go_router/go_router.dart';
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
//   Future<void> fetchChatList(dynamic sId, {BuildContext? context}) async {
//     debugPrint('================ 🚀 [fetchChatList STARTED] ================');
//     state = state.copyWith(chatInit: const AsyncValue.loading());
//
//     try {
//       final response = await _repository.chatInit(sId.toString());
//       state = state.copyWith(chatInit: AsyncValue.data(response));
//       debugPrint('✅ [fetchChatList SUCCESS]');
//     } catch (e, stack) {
//       debugPrint('❌ [fetchChatList ERROR]: $e');
//       state = state.copyWith(chatInit: AsyncValue.error(e, stack));
//
//       final String errText = e.toString().toUpperCase();
//
//       // Flexible 402 / Payment match logic
//       final bool is402 = errText.contains('402') ||
//           errText.contains('PAYMENT_REQUIRED') ||
//           errText.contains('SUBSCRIBED') ||
//           errText.contains('SOMETHING WENT WRONG'); // ApiClient fallback match
//
//       if (is402) {
//         debugPrint('🔒 402 Payment Required match found!');
//
//         if (context != null && context.mounted) {
//           debugPrint('🔀 Navigating to Premium Screen...');
//           context.pushNamed('premium');
//         } else {
//           debugPrint('⚠️ Navigation Context missing or not mounted.');
//         }
//       }
//     }
//   }
//
//   Future<void> fetchChatListCompanion(dynamic sId) async {
//     state = state.copyWith(chatInit: const AsyncValue.loading());
//     try {
//       final response = await _repository.chatInitCreated(sId.toString());
//       state = state.copyWith(chatInit: AsyncValue.data(response));
//     } catch (e, stack) {
//       state = state.copyWith(chatInit: AsyncValue.error(e, stack));
//     }
//   }
//
//   // 2️⃣ RolePlay Chat Initial Fetch
//   Future<void> fetchChatListRole(dynamic sId) async {
//     state = state.copyWith(roleChatInit: const AsyncValue.loading());
//     try {
//       final response = await _repository.chatInitRole(sId.toString());
//
//       // 🔧 FIX: history se aane wale purane messages me bhi kabhi-kabhi
//       // content stringified JSON ({"reply": "...", ...}) ke roop me aata hai.
//       // Yaha history load hote hi sab messages ko clean kar dete hain
//       // taaki purani chats bhi sahi text dikhayein, raw JSON nahi.
//       if (response.data?.messages != null) {
//         for (final msg in response.data!.messages!) {
//           msg.content = _extractReplyText(msg.content);
//         }
//       }
//
//       state = state.copyWith(roleChatInit: AsyncValue.data(response));
//     } catch (e, stack) {
//       state = state.copyWith(roleChatInit: AsyncValue.error(e, stack));
//     }
//   }
//
//   // 3️⃣ Simple Chat Local Message Append
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
//   // 4️⃣ 🟢 RolePlay Chat Local Message Append (Force UI Re-render)
//   // 🔧 FIX: pehle ye function alag-alag types (Messages / RoleChatMessage / Map)
//   // ko ek hi List<dynamic> me daal ke fir ChatInitRoleModel.fromJson(roleData.toJson())
//   // call karta tha. toJson() jab kisi non-RoleChatMessage object pe call hota tha
//   // to runtime TypeError aata tha, jo silently catch ho jaata tha aur UI update
//   // hi nahi hota tha. Ab hum sab kuch RoleChatMessage me normalize karte hain
//   // aur naya model bina JSON round-trip ke seedha bana dete hain.
//   void addRoleMessageLocally(dynamic newMessage) {
//     state.roleChatInit.whenData((roleData) {
//       if (roleData != null && roleData.data != null) {
//         final currentMessages =
//         List<RoleChatMessage>.from(roleData.data!.messages ?? []);
//
//         // 🔧 Kisi bhi input type (Messages / RoleChatMessage / Map) ko
//         // safely RoleChatMessage me convert karo
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
//   // 🔧 Helper: har tarah ke message object ko RoleChatMessage me convert karta hai
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
//       // fallback: dynamic getter access
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
//     // 🟢 FIX: Asterisks (*) wali lines remove karke sirf spoken reply nikalna
//     return _extractDialogueOnly(extractedResult);
//   }
//
//   String _extractDialogueOnly(String fullText) {
//     if (fullText.isEmpty) return fullText;
//
//     // 1. Regex jo '*' se start aur '*' pe end hone wale saare blocks ko remove karega (dotAll: true for newlines)
//     String cleanedText = fullText.replaceAll(
//       RegExp(r'\*.*?\*', dotAll: true),
//       '',
//     );
//
//     // 2. Multiline empty spaces aur newlines ko single clean line/paragraph me normalize karein
//     cleanedText = cleanedText
//         .split('\n')
//         .map((line) => line.trim())
//         .where((line) => line.isNotEmpty)
//         .join('\n\n');
//
//     return cleanedText.trim();
//   }
//   // 5️⃣ Simple Send Message API Call
//   Future<void> sendMessage({
//     required String characterId,
//     required String conversationId,
//     required String messageText,
//   }) async {
//     final String tempId = DateTime.now().millisecondsSinceEpoch.toString();
//     final userMessage = Messages(
//       sId: tempId,
//       conversationId: conversationId,
//       content: messageText,
//       role: 'user',
//       createdAt: DateTime.now().toIso8601String(),
//     );
//     addMessageLocally(userMessage);
//
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
//       if (response != null && response['success'] == true) {
//         final companionData = response['data']?['companionMessage'];
//
//         if (companionData != null) {
//           final aiMessage = Messages(
//             sId: companionData['id'] ??
//                 companionData['_id'] ??
//                 DateTime.now().millisecondsSinceEpoch.toString(),
//             conversationId:
//             response['data']?['conversationId'] ?? conversationId,
//             content: _extractReplyText(companionData['content']?.toString()),
//             role: companionData['role'] ?? 'assistant',
//             createdAt: companionData['createdAt'],
//           );
//
//           addMessageLocally(aiMessage);
//         }
//       }
//     } catch (e) {
//       debugPrint("Error sending message: $e");
//     } finally {
//       state = state.copyWith(isSending: false);
//     }
//   }
//
//
//
//   Future<void> sendMessageCompanion({
//     required String characterId,
//     required String conversationId,
//     required String messageText,
//
//   }) async {
//     if (messageText.trim().isEmpty) return;
// print("rammmm${conversationId}");
//     // 🟢 1. Temporary unique ID generated for Optimistic Update
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
//     // 🟢 2. Add message locally instantly (Screen par turant show hoga)
//     addMessageLocally(userMessage);
//
//     state = state.copyWith(isSending: true);
//
//     final Map<String, dynamic> requestData = {
//       "companionId": characterId,
//       "conversationId": conversationId,
//       "message": messageText,
//     };
//
//     try {
//       // 🟢 3. Call API
//       final response = await _repository.sendMsgCreated(requestData);
//
//       if (response != null && response['success'] == true) {
//         final companionData = response['data']?['companionMessage'];
//
//         if (companionData != null) {
//           final aiMessage = Messages(
//             sId: companionData['id'] ??
//                 companionData['_id'] ??
//                 DateTime.now().millisecondsSinceEpoch.toString(),
//             conversationId:
//             response['data']?['conversationId'] ?? conversationId,
//             content: _extractReplyText(companionData['content']?.toString()),
//             role: companionData['role'] ?? 'assistant',
//             createdAt: companionData['createdAt'] ?? DateTime.now().toIso8601String(),
//           );
//
//           // 🟢 4. Add Companion's response locally
//           addMessageLocally(aiMessage);
//         }
//       } else {
//         // API returned success = false -> Revert optimistic message
//         _removeLocalMessage(tempId);
//       }
//     } catch (e) {
//       debugPrint("❌ Error sending companion message: $e");
//       // API Failed -> Revert temporary message from UI
//       _removeLocalMessage(tempId);
//     } finally {
//       state = state.copyWith(isSending: false);
//     }
//   }
//
// // 🟢 Helper to remove temp message if API fails
//   void _removeLocalMessage(String tempId) {
//     final updatedList = state.messages.where((m) => m.sId != tempId).toList();
//     state = state.copyWith(messages: updatedList);
//   }
//
//   // 6️⃣ 🟢 RolePlay Send Message API Call
//   Future<void> sendMessageRoll({
//     required String roleplayId,
//     required String conversationId,
//     required String sessionId,
//     required String messageText,
//   }) async {
//     debugPrint('================ 🚀 [SEND MESSAGE ROLL STARTED] ================');
//     final String tempId = DateTime.now().millisecondsSinceEpoch.toString();
//
//     final userMessage = Messages(
//       sId: tempId,
//       conversationId: conversationId,
//       content: messageText,
//       role: 'user',
//       createdAt: DateTime.now().toIso8601String(),
//     );
//
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
//           // 🔧 FIX: backend content stringified JSON bhejta hai
//           // ({"reply": "...", "language": "...", "intent": "..."}),
//           // usme se actual "reply" text nikaalte hain
//           final String parsedContent = _extractReplyText(companion.content);
//
//           debugPrint(
//               '🔎 [PARSE CHECK] raw content len=${companion.content?.length}, parsed len=${parsedContent.length}');
//
//           final aiMessage = Messages(
//             sId: companion.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
//             conversationId: responseModel.data!.conversationId ?? conversationId,
//             content: parsedContent, // 👈 ab yaha "parsedContent" use ho raha hai, raw JSON nahi
//             role: companion.role ?? 'assistant',
//             createdAt: companion.createdAt,
//           );
//
//           debugPrint('🤖 AI Response Added: "${aiMessage.content}"');
//           addRoleMessageLocally(aiMessage);
//         }
//       }
//     } catch (e, stack) {
//       debugPrint('❌ Error sending message: $e');
//       debugPrint('🚨 StackTrace: $stack');
//     } finally {
//       state = state.copyWith(isSending: false);
//       debugPrint('================ 🏁 [SEND MESSAGE ROLL ENDED] ================');
//     }
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:infinity_love/features/chat/model/chat_init_model.dart';
import 'package:infinity_love/features/chat/model/chat_init_role_model.dart';
import '../../../../core/di/service_locator.dart';
import '../../../routes/app_routes.dart';
import '../../home/state/features_state.dart';
import '../model/massage_model.dart';
import '../repo/chat_repo.dart';

final chatNotifierProvider =
StateNotifierProvider<ChatNotifier, FeaturesState>((ref) {
  return ChatNotifier(sl<ChatRepository>());
});

class ChatNotifier extends StateNotifier<FeaturesState> {
  final ChatRepository _repository;

  ChatNotifier(this._repository) : super(const FeaturesState());

  // 1️⃣ Simple Chat Initial Fetch
  Future<void> fetchChatList(dynamic sId, {String? imageUrl}) async {
    debugPrint('================ 🚀 [fetchChatList STARTED] ================');
    state = state.copyWith(chatInit: const AsyncValue.loading());

    try {
      final response = await _repository.chatInit(sId.toString());

      // 1️⃣ State data me store karein
      state = state.copyWith(chatInit: AsyncValue.data(response));
      debugPrint('✅ [fetchChatList SUCCESS]');

      // 2️⃣ 🟢 200 ya 201 Success Response Check & Navigation
      if (response != null && (response.success == true || response.data != null)) {
        debugPrint('🔀 [SUCCESS 200/201] Navigating to chatScreen via Global Key...');

        final BuildContext? globalContext = rootNavigatorKey.currentContext;

        if (globalContext != null && globalContext.mounted) {
          globalContext.pushNamed(
            'chatScreen',
            extra: {
              'sId': sId.toString(),
              'image': imageUrl ?? '', // Dynamic Image URL pass
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
        debugPrint('🔒 402 Payment Required match found! Global Key Redirecting...');

        // 🟢 402 Redirection to Premium Screen
        rootNavigatorKey.currentContext?.pushNamed('premium');
      }
    }
  }

  // Fetch Companion Chat List
  Future<void> fetchChatListCompanion(dynamic sId, {BuildContext? context}) async {
    state = state.copyWith(chatInit: const AsyncValue.loading());
    try {
      final response = await _repository.chatInitCreated(sId.toString());
      state = state.copyWith(chatInit: AsyncValue.data(response));
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
  Future<void> fetchChatListRole(dynamic sId, {String? imageUrl, BuildContext? context}) async {
    debugPrint('================ 🚀 [fetchChatListRole STARTED] ================');
    state = state.copyWith(roleChatInit: const AsyncValue.loading());

    try {
      final response = await _repository.chatInitRole(sId.toString());

      // 1️⃣ Content parsing
      if (response.data?.messages != null) {
        for (final msg in response.data!.messages!) {
          msg.content = _extractReplyText(msg.content);
        }
      }

      // 2️⃣ State update
      state = state.copyWith(roleChatInit: AsyncValue.data(response));


      // 3️⃣ 🟢 200/201 Success Response Navigation to chatScreen2
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
        debugPrint('🔒 402 Payment Required match found! Global Key Redirecting...');

        // 🟢 402 Redirection via Global Key Context
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
    final String tempId = DateTime.now().millisecondsSinceEpoch.toString();
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
      "characterId": characterId,
      "conversationId": conversationId,
      "message": messageText,
    };

    try {
      final response = await _repository.sendMsg(requestData);

      if (response != null && response['success'] == true) {
        final companionData = response['data']?['companionMessage'];

        if (companionData != null) {
          final aiMessage = Messages(
            sId: companionData['id'] ??
                companionData['_id'] ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            conversationId:
            response['data']?['conversationId'] ?? conversationId,
            content: _extractReplyText(companionData['content']?.toString()),
            role: companionData['role'] ?? 'assistant',
            createdAt: companionData['createdAt'],
          );

          addMessageLocally(aiMessage);
        }
      }
    } catch (e) {
      debugPrint("Error sending message: $e");
    } finally {
      state = state.copyWith(isSending: false);
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

      if (response != null && response['success'] == true) {
        final companionData = response['data']?['companionMessage'];

        if (companionData != null) {
          final aiMessage = Messages(
            sId: companionData['id'] ??
                companionData['_id'] ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            conversationId:
            response['data']?['conversationId'] ?? conversationId,
            content: _extractReplyText(companionData['content']?.toString()),
            role: companionData['role'] ?? 'assistant',
            createdAt:
            companionData['createdAt'] ?? DateTime.now().toIso8601String(),
          );

          addMessageLocally(aiMessage);
        }
      } else {
        _removeLocalMessage(tempId);
      }
    } catch (e) {
      debugPrint("❌ Error sending companion message: $e");
      _removeLocalMessage(tempId);
    } finally {
      state = state.copyWith(isSending: false);
    }
  }

  // Helper to remove temp message if API fails
  void _removeLocalMessage(String tempId) {
    state.chatInit.whenData((chatData) {
      if (chatData?.data?.messages != null) {
        final updatedList = chatData!.data!.messages!
            .where((m) => m.sId != tempId)
            .toList();
        chatData.data!.messages = updatedList;
        state = state.copyWith(
          chatInit: AsyncValue.data(chatData),
        );
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
    debugPrint('================ 🚀 [SEND MESSAGE ROLL STARTED] ================');
    final String tempId = DateTime.now().millisecondsSinceEpoch.toString();

    final userMessage = Messages(
      sId: tempId,
      conversationId: conversationId,
      content: messageText,
      role: 'user',
      createdAt: DateTime.now().toIso8601String(),
    );

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
            sId: companion.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
            conversationId:
            responseModel.data!.conversationId ?? conversationId,
            content: parsedContent,
            role: companion.role ?? 'assistant',
            createdAt: companion.createdAt,
          );

          debugPrint('🤖 AI Response Added: "${aiMessage.content}"');
          addRoleMessageLocally(aiMessage);
        }
      }
    } catch (e, stack) {
      debugPrint('❌ Error sending message: $e');
      debugPrint('🚨 StackTrace: $stack');
    } finally {
      state = state.copyWith(isSending: false);
      debugPrint('================ 🏁 [SEND MESSAGE ROLL ENDED] ================');
    }
  }
}