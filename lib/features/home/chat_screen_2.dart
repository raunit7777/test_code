import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/chat/provider/chat_provider.dart';
import 'package:infinity_love/features/home/provider/features_provider.dart';
import '../../../core/constants/const_text.dart';
import '../chat/model/chat_init_model.dart';
import '../custmization/model_custmization.dart';
import '../custmization/model_language.dart';
import '../custmization/theam_screen.dart';

class ChatScreen2 extends ConsumerStatefulWidget {
  final String? sId;
  final String? imageUrl;

  const ChatScreen2({
    super.key,
    this.sId,
    this.imageUrl,
  });

  @override
  ConsumerState<ChatScreen2> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen2> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Color _currentThemeColor = AppColors.primaryPink;
  String _selectedLanguage = 'English';
  String _selectedPersonality = 'Playful & Caring';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.sId != null && widget.sId!.isNotEmpty) {
        // 1️⃣ Fetch Roleplay Character Details
        ref
            .read(featuresProvider.notifier)
            .fetchProfileDetailsRoleModel(widget.sId!);

        // 2️⃣ Fetch Roleplay Initial Messages/History
        ref.read(chatNotifierProvider.notifier).fetchChatListRole(widget.sId!);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final isSending = ref.read(chatNotifierProvider).isSending;
    if (isSending) return;

    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final roleChatData =
        ref.read(chatNotifierProvider).roleChatInit.value?.data;
    final String conversationId = roleChatData?.conversationId ?? '';
    final String sessionId = roleChatData?.sessionId ?? '';

    debugPrint(
        '🔍 [SEND CHECK] sId=${widget.sId} conversationId="$conversationId" sessionId="$sessionId" roleChatInit.value=${ref.read(chatNotifierProvider).roleChatInit.value}');

    if (widget.sId != null &&
        widget.sId!.isNotEmpty &&
        conversationId.isNotEmpty) {
      debugPrint('✅ [SEND CHECK] Calling sendMessageRoll (API path)');
      ref.read(chatNotifierProvider.notifier).sendMessageRoll(
        roleplayId: widget.sId!,
        conversationId: conversationId,
        sessionId: sessionId,
        messageText: text,
      );
    } else {
      debugPrint('⚠️ [SEND CHECK] LOCAL-ONLY path — API never called! conversationId empty ya sId missing hai.');
      final tempUserMsg = Messages(
        sId: DateTime.now().millisecondsSinceEpoch.toString(),
        content: text,
        role: 'user',
        createdAt: DateTime.now().toIso8601String(),
      );
      ref.read(chatNotifierProvider.notifier).addRoleMessageLocally(tempUserMsg);
    }

    _messageController.clear();
    _scrollToBottom();
  }

  void _showFullIntroModal(BuildContext context, dynamic profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final String imageToDisplay =
        (profile?.image != null && profile!.image!.isNotEmpty)
            ? profile.image!
            : (widget.imageUrl ?? '');

        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Color(0xFF0F0F12),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    CustomText.bold(
                      'Character Introduction',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      if (imageToDisplay.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _currentThemeColor,
                              width: 2.5,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(imageToDisplay),
                          ),
                        ),
                      const SizedBox(height: 12),
                      CustomText.bold(
                        profile?.name ?? 'Aarohi',
                        fontSize: 22,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      CustomText.bold(
                        'Role-PLAY Intro',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.menu_book_rounded,
                                    color: Colors.white70, size: 18),
                                const SizedBox(width: 8),
                                CustomText.bold(
                                  'Scene Setup (User Reads First)',
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            CustomText.regular(
                              profile?.storyIntro ?? '',
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.85),
                              height: 1.45,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (profile?.userRole != null &&
                          profile!.userRole!.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('🎭',
                                      style: TextStyle(fontSize: 16)),
                                  const SizedBox(width: 8),
                                  CustomText.bold(
                                    "User's Role",
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              CustomText.regular(
                                profile.userRole!,
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.85),
                                height: 1.4,
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B32EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: CustomText.bold(
                      'Start Chatting',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRolePlayTopCard(dynamic profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E172B).withOpacity(0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF6B3BA7).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: Color(0xFFB580FF), size: 16),
              const SizedBox(width: 6),
              CustomText.bold(
                'Role Play',
                fontSize: 14,
                color: const Color(0xFFB580FF),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.menu_book_rounded,
                  color: Colors.white70, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: CustomText.bold(
                  'Scene Setup (User Reads First)',
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  profile?.storyIntro ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => _showFullIntroModal(context, profile),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF331F52),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF7A43CB)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.aspect_ratio_rounded,
                          color: Color(0xFFC79CFF), size: 12),
                      const SizedBox(width: 4),
                      CustomText.medium(
                        'Full Intro',
                        fontSize: 11,
                        color: const Color(0xFFC79CFF),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF161618),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText.bold(
                          'Chat Settings',
                          fontSize: 20,
                          color: AppColors.textPrimaryLight,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white12, height: 20),
                    _buildSettingsTile(
                      icon: HugeIcons.strokeRoundedTranslate,
                      title: 'Partner Language',
                      subtitle: _selectedLanguage,
                      onTap: () async {
                        Navigator.pop(context);
                        final newLang = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectLanguageScreen(
                              initialLanguage: _selectedLanguage,
                            ),
                          ),
                        );
                        if (newLang != null) {
                          setState(() {
                            _selectedLanguage = newLang;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      icon: HugeIcons.strokeRoundedAiSetting,
                      title: 'AI Model Customization',
                      subtitle: _selectedPersonality,
                      onTap: () async {
                        Navigator.pop(context);
                        final personalityData = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const CustomizePersonalityScreen(),
                          ),
                        );
                        if (personalityData != null) {
                          setState(() {
                            if (personalityData['additionalTraits'] != null &&
                                (personalityData['additionalTraits'] as List)
                                    .isNotEmpty) {
                              _selectedPersonality =
                                  (personalityData['additionalTraits'] as List)
                                      .join(', ');
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      icon: HugeIcons.strokeRoundedPaintBrush01,
                      title: 'Chat Theme',
                      subtitle: 'Customize theme color',
                      onTap: () async {
                        Navigator.pop(context);
                        final newColor = await Navigator.push<Color>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomizeThemeScreen(
                              initialColor: _currentThemeColor,
                            ),
                          ),
                        );
                        if (newColor != null) {
                          setState(() {
                            _currentThemeColor = newColor;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _currentThemeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: CustomText.bold(
                          'Done',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingsTile({
    required dynamic icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            HugeIcon(
              icon: icon,
              color: _currentThemeColor,
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.medium(
                    title,
                    fontSize: 15,
                    color: AppColors.textPrimaryLight,
                  ),
                  const SizedBox(height: 2),
                  CustomText.regular(
                    subtitle,
                    fontSize: 12,
                    color: AppColors.textSecondaryLight,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white38,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.cardDarkBg,
      child: const Center(
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedUser,
          size: 80,
          color: AppColors.textSecondaryDark,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleDetailsState = ref.watch(featuresProvider).role;
    final profileData = roleDetailsState.value?.data;

    final roleChatState = ref.watch(chatNotifierProvider).roleChatInit;
    final bool isSending = ref.watch(chatNotifierProvider).isSending;

    final String name = profileData?.name ?? 'Partner';
    final String imageToDisplay =
    (profileData?.image != null && profileData!.image!.isNotEmpty)
        ? profileData.image!
        : (widget.imageUrl ?? '');
    final bool hasValidImage = imageToDisplay.isNotEmpty;

    // Auto-scroll on new message
    ref.listen(chatNotifierProvider, (previous, next) {
      _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: hasValidImage
                ? Image.network(
              imageToDisplay,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _buildPlaceholder(),
            )
                : _buildPlaceholder(),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.85),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColors.textPrimaryLight,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Profile Avatar
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _currentThemeColor,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.cardDarkBg,
                              backgroundImage: hasValidImage
                                  ? NetworkImage(imageToDisplay)
                                  : null,
                              child: !hasValidImage
                                  ? const Icon(
                                Icons.person,
                                size: 20,
                                color: Colors.white,
                              )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00FF66),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText.bold(
                              name,
                              fontSize: 16,
                              color: AppColors.textPrimaryLight,
                            ),
                            CustomText.regular(
                              'Online',
                              fontSize: 12,
                              color: const Color(0xFF00FF66),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () => _showSettingsBottomSheet(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: const Center(
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedSettings01,
                              color: AppColors.textPrimaryLight,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 1️⃣ TOP COLLAPSED ROLE PLAY CARD
                roleDetailsState.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (model) => _buildRolePlayTopCard(model?.data),
                ),

                // 2️⃣ CHAT MESSAGES LIST (SAFE DYNAMIC READING WITH NULL CHECKS)
                Expanded(
                  child: roleChatState.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    ),
                    error: (error, stack) => Center(
                      child: CustomText.medium(
                        'Failed to load role chat: $error',
                        color: Colors.white70,
                      ),
                    ),
                    data: (roleInitModel) {
                      final List<dynamic> messages =
                      (roleInitModel?.data?.messages ?? []).cast<dynamic>();

                      if (messages.isEmpty && !isSending) {
                        return Center(
                          child: CustomText.regular(
                            'Type a message to start roleplay! 🎭',
                            color: Colors.white54,
                          ),
                        );
                      }

                      return ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12,
                        ),
                        itemCount: messages.length + (isSending ? 1 : 0),
                        separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (isSending && index == messages.length) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E1E)
                                      .withOpacity(0.88),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    topRight: Radius.circular(18),
                                    bottomRight: Radius.circular(18),
                                    bottomLeft: Radius.circular(4),
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.12),
                                    width: 0.8,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF8B32EB),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    CustomText.regular(
                                      'Typing...',
                                      fontSize: 13,
                                      color: Colors.white70,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // 🟢 Safe Dynamic Role and Content Extraction
                          final dynamic msg = messages[index];
                          String role = '';
                          String content = '';

                          if (msg is Messages) {
                            role = msg.role ?? '';
                            content = msg.content ?? '';
                          } else if (msg is Map) {
                            role = msg['role'] ?? '';
                            content = msg['content'] ?? '';
                          } else {
                            try {
                              role = msg.role ?? '';
                              content = msg.content ?? '';
                            } catch (_) {}
                          }

                          final bool isMe = (role == 'user' ||
                              role == 'me' ||
                              role == 'human');

                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                MediaQuery.of(context).size.width * 0.78,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? const Color(0xFF8B32EB)
                                    : const Color(0xFF1C1C20).withOpacity(0.92),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(18),
                                  topRight: const Radius.circular(18),
                                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                                  bottomRight: Radius.circular(isMe ? 4 : 18),
                                ),
                                border: isMe
                                    ? null
                                    : Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 0.8,
                                ),
                              ),
                              child: CustomText.regular(
                                content,
                                fontSize: 14,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Bottom Input Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            readOnly: isSending,
                            style: TextStyle(
                              color: isSending
                                  ? Colors.white38
                                  : AppColors.textPrimaryLight,
                              fontSize: 15,
                            ),
                            onSubmitted: (_) =>
                            isSending ? null : _sendMessage(),
                            decoration: InputDecoration(
                              hintText: isSending
                                  ? 'Please wait...'
                                  : 'Type a message...',
                              hintStyle: const TextStyle(
                                color: AppColors.textSecondaryLight,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: GestureDetector(
                            onTap: isSending ? null : _sendMessage,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSending
                                    ? const Color(0xFF8B32EB).withOpacity(0.4)
                                    : const Color(0xFF8B32EB),
                              ),
                              child: Center(
                                child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedSent,
                                  color: isSending
                                      ? Colors.white38
                                      : AppColors.textPrimaryLight,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}