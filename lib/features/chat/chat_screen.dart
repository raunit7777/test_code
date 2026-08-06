


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/chat/provider/chat_provider.dart';
import '../../../core/constants/const_text.dart';
import '../../core/constants/typing_loader.dart';
import '../custmization/model_custmization.dart';
import '../custmization/model_language.dart';
import '../custmization/theam_screen.dart';
import 'model/chat_init_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String? sId;
  final String? imageUrl; // Passed network image URL

  const ChatScreen({
    super.key,
    this.sId,
    this.imageUrl,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Theme Color State Variable
  Color _currentThemeColor = AppColors.primaryPink;

  // Settings State Variables
  String _selectedLanguage = 'English';
  String _selectedPersonality = 'Playful & Caring';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // if (widget.sId != null && widget.sId!.isNotEmpty) {
      //   ref.read(chatNotifierProvider.notifier).fetchChatList(widget.sId!);
      // }
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
    // 🔴 Block duplicate sends if a request is already pending
    if (isSending) return;

    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final chatData = ref.read(chatNotifierProvider).chatInit.value?.data;
    final String conversationId = chatData?.conversationId ?? '';

    if (widget.sId != null && widget.sId!.isNotEmpty && conversationId.isNotEmpty) {
      ref.read(chatNotifierProvider.notifier).sendMessage(
        characterId: widget.sId!,
        conversationId: conversationId,
        messageText: text,
      );
    } else {
      final newMessage = Messages(
        sId: DateTime.now().millisecondsSinceEpoch.toString(),
        content: text,
        role: 'user',
        createdAt: DateTime.now().toIso8601String(),
      );
      ref.read(chatNotifierProvider.notifier).addMessageLocally(newMessage);
    }

    _messageController.clear();
    _scrollToBottom();
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
    final chatState = ref.watch(chatNotifierProvider).chatInit;
    final bool isSending = ref.watch(chatNotifierProvider).isSending;
    final bool hasValidImage =
        widget.imageUrl != null && widget.imageUrl!.isNotEmpty;

    // Auto scroll when message list or sending status changes
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
              widget.imageUrl!,
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
                    Colors.transparent,
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
                      horizontal: 12.0, vertical: 8.0),
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
                                  ? NetworkImage(widget.imageUrl!)
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
                              'Ayushi',
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
                        onTap: () {},
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: const Center(
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedDice,
                              color: AppColors.textPrimaryLight,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

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

                // Messages List
                Expanded(
                  child: chatState.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    ),
                    error: (error, stack) => Center(
                      child: CustomText.medium(
                        'Failed to load chats: $error',
                        color: Colors.white70,
                      ),
                    ),
                    data: (chatModel) {
                      final messages = chatModel?.data?.messages ?? [];

                      if (messages.isEmpty && !isSending) {
                        return Center(
                          child: CustomText.regular(
                            'Say hi to start conversation! 😊',
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
                          // Typing Loader item when waiting for API response
                          if (isSending && index == messages.length) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E1E).withOpacity(0.88),
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
                                child: TypingIndicator(
                                  dotColor: _currentThemeColor, // Ya direct Colors.white70 bhi de sakte hain
                                  dotSize: 7.0,
                                ),
                              ),
                            );
                          }

                          final msg = messages[index];
                          final bool isMe = (msg.role == 'user' ||
                              msg.role == 'me' ||
                              msg.role == 'human');

                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                MediaQuery.of(context).size.width * 0.75,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? _currentThemeColor
                                    : const Color(0xFF1E1E1E)
                                    .withOpacity(0.88),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(18),
                                  topRight: const Radius.circular(18),
                                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                                  bottomRight: Radius.circular(isMe ? 4 : 18),
                                ),
                                border: isMe
                                    ? null
                                    : Border.all(
                                  color: Colors.white.withOpacity(0.12),
                                  width: 0.8,
                                ),
                              ),
                              child: CustomText.regular(
                                msg.content ?? '',
                                fontSize: 14,
                                color: AppColors.textPrimaryLight,
                                height: 1.4,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Bottom Send Area (Blocked when isSending is True)
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
                            // 🟢 Disable input field while response is loading
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
                            // 🟢 Ignore tap while response is loading
                            onTap: isSending ? null : _sendMessage,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // 🟢 Reduced opacity when disabled
                                color: isSending
                                    ? _currentThemeColor.withOpacity(0.4)
                                    : _currentThemeColor,
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