import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/home/provider/features_provider.dart';

import '../../../core/constants/app_string.dart';
import '../../../core/constants/const_text.dart';
import '../../../extensions/context_extension.dart';
import '../model/conversation_model.dart';

class ChatListScreen2 extends ConsumerStatefulWidget {
  const ChatListScreen2({super.key});

  @override
  ConsumerState<ChatListScreen2> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen2> {
  static const Color pinkAccent = Color(0xFFE91E63);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(featuresProvider.notifier).fetchConversationList();
    });
  }

  // Time format karne ke liye simple helper method
  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(rawDate);
      final difference = DateTime.now().difference(dateTime);

      if (difference.inDays >= 7) {
        return '${(difference.inDays / 7).floor()}w ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(featuresProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: SafeArea(
        child: Column(
          children: [
            // --- Chat List Section ---
            Expanded(
              child: profileState.conversationList.when(
                // 1️⃣ Loading State
                loading: () =>  Center(
                  child: CupertinoActivityIndicator(color: pinkAccent),
                ),

                // 2️⃣ Error State
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText.regular(
                        AppStrings.failedToLoadProfiles,
                        color: Colors.white70,
                        fontSize: context.screenWidth * 0.04,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: context.screenHeight * 0.012),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pinkAccent,
                            padding: EdgeInsets.symmetric(
                              horizontal: context.screenWidth * 0.06,
                              vertical: context.screenHeight * 0.012,
                            ),
                          ),
                          onPressed: () {
                            ref
                                .read(featuresProvider.notifier)
                                .fetchConversationList();
                          },
                          child: Text(
                            AppStrings.retry,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: context.screenWidth * 0.035,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // 3️⃣ Data Success State
                data: (ConversationModel? conversationModel) {
                  final items = conversationModel?.data?.items ?? [];

                  if (items.isEmpty) {
                    return Center(
                      child: CustomText.regular(
                        AppStrings.noProfilesAvailable,
                        color: Colors.white54,
                        fontSize: context.screenWidth * 0.04,
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.04,
                      vertical: context.screenHeight * 0.02,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => SizedBox(
                      height: context.screenHeight * 0.025,
                    ),
                    itemBuilder: (context, index) {
                      final chatItem = items[index];
                      return _buildChatItem(chatItem, context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Dynamic Chat Tile Widget ---
  Widget _buildChatItem(Items item, BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed('modelProfile', extra: item.chatEntityId ?? item.sId);
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Avatar
            Container(
              width: context.screenWidth * 0.16,
              height: context.screenWidth * 0.16,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: (item.entityImage != null && item.entityImage!.isNotEmpty)
                    ? Image.network(
                  item.entityImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildFallbackImage(),
                )
                    : _buildFallbackImage(),
              ),
            ),
            SizedBox(width: context.screenWidth * 0.04),

            // Content Column (Name + Last Message)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row with Name and Time Stamp
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText.bold(
                          item.entityName ?? item.title ?? AppStrings.defaultUnknown,
                          fontSize: context.screenWidth * 0.045,
                          color: Colors.white,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      CustomText.regular(
                        _formatDate(item.lastMessageAt ?? item.updatedAt),
                        fontSize: context.screenWidth * 0.035,
                        color: Colors.white54,
                      ),
                    ],
                  ),
                  SizedBox(height: context.screenHeight * 0.006),

                  // Last Message Preview
                  CustomText.regular(
                    item.lastMessage ?? '',
                    fontSize: context.screenWidth * 0.038,
                    color: Colors.white70,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fallback Circular Image
  Widget _buildFallbackImage() {
    return Image.asset(
      "assets/22.png",
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[900],
        child: Icon(
          Icons.person,
          size: context.screenWidth * 0.08,
          color: Colors.white30,
        ),
      ),
    );
  }
}