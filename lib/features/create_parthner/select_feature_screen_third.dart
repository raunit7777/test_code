import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/create_parthner/repo/create_partner_repo.dart';
import 'package:infinity_love/features/create_parthner/review_ai_model.dart';
import '../../core/constants/const_text.dart';


class AdditionalTraitsScreen extends ConsumerStatefulWidget {
  const AdditionalTraitsScreen({super.key});

  @override
  ConsumerState<AdditionalTraitsScreen> createState() =>
      _AdditionalTraitsScreenState();
}

class _AdditionalTraitsScreenState
    extends ConsumerState<AdditionalTraitsScreen> {
  final List<String> _availableTraits = [
    'Adventurous',
    'Caring',
    'Creative',
    'Flirty',
    'Funny',
    'Intelligent',
    'Jealous',
    'Kind',
    'Loyal',
    'Mysterious',
    'Optimistic',
    'Patient',
    'Romantic',
    'Sarcastic',
    'Sensitive',
    'Supportive',
    'Talkative',
    'Teasing',
  ];

  final Set<String> _selectedTraits = {};

  @override
  void initState() {
    super.initState();
    // 🟢 Riverpod state se pehle se selected traits restore kar rahe hain
    final existingTraits = ref.read(createPartnerProvider).partnerData.traits;
    if (existingTraits.isNotEmpty) {
      _selectedTraits.addAll(existingTraits);
    }
  }

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

  void _onNext() {
    if (_selectedTraits.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least 1 trait')),
      );
      return;
    }

    // 🟢 Save step 3 traits data in Riverpod Provider
    ref
        .read(createPartnerProvider.notifier)
        .updateTraits(_selectedTraits.toList());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReviewScreen(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText.bold(
                    'Additional Traits',
                    fontSize: 26,
                    color: AppColors.textPrimaryLight,
                  ),
                  CustomText.regular(
                    '${_selectedTraits.length}/5 selected',
                    fontSize: 14,
                    color: AppColors.textSecondaryLight,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 12,
                runSpacing: 14,
                children: _availableTraits.map((trait) {
                  final isSelected = _selectedTraits.contains(trait);
                  return GestureDetector(
                    onTap: () => _toggleTrait(trait),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryPink
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryPink
                              : Colors.white.withOpacity(0.12),
                          width: 1,
                        ),
                      ),
                      child: isSelected
                          ? CustomText.bold(trait,
                          fontSize: 14, color: Colors.white)
                          : CustomText.regular(trait,
                          fontSize: 14,
                          color: AppColors.textPrimaryLight),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}