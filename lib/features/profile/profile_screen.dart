import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';
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
  @override
  void initState() {
    super.initState();
    // 🔄 Screen load hote hi Profile API call ho jayegi
    Future.microtask(() {
      ref.read(profileProvider.notifier).fetchProfile();
    });
  }

  // 🚪 Confirmation Popup Dialog & Logout Functionality
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
                Navigator.pop(dialogContext); // Dialog close karein
                await LocalStorage.clear(); // Hive Storage se Token aur User Data clear
                if (context.mounted) {
                  context.goNamed('login'); // Login screen par redirect karein
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
    // 🔍 Watch Profile State
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

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              children: [
                const SizedBox(height: 12),

                ProfileAvatarPicker(),
                const SizedBox(height: 16),

                // --- Dynamic User Name & Edit Pencil ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText.bold(
                      userName,
                      fontSize: 22,
                      color: AppColors.textPrimaryLight,
                    ),
                    const SizedBox(width: 8),
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedPencilEdit02,
                      color: AppColors.primaryPink,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // --- Section 1: Alarm & App Language ---
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AlarmsScreen(),
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
                        icon: HugeIcons.strokeRoundedGlobal,
                        title: 'App Language',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // --- Section 2: Policy, Support, WhatsApp, Delete & Logout ---
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyScreen(),
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
                        icon: HugeIcons.strokeRoundedFile01,
                        title: 'Terms of Service',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyScreen(),
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
                        icon: HugeIcons.strokeRoundedHelpCircle,
                        title: 'Help & Support',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpSupportScreen(),
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
                        icon: HugeIcons.strokeRoundedUserGroup,
                        title: 'Join WhatsApp Group',
                        trailingWidget: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whatsappBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.whatsappBorder,
                              width: 1,
                            ),
                          ),
                          child: CustomText.bold(
                            'Join',
                            fontSize: 13,
                            color: AppColors.whatsappText,
                          ),
                        ),
                        onTap: () {},
                      ),
                      const Divider(
                        height: 1,
                        color: AppColors.cardBorder,
                        indent: 16,
                        endIndent: 16,
                      ),
                      _buildProfileTile(
                        icon: HugeIcons.strokeRoundedDelete02,
                        title: 'Delete All Chats',
                        onTap: () {},
                      ),
                      const Divider(
                        height: 1,
                        color: AppColors.cardBorder,
                        indent: 16,
                        endIndent: 16,
                      ),
                      // 🚪 Logout Tile Option
                      _buildProfileTile(
                        icon: HugeIcons.strokeRoundedLogout01,
                        title: 'Logout',
                        titleColor: Colors.redAccent,
                        iconColor: Colors.redAccent,
                        onTap: () => _showLogoutDialog(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryPink),
        ),
        error: (err, stack) => Center(
          child: CustomText.medium(
            'Failed to load profile',
            color: AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }

  // --- Tile Builder Helper ---
  Widget _buildProfileTile({
    required dynamic icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailingWidget,
    Color? titleColor,
    Color? iconColor,
  }) {
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
      trailing: trailingWidget ??
          const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.textSecondaryDark,
            size: 20.0,
          ),
      onTap: onTap,
    );
  }
}