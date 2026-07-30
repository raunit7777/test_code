import 'package:flutter/material.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/const_text.dart';

class PartnerModel {
  final String name;
  final String tag;
  final String imageUrl;

  const PartnerModel({
    required this.name,
    required this.tag,
    required this.imageUrl,
  });
}

class SelectPartnerScreen extends StatelessWidget {
  const SelectPartnerScreen({super.key});

  // Dummy list for partners
  static const List<PartnerModel> _partners = [
    PartnerModel(
      name: 'Aarohi',
      tag: 'cute senior 😍',
      imageUrl: 'assets/21.png',
    ),
    PartnerModel(
      name: 'Ananya',
      tag: 'deshi beauty 🌸',
      imageUrl: 'assets/22.png',
    ),
    PartnerModel(
      name: 'Ananya',
      tag: 'deshi beauty 🌸',
      imageUrl: 'assets/23.png',
    ),
    PartnerModel(
      name: 'Ananya',
      tag: 'deshi beauty 🌸',
      imageUrl: 'assets/24.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      appBar: AppBar(
        backgroundColor: AppColors.bgBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimaryLight,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: CustomText.bold(
          'Select Partner',
          color: AppColors.textPrimaryLight,
          fontSize: 22,
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          itemCount: _partners.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final partner = _partners[index];
            return _PartnerCard(partner: partner);
          },
        ),
      ),
    );
  }
}

// Partner Card Sub-widget
class _PartnerCard extends StatelessWidget {
  final PartnerModel partner;

  const _PartnerCard({required this.partner});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 440,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        // Outer Glow Shadow for Card Container
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.25),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: -2,
          ),
        ],
        border: Border.all(
          color: AppColors.primaryPink.withOpacity(0.6),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.asset(
              partner.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.cardDarkBg,
                child: const Center(
                  child: Icon(
                    Icons.person,
                    color: AppColors.textSecondaryLight,
                    size: 60,
                  ),
                ),
              ),
            ),

            // Bottom Multi-Layer Dark Gradient for readability
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black12,
                      Colors.black54,
                      Colors.black87,
                    ],
                    stops: [0.4, 0.65, 0.85, 1.0],
                  ),
                ),
              ),
            ),

            // Partner Info (Name & Tag Chip with Text Shadow)
            Positioned(
              left: 20,
              bottom: 24,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name Text with Magenta Glow Effect
                  Stack(
                    children: [
                      // Text Glow Shadow
                      Text(
                        partner.name,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPink,
                          shadows: [
                            Shadow(
                              color: AppColors.primaryPink.withOpacity(0.9),
                              blurRadius: 20,
                            ),
                            Shadow(
                              color: AppColors.primaryPink.withOpacity(0.6),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      // Main Text
                      CustomText.bold(
                        partner.name,
                        color: AppColors.textPrimaryLight,
                        fontSize: 32,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Tag Pill Chip with Border & Soft Shadow
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bgBlack.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.textPrimaryLight.withOpacity(0.25),
                        width: 1,
                      ),
                    ),
                    child: CustomText.medium(
                      partner.tag,
                      color: AppColors.textPrimaryLight,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}