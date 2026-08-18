// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:go_router/go_router.dart';
// // import 'package:infinity_love/core/constants/app_color.dart';
// // import 'package:infinity_love/features/home/provider/features_provider.dart';
// // import '../../../core/constants/app_string.dart';
// // import '../../../core/constants/const_text.dart';
// // import '../../../extensions/context_extension.dart';
// // import '../../chat/provider/chat_provider.dart';
// // import '../model/conversation_model.dart';
// //
// // class ChatListScreen extends ConsumerStatefulWidget {
// //   final String? filterChatType; // 🟢 Example: "CHARACTER", "ROLEPLAY", "COMPANION"
// //
// //   const ChatListScreen({
// //     super.key,
// //     this.filterChatType,
// //   });
// //
// //   @override
// //   ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
// // }
// //
// // class _ChatListScreenState extends ConsumerState<ChatListScreen> {
// //   static const Color pinkAccent = Color(0xFFE91E63);
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     Future.microtask(() {
// //       if (mounted) {
// //         ref.read(featuresProvider.notifier).fetchConversationList();
// //       }
// //     });
// //   }
// //
// //   String _formatDate(String? rawDate) {
// //     if (rawDate == null || rawDate.isEmpty) return '';
// //     try {
// //       final dateTime = DateTime.parse(rawDate);
// //       final difference = DateTime.now().difference(dateTime);
// //
// //       if (difference.inDays >= 7) {
// //         return '${(difference.inDays / 7).floor()}w ago';
// //       } else if (difference.inDays > 0) {
// //         return '${difference.inDays}d ago';
// //       } else if (difference.inHours > 0) {
// //         return '${difference.inHours}h ago';
// //       } else if (difference.inMinutes > 0) {
// //         return '${difference.inMinutes}m ago';
// //       } else {
// //         return 'Just now';
// //       }
// //     } catch (_) {
// //       return '';
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final profileState = ref.watch(featuresProvider);
// //
// //     return Scaffold(
// //       backgroundColor: AppColors.bgBlack,
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             Expanded(
// //               child: profileState.conversationList.when(
// //                 loading: () =>  Center(
// //                   child: CupertinoActivityIndicator(color: pinkAccent),
// //                 ),
// //                 error: (error, stack) => Center(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       CustomText.regular(
// //                         AppStrings.failedToLoadProfiles,
// //                         color: Colors.white70,
// //                         fontSize: context.screenWidth * 0.04,
// //                       ),
// //                       Padding(
// //                         padding: EdgeInsets.only(top: context.screenHeight * 0.012),
// //                         child: ElevatedButton(
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: pinkAccent,
// //                             padding: EdgeInsets.symmetric(
// //                               horizontal: context.screenWidth * 0.06,
// //                               vertical: context.screenHeight * 0.012,
// //                             ),
// //                           ),
// //                           onPressed: () {
// //                             ref
// //                                 .read(featuresProvider.notifier)
// //                                 .fetchConversationList();
// //                           },
// //                           child: Text(
// //                             AppStrings.retry,
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontSize: context.screenWidth * 0.035,
// //                             ),
// //                           ),
// //                         ),
// //                       )
// //                     ],
// //                   ),
// //                 ),
// //                 data: (ConversationModel? conversationModel) {
// //                   final rawItems = conversationModel?.data?.items ?? [];
// //
// //                   final items = widget.filterChatType == null
// //                       ? rawItems
// //                       : rawItems
// //                       .where((element) =>
// //                   element.chatType?.toUpperCase() ==
// //                       widget.filterChatType?.toUpperCase())
// //                       .toList();
// //
// //                   if (items.isEmpty) {
// //                     return Center(
// //                       child: CustomText.regular(
// //                         AppStrings.noProfilesAvailable,
// //                         color: Colors.white54,
// //                         fontSize: context.screenWidth * 0.04,
// //                       ),
// //                     );
// //                   }
// //
// //                   return ListView.separated(
// //                     padding: EdgeInsets.symmetric(
// //                       horizontal: context.screenWidth * 0.04,
// //                       vertical: context.screenHeight * 0.02,
// //                     ),
// //                     itemCount: items.length,
// //                     separatorBuilder: (context, index) => SizedBox(
// //                       height: context.screenHeight * 0.025,
// //                     ),
// //                     itemBuilder: (context, index) {
// //                       final chatItem = items[index];
// //                       return _buildChatItem(chatItem, context);
// //                     },
// //                   );
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildChatItem(Items item, BuildContext context) {
// //     // 🟢 Clean name extraction ("Chat with Aanya" -> "Aanya")
// //     final String rawName = item.entityName ?? item.title ?? AppStrings.defaultUnknown;
// //     final String cleanName = rawName.replaceFirst(RegExp(r'^Chat with\s+', caseSensitive: false), '');
// //
// //     return InkWell(
// //       onTap: () {
// //         final String chatType = item.chatType?.toUpperCase() ?? '';
// //         final String entityId = item.chatEntityId ?? item.sId ?? '';
// //         final String entityId2 = item.companionId?.sId ?? item.sId ?? '';
// //         final String? entityImage = item.entityImage;
// //
// //         // 🟢 Chat Type ke hisab se specific API Call aur Navigation
// //         if (chatType == 'ROLEPLAY') {
// //           ref.read(chatNotifierProvider.notifier).fetchChatListRole(
// //             entityId,
// //             imageUrl: entityImage,
// //             context: context,
// //           );
// //         } else if (chatType == 'COMPANION') {
// //           ref.read(chatNotifierProvider.notifier).fetchChatListCompanion(
// //             entityId2,
// //             context: context,
// //           );
// //           context.pushNamed(
// //             'chatScreen3',
// //             extra: {
// //               'sId': entityId2,
// //               'image': entityImage,
// //               'name': cleanName,
// //             },
// //           );
// //         } else {
// //           // 🟢 Handles CHARACTER or Default Cases
// //           ref.read(chatNotifierProvider.notifier).fetchChatList(
// //             entityId,
// //             cleanName,
// //             imageUrl: entityImage,
// //           );
// //         }
// //       },
// //       borderRadius: BorderRadius.circular(12),
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(vertical: 4.0),
// //         child: Row(
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: [
// //             Container(
// //               width: context.screenWidth * 0.16,
// //               height: context.screenWidth * 0.16,
// //               decoration: const BoxDecoration(
// //                 shape: BoxShape.circle,
// //               ),
// //               child: ClipOval(
// //                 child: Builder(
// //                   builder: (context) {
// //                     final imageUrl = item.entityImage;
// //                     final hasImage = imageUrl != null && imageUrl.isNotEmpty;
// //
// //                     if (hasImage) {
// //                       return Image.network(
// //                         imageUrl,
// //                         fit: BoxFit.cover,
// //                         errorBuilder: (context, error, stackTrace) {
// //                           return _buildFallbackImage();
// //                         },
// //                         loadingBuilder: (context, child, loadingProgress) {
// //                           if (loadingProgress == null) return child;
// //                           return const Center(
// //                             child: SizedBox(
// //                               width: 16,
// //                               height: 16,
// //                               child: CupertinoActivityIndicator(),
// //                             ),
// //                           );
// //                         },
// //                       );
// //                     } else {
// //                       return _buildFallbackImage();
// //                     }
// //                   },
// //                 ),
// //               ),
// //             ),
// //             SizedBox(width: context.screenWidth * 0.04),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Expanded(
// //                         child: CustomText.bold(
// //                           cleanName, // 🟢 List item UI me Clean Name
// //                           fontSize: context.screenWidth * 0.045,
// //                           color: Colors.white,
// //                           maxLines: 1,
// //                           overflow: TextOverflow.ellipsis,
// //                         ),
// //                       ),
// //                       CustomText.regular(
// //                         _formatDate(item.lastMessageAt ?? item.updatedAt),
// //                         fontSize: context.screenWidth * 0.035,
// //                         color: Colors.white54,
// //                       ),
// //                     ],
// //                   ),
// //                   SizedBox(height: context.screenHeight * 0.006),
// //                   CustomText.regular(
// //                     item.lastMessage ?? '',
// //                     fontSize: context.screenWidth * 0.038,
// //                     color: Colors.white70,
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFallbackImage() {
// //     return Container(
// //       color: Colors.grey[900],
// //       child: Icon(
// //         Icons.person,
// //         size: context.screenWidth * 0.08,
// //         color: Colors.white30,
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:infinity_love/core/constants/app_color.dart';
// import 'package:infinity_love/features/home/provider/features_provider.dart';
// import '../../../core/constants/app_string.dart';
// import '../../../core/constants/const_text.dart';
// import '../../../extensions/context_extension.dart';
// import '../../chat/provider/chat_provider.dart';
// import '../model/conversation_model.dart';
//
// class ChatListScreen extends ConsumerStatefulWidget {
//   final String? filterChatType; // 🟢 Example: "CHARACTER", "ROLEPLAY", "COMPANION"
//
//   const ChatListScreen({
//     super.key,
//     this.filterChatType,
//   });
//
//   @override
//   ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
// }
//
// class _ChatListScreenState extends ConsumerState<ChatListScreen> {
//   static const Color pinkAccent = Color(0xFFE91E63);
//   bool _isNavigating = false; // 🟢 Prevents multiple rapid taps
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       if (mounted) {
//         ref.read(featuresProvider.notifier).fetchConversationList();
//       }
//     });
//   }
//
//   String _formatDate(String? rawDate) {
//     if (rawDate == null || rawDate.isEmpty) return '';
//     try {
//       final dateTime = DateTime.parse(rawDate);
//       final difference = DateTime.now().difference(dateTime);
//
//       if (difference.inDays >= 7) {
//         return '${(difference.inDays / 7).floor()}w ago';
//       } else if (difference.inDays > 0) {
//         return '${difference.inDays}d ago';
//       } else if (difference.inHours > 0) {
//         return '${difference.inHours}h ago';
//       } else if (difference.inMinutes > 0) {
//         return '${difference.inMinutes}m ago';
//       } else {
//         return 'Just now';
//       }
//     } catch (_) {
//       return '';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final profileState = ref.watch(featuresProvider);
//
//     return Scaffold(
//       backgroundColor: AppColors.bgBlack,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: profileState.conversationList.when(
//                 loading: () => const Center(
//                   child: CupertinoActivityIndicator(color: pinkAccent),
//                 ),
//                 error: (error, stack) => Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CustomText.regular(
//                         AppStrings.failedToLoadProfiles,
//                         color: Colors.white70,
//                         fontSize: context.screenWidth * 0.04,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(top: context.screenHeight * 0.012),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: pinkAccent,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: context.screenWidth * 0.06,
//                               vertical: context.screenHeight * 0.012,
//                             ),
//                           ),
//                           onPressed: () {
//                             ref
//                                 .read(featuresProvider.notifier)
//                                 .fetchConversationList();
//                           },
//                           child: Text(
//                             AppStrings.retry,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: context.screenWidth * 0.035,
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 data: (ConversationModel? conversationModel) {
//                   final rawItems = conversationModel?.data?.items ?? [];
//
//                   final items = widget.filterChatType == null
//                       ? rawItems
//                       : rawItems
//                       .where((element) =>
//                   element.chatType?.toUpperCase() ==
//                       widget.filterChatType?.toUpperCase())
//                       .toList();
//
//                   if (items.isEmpty) {
//                     return Center(
//                       child: CustomText.regular(
//                         AppStrings.noProfilesAvailable,
//                         color: Colors.white54,
//                         fontSize: context.screenWidth * 0.04,
//                       ),
//                     );
//                   }
//
//                   return ListView.separated(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: context.screenWidth * 0.04,
//                       vertical: context.screenHeight * 0.02,
//                     ),
//                     itemCount: items.length,
//                     separatorBuilder: (context, index) => SizedBox(
//                       height: context.screenHeight * 0.025,
//                     ),
//                     itemBuilder: (context, index) {
//                       final chatItem = items[index];
//                       return _buildChatItem(chatItem, context);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildChatItem(Items item, BuildContext context) {
//     // 🟢 Clean name extraction ("Chat with Aanya" -> "Aanya")
//     final String rawName = item.entityName ?? item.title ?? AppStrings.defaultUnknown;
//     final String cleanName = rawName.replaceFirst(RegExp(r'^Chat with\s+', caseSensitive: false), '');
//
//     return InkWell(
//       onTap: () async {
//         // 🟢 Guard to prevent double tap / double navigation pushes
//         if (_isNavigating) return;
//
//         setState(() {
//           _isNavigating = true;
//         });
//
//         final String chatType = item.chatType?.toUpperCase() ?? '';
//         final String entityId = item.chatEntityId ?? item.sId ?? '';
//         final String entityId2 = item.companionId?.sId ?? item.sId ?? '';
//         final String? entityImage = item.entityImage;
//
//         try {
//           // 🟢 Chat Type ke hisab se specific API Call aur Navigation
//           if (chatType == 'ROLEPLAY') {
//             await ref.read(chatNotifierProvider.notifier).fetchChatListRole(
//               entityId,
//               imageUrl: entityImage,
//               context: context,
//             );
//           } else if (chatType == 'COMPANION') {
//             await ref.read(chatNotifierProvider.notifier).fetchChatListCompanion(
//               entityId2,
//               context: context,
//             );
//             if (context.mounted) {
//               context.pushNamed(
//                 'chatScreen3',
//                 extra: {
//                   'sId': entityId2,
//                   'image': entityImage,
//                   'name': cleanName,
//                 },
//               );
//             }
//           } else {
//             // 🟢 Handles CHARACTER or Default Cases
//             await ref.read(chatNotifierProvider.notifier).fetchChatList(
//               entityId,
//               cleanName,
//               imageUrl: entityImage,
//             );
//           }
//         } finally {
//           // 🟢 Delay resetting flag so subsequent taps work after back navigation
//           Future.delayed(const Duration(milliseconds: 1000), () {
//             if (mounted) {
//               setState(() {
//                 _isNavigating = false;
//               });
//             }
//           });
//         }
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 4.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               width: context.screenWidth * 0.16,
//               height: context.screenWidth * 0.16,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//               ),
//               child: ClipOval(
//                 child: Builder(
//                   builder: (context) {
//                     final imageUrl = item.entityImage;
//                     final hasImage = imageUrl != null && imageUrl.isNotEmpty;
//
//                     if (hasImage) {
//                       return Image.network(
//                         imageUrl,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return _buildFallbackImage();
//                         },
//                         loadingBuilder: (context, child, loadingProgress) {
//                           if (loadingProgress == null) return child;
//                           return const Center(
//                             child: SizedBox(
//                               width: 16,
//                               height: 16,
//                               child: CupertinoActivityIndicator(),
//                             ),
//                           );
//                         },
//                       );
//                     } else {
//                       return _buildFallbackImage();
//                     }
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(width: context.screenWidth * 0.04),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: CustomText.bold(
//                           cleanName, // 🟢 List item UI me Clean Name
//                           fontSize: context.screenWidth * 0.045,
//                           color: Colors.white,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       CustomText.regular(
//                         _formatDate(item.lastMessageAt ?? item.updatedAt),
//                         fontSize: context.screenWidth * 0.035,
//                         color: Colors.white54,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: context.screenHeight * 0.006),
//                   CustomText.regular(
//                     item.lastMessage ?? '',
//                     fontSize: context.screenWidth * 0.038,
//                     color: Colors.white70,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFallbackImage() {
//     return Container(
//       color: Colors.grey[900],
//       child: Icon(
//         Icons.person,
//         size: context.screenWidth * 0.08,
//         color: Colors.white30,
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart' hide Characters;
import 'package:flutter/material.dart' hide Characters;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/home/provider/features_provider.dart';
import '../../../core/constants/app_string.dart';
import '../../../core/constants/const_text.dart';
import '../../../extensions/context_extension.dart';
import '../../chat/provider/chat_provider.dart';
import '../model/conversation_model.dart';
import '../model/featurs_model.dart';
import '../state/features_state.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  final String? filterChatType; // 🟢 Example: "CHARACTER", "ROLEPLAY", "COMPANION"

  const ChatListScreen({
    super.key,
    this.filterChatType,
  });

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  static const Color pinkAccent = Color(0xFFE91E63);
  bool _isNavigating = false; // 🟢 Prevents multiple rapid taps

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        // 🟢 Dono API Data Calls (Horizontal Circles Profile + Vertical Conversation List)
        ref.read(featuresProvider.notifier).fetchProfile();
        ref.read(featuresProvider.notifier).fetchConversationList();
      }
    });
  }

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


            // 🟢 2. VERTICAL CHAT / CONVERSATION LIST
            Expanded(
              child: profileState.conversationList.when(
                loading: () => const Center(
                  child: CupertinoActivityIndicator(color: pinkAccent),
                ),
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
                            ref
                                .read(featuresProvider.notifier)
                                .fetchProfile();
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
                data: (ConversationModel? conversationModel) {
                  final rawItems = conversationModel?.data?.items ?? [];

                  final items = widget.filterChatType == null
                      ? rawItems
                      : rawItems
                      .where((element) =>
                  element.chatType?.toUpperCase() ==
                      widget.filterChatType?.toUpperCase())
                      .toList();

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

  // 🟢 Horizontal Circle List Widget using fetchProfile() Data
  Widget _buildHorizontalProfilesList(FeaturesState profileState) {
    return SizedBox(
      height: context.screenWidth * 0.24,
      child: profileState.profileList.when(
        loading: () => const Center(
          child: CupertinoActivityIndicator(color: pinkAccent),
        ),
        error: (_, __) => const SizedBox.shrink(),
        data: (FeatureModel? featureModel) {
          final characters = featureModel?.data?.characters ?? [];

          if (characters.isEmpty) {
            return const SizedBox.shrink();
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: context.screenWidth * 0.04,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: characters.length,
            separatorBuilder: (context, index) => SizedBox(
              width: context.screenWidth * 0.035,
            ),
            itemBuilder: (context, index) {
              final character = characters[index];
              return _buildCircleProfileItem(character);
            },
          );
        },
      ),
    );
  }

  // 🟢 Single Circular Profile Item
  Widget _buildCircleProfileItem(Characters character) {
    final String cleanName = character.name ?? AppStrings.defaultUnknown;
    final String? imageUrl = character.image;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return GestureDetector(
      onTap: () {
        if (_isNavigating) return;
        setState(() => _isNavigating = true);

        context.pushNamed('modelProfile', extra: character.sId);

        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) setState(() => _isNavigating = false);
        });
      },
      child: SizedBox(
        width: context.screenWidth * 0.16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(2.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [pinkAccent, Color(0xFFFF4081)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: const BoxDecoration(
                  color: AppColors.bgBlack,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: context.screenWidth * 0.07,
                  backgroundColor: Colors.grey[900],
                  child: ClipOval(
                    child: hasImage
                        ? Image.network(
                      imageUrl,
                      width: context.screenWidth * 0.14,
                      height: context.screenWidth * 0.14,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildFallbackAvatarIcon(),
                    )
                        : _buildFallbackAvatarIcon(),
                  ),
                ),
              ),
            ),
            SizedBox(height: context.screenHeight * 0.005),
            CustomText.medium(
              cleanName,
              fontSize: context.screenWidth * 0.03,
              color: Colors.white,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackAvatarIcon() {
    return Icon(
      Icons.person,
      size: context.screenWidth * 0.07,
      color: Colors.white30,
    );
  }

  // 🟢 Vertical Chat Item
  Widget _buildChatItem(Items item, BuildContext context) {
    final String rawName = item.entityName ?? item.title ?? AppStrings.defaultUnknown;
    final String cleanName = rawName.replaceFirst(RegExp(r'^Chat with\s+', caseSensitive: false), '');

    return InkWell(
      onTap: () async {
        if (_isNavigating) return;

        setState(() {
          _isNavigating = true;
        });

        final String chatType = item.chatType?.toUpperCase() ?? '';
        final String entityId = item.chatEntityId ?? item.sId ?? '';
        final String entityId2 = item.companionId?.sId ?? item.sId ?? '';
        final String? entityImage = item.entityImage;

        try {
          if (chatType == 'ROLEPLAY') {
            await ref.read(chatNotifierProvider.notifier).fetchChatListRole(
              entityId,
              imageUrl: entityImage,
              context: context,
            );
          } else if (chatType == 'COMPANION') {
            await ref.read(chatNotifierProvider.notifier).fetchChatListCompanion(
              entityId2,
              context: context,
            );
            if (context.mounted) {
              context.pushNamed(
                'chatScreen3',
                extra: {
                  'sId': entityId2,
                  'id': entityId, // 👈 Ya entityId2 / _id jo bhi aapka id variable ho
                  'image': entityImage,
                  'name': cleanName,
                },
              );
            }
          } else {
            await ref.read(chatNotifierProvider.notifier).fetchChatList(
              entityId,
              cleanName,
              imageUrl: entityImage,
            );
          }
        } finally {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              setState(() {
                _isNavigating = false;
              });
            }
          });
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: context.screenWidth * 0.16,
              height: context.screenWidth * 0.16,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Builder(
                  builder: (context) {
                    final imageUrl = item.entityImage;
                    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

                    if (hasImage) {
                      return Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildFallbackImage();
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CupertinoActivityIndicator(),
                            ),
                          );
                        },
                      );
                    } else {
                      return _buildFallbackImage();
                    }
                  },
                ),
              ),
            ),
            SizedBox(width: context.screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText.bold(
                          cleanName,
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

  Widget _buildFallbackImage() {
    return Container(
      color: Colors.grey[900],
      child: Icon(
        Icons.person,
        size: context.screenWidth * 0.08,
        color: Colors.white30,
      ),
    );
  }
}