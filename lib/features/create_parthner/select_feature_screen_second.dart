import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/create_parthner/repo/create_partner_repo.dart';
import 'package:infinity_love/features/create_parthner/select_feature_screen_third.dart';
import '../../core/constants/const_text.dart';


class PersonalityTraitsScreen extends ConsumerStatefulWidget {
  const PersonalityTraitsScreen({super.key});

  @override
  ConsumerState<PersonalityTraitsScreen> createState() =>
      _PersonalityTraitsScreenState();
}

class _PersonalityTraitsScreenState
    extends ConsumerState<PersonalityTraitsScreen> {
  double _shyNaughtyValue = 0.5;
  double _caringPlayfulValue = 0.5;
  double _matureChildishValue = 0.5;

  @override
  void initState() {
    super.initState();
    // 🟢 Riverpod state se existing slider values retrieve kar rahe hain
    final existingData = ref.read(createPartnerProvider).partnerData;
    _shyNaughtyValue = existingData.shyNaughty;
    _caringPlayfulValue = existingData.caringPlayful;
    _matureChildishValue = existingData.matureChildish;
  }

  void _onNext() {
    // 🟢 Save step 2 sliders data in Riverpod
    ref.read(createPartnerProvider.notifier).updateSliders(
      shyNaughty: _shyNaughtyValue,
      caringPlayful: _caringPlayfulValue,
      matureChildish: _matureChildishValue,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AdditionalTraitsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      appBar: AppBar(
        backgroundColor: AppColors.bgBlack,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E22),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.textPrimaryLight,
                size: 20,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: CustomText.bold(
          'Personality',
          fontSize: 16,
          color: AppColors.textPrimaryLight,
        ),
        actions: [
          TextButton(
            onPressed: _onNext,
            child: CustomText.bold(
              'Next',
              fontSize: 16,
              color: AppColors.primaryPink,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText.bold(
                'Personality Traits',
                fontSize: 28,
                color: AppColors.textPrimaryLight,
              ),
              const SizedBox(height: 6),
              CustomText.regular(
                'Adjust the sliders to define her personality',
                fontSize: 14,
                color: AppColors.textSecondaryLight,
              ),
              const SizedBox(height: 24),

              _buildSliderCard(
                leftText: '😳 Shy',
                rightText: 'Naughty 😏',
                value: _shyNaughtyValue,
                onChanged: (val) => setState(() => _shyNaughtyValue = val),
              ),
              const SizedBox(height: 14),

              _buildSliderCard(
                leftText: '💖 Caring',
                rightText: 'Playful 😜',
                value: _caringPlayfulValue,
                onChanged: (val) => setState(() => _caringPlayfulValue = val),
              ),
              const SizedBox(height: 14),

              _buildSliderCard(
                leftText: '👔 Mature',
                rightText: 'Childish 🧸',
                value: _matureChildishValue,
                onChanged: (val) => setState(() => _matureChildishValue = val),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderCard({
    required String leftText,
    required String rightText,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardDarkBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText.medium(leftText, fontSize: 14, color: AppColors.textPrimaryLight),
              CustomText.medium(rightText, fontSize: 14, color: AppColors.textPrimaryLight),
            ],
          ),
          const SizedBox(height: 6),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 5,
              activeTrackColor: AppColors.primaryPink,
              inactiveTrackColor: Colors.white12,
              thumbColor: Colors.white,
              overlayColor: AppColors.primaryPink.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 3),
            ),
            child: Slider(value: value, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}