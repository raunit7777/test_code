import 'package:flutter/material.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/create_parthner/select_feature_screen_third.dart';
import '../../core/constants/const_text.dart';

class PersonalityTraitsScreen extends StatefulWidget {
  const PersonalityTraitsScreen({super.key});

  @override
  State<PersonalityTraitsScreen> createState() =>
      _PersonalityTraitsScreenState();
}

class _PersonalityTraitsScreenState extends State<PersonalityTraitsScreen> {
  // --- Slider States (0.0 to 1.0) ---
  double _shyNaughtyValue = 0.5;
  double _caringPlayfulValue = 0.5;
  double _matureChildishValue = 0.5;

  // --- Additional Traits Multi-Select State (Max 5) ---
  final List<String> _availableTraits = [
    'Adventurous',
    'Caring',
    'Creative',
    'Flirty',
    'Funny',
    'Loyal',
    'Sarcastic',
    'Talkative',
    'Witty',
  ];

  final Set<String> _selectedTraits = {};

  void _toggleTrait(String trait) {
    setState(() {
      if (_selectedTraits.contains(trait)) {
        _selectedTraits.remove(trait);
      } else {
        if (_selectedTraits.length < 5) {
          _selectedTraits.add(trait);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You can select up to 5 traits only!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdditionalTraitsScreen(),
                ),
              );

              // Next Action
            },
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
              // --- 1. TITLE & SUBTITLE ---
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

              // --- 2. PERSONALITY SLIDERS ---
              // Slider 1: Shy vs Naughty
              _buildSliderCard(
                leftText: '😳 Shy',
                rightText: 'Naughty 😏',
                value: _shyNaughtyValue,
                onChanged: (val) => setState(() => _shyNaughtyValue = val),
              ),
              const SizedBox(height: 14),

              // Slider 2: Caring vs Playful
              _buildSliderCard(
                leftText: '💖 Caring',
                rightText: 'Playful 😜',
                value: _caringPlayfulValue,
                onChanged: (val) => setState(() => _caringPlayfulValue = val),
              ),
              const SizedBox(height: 14),

              // Slider 3: Mature vs Childish
              _buildSliderCard(
                leftText: '👔 Mature',
                rightText: 'Childish 🧸',
                value: _matureChildishValue,
                onChanged: (val) => setState(() => _matureChildishValue = val),
              ),

              const SizedBox(height: 32),

              // --- 3. ADDITIONAL TRAITS HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText.bold(
                    'Additional Traits',
                    fontSize: 16,
                    color: AppColors.textPrimaryLight,
                  ),
                  CustomText.regular(
                    '${_selectedTraits.length}/5 selected',
                    fontSize: 13,
                    color: AppColors.textSecondaryLight,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              CustomText.regular(
                'Select up to 5 traits that best describe her personality',
                fontSize: 13,
                color: AppColors.textSecondaryLight,
              ),

              const SizedBox(height: 16),

              // --- 4. TRAITS CHIPS (CUSTOM ANIMATED CONTAINER) ---
              Wrap(
                spacing: 10,
                runSpacing: 12,
                children: _availableTraits.map((trait) {
                  final isSelected = _selectedTraits.contains(trait);
                  return GestureDetector(
                    onTap: () => _toggleTrait(trait),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryPink
                            : AppColors.cardDarkBg,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryPink
                              : Colors.white.withOpacity(0.12),
                          width: 1,
                        ),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: AppColors.primaryPink.withOpacity(0.35),
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ]
                            : null,
                      ),
                      child: isSelected
                          ? CustomText.bold(
                        trait,
                        fontSize: 14,
                        color: Colors.white,
                      )
                          : CustomText.medium(
                        trait,
                        fontSize: 14,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGET FOR SLIDER CARDS ---
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
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText.medium(
                leftText,
                fontSize: 14,
                color: AppColors.textPrimaryLight,
              ),
              CustomText.medium(
                rightText,
                fontSize: 14,
                color: AppColors.textPrimaryLight,
              ),
            ],
          ),
          const SizedBox(height: 6),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 5,
              activeTrackColor: AppColors.primaryPink, // Active progress Pink
              inactiveTrackColor: Colors.white12,
              thumbColor: Colors.white,
              overlayColor: AppColors.primaryPink.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10,
                elevation: 3,
              ),
            ),
            child: Slider(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}