import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/const_text.dart'; // Apna exact path update kar lena

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
          fontSize: 18,
          color: AppColors.textPrimaryLight,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Page Header ---
            CustomText.bold(
              'Privacy & Data Policy',
              fontSize: 24,
              color: AppColors.textPrimaryLight,
            ),
            const SizedBox(height: 16),

            // --- Metadata Card ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.cardDarkBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder, width: 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMetaRow('Effective Date: ', 'September 23, 2025'),
                  const SizedBox(height: 6),
                  _buildMetaRow('Last Updated: ', 'December 13, 2025'),
                  const SizedBox(height: 6),
                  _buildMetaRow('App Version: ', '7.0.5'),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // --- 1. Introduction ---
            _buildSectionTitle('1. Introduction'),
            _buildParagraph(
              'Welcome to Infinite love. We respect your privacy and are committed to protecting your personal data. This Privacy Policy explains how we handle your information, especially your interactions with our AI characters.',
            ),

            // --- 2. Information We Collect ---
            _buildSectionTitle('2. Information We Collect'),
            _buildSubSectionTitle('2.1 Account Data'),
            _buildParagraph('Name, email, and profile details you provide during registration.'),
            _buildSubSectionTitle('2.2 Chat & Interaction Data'),
            _buildParagraph(
              'We process the text messages you send to the AI to generate responses. We may store these chat logs locally on your device or securely on our servers to maintain conversation context.',
            ),
            _buildSubSectionTitle('2.3 Device Data'),
            _buildParagraph(
              'IP address, device model, and usage patterns (e.g., how long you talk to the AI) to improve app performance.',
            ),

            // --- 3. AI and Data Usage ---
            _buildSectionTitle('3. AI and Data Usage'),
            _buildParagraph('How we use your chats is important:'),
            _buildBulletPoint('Response Generation', 'Your messages are sent to our AI providers (LLMs) solely to generate a response.'),
            _buildBulletPoint('No Public Training', 'We do NOT share your personal chats to train public AI models.'),
            _buildBulletPoint('Personalization', 'The app "remembers" details you share to make the AI friendlier and more personalized.'),

            // --- 4. Data Sharing ---
            _buildSectionTitle('4. Data Sharing'),
            _buildParagraph('We do not sell your personal data. We only share data with:'),
            _buildBulletPoint('AI Service Providers', 'Strictly for processing your inputs to generate text.'),
            _buildBulletPoint('Legal Authorities', 'If required by Indian law (e.g., in cases of cybercrime or safety threats).'),

            // --- 5. Data Security ---
            _buildSectionTitle('5. Data Security'),
            _buildParagraph(
              'We use TLS/SSL encryption for data in transit. While we strive to protect your data, please remember that no method of transmission over the internet is 100% secure. We advise against sharing sensitive financial info (like credit card numbers) with the AI character.',
            ),

            // --- 6. Children\'s Privacy ---
            _buildSectionTitle("6. Children's Privacy"),
            _buildParagraph(
              'Our Service is not intended for children under 13. We do not knowingly collect data from users under 13.\n\nUsers aged 13-17 must have parental permission. If we discover a user is under 13, we will delete their account and data immediately.',
            ),

            // --- 7. Indian Laws (DPDP Act) ---
            _buildSectionTitle('7. Indian Laws (DPDP Act)'),
            _buildParagraph('As a user in India, you have the right to:'),
            _buildBulletPoint('Access', 'Ask for a copy of your personal data.'),
            _buildBulletPoint('Correction', 'Fix incorrect data.'),
            _buildBulletPoint('Erasure', 'Request deletion of your account and chat history.'),
            _buildBulletPoint('Grievance Redressal', 'Contact our officer for any privacy complaints.'),

            // --- 8. Changes to Policy ---
            _buildSectionTitle('8. Changes to Policy'),
            _buildParagraph(
              'We may update this policy as AI technology evolves. We will notify you of significant changes via the app.',
            ),

            // --- 9. Contact & Grievance Officer ---
            _buildSectionTitle('9. Contact & Grievance Officer'),
            _buildParagraph('For privacy questions or to request data deletion, contact our Grievance Officer:'),
            _buildBulletPoint('Email', 'grievance@kishantechnologies.com'),
            _buildBulletPoint('Subject', 'Privacy Concern'),
            _buildBulletPoint('Address', 'Indore, Madhya Pradesh, India'),

            const SizedBox(height: 32),
            const Divider(color: AppColors.cardBorder, height: 1),
            const SizedBox(height: 24),

            // --- Footer ---
            Center(
              child: CustomText.bold(
                'OPERATED BY FOUNDER CODE',
                fontSize: 12,
                color: AppColors.textSecondaryDark,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // --- Helpers ---
  Widget _buildMetaRow(String label, String value) {
    return Row(
      children: [
        CustomText.medium(
          label,
          fontSize: 13,
          color: AppColors.textSecondaryLight,
        ),
        CustomText.bold(
          value,
          fontSize: 13,
          color: AppColors.textPrimaryLight,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 10.0),
      child: CustomText.bold(
        title,
        fontSize: 18,
        color: AppColors.textPrimaryLight,
      ),
    );
  }

  Widget _buildSubSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 6.0),
      child: CustomText.bold(
        title,
        fontSize: 15,
        color: AppColors.textPrimaryLight,
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: CustomText.regular(
        text,
        fontSize: 13.5,
        height: 1.5,
        color: AppColors.textSecondaryLight,
      ),
    );
  }

  Widget _buildBulletPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText.bold(
            '•  ',
            fontSize: 14,
            color: AppColors.textSecondaryLight,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: AppColors.textSecondaryLight,
                ),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}