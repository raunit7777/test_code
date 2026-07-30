import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import '../../core/constants/const_text.dart';
import 'custmization/model_custmization.dart';
import 'custmization/model_language.dart';
import 'custmization/theam_screen.dart';

// Message Data Model
class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Theme Color State Variable
  Color _currentThemeColor = AppColors.primaryPink;

  // Settings State Variables
  String _selectedLanguage = 'English';
  String _selectedPersonality = 'Playful & Caring';

  // Chat Messages List
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hey there! It's so good to see you again. What's on your mind today? 😊",
      isMe: false,
      time: DateTime.now(),
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isMe: true,
          time: DateTime.now(),
        ),
      );
      _messageController.clear();
    });

    // Auto-scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
                    // Top Drag Handle
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

                    // 1. Language Option
                _buildSettingsTile(
                  icon: HugeIcons.strokeRoundedTranslate,
                  title: 'Partner Language',
                  subtitle: _selectedLanguage,
                  onTap: () async {
                    Navigator.pop(context); // Close bottom sheet

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
                        _selectedLanguage = newLang; // State me nayi language set ho jayegi
                      });
                    }
                  },
                ),

                    const SizedBox(height: 12),

                    // 2. AI Customization
                    // ChatScreen ke _showSettingsBottomSheet ke andar:

                    _buildSettingsTile(
                      icon: HugeIcons.strokeRoundedAiSetting,
                      title: 'AI Model Customization',
                      subtitle: _selectedPersonality, // e.g. "Custom Personality" ya traits summary
                      onTap: () async {
                        Navigator.pop(context); // Bottom sheet close karein

                        // Customize Personality Screen kholein aur return value ka wait karein
                        final personalityData = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomizePersonalityScreen(),
                          ),
                        );

                        if (personalityData != null) {
                          setState(() {
                            // Aap context/state ke according personality store kar sakte hain
                            // e.g. Agar list of traits mili hai toh subtitle update kar dein
                            if (personalityData['additionalTraits'] != null &&
                                (personalityData['additionalTraits'] as List).isNotEmpty) {
                              _selectedPersonality = (personalityData['additionalTraits'] as List).join(', ');
                            }
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    // 3. Theme Color Option
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

                    // Close Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _currentThemeColor, // Applied dynamic theme color
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
              color: _currentThemeColor, // Applied dynamic theme color
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

  void _showSelectionDialog(
      BuildContext context, {
        required String title,
        required List<String> options,
        required String currentValue,
        required Function(String) onSelect,
      }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF222224),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: CustomText.bold(title, fontSize: 18, color: Colors.white),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              final isSelected = option == currentValue;
              return ListTile(
                title: CustomText.medium(
                  option,
                  color: isSelected ? _currentThemeColor : Colors.white,
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: _currentThemeColor)
                    : null,
                onTap: () {
                  onSelect(option);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/21.png",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.cardDarkBg,
                child: const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    size: 80,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ),
            ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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

                      // Profile Avatar with Dynamic Accent Border
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _currentThemeColor, // Dynamic Theme Accent
                                width: 2,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage("assets/21.png"),
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
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                    itemCount: _messages.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Align(
                        alignment: message.isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: message.isMe
                                ? _currentThemeColor // 🟢 FIXED: Using selected theme color here
                                : const Color(0xFF1E1E1E).withOpacity(0.88),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: Radius.circular(message.isMe ? 18 : 4),
                              bottomRight: Radius.circular(message.isMe ? 4 : 18),
                            ),
                            border: message.isMe
                                ? null
                                : Border.all(
                              color: Colors.white.withOpacity(0.12),
                              width: 0.8,
                            ),
                          ),
                          child: CustomText.regular(
                            message.text,
                            fontSize: 14,
                            color: AppColors.textPrimaryLight,
                            height: 1.4,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Send Area
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
                            style: const TextStyle(
                              color: AppColors.textPrimaryLight,
                              fontSize: 15,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(
                                color: AppColors.textSecondaryLight,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        // Send Button
                        Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: GestureDetector(
                            onTap: _sendMessage,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentThemeColor, // 🟢 FIXED: Using selected theme color here
                              ),
                              child: const Center(
                                child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedSent,
                                  color: AppColors.textPrimaryLight,
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