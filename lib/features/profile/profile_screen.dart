import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/const_text.dart';
import '../../shared/weget/image_pick.dart';
import '../alarm/alram_screen.dart';
import '../policy/help_and_support.dart';
import '../policy/term_and_condition.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          children: [
            const SizedBox(height: 12),

            ProfileAvatarPicker(),
            const SizedBox(height: 16),

            // --- User Name & Edit Pencil ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText.bold(
                  'User',
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

            // --- Section 2: Policy, Support, WhatsApp & Delete ---
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
                          builder: (context) => const PrivacyPolicyScreen(), // Apne route ka naam yahan likhein
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
                          builder: (context) => const PrivacyPolicyScreen(), // Apne route ka naam yahan likhein
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
                          builder: (context) => const HelpSupportScreen(), // Apne route ka naam yahan likhein
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
                        color:AppColors. whatsappBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.whatsappBorder,
                          width: 1,
                        ),
                      ),
                      child: CustomText.bold(
                        'Join',
                        fontSize: 13,
                        color:AppColors. whatsappText,
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
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
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
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: HugeIcon(
        icon: icon,
        color: AppColors.textSecondaryLight,
        size: 22.0,
      ),
      title: CustomText.medium(
        title,
        fontSize: 15,
        color: AppColors.textPrimaryLight,
      ),
      trailing:
      trailingWidget ??
          const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.textSecondaryDark,
            size: 20.0,
          ),
      onTap: onTap,
    );
  }
}