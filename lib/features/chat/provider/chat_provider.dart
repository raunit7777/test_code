import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/service_locator.dart';
import '../../../routes/app_routes.dart';
import '../../home/provider/features_provider.dart';
import '../../home/state/features_state.dart';
import '../model/chat_init_model.dart';
import '../model/chat_init_role_model.dart';
import '../model/massage_model.dart';
import '../repo/chat_repo.dart';

final chatNotifierProvider =
    StateNotifierProvider<ChatNotifier, FeaturesState>((ref) {
  return ChatNotifier(sl<ChatRepository>(), ref);
});

class ChatNotifier extends StateNotifier<FeaturesState> {
  final ChatRepository _repository;
  final Ref _ref;
  final Uuid _uuid = const Uuid();

  // Active conversation ID tracker for state isolation across concurrent / late requests
  String? _activeConversationId;

  String? get activeConversationId => _activeConversationId;

  ChatNotifier(this._repository, this._ref) : super(const FeaturesState());

  // ---------------------------------------------------------------------------
  // 1️⃣ Simple Chat Initial Fetch
  // ---------------------------------------------------------------------------
  Future<void> fetchChatList(
    dynamic sId,
    dynamic name, {
    String? imageUrl,
  }) async {
    final String convId = sId.toString();
    _activeConversationId = convId;

    state = state.copyWith(chatInit: const AsyncValue.loading());

    try {
      final response = await _repository.chatInit(convId);

      // Verify conversation has not changed while waiting for network response
      if (_activeConversationId != convId) {
        debugPrint('⚠️ [fetchChatList] Discarding response for inactive conversation: $convId');
        return;
      }

      state = state.copyWith(chatInit: AsyncValue.data(response));

      if (response.success == true || response.data != null) {
        final BuildContext? globalContext = rootNavigatorKey.currentContext;
        if (globalContext != null && globalContext.mounted) {
          globalContext.pushNamed(
            'chatScreen',
            extra: {
              'sId': convId,
              'image': imageUrl ?? '',
              'name': name,
            },
          );
        }
      }
    } catch (e, stack) {
      if (_activeConversationId != convId) return;

      debugPrint('❌ [fetchChatList ERROR]: $e');
      state = state.copyWith(chatInit: AsyncValue.error(e, stack));
      _handlePaywallCheck(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Fetch Companion Chat List
  // ---------------------------------------------------------------------------
  Future<void> fetchChatListCompanion(
    dynamic sId, {
    BuildContext? context,
  }) async {
    final String convId = sId.toString();
    _activeConversationId = convId;

    state = state.copyWith(chatInit: const AsyncValue.loading());

    try {
      final response3 = await _repository.chatInitCreated(convId);

      if (_activeConversationId != convId) {
        debugPrint('⚠️ [fetchChatListCompanion] Discarding response for inactive conversation: $convId');
        return;
      }

      final mappedResponse = ChatInitModel.fromJson(response3.toJson());
      state = state.copyWith(chatInit: AsyncValue.data(mappedResponse));
    } catch (e, stack) {
      if (_activeConversationId != convId) return;

      state = state.copyWith(chatInit: AsyncValue.error(e, stack));
      _handlePaywallCheck(e, context: (context != null && context.mounted) ? context : null);
    }
  }

  // ---------------------------------------------------------------------------
  // 2️⃣ RolePlay Chat Initial Fetch
  // ---------------------------------------------------------------------------
  Future<void> fetchChatListRole(
    dynamic sId, {
    String? imageUrl,
    BuildContext? context,
  }) async {
    final String convId = sId.toString();
    _activeConversationId = convId;

    state = state.copyWith(roleChatInit: const AsyncValue.loading());

    try {
      final response = await _repository.chatInitRole(convId);

      if (_activeConversationId != convId) {
        debugPrint('⚠️ [fetchChatListRole] Discarding response for inactive conversation: $convId');
        return;
      }

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
            'roleplayChat',
            extra: {
              'sId': convId,
              'image': imageUrl ?? '',
            },
          );
        }
      }
    } catch (e, stack) {
      if (_activeConversationId != convId) return;

      debugPrint('❌ [fetchChatListRole ERROR]: $e');
      state = state.copyWith(roleChatInit: AsyncValue.error(e, stack));
      _handlePaywallCheck(e, context: (context != null && context.mounted) ? context : null);
    }
  }

