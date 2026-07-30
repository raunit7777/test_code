import 'package:flutter/material.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/create_parthner/select_feature_screen_first.dart';

import '../../core/constants/app_btn.dart';
import '../../core/constants/const_text.dart';


class CreatePartnerIntroScreen extends StatefulWidget {
  const CreatePartnerIntroScreen({super.key});

  @override
  State<CreatePartnerIntroScreen> createState() =>
      _CreatePartnerIntroScreenState();
}

class _CreatePartnerIntroScreenState extends State<CreatePartnerIntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Staggered Animations
  late Animation<double> _circleScaleAnimation;
  late Animation<double> _circleFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _buttonFadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // 1. Circle Avatar Animation (0% - 45% of total time)
    _circleScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _circleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    // 2. Text Content Animation (35% - 75% of total time)
    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
          ),
        );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.35, 0.70, curve: Curves.easeIn),
      ),
    );

    // 3. Button Entrance Animation (65% - 100% of total time)
    _buttonScaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.65, 0.90, curve: Curves.easeIn),
      ),
    );

    // Start Sequence Animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const Spacer(),

              // --- 1. ANIMATED CIRCLE AVATAR WITH GLOW ---
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _circleFadeAnimation,
                    child: ScaleTransition(
                      scale: _circleScaleAnimation,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer Glow Blur Aura
                            Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryPink.withOpacity(0.35),
                                    blurRadius: 50,
                                    spreadRadius: 10,
                                  ),
                                  BoxShadow(
                                    color: Colors.purpleAccent.withOpacity(0.25),
                                    blurRadius: 60,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            ),

                            // Gradient Ring Border Container
                            Container(
                              width: 210,
                              height: 210,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFF5284),
                                    Color(0xFF9C27B0),
                                    Color(0xFF536DFE),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.bgBlack,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white.withOpacity(0.12),
                                          Colors.white.withOpacity(0.02),
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.person_rounded,
                                        size: 95,
                                        color: AppColors.textPrimaryLight,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 48),

              // --- 2. ANIMATED TEXT CONTENT ---
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _textFadeAnimation,
                    child: SlideTransition(
                      position: _textSlideAnimation,
                      child: Column(
                        children: [
                          CustomText.bold(
                            'Create Your AI Partner',
                            fontSize: 32,textAlign: TextAlign.center,
                            color: AppColors.textPrimaryLight,
                            height: 1.2,
                          ),
                          const SizedBox(height: 18),
                          CustomText.regular(
                            'Design your perfect AI companion with a unique personality, interests, and knowledge base for meaningful conversations and connections.',
                            fontSize: 15,textAlign: TextAlign.center,
                            color: AppColors.textSecondaryLight,
                            height: 1.5,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              // --- 3. CUSTOM ANIMATED APPBTN ---
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _buttonFadeAnimation,
                    child: ScaleTransition(
                      scale: _buttonScaleAnimation,
                      child: AppBtn(
                        title: 'Create My AI Partner',
                        color: AppColors.primaryPink,
                        titleColor: AppColors.textPrimaryLight,
                        fontSize: 17,
                        borderRadius: 20,
                        height: 56,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreatePartnerFormScreen(),
                            ),
                          );


                          // Navigation/Action logic here
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}