import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/const_text.dart';
import '../profile/profile_model/all_policy.dart';
import '../profile/provider/profile_provider.dart';

class PrivacyPolicyScreen extends ConsumerStatefulWidget {
  final int selectedIndex;

  const PrivacyPolicyScreen({
    super.key,
    required this.selectedIndex,
  });

  @override
  ConsumerState<PrivacyPolicyScreen> createState() =>
      _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends ConsumerState<PrivacyPolicyScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(policyProvider.notifier).term();
    });
  }

  @override
  Widget build(BuildContext context) {
    final policyState = ref.watch(policyProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: policyState.when(
        data: (AllPolicy? policyModel) {
          final policies = policyModel?.data ?? [];

          if (policies.isEmpty ||
              widget.selectedIndex < 0 ||
              widget.selectedIndex >= policies.length) {
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
              ),
              body: Center(
                child: CustomText.regular(
                  'No policy content found for index #${widget.selectedIndex}',
                  color: AppColors.textSecondaryLight,
                ),
              ),
            );
          }

          final Data selectedData = policies[widget.selectedIndex];

          final String pageTitle = selectedData.title ?? 'Policy';
          final String htmlContent =
              selectedData.content ?? '<p>No content available.</p>';
          final String updatedDate = selectedData.updatedAt != null
              ? selectedData.updatedAt!.split('T').first
              : '2026-08-07';

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
                pageTitle,
                fontSize: 18,
                color: AppColors.textPrimaryLight,
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomText.bold(
                      pageTitle,
                      fontSize: 22,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColors.cardDarkBg,
                        borderRadius: BorderRadius.circular(14),
                        border:
                        Border.all(color: AppColors.cardBorder, width: 0.8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMetaRow('Last Updated: ', updatedDate),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.zero,
                    decoration: const BoxDecoration(
                      color: AppColors.bgBlack,
                    ),
                    child: Html(
                      data: htmlContent,
                      style: {
                        "html": Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                        ),
                        "body": Style(
                          color: AppColors.textSecondaryLight,
                          fontSize: FontSize(14.0),
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                          lineHeight: const LineHeight(1.6),
                        ),
                        "p": Style(
                          color: AppColors.textSecondaryLight,
                          fontSize: FontSize(14.0),
                          margin: Margins.only(bottom: 12.0),
                          padding: HtmlPaddings.zero,
                          lineHeight: const LineHeight(1.6),
                        ),
                        "h1": Style(
                          color: AppColors.textPrimaryLight,
                          fontSize: FontSize(22.0),
                          fontWeight: FontWeight.bold,
                          margin: Margins.only(top: 16.0, bottom: 10.0),
                          padding: HtmlPaddings.zero,
                        ),
                        "h2": Style(
                          color: AppColors.textPrimaryLight,
                          fontSize: FontSize(18.0),
                          fontWeight: FontWeight.bold,
                          margin: Margins.only(top: 14.0, bottom: 8.0),
                          padding: HtmlPaddings.zero,
                        ),
                        "h3": Style(
                          color: AppColors.textPrimaryLight,
                          fontSize: FontSize(16.0),
                          fontWeight: FontWeight.w600,
                          margin: Margins.only(top: 12.0, bottom: 6.0),
                          padding: HtmlPaddings.zero,
                        ),
                        "ul": Style(
                          margin: Margins.only(bottom: 12.0),
                          padding: HtmlPaddings.zero,
                        ),
                        "ol": Style(
                          margin: Margins.only(bottom: 12.0),
                          padding: HtmlPaddings.zero,
                        ),
                        "li": Style(
                          color: AppColors.textSecondaryLight,
                          fontSize: FontSize(14.0),
                          margin: Margins.only(bottom: 6.0),
                          padding: HtmlPaddings.zero,
                        ),
                        "strong": Style(
                          color: AppColors.textPrimaryLight,
                          fontWeight: FontWeight.bold,
                        ),
                        "b": Style(
                          color: AppColors.textPrimaryLight,
                          fontWeight: FontWeight.bold,
                        ),
                        "em": Style(
                          fontStyle: FontStyle.italic,
                        ),
                        "i": Style(
                          fontStyle: FontStyle.italic,
                        ),
                        "a": Style(
                          color: AppColors.primaryPink,
                          textDecoration: TextDecoration.underline,
                        ),
                        "blockquote": Style(
                          margin: Margins.only(top: 8.0, bottom: 12.0),
                          padding: HtmlPaddings.all(12.0),
                          backgroundColor: Colors.white.withOpacity(0.05),
                        ),
                        "code": Style(
                          backgroundColor: Colors.white10,
                          color: AppColors.textPrimaryLight,
                          fontSize: FontSize(13.0),
                          padding: HtmlPaddings.zero,
                        ),
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Divider(color: AppColors.cardBorder, height: 1),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
        loading: () => Scaffold(
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
          ),
          body: const Center(
            child: CupertinoActivityIndicator(color: AppColors.primaryPink),
          ),
        ),
        error: (err, stack) => Scaffold(
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
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText.medium(
                  'Failed to load policy',
                  color: AppColors.textSecondaryLight,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                  ),
                  onPressed: () {
                    ref.read(policyProvider.notifier).term();
                  },
                  child: const Text('Retry',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
}