  // ---------------------------------------------------------------------------
  // Local State Helpers with Active Conversation Isolation
  // ---------------------------------------------------------------------------
  void addMessageLocally(Messages newMessage) {
    if (newMessage.conversationId != null &&
        _activeConversationId != null &&
        newMessage.conversationId != _activeConversationId) {
      debugPrint('🛡️ [Isolation] Rejecting message append for inactive conversation: ${newMessage.conversationId}');
      return;
    }

    state.chatInit.whenData((chatData) {
      if (chatData != null && chatData.data != null) {
        final currentMessages = List<Messages>.from(chatData.data!.messages ?? []);

        final index = currentMessages.indexWhere((msg) =>
            (msg.clientMessageId != null && msg.clientMessageId == newMessage.clientMessageId) ||
            (msg.sId != null && msg.sId == newMessage.sId));

        if (index >= 0) {
          currentMessages[index] = newMessage;
        } else {
          currentMessages.add(newMessage);
        }

        chatData.data!.messages = currentMessages;
        state = state.copyWith(chatInit: AsyncValue.data(chatData));
      }
    });
  }

  void _markMessageFailed(String clientUuid, String conversationId) {
    state.chatInit.whenData((chatData) {
      if (chatData?.data?.messages != null) {
        final currentMessages = List<Messages>.from(chatData!.data!.messages!);
        final index = currentMessages.indexWhere((m) =>
            m.clientMessageId == clientUuid || m.sId == clientUuid);

        if (index >= 0) {
          currentMessages[index].status = MessageStatus.failed;
          chatData.data!.messages = currentMessages;
          state = state.copyWith(chatInit: AsyncValue.data(chatData));
          debugPrint('⚠️ [ChatProvider] Marked optimistic message as failed (UUID: $clientUuid)');
        }
      }
    });
  }

