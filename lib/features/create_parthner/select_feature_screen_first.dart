import 'package:flutter/material.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/create_parthner/select_feature_screen_second.dart';
import '../../core/constants/const_text.dart';

class CreatePartnerFormScreen extends StatefulWidget {
  const CreatePartnerFormScreen({super.key});

  @override
  State<CreatePartnerFormScreen> createState() =>
      _CreatePartnerFormScreenState();
}

class _CreatePartnerFormScreenState extends State<CreatePartnerFormScreen> {
  final TextEditingController _nameController = TextEditingController();

  // Selection States
  String _selectedRelationship = 'Girlfriend';
  double _selectedAge = 22;

  final List<String> _relationshipOptions = [
    'Girlfriend',
    'Bestie',
    'Wife',
    'Crush',
    'Soulmate',
    'Bhabhi',
    'Step Sis',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
                color: Color(0xFF222224),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: AppColors.textPrimaryLight,
                size: 20,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: CustomText.bold(
          'Create AI Partner',
          fontSize: 16,
          color: AppColors.textPrimaryLight,
        ),
        actions: [
          TextButton(
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonalityTraitsScreen(),
                ),
              );

              // Next action
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
              // --- 1. HEADER TITLE & SUBTITLE ---
              CustomText.bold(
                'Create Your AI\nPartner',
                fontSize: 28,
                color: AppColors.textPrimaryLight,
                height: 1.2,
              ),
              const SizedBox(height: 6),
              CustomText.regular(
                'Customize your perfect companion',
                fontSize: 14,
                color: AppColors.textSecondaryLight,
              ),

              const SizedBox(height: 24),

              // --- 2. PROFILE AVATAR WITH CAMERA BADGE ---
              Center(
                child: Stack(
                  children: [
                    // Main Gradient Circle Avatar with Glow Shadow
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFF6565),
                            AppColors.primaryPink,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPink.withOpacity(0.4),
                            blurRadius: 35,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.people_alt_rounded,
                          size: 70,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                    ),

                    // Camera Icon Button
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          // Upload/Select Image Action
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.black87,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // --- 3. HER NAME FIELD ---
              CustomText.bold(
                'Her Name',
                fontSize: 16,
                color: AppColors.textPrimaryLight,
              ),
              const SizedBox(height: 12),
              Container(
                height: 54,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardDarkBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.adjust_rounded,
                      color: AppColors.textSecondaryLight,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        style: const TextStyle(
                          color: AppColors.textPrimaryLight,
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter a beautiful name',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondaryLight,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // --- 4. YOUR RELATIONSHIP ---
              CustomText.bold(
                'Your Relationship',
                fontSize: 16,
                color: AppColors.textPrimaryLight,
              ),
              const SizedBox(height: 14),

              Wrap(
                spacing: 10,
                runSpacing: 12,
                children: _relationshipOptions.map((relation) {
                  final isSelected = _selectedRelationship == relation;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedRelationship = relation);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        // 🌸 Selected par Primary Pink, unselected par Dark Background
                        color: isSelected
                            ? AppColors.primaryPink
                            : const Color(0xFF18181A),
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
                        relation,
                        fontSize: 14,
                        color: Colors.white, // ⚪ Selected Text Pure White
                      )
                          : CustomText.regular(
                        relation,
                        fontSize: 14,
                        color: AppColors.textPrimaryLight.withOpacity(0.7),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // --- 5. HER AGE SLIDER ---
              CustomText.bold(
                'Her Age: ${_selectedAge.round()}',
                fontSize: 16,
                color: AppColors.textPrimaryLight,
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                decoration: BoxDecoration(
                  color: AppColors.cardDarkBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 4,
                        activeTrackColor: AppColors.primaryPink,
                        inactiveTrackColor: Colors.white24,
                        thumbColor: Colors.white,
                        overlayColor: AppColors.primaryPink.withOpacity(0.2),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 10,
                          elevation: 4,
                        ),
                      ),
                      child: Slider(
                        value: _selectedAge,
                        min: 18,
                        max: 45,
                        onChanged: (val) {
                          setState(() => _selectedAge = val);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText.regular(
                            '18',
                            fontSize: 12,
                            color: AppColors.textSecondaryLight,
                          ),
                          CustomText.regular(
                            '45',
                            fontSize: 12,
                            color: AppColors.textSecondaryLight,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}