import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/home/provider/features_provider.dart';
import 'package:infinity_love/features/home/tab/chat_list.dart';

import '../../../core/constants/app_string.dart';
import '../tab/tab_bar.dart';
import 'model/conversation_model.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  static const Color pinkAccent = Color(0xFFE91E63);

  int selectedTabIndex = 0; // Default: 'Chats'
  final List<String> tabList = ['Chats', 'Role Play', 'Created'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        ref.read(featuresProvider.notifier).fetchConversationList();
      }
    });
  }

  // 🔄 Refresh handler function
  Future<void> _onRefresh() async {
    await ref.read(featuresProvider.notifier).fetchConversationList();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(featuresProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: SafeArea(
        // 🟢 RefreshIndicator wrapper with scrollable view support
        child: RefreshIndicator(
          color: pinkAccent,
          backgroundColor: const Color(0xFF1E1E1E),
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kBottomNavigationBarHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Title ---
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 16.0, bottom: 16.0),
                    child: Text(
                      'Messages',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // --- 1. TOP STORY AVATARS ---
                  SizedBox(
                    height: 95,
                    child: profileState.conversationList.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: pinkAccent),
                      ),
                      error: (error, stack) => const SizedBox.shrink(),
                      data: (ConversationModel? conversationModel) {
                        final items = conversationModel?.data?.items ?? [];

                        if (items.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          separatorBuilder: (context, index) =>
                          const SizedBox(width: 18),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return StoryAvatarItem(item: item);
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- 2. TAB FILTER BAR ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomTabPillBar(
                      tabs: tabList,
                      selectedIndex: selectedTabIndex,
                      onTabSelected: (index) {
                        setState(() {
                          selectedTabIndex = index;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- 3. FILTERED VERTICAL CHAT LIST (IndexedStack) ---
                  Expanded(
                    child: IndexedStack(
                      index: selectedTabIndex,
                      children: const [
                        // Tab 0: Character/Normal Chats
                        ChatListScreen(
                          filterChatType: "CHARACTER",
                        ),

                        // Tab 1: RolePlay Chats
                        ChatListScreen(
                          filterChatType: "ROLEPLAY",
                        ),

                        // Tab 2: Created / Empty State
                        ChatListScreen(
                          filterChatType: "COMPANION",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Dynamic Story Avatar Widget ---
class StoryAvatarItem extends StatelessWidget {
  final Items item;
  static const Color pinkAccent = Color(0xFFE91E63);

  const StoryAvatarItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.chatType?.toUpperCase() == 'ROLEPLAY') {
          context.pushNamed(
            'chatScreen2',
            extra: {
              'sId': item.chatEntityId ?? item.sId,
              'image': item.entityImage,
            },
          );
        } else {
          context.pushNamed(
            'chatScreen',
            extra: {
              'sId': item.chatEntityId ?? item.sId,
              'image': item.entityImage,
            },
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: pinkAccent, width: 2),
            ),
            child: SizedBox(
              width: 52,
              height: 52,
              child: ClipOval(
                child: (item.entityImage != null && item.entityImage!.isNotEmpty)
                    ? Image.network(
                  item.entityImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset("assets/22.png", fit: BoxFit.cover),
                )
                    : Image.asset("assets/22.png", fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 64,
            child: Text(
              item.entityName ?? AppStrings.defaultUnknown,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Empty State Card Component ---
class EmptyStateTabCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;

  const EmptyStateTabCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.iconData = Icons.settings,
  });

  static const Color pinkAccent = Color(0xFFE91E63);
  static const Color cardBg = Color(0xFF121212);
  static const Color cardBorder = Color(0xFF222222);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: cardBorder, width: 1.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: pinkAccent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}