  void addRoleMessageLocally(dynamic newMessage) {
    final RoleChatMessage newMsg = _toRoleChatMessage(newMessage);

    if (newMsg.conversationId != null &&
        _activeConversationId != null &&
        newMsg.conversationId != _activeConversationId) {
      debugPrint('🛡️ [Isolation] Rejecting role message append for inactive conversation: ${newMsg.conversationId}');
      return;
    }

    state.roleChatInit.whenData((roleData) {
      if (roleData != null && roleData.data != null) {
        final currentMessages = List<RoleChatMessage>.from(roleData.data!.messages ?? []);

        final index = currentMessages.indexWhere((msg) =>
            (msg.clientMessageId != null && msg.clientMessageId == newMsg.clientMessageId) ||
            ((msg.sId ?? '').isNotEmpty && msg.sId == newMsg.sId));

        if (index >= 0) {
          currentMessages[index] = newMsg;
        } else {
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

        state = state.copyWith(roleChatInit: AsyncValue.data(updatedModel));
      }
    });
  }

  void _markRoleMessageFailed(String clientUuid, String conversationId) {
    state.roleChatInit.whenData((roleData) {
      if (roleData?.data?.messages != null) {
        final currentMessages = List<RoleChatMessage>.from(roleData!.data!.messages!);
        final index = currentMessages.indexWhere((m) =>
            m.clientMessageId == clientUuid || m.sId == clientUuid);

        if (index >= 0) {
          currentMessages[index].status = MessageStatus.failed;
          roleData.data!.messages = currentMessages;
          final updatedData = RoleChatData(
            conversationId: roleData.data!.conversationId,
            sessionId: roleData.data!.sessionId,
            messages: currentMessages,
            total: roleData.data!.total,
            isNew: roleData.data!.isNew,
          );
          state = state.copyWith(
            roleChatInit: AsyncValue.data(
              ChatInitRoleModel(
                success: roleData.success,
                data: updatedData,
                message: roleData.message,
              ),
            ),
          );
          debugPrint('⚠️ [ChatProvider] Marked role message as failed (UUID: $clientUuid)');
        }
      }
    });
  }

  // ---------------------------------------------------------------------------
  // 5️⃣ Simple Send Message API Call with Client-Generated UUID & Optimistic Update
  // ---------------------------------------------------------------------------
  Future<void> sendMessage({
    required String characterId,
    required String conversationId,
    required String messageText,
    String? existingClientMessageId,
  }) async {
    if (messageText.trim().isEmpty) return;

    _activeConversationId = conversationId;
    final String clientUuid = existingClientMessageId ?? _uuid.v4();

    final userMessage = Messages(
      sId: clientUuid,
      clientMessageId: clientUuid,
      conversationId: conversationId,
      content: messageText,
      role: 'user',
      createdAt: DateTime.now().toIso8601String(),
      status: MessageStatus.sending,
    );

    // Optimistic Update
    addMessageLocally(userMessage);
    state = state.copyWith(isSending: true);

    final Map<String, dynamic> requestData = {
      "characterId": characterId,
      "conversationId": conversationId,
      "message": messageText,
      "clientMessageId": clientUuid,
    };

    try {
      final response = await _repository.sendMsg(requestData);

      final int? statusCode = response is Response
          ? response.statusCode
          : (response?['statusCode'] ?? 200);
      final dynamic responseData = response is Response ? response.data : response;

      // Verify conversation is still active before appending response
      if (_activeConversationId != conversationId) {
        debugPrint('🛡️ [Isolation] Late response received for inactive conversation: $conversationId');
        return;
      }

      if ((statusCode == 200 || statusCode == 201) &&
          responseData != null &&
          responseData['success'] == true) {
        // Mark user message as sent
        userMessage.status = MessageStatus.sent;
        addMessageLocally(userMessage);

        final companionData = responseData['data']?['companionMessage'];
        if (companionData != null) {
          final aiMessage = Messages(
            sId: companionData['id'] ??
                companionData['_id'] ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            conversationId: responseData['data']?['conversationId'] ?? conversationId,
            content: _extractReplyText(companionData['content']?.toString()),
            role: companionData['role'] ?? 'assistant',
            createdAt: companionData['createdAt'] ?? DateTime.now().toIso8601String(),
            status: MessageStatus.sent,
          );

          addMessageLocally(aiMessage);
        }
      } else {
        // Failure: Preserve optimistic message and mark as failed
        _markMessageFailed(clientUuid, conversationId);
      }
    } catch (e) {
      debugPrint('❌ Exception Caught in sendMessage: $e');
      // Do NOT delete message on network failure: mark as failed for retry
      _markMessageFailed(clientUuid, conversationId);
      _handlePaywallCheck(e);
    } finally {
      state = state.copyWith(isSending: false);
    }
  }

  // ---------------------------------------------------------------------------
  // Companion Send Message API Call
  // ---------------------------------------------------------------------------
  Future<void> sendMessageCompanion({
    required String characterId,
    required String conversationId,
    required String messageText,
    String? existingClientMessageId,
  }) async {
    if (messageText.trim().isEmpty) return;

    _activeConversationId = conversationId;
    final String clientUuid = existingClientMessageId ?? _uuid.v4();

    final userMessage = Messages(
      sId: clientUuid,
      clientMessageId: clientUuid,
      conversationId: conversationId,
      content: messageText,
      role: 'user',
      createdAt: DateTime.now().toIso8601String(),
      status: MessageStatus.sending,
    );

    addMessageLocally(userMessage);
    state = state.copyWith(isSending: true);

    final Map<String, dynamic> requestData = {
      "companionId": characterId,
      "conversationId": conversationId,
      "message": messageText,
      "clientMessageId": clientUuid,
    };

    try {
      final response = await _repository.sendMsgCreated(requestData);

      final int? statusCode = response is Response
          ? response.statusCode
          : (response?['statusCode'] ?? 200);
      final dynamic responseData = response is Response ? response.data : response;

      if (_activeConversationId != conversationId) {
        debugPrint('🛡️ [Isolation] Late response received for inactive companion conversation: $conversationId');
        return;
      }

      if ((statusCode == 200 || statusCode == 201) &&
          responseData != null &&
          responseData['success'] == true) {
        userMessage.status = MessageStatus.sent;
        addMessageLocally(userMessage);

        final companionData = responseData['data']?['companionMessage'];
        if (companionData != null) {
          final aiMessage = Messages(
            sId: companionData['id'] ??
                companionData['_id'] ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            conversationId: responseData['data']?['conversationId'] ?? conversationId,
            content: _extractReplyText(companionData['content']?.toString()),
            role: companionData['role'] ?? 'assistant',
            createdAt: companionData['createdAt'] ?? DateTime.now().toIso8601String(),
            status: MessageStatus.sent,
          );

          addMessageLocally(aiMessage);
        }
      } else {
        _markMessageFailed(clientUuid, conversationId);
      }
    } catch (e) {
      debugPrint("❌ Error sending companion message: $e");
      _markMessageFailed(clientUuid, conversationId);
      _handlePaywallCheck(e);
    } finally {
      state = state.copyWith(isSending: false);
    }
  }

  // ---------------------------------------------------------------------------
  // 6️⃣ RolePlay Send Message API Call
  // ---------------------------------------------------------------------------
  Future<void> sendMessageRoll({
    required String roleplayId,
    required String conversationId,
    required String sessionId,
    required String messageText,
    String? existingClientMessageId,
  }) async {
    if (messageText.trim().isEmpty) return;

    _activeConversationId = conversationId;
    final String clientUuid = existingClientMessageId ?? _uuid.v4();

    final userMessage = RoleChatMessage(
      sId: clientUuid,
      clientMessageId: clientUuid,
      conversationId: conversationId,
      content: messageText,
      role: 'user',
      createdAt: DateTime.now().toIso8601String(),
      status: MessageStatus.sending,
    );

    addRoleMessageLocally(userMessage);
    state = state.copyWith(isSending: true);

    final Map<String, dynamic> requestData = {
      "conversationId": conversationId,
      "message": messageText,
      "roleplayId": roleplayId,
      "sessionId": sessionId,
      "clientMessageId": clientUuid,
    };

    try {
      final MassageRoleModel responseModel = await _repository.sendMsgRoll(requestData);

      if (_activeConversationId != conversationId) {
        debugPrint('🛡️ [Isolation] Late response received for inactive roleplay conversation: $conversationId');
        return;
      }

      if (responseModel.success == true && responseModel.data != null) {
        userMessage.status = MessageStatus.sent;
        addRoleMessageLocally(userMessage);

        final companion = responseModel.data!.companionMessage;
        if (companion != null) {
          final String parsedContent = _extractReplyText(companion.content);

          final aiMessage = RoleChatMessage(
            sId: companion.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
            conversationId: responseModel.data!.conversationId ?? conversationId,
            content: parsedContent,
            role: companion.role ?? 'assistant',
            createdAt: companion.createdAt,
            status: MessageStatus.sent,
          );

          addRoleMessageLocally(aiMessage);
        }
      } else {
        _markRoleMessageFailed(clientUuid, conversationId);
      }
    } catch (e) {
      debugPrint('❌ Error sending message in sendMessageRoll: $e');
      _markRoleMessageFailed(clientUuid, conversationId);
      _handlePaywallCheck(e);
    } finally {
      state = state.copyWith(isSending: false);
    }
  }

  // ---------------------------------------------------------------------------
  // Strict Paywall Guard: Only trigger on explicit backend status codes
  // ---------------------------------------------------------------------------
  void _handlePaywallCheck(dynamic e, {BuildContext? context}) {
    int? statusCode;
    String errorCode = '';

    if (e is DioException) {
      statusCode = e.response?.statusCode;
      final data = e.response?.data;
      if (data is Map) {
        errorCode = (data['code'] ?? data['errorCode'] ?? data['error'] ?? '').toString().toUpperCase();
      }
    }

    // Strict Paywall Detection: Explicit HTTP 402 or explicit backend error code
    final bool isSubscriptionRequired = statusCode == 402 ||
        errorCode == 'SUBSCRIPTION_REQUIRED' ||
        errorCode == 'DAILY_LIMIT_REACHED' ||
        errorCode == 'PAYMENT_REQUIRED';

    if (isSubscriptionRequired) {
      debugPrint('🔒 Explicit Paywall Triggered (HTTP $statusCode, Code: $errorCode)');
      final effectiveContext = context ?? rootNavigatorKey.currentContext;
      if (effectiveContext != null && effectiveContext.mounted) {
        effectiveContext.pushNamed('premium');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // 7️⃣ Delete Single Chat Message / Conversation by ID
  // ---------------------------------------------------------------------------
  Future<bool> deleteChat() async {
    try {
      final response = await _repository.deleteChat();
      final int? statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        _ref.read(featuresProvider.notifier).fetchConversationList();
        state = state.copyWith(chatInit: const AsyncValue.data(null));
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ [deleteChat ERROR]: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // 8️⃣ Delete All Chats by Entity & ChatType
  // ---------------------------------------------------------------------------
  Future<bool> deleteAllChatByEntity({
    required String entityId,
    required String chatType,
  }) async {
    try {
      final response = await _repository.deleteChatAll(
        entityId: entityId,
        chatType: chatType,
      );

      final int? statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        _ref.read(featuresProvider.notifier).fetchConversationList();
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

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
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
        status: msg.status,
        clientMessageId: msg.clientMessageId,
      );
    } else if (msg is Map) {
      return RoleChatMessage(
        sId: (msg['sId'] ?? msg['id'] ?? msg['_id'])?.toString(),
        conversationId: msg['conversationId']?.toString(),
        userId: msg['userId']?.toString(),
        role: msg['role']?.toString(),
        content: msg['content']?.toString(),
        createdAt: msg['createdAt']?.toString(),
        clientMessageId: msg['clientMessageId']?.toString(),
      );
    } else {
      return RoleChatMessage(
        sId: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'assistant',
        content: msg.toString(),
      );
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
      match ??= RegExp(r'"reply"\s*:\s*"(.*?)"\s*}\s*$', dotAll: true).firstMatch(content);

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
}
