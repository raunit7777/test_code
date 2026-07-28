import 'dart:async';
import 'package:flutter/material.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/splash/screens/select_language_screen.dart';

import '../../../core/constants/const_text.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Page 2 Grid Auto-scroll setup
  final ScrollController _gridScrollController = ScrollController();
  Timer? _autoScrollTimer;

  // Page 3 Features Data
  final List<Map<String, dynamic>> _features = const [
    {
      'title': 'Create Your AI',
      'subtitle':
      'Design and customize your own AI partner with unique personality traits and interests.',
      'icon': Icons.person_add_alt_1_rounded,
    },
    {
      'title': 'Role Play Mode',
      'subtitle':
      'Engage in immersive role-playing scenarios with your AI partner.',
      'icon': Icons.chat_bubble_outline_rounded,
    },
    {
      'title': 'Play Games Together',
      'subtitle': 'Enjoy fun games like Ludo with your AI partner anytime!',
      'icon': Icons.sports_esports_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startSlowAutoScroll();
  }

  void _startSlowAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_gridScrollController.hasClients) return;

      final maxScroll = _gridScrollController.position.maxScrollExtent;
      final currentScroll = _gridScrollController.offset;

      if (currentScroll >= maxScroll) {
        _gridScrollController.jumpTo(0);
      } else {
        _gridScrollController.animateTo(
          currentScroll + 0.8,
          duration: const Duration(milliseconds: 50),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _gridScrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChooseLanguageScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: AppColors.bgBlack),
        child: SafeArea(
          child: Column(
            children: [
              // Dynamic Pages Slider
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildPage1(),
                    _buildPage2(),
                    _buildPage3(),
                  ],
                ),
              ),

              // Page 2 par dots & bottom button hide rahenge
              if (_currentPage != 1)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  child: Column(
                    children: [
                      // Page Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                              (index) => _buildDot(index),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Floating Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: _onNextPressed,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFF2A7A),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x40FF2A7A),
                                  blurRadius: 15,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Icon(
                              _currentPage == 2
                                  ? Icons.check
                                  : Icons.arrow_forward,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // --- SCREEN 1: Welcome ---
  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Spacer(flex: 2),

          Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0B0A0F),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF2B7A).withValues(alpha: 0.15),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/logo2.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.favorite,
                  color: Color(0xFFFF2A7A),
                  size: 80,
                ),
              ),
            ),
          ),

          const Spacer(flex: 2),

          CustomText.bold(
            'Welcome to\nInfinite love',
            textAlign: TextAlign.center,
            fontSize: 32,
            color: Colors.white,
            height: 1.25,
          ),

          const SizedBox(height: 16),

          CustomText.regular(
            'Your personal, insightful, and always-\navailable AI Partner.',
            textAlign: TextAlign.center,
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.6),
            height: 1.4,
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }

  // --- SCREEN 2: Meet Partners (Grid View) ---
  Widget _buildPage2() {
    return Column(
      children: [
        const SizedBox(height: 8),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              controller: _gridScrollController,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.78,
              ),
              itemCount: 30,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.asset(
                      'assets/11.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF1E1A24),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white24,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Bottom Banner Container
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
          decoration: BoxDecoration(
            color: const Color(0xFF131118),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText.bold(
                      'Meet Your AI Partners',
                      color: const Color(0xFFFF2A7A),
                      fontSize: 22,
                      letterSpacing: -0.3,
                    ),
                    const SizedBox(height: 8),
                    CustomText.regular(
                      'Discover unique personalities ready to connect with you. Each AI partner has its own distinct personality and expertise.',
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13.5,
                      height: 1.4,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              GestureDetector(
                onTap: _onNextPressed,
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFF2A7A),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x55FF2A7A),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- SCREEN 3: Features ---
  Widget _buildPage3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          CustomText.bold(
            'Explore Amazing\nFeatures',
            textAlign: TextAlign.center,
            fontSize: 28,
            color: const Color(0xFFFF2A7A),
            height: 1.2,
          ),
          const SizedBox(height: 24),

          ..._features.map((item) => _buildFeatureCard(item)),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChooseLanguageScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF2A7A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: CustomText.bold(
                'Start Your Journey',
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16131A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accentPink,
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF2A7A).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              feature['icon'] as IconData,
              color: const Color(0xFFFF2A7A),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.bold(
                  feature['title']!,
                  fontSize: 16,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                CustomText.regular(
                  feature['subtitle']!,
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.5),
                  height: 1.3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 18 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFFF2A7A)
            : Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}