// //
// //
// // import 'dart:io';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:go_router/go_router.dart';
// // import 'package:hugeicons/hugeicons.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:infinity_love/core/constants/app_color.dart';
// // import 'package:infinity_love/features/profile/provider/profile_provider.dart';
// //
// // import '../../core/constants/const_text.dart';
// // import '../../core/storage/loacal_storage.dart';
// // import '../../shared/weget/image_pick.dart';
// // import '../alarm/alram_screen.dart';
// // import '../policy/help_and_support.dart';
// // import '../policy/term_and_condition.dart';
// //
// // class MyProfileScreen extends ConsumerStatefulWidget {
// //   const MyProfileScreen({super.key});
// //
// //   @override
// //   ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
// // }
// //
// // class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     Future.microtask(() {
// //       _refreshProfile();
// //     });
// //   }
// //
// //   // 🔄 Refresh Profile Handler for Pull To Refresh
// //   Future<void> _refreshProfile() async {
// //     await ref.read(profileProvider.notifier).fetchProfile();
// //   }
// //
// //   // 🖼️ Avatar Picker se Cloudinary URL milne par Direct Profile Update
// //   Future<void> _onAvatarSelected(String uploadedCloudinaryUrl) async {
// //     if (uploadedCloudinaryUrl.isEmpty) return;
// //
// //     final profileModel = ref.read(profileProvider).value;
// //     final currentName = profileModel?.data?.name ?? 'User';
// //
// //     final success = await ref.read(profileProvider.notifier).updateProfile(
// //       name: currentName,
// //       avatar: uploadedCloudinaryUrl,
// //       onSuccess: (msg) {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text(msg), backgroundColor: Colors.green),
// //           );
// //         }
// //       },
// //       onError: (err) {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text(err), backgroundColor: Colors.redAccent),
// //           );
// //         }
// //       },
// //     );
// //
// //     if (success && mounted) {
// //       _refreshProfile();
// //     }
// //   }
// //
// //   // ✏️ Profile Edit Popup Modal (Name & Avatar Edit)
// //   void _showEditProfileDialog(BuildContext context, String currentName, String currentAvatar) {
// //     final TextEditingController nameController = TextEditingController(text: currentName);
// //     String updatedAvatarUrl = currentAvatar;
// //     bool isUpdating = false;
// //
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       builder: (BuildContext sheetContext) {
// //         return StatefulBuilder(
// //           builder: (BuildContext context, StateSetter setModalState) {
// //             return Container(
// //               padding: EdgeInsets.only(
// //                 left: 20,
// //                 right: 20,
// //                 top: 20,
// //                 bottom: MediaQuery.of(context).viewInsets.bottom + 20,
// //               ),
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFF1E1E20),
// //                 borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
// //                 border: Border.all(color: AppColors.cardBorder, width: 0.8),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: AppColors.primaryPink.withValues(alpha: 0.2),
// //                     blurRadius: 20,
// //                     spreadRadius: 2,
// //                   ),
// //                 ],
// //               ),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   // Title Bar
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       CustomText.bold(
// //                         'Edit Profile',
// //                         fontSize: 18,
// //                         color: AppColors.textPrimaryLight,
// //                       ),
// //                       IconButton(
// //                         onPressed: () => Navigator.pop(sheetContext),
// //                         icon: const Icon(Icons.close, color: Colors.white54),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 16),
// //
// //                   // Image Picker Section inside Sheet
// //                   ProfileAvatarPicker(
// //                     imageUrl: updatedAvatarUrl,
// //                     onImageSelected: (newUrl) {
// //                       setModalState(() {
// //                         updatedAvatarUrl = newUrl;
// //                       });
// //                     },
// //                   ),
// //                   const SizedBox(height: 20),
// //
// //                   // Name Input Field
// //                   TextField(
// //                     controller: nameController,
// //                     style: const TextStyle(color: Colors.white),
// //                     decoration: InputDecoration(
// //                       labelText: 'Full Name',
// //                       labelStyle: const TextStyle(color: AppColors.textSecondaryLight),
// //                       filled: true,
// //                       fillColor: AppColors.cardDarkBg,
// //                       prefixIcon: const Icon(
// //                         Icons.person_outline,
// //                         color: AppColors.primaryPink,
// //                       ),
// //                       enabledBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(14),
// //                         borderSide: const BorderSide(color: AppColors.cardBorder),
// //                       ),
// //                       focusedBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(14),
// //                         borderSide: const BorderSide(color: AppColors.primaryPink),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 24),
// //
// //                   // Save Action Button
// //                   SizedBox(
// //                     width: double.infinity,
// //                     height: 48,
// //                     child: ElevatedButton(
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: AppColors.primaryPink,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(14),
// //                         ),
// //                       ),
// //                       onPressed: isUpdating
// //                           ? null
// //                           : () async {
// //                         final newName = nameController.text.trim();
// //                         if (newName.isEmpty) {
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             const SnackBar(
// //                               content: Text('Name cannot be empty'),
// //                               backgroundColor: Colors.redAccent,
// //                             ),
// //                           );
// //                           return;
// //                         }
// //
// //                         setModalState(() {
// //                           isUpdating = true;
// //                         });
// //
// //                         final success = await ref
// //                             .read(profileProvider.notifier)
// //                             .updateProfile(
// //                           name: newName,
// //                           avatar: updatedAvatarUrl,
// //                           onSuccess: (message) {
// //                             Navigator.pop(sheetContext);
// //                             ScaffoldMessenger.of(context).showSnackBar(
// //                               SnackBar(
// //                                 content: Text(message),
// //                                 backgroundColor: Colors.green,
// //                               ),
// //                             );
// //                           },
// //                           onError: (errorMessage) {
// //                             setModalState(() {
// //                               isUpdating = false;
// //                             });
// //                             ScaffoldMessenger.of(context).showSnackBar(
// //                               SnackBar(
// //                                 content: Text(errorMessage),
// //                                 backgroundColor: Colors.redAccent,
// //                               ),
// //                             );
// //                           },
// //                         );
// //
// //                         if (success && context.mounted) {
// //                           _refreshProfile();
// //                         }
// //                       },
// //                       child: isUpdating
// //                           ? const SizedBox(
// //                         width: 20,
// //                         height: 20,
// //                         child: CupertinoActivityIndicator(
// //                           color: Colors.white,
// //                         ),
// //                       )
// //                           : CustomText.bold(
// //                         'Save Changes',
// //                         fontSize: 16,
// //                         color: Colors.white,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //   // 🚪 Logout Dialog
// //   void _showLogoutDialog(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext dialogContext) {
// //         return AlertDialog(
// //           backgroundColor: const Color(0xFF1E1E20),
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(20),
// //             side: const BorderSide(color: AppColors.cardBorder, width: 0.8),
// //           ),
// //           title: CustomText.bold(
// //             'Logout',
// //             fontSize: 20,
// //             color: AppColors.textPrimaryLight,
// //           ),
// //           content: CustomText.regular(
// //             'Are you sure you want to logout?',
// //             fontSize: 15,
// //             color: AppColors.textSecondaryLight,
// //           ),
// //           actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(dialogContext),
// //               child: CustomText.medium(
// //                 'Cancel',
// //                 fontSize: 15,
// //                 color: AppColors.textSecondaryLight,
// //               ),
// //             ),
// //             ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: AppColors.primaryPink,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //               ),
// //               onPressed: () async {
// //                 Navigator.pop(dialogContext);
// //                 await LocalStorage.clear();
// //                 if (context.mounted) {
// //                   context.goNamed('login');
// //                 }
// //               },
// //               child: CustomText.bold(
// //                 'Logout',
// //                 fontSize: 15,
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final profileState = ref.watch(profileProvider);
// //
// //     return Scaffold(
// //       backgroundColor: AppColors.bgBlack,
// //       appBar: AppBar(
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: const HugeIcon(
// //             icon: HugeIcons.strokeRoundedArrowLeft01,
// //             color: AppColors.textPrimaryLight,
// //             size: 24.0,
// //           ),
// //           onPressed: () => Navigator.maybePop(context),
// //         ),
// //         title: CustomText.bold(
// //           'My Profile',
// //           fontSize: 20,
// //           color: AppColors.textPrimaryLight,
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: profileState.when(
// //         data: (profileModel) {
// //           final userData = profileModel?.data;
// //           final userName = userData?.name ?? 'User';
// //           final userAvatar = userData?.avatar ?? '';
// //
// //           // 🟢 Pull to Refresh Added Here
// //           return RefreshIndicator(
// //             onRefresh: _refreshProfile,
// //             color: AppColors.primaryPink,
// //             backgroundColor: AppColors.cardDarkBg,
// //             child: SingleChildScrollView(
// //               physics: const AlwaysScrollableScrollPhysics(), // Pull down swipe ko enable rakhne ke liye
// //               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
// //               child: Column(
// //                 children: [
// //                   const SizedBox(height: 12),
// //
// //                   // 🖼️ Avatar Picker
// //                   ProfileAvatarPicker(
// //                     imageUrl: userAvatar,
// //                     onImageSelected: _onAvatarSelected,
// //                   ),
// //                   const SizedBox(height: 16),
// //
// //                   // --- Dynamic User Name & Edit Pencil ---
// //                   GestureDetector(
// //                     onTap: () => _showEditProfileDialog(context, userName, userAvatar),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         CustomText.bold(
// //                           userName,
// //                           fontSize: 22,
// //                           color: AppColors.textPrimaryLight,
// //                         ),
// //                         const SizedBox(width: 8),
// //                         Container(
// //                           padding: const EdgeInsets.all(6),
// //                           decoration: BoxDecoration(
// //                             color: AppColors.primaryPink.withValues(alpha: 0.15),
// //                             shape: BoxShape.circle,
// //                           ),
// //                           child: const HugeIcon(
// //                             icon: HugeIcons.strokeRoundedPencilEdit02,
// //                             color: AppColors.primaryPink,
// //                             size: 18,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 32),
// //
// //                   // --- Section 1: Alarm & App Language ---
// //                   Container(
// //                     decoration: BoxDecoration(
// //                       color: AppColors.cardDarkBg,
// //                       borderRadius: BorderRadius.circular(18),
// //                       border: Border.all(color: AppColors.cardBorder, width: 0.8),
// //                     ),
// //                     child: Column(
// //                       children: [
// //                         _buildProfileTile(
// //                           icon: HugeIcons.strokeRoundedClock01,
// //                           title: 'Alarm',
// //                           onTap: () {
// //                             Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) => const AlarmsScreen(),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),
// //
// //                   // --- Section 2: Options ---
// //                   Container(
// //                     decoration: BoxDecoration(
// //                       color: AppColors.cardDarkBg,
// //                       borderRadius: BorderRadius.circular(18),
// //                       border: Border.all(color: AppColors.cardBorder, width: 0.8),
// //                     ),
// //                     child: Column(
// //                       children: [
// //                         _buildProfileTile(
// //                           icon: HugeIcons.strokeRoundedInformationCircle,
// //                           title: 'Privacy Policy',
// //                           onTap: () {
// //                             Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) => const PrivacyPolicyScreen(selectedIndex: 1),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                         const Divider(
// //                           height: 1,
// //                           color: AppColors.cardBorder,
// //                           indent: 16,
// //                           endIndent: 16,
// //                         ),
// //                         _buildProfileTile(
// //                           icon: HugeIcons.strokeRoundedInformationCircle,
// //                           title: 'Term & Condition',
// //                           onTap: () {
// //                             Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) => const PrivacyPolicyScreen(
// //                                   selectedIndex: 2,
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                         const Divider(
// //                           height: 1,
// //                           color: AppColors.cardBorder,
// //                           indent: 16,
// //                           endIndent: 16,
// //                         ),
// //                         _buildProfileTile(
// //                           icon: HugeIcons.strokeRoundedInformationCircle,
// //                           title: 'Help & Support',
// //                           onTap: () {
// //                             Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) => const PrivacyPolicyScreen(
// //                                   selectedIndex: 0,
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //
// //                         const Divider(
// //                           height: 1,
// //                           color: AppColors.cardBorder,
// //                           indent: 16,
// //                           endIndent: 16,
// //                         ),
// //                         _buildProfileTile(
// //                           icon: HugeIcons.strokeRoundedInformationCircle,
// //                           title: 'Delete All Chat',
// //                           onTap: () {
// //                             Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) => const PrivacyPolicyScreen(
// //                                   selectedIndex: 0,
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                         const Divider(
// //                           height: 1,
// //                           color: AppColors.cardBorder,
// //                           indent: 16,
// //                           endIndent: 16,
// //                         ),
// //                         _buildProfileTile(
// //                           icon: HugeIcons.strokeRoundedLogout01,
// //                           title: 'Logout',
// //                           titleColor: Colors.redAccent,
// //                           iconColor: Colors.redAccent,
// //                           onTap: () => _showLogoutDialog(context),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 24),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //         loading: () => const Center(
// //           child: CupertinoActivityIndicator(color: AppColors.primaryPink),
// //         ),
// //         error: (err, stack) => Center(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               CustomText.medium(
// //                 'Failed to load profile',
// //                 color: AppColors.textSecondaryLight,
// //               ),
// //               const SizedBox(height: 12),
// //               ElevatedButton(
// //                 style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPink),
// //                 onPressed: _refreshProfile,
// //                 child: const Text('Retry', style: TextStyle(color: Colors.white)),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildProfileTile({
// //     required dynamic icon,
// //     required String title,
// //     required VoidCallback onTap,
// //     Widget? trailingWidget,
// //     Color? titleColor,
// //     Color? iconColor,
// //   }) {
// //     return ListTile(
// //       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
// //       leading: HugeIcon(
// //         icon: icon,
// //         color: iconColor ?? AppColors.textSecondaryLight,
// //         size: 22.0,
// //       ),
// //       title: CustomText.medium(
// //         title,
// //         fontSize: 15,
// //         color: titleColor ?? AppColors.textPrimaryLight,
// //       ),
// //       trailing: trailingWidget ??
// //           const HugeIcon(
// //             icon: HugeIcons.strokeRoundedArrowRight01,
// //             color: AppColors.textSecondaryDark,
// //             size: 20.0,
// //           ),
// //       onTap: onTap,
// //     );
// //   }
// // }
//
//
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:infinity_love/core/constants/app_color.dart';
// import 'package:infinity_love/features/chat/provider/chat_provider.dart';
// import 'package:infinity_love/features/profile/provider/profile_provider.dart';
//
// import '../../core/constants/const_text.dart';
// import '../../core/storage/loacal_storage.dart';
// import '../../shared/weget/image_pick.dart';
// import '../alarm/alram_screen.dart';
// import '../policy/help_and_support.dart';
// import '../policy/term_and_condition.dart';
//
// class MyProfileScreen extends ConsumerStatefulWidget {
//   const MyProfileScreen({super.key});
//
//   @override
//   ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
// }
//
// class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       _refreshProfile();
//     });
//   }
//
//   // 🔄 Refresh Profile Handler for Pull To Refresh
//   Future<void> _refreshProfile() async {
//     await ref.read(profileProvider.notifier).fetchProfile();
//   }
//
//   // 🗑️ Delete All Chat Confirmation Dialog & Action Call
//   void _showDeleteAllChatDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           backgroundColor: const Color(0xFF1E1E20),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//             side: const BorderSide(color: AppColors.cardBorder, width: 0.8),
//           ),
//           title: CustomText.bold(
//             'Delete All Chat',
//             fontSize: 20,
//             color: AppColors.textPrimaryLight,
//           ),
//           content: CustomText.regular(
//             'Are you sure you want to delete all your conversations? This action cannot be undone.',
//             fontSize: 15,
//             color: AppColors.textSecondaryLight,
//           ),
//           actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(dialogContext),
//               child: CustomText.medium(
//                 'Cancel',
//                 fontSize: 15,
//                 color: AppColors.textSecondaryLight,
//               ),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               ),
//               onPressed: () async {
//                 Navigator.pop(dialogContext);
//
//
//
//
//                 final success = await ref
//                     .read(chatNotifierProvider.notifier)
//                     .deleteChat(
//
//                 );
//
//                 if (context.mounted) {
//                   if (success) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('All chats deleted successfully!'),
//                         backgroundColor: Colors.green,
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Failed to delete chats. Try again.'),
//                         backgroundColor: Colors.redAccent,
//                       ),
//                     );
//                   }
//                 }
//               },
//               child: CustomText.bold(
//                 'Delete',
//                 fontSize: 15,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // 🖼️ Avatar Picker se Cloudinary URL milne par Direct Profile Update
//   Future<void> _onAvatarSelected(String uploadedCloudinaryUrl) async {
//     if (uploadedCloudinaryUrl.isEmpty) return;
//
//     final profileModel = ref.read(profileProvider).value;
//     final currentName = profileModel?.data?.name ?? 'User';
//
//     final success = await ref.read(profileProvider.notifier).updateProfile(
//       name: currentName,
//       avatar: uploadedCloudinaryUrl,
//       onSuccess: (msg) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(msg), backgroundColor: Colors.green),
//           );
//         }
//       },
//       onError: (err) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(err), backgroundColor: Colors.redAccent),
//           );
//         }
//       },
//     );
//
//     if (success && mounted) {
//       _refreshProfile();
//     }
//   }
//
//   // ✏️ Profile Edit Popup Modal (Name & Avatar Edit)
//   void _showEditProfileDialog(BuildContext context, String currentName, String currentAvatar) {
//     final TextEditingController nameController = TextEditingController(text: currentName);
//     String updatedAvatarUrl = currentAvatar;
//     bool isUpdating = false;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext sheetContext) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setModalState) {
//             return Container(
//               padding: EdgeInsets.only(
//                 left: 20,
//                 right: 20,
//                 top: 20,
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//               ),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1E1E20),
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//                 border: Border.all(color: AppColors.cardBorder, width: 0.8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primaryPink.withValues(alpha: 0.2),
//                     blurRadius: 20,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Title Bar
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       CustomText.bold(
//                         'Edit Profile',
//                         fontSize: 18,
//                         color: AppColors.textPrimaryLight,
//                       ),
//                       IconButton(
//                         onPressed: () => Navigator.pop(sheetContext),
//                         icon: const Icon(Icons.close, color: Colors.white54),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Image Picker Section inside Sheet
//                   ProfileAvatarPicker(
//                     imageUrl: updatedAvatarUrl,
//                     onImageSelected: (newUrl) {
//                       setModalState(() {
//                         updatedAvatarUrl = newUrl;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Name Input Field
//                   TextField(
//                     controller: nameController,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       labelText: 'Full Name',
//                       labelStyle: const TextStyle(color: AppColors.textSecondaryLight),
//                       filled: true,
//                       fillColor: AppColors.cardDarkBg,
//                       prefixIcon: const Icon(
//                         Icons.person_outline,
//                         color: AppColors.primaryPink,
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14),
//                         borderSide: const BorderSide(color: AppColors.cardBorder),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14),
//                         borderSide: const BorderSide(color: AppColors.primaryPink),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Save Action Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 48,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primaryPink,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                       ),
//                       onPressed: isUpdating
//                           ? null
//                           : () async {
//                         final newName = nameController.text.trim();
//                         if (newName.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Name cannot be empty'),
//                               backgroundColor: Colors.redAccent,
//                             ),
//                           );
//                           return;
//                         }
//
//                         setModalState(() {
//                           isUpdating = true;
//                         });
//
//                         final success = await ref
//                             .read(profileProvider.notifier)
//                             .updateProfile(
//                           name: newName,
//                           avatar: updatedAvatarUrl,
//                           onSuccess: (message) {
//                             Navigator.pop(sheetContext);
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(message),
//                                 backgroundColor: Colors.green,
//                               ),
//                             );
//                           },
//                           onError: (errorMessage) {
//                             setModalState(() {
//                               isUpdating = false;
//                             });
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(errorMessage),
//                                 backgroundColor: Colors.redAccent,
//                               ),
//                             );
//                           },
//                         );
//
//                         if (success && context.mounted) {
//                           _refreshProfile();
//                         }
//                       },
//                       child: isUpdating
//                           ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CupertinoActivityIndicator(
//                           color: Colors.white,
//                         ),
//                       )
//                           : CustomText.bold(
//                         'Save Changes',
//                         fontSize: 16,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // 🚪 Logout Dialog
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           backgroundColor: const Color(0xFF1E1E20),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//             side: const BorderSide(color: AppColors.cardBorder, width: 0.8),
//           ),
//           title: CustomText.bold(
//             'Logout',
//             fontSize: 20,
//             color: AppColors.textPrimaryLight,
//           ),
//           content: CustomText.regular(
//             'Are you sure you want to logout?',
//             fontSize: 15,
//             color: AppColors.textSecondaryLight,
//           ),
//           actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(dialogContext),
//               child: CustomText.medium(
//                 'Cancel',
//                 fontSize: 15,
//                 color: AppColors.textSecondaryLight,
//               ),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryPink,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               ),
//               onPressed: () async {
//                 Navigator.pop(dialogContext);
//                 await LocalStorage.clear();
//                 if (context.mounted) {
//                   context.goNamed('login');
//                 }
//               },
//               child: CustomText.bold(
//                 'Logout',
//                 fontSize: 15,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final profileState = ref.watch(profileProvider);
//
//     return Scaffold(
//       backgroundColor: AppColors.bgBlack,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const HugeIcon(
//             icon: HugeIcons.strokeRoundedArrowLeft01,
//             color: AppColors.textPrimaryLight,
//             size: 24.0,
//           ),
//           onPressed: () => Navigator.maybePop(context),
//         ),
//         title: CustomText.bold(
//           'My Profile',
//           fontSize: 20,
//           color: AppColors.textPrimaryLight,
//         ),
//         centerTitle: true,
//       ),
//       body: profileState.when(
//         data: (profileModel) {
//           final userData = profileModel?.data;
//           final userName = userData?.name ?? 'User';
//           final userAvatar = userData?.avatar ?? '';
//
//           return RefreshIndicator(
//             onRefresh: _refreshProfile,
//             color: AppColors.primaryPink,
//             backgroundColor: AppColors.cardDarkBg,
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 12),
//
//                   // 🖼️ Avatar Picker
//                   ProfileAvatarPicker(
//                     imageUrl: userAvatar,
//                     onImageSelected: _onAvatarSelected,
//                   ),
//                   const SizedBox(height: 16),
//
//                   // --- Dynamic User Name & Edit Pencil ---
//                   GestureDetector(
//                     onTap: () => _showEditProfileDialog(context, userName, userAvatar),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CustomText.bold(
//                           userName,
//                           fontSize: 22,
//                           color: AppColors.textPrimaryLight,
//                         ),
//                         const SizedBox(width: 8),
//                         Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: AppColors.primaryPink.withValues(alpha: 0.15),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const HugeIcon(
//                             icon: HugeIcons.strokeRoundedPencilEdit02,
//                             color: AppColors.primaryPink,
//                             size: 18,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//
//                   // --- Section 1: Alarm ---
//                   Container(
//                     decoration: BoxDecoration(
//                       color: AppColors.cardDarkBg,
//                       borderRadius: BorderRadius.circular(18),
//                       border: Border.all(color: AppColors.cardBorder, width: 0.8),
//                     ),
//                     child: Column(
//                       children: [
//                         _buildProfileTile(
//                           icon: HugeIcons.strokeRoundedClock01,
//                           title: 'Alarm',
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const AlarmsScreen(),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // --- Section 2: Options ---
//                   Container(
//                     decoration: BoxDecoration(
//                       color: AppColors.cardDarkBg,
//                       borderRadius: BorderRadius.circular(18),
//                       border: Border.all(color: AppColors.cardBorder, width: 0.8),
//                     ),
//                     child: Column(
//                       children: [
//                         _buildProfileTile(
//                           icon: HugeIcons.strokeRoundedInformationCircle,
//                           title: 'Privacy Policy',
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const PrivacyPolicyScreen(selectedIndex: 1),
//                               ),
//                             );
//                           },
//                         ),
//                         const Divider(
//                           height: 1,
//                           color: AppColors.cardBorder,
//                           indent: 16,
//                           endIndent: 16,
//                         ),
//                         _buildProfileTile(
//                           icon: HugeIcons.strokeRoundedInformationCircle,
//                           title: 'Term & Condition',
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const PrivacyPolicyScreen(
//                                   selectedIndex: 2,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const Divider(
//                           height: 1,
//                           color: AppColors.cardBorder,
//                           indent: 16,
//                           endIndent: 16,
//                         ),
//                         _buildProfileTile(
//                           icon: HugeIcons.strokeRoundedInformationCircle,
//                           title: 'Help & Support',
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const PrivacyPolicyScreen(
//                                   selectedIndex: 0,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const Divider(
//                           height: 1,
//                           color: AppColors.cardBorder,
//                           indent: 16,
//                           endIndent: 16,
//                         ),
//                         // 🔴 CONNECTED DELETE ALL CHAT OPTION
//                         _buildProfileTile(
//                           icon: HugeIcons.strokeRoundedDelete02,
//                           title: 'Delete All Chat',
//                           titleColor: Colors.redAccent,
//                           iconColor: Colors.redAccent,
//                           onTap: () => _showDeleteAllChatDialog(context),
//                         ),
//                         const Divider(
//                           height: 1,
//                           color: AppColors.cardBorder,
//                           indent: 16,
//                           endIndent: 16,
//                         ),
//                         _buildProfileTile(
//                           icon: HugeIcons.strokeRoundedLogout01,
//                           title: 'Logout',
//                           titleColor: Colors.redAccent,
//                           iconColor: Colors.redAccent,
//                           onTap: () => _showLogoutDialog(context),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//           );
//         },
//         loading: () => const Center(
//           child: CupertinoActivityIndicator(color: AppColors.primaryPink),
//         ),
//         error: (err, stack) => Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CustomText.medium(
//                 'Failed to load profile',
//                 color: AppColors.textSecondaryLight,
//               ),
//               const SizedBox(height: 12),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPink),
//                 onPressed: _refreshProfile,
//                 child: const Text('Retry', style: TextStyle(color: Colors.white)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileTile({
//     required dynamic icon,
//     required String title,
//     required VoidCallback onTap,
//     Widget? trailingWidget,
//     Color? titleColor,
//     Color? iconColor,
//   }) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//       leading: HugeIcon(
//         icon: icon,
//         color: iconColor ?? AppColors.textSecondaryLight,
//         size: 22.0,
//       ),
//       title: CustomText.medium(
//         title,
//         fontSize: 15,
//         color: titleColor ?? AppColors.textPrimaryLight,
//       ),
//       trailing: trailingWidget ??
//           const HugeIcon(
//             icon: HugeIcons.strokeRoundedArrowRight01,
//             color: AppColors.textSecondaryDark,
//             size: 20.0,
//           ),
//       onTap: onTap,
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/core/utils/utils.dart';
import 'package:infinity_love/features/chat/provider/chat_provider.dart';
import 'package:infinity_love/features/profile/provider/profile_provider.dart';

import '../../core/constants/const_text.dart';
import '../../core/storage/loacal_storage.dart';
import '../../shared/weget/image_pick.dart';
import '../alarm/alram_screen.dart';
import '../policy/help_and_support.dart';
import '../policy/term_and_condition.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  // 🟢 Title tracker to show loader on specific tile and lock double taps
  String? _loadingTitle;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _refreshProfile();
    });
  }

  // 🔄 Refresh Profile Handler for Pull To Refresh
  Future<void> _refreshProfile() async {
    await ref.read(profileProvider.notifier).fetchProfile();
  }

  // 🗑️ Delete All Chat Confirmation Dialog & Action Call
  void _showDeleteAllChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.cardBorder, width: 0.8),
          ),
          title: CustomText.bold(
            'Delete All Chat',
            fontSize: 20,
            color: AppColors.textPrimaryLight,
          ),
          content: CustomText.regular(
            'Are you sure you want to delete all your conversations? This action cannot be undone.',
            fontSize: 15,
            color: AppColors.textSecondaryLight,
          ),
          actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: CustomText.medium(
                'Cancel',
                fontSize: 15,
                color: AppColors.textSecondaryLight,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);

                final success = await ref
                    .read(chatNotifierProvider.notifier)
                    .deleteChat();

                if (context.mounted) {
                  if (success) {
                    Utils.showSuccessMessage(
                      context,
                      'All chats deleted successfully!',
                    );
                  } else {
                    Utils.showErrorMessage(
                      context,
                      'Failed to delete chats. Try again.',
                    );
                  }
                }
              },
              child: CustomText.bold(
                'Delete',
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  // 🖼️ Avatar Picker se Cloudinary URL milne par Direct Profile Update
  Future<void> _onAvatarSelected(String uploadedCloudinaryUrl) async {
    if (uploadedCloudinaryUrl.isEmpty) return;

    final profileModel = ref.read(profileProvider).value;
    final currentName = profileModel?.data?.name ?? 'User';

    final success = await ref.read(profileProvider.notifier).updateProfile(
      name: currentName,
      avatar: uploadedCloudinaryUrl,
      onSuccess: (msg) {
        if (mounted) {
          Utils.showSuccessMessage(context, msg);
        }
      },
      onError: (err) {
        if (mounted) {
          Utils.showErrorMessage(context, err);
        }
      },
    );

    if (success && mounted) {
      _refreshProfile();
    }
  }

  // ✏️ Profile Edit Popup Modal (Name & Avatar Edit)
  void _showEditProfileDialog(BuildContext context, String currentName, String currentAvatar) {
    final TextEditingController nameController = TextEditingController(text: currentName);
    String updatedAvatarUrl = currentAvatar;
    bool isUpdating = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E20),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(color: AppColors.cardBorder, width: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPink.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText.bold(
                        'Edit Profile',
                        fontSize: 18,
                        color: AppColors.textPrimaryLight,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        icon: const Icon(Icons.close, color: Colors.white54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Image Picker Section inside Sheet
                  ProfileAvatarPicker(
                    imageUrl: updatedAvatarUrl,
                    onImageSelected: (newUrl) {
                      setModalState(() {
                        updatedAvatarUrl = newUrl;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Name Input Field
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: const TextStyle(color: AppColors.textSecondaryLight),
                      filled: true,
                      fillColor: AppColors.cardDarkBg,
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: AppColors.primaryPink,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.primaryPink),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: isUpdating
                          ? null
                          : () async {
                        final newName = nameController.text.trim();
                        if (newName.isEmpty) {
                          Utils.showErrorMessage(context, 'Name cannot be empty');
                          return;
                        }

                        setModalState(() {
                          isUpdating = true;
                        });

                        final success = await ref
                            .read(profileProvider.notifier)
                            .updateProfile(
                          name: newName,
                          avatar: updatedAvatarUrl,
                          onSuccess: (message) {
                            Navigator.pop(sheetContext);
                            Utils.showSuccessMessage(context, message);
                          },
                          onError: (errorMessage) {
                            setModalState(() {
                              isUpdating = false;
                            });
                            Utils.showErrorMessage(context, errorMessage);
                          },
                        );

                        if (success && context.mounted) {
                          _refreshProfile();
                        }
                      },
                      child: isUpdating
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CupertinoActivityIndicator(
                          color: Colors.white,
                        ),
                      )
                          : CustomText.bold(
                        'Save Changes',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 🚪 Logout Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.cardBorder, width: 0.8),
          ),
          title: CustomText.bold(
            'Logout',
            fontSize: 20,
            color: AppColors.textPrimaryLight,
          ),
          content: CustomText.regular(
            'Are you sure you want to logout?',
            fontSize: 15,
            color: AppColors.textSecondaryLight,
          ),
          actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: CustomText.medium(
                'Cancel',
                fontSize: 15,
                color: AppColors.textSecondaryLight,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await LocalStorage.clear();
                if (context.mounted) {
                  context.goNamed('login');
                }
              },
              child: CustomText.bold(
                'Logout',
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimaryLight,
            size: 24.0,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: CustomText.bold(
          'My Profile',
          fontSize: 20,
          color: AppColors.textPrimaryLight,
        ),
        centerTitle: true,
      ),
      body: profileState.when(
        data: (profileModel) {
          final userData = profileModel?.data;
          final userName = userData?.name ?? 'User';
          final userAvatar = userData?.avatar ?? '';

          return RefreshIndicator(
            onRefresh: _refreshProfile,
            color: AppColors.primaryPink,
            backgroundColor: AppColors.cardDarkBg,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // 🖼️ Avatar Picker
                  ProfileAvatarPicker(
                    imageUrl: userAvatar,
                    onImageSelected: _onAvatarSelected,
                  ),
                  const SizedBox(height: 16),

                  // --- Dynamic User Name & Edit Pencil ---
                  GestureDetector(
                    onTap: () => _showEditProfileDialog(context, userName, userAvatar),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText.bold(
                          userName,
                          fontSize: 22,
                          color: AppColors.textPrimaryLight,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPink.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const HugeIcon(
                            icon: HugeIcons.strokeRoundedPencilEdit02,
                            color: AppColors.primaryPink,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- Section 1: Alarm ---
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardDarkBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.cardBorder, width: 0.8),
                    ),
                    child: Column(
                      children: [
                        _buildProfileTile(
                          icon: HugeIcons.strokeRoundedClock01,
                          title: 'Alarm',
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AlarmsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Section 2: Options ---
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardDarkBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.cardBorder, width: 0.8),
                    ),
                    child: Column(
                      children: [
                        _buildProfileTile(
                          icon: HugeIcons.strokeRoundedInformationCircle,
                          title: 'Privacy Policy',
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyPolicyScreen(selectedIndex: 1),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          height: 1,
                          color: AppColors.cardBorder,
                          indent: 16,
                          endIndent: 16,
                        ),
                        _buildProfileTile(
                          icon: HugeIcons.strokeRoundedInformationCircle,
                          title: 'Term & Condition',
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyPolicyScreen(
                                  selectedIndex: 2,
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          height: 1,
                          color: AppColors.cardBorder,
                          indent: 16,
                          endIndent: 16,
                        ),
                        _buildProfileTile(
                          icon: HugeIcons.strokeRoundedInformationCircle,
                          title: 'Help & Support',
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HelpSupportScreen(

                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          height: 1,
                          color: AppColors.cardBorder,
                          indent: 16,
                          endIndent: 16,
                        ),
                        _buildProfileTile(
                          icon: HugeIcons.strokeRoundedDelete02,
                          title: 'Delete All Chat',
                          titleColor: Colors.redAccent,
                          iconColor: Colors.redAccent,
                          onTap: () async {
                            _showDeleteAllChatDialog(context);
                          },
                        ),
                        const Divider(
                          height: 1,
                          color: AppColors.cardBorder,
                          indent: 16,
                          endIndent: 16,
                        ),
                        _buildProfileTile(
                          icon: HugeIcons.strokeRoundedLogout01,
                          title: 'Logout',
                          titleColor: Colors.redAccent,
                          iconColor: Colors.redAccent,
                          onTap: () async {
                            _showLogoutDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CupertinoActivityIndicator(color: AppColors.primaryPink),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText.medium(
                'Failed to load profile',
                color: AppColors.textSecondaryLight,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPink),
                onPressed: _refreshProfile,
                child: const Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🟢 Tile Widget with Automatic Loader and Double-Tap Guard
  Widget _buildProfileTile({
    required dynamic icon,
    required String title,
    required Future<void> Function() onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    final bool isLoading = _loadingTitle == title;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: HugeIcon(
        icon: icon,
        color: iconColor ?? AppColors.textSecondaryLight,
        size: 22.0,
      ),
      title: CustomText.medium(
        title,
        fontSize: 15,
        color: titleColor ?? AppColors.textPrimaryLight,
      ),
      trailing: isLoading
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CupertinoActivityIndicator(color: AppColors.primaryPink),
      )
          : const HugeIcon(
        icon: HugeIcons.strokeRoundedArrowRight01,
        color: AppColors.textSecondaryDark,
        size: 20.0,
      ),
      onTap: isLoading || _loadingTitle != null
          ? null // 🟢 Disable tap when any tile is loading to prevent double routing
          : () async {
        setState(() => _loadingTitle = title); // Start loader on current tile

        try {
          await onTap();
        } finally {
          if (mounted) {
            setState(() => _loadingTitle = null); // Stop loader when navigation/action finishes
          }
        }
      },
    );
  }
}