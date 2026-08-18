import 'dart:async';
import 'package:flutter/material.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/auth/login_screen.dart';

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
    _autoScrollTimer =
        Timer.periodic(const Duration(milliseconds: 50), (timer) {
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
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double screenHeight = size.height;

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
                    _buildPage1(screenWidth, screenHeight),
                    _buildPage2(screenWidth, screenHeight),
                    _buildPage3(screenWidth, screenHeight),
                  ],
                ),
              ),

              // Page 1 Navigation Bottom Bar
              if (_currentPage == 0)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.015,
                  ),
                  child: Column(
                    children: [
                      // Page Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                              (index) => _buildDot(index, screenWidth),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // Floating Arrow Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: _onNextPressed,
                          child: Container(
                            width: screenWidth * 0.15,
                            height: screenWidth * 0.15,
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
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: screenWidth * 0.07,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // --- SCREEN 1: Welcome (MediaQuery Managed) ---
  Widget _buildPage1(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
      child: Column(
        children: [
          const Spacer(flex: 2),

          Container(
            width: screenWidth * 0.58,
            height: screenWidth * 0.58,
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
                width: screenWidth * 0.38,
                height: screenWidth * 0.38,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.favorite,
                  color: const Color(0xFFFF2A7A),
                  size: screenWidth * 0.2,
                ),
              ),
            ),
          ),

          const Spacer(flex: 2),

          CustomText.bold(
            'Welcome to\nInfinite love',
            textAlign: TextAlign.center,
            fontSize: screenWidth * 0.08,
            color: Colors.white,
            height: 1.25,
          ),

          SizedBox(height: screenHeight * 0.02),

          CustomText.regular(
            'Your personal, insightful, and always-\navailable AI Partner.',
            textAlign: TextAlign.center,
            fontSize: screenWidth * 0.038,
            color: Colors.white.withValues(alpha: 0.6),
            height: 1.4,
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }

  // --- SCREEN 2: Meet Partners Grid (MediaQuery Managed) ---
  Widget _buildPage2(double screenWidth, double screenHeight) {
    final List<String> partnerImages = [
      'assets/21.png',
      'assets/22.png',
      'assets/23.png',
      'assets/24.png',
    ];

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.01),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: GridView.builder(
              controller: _gridScrollController,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: screenWidth * 0.02,
                mainAxisSpacing: screenHeight * 0.01,
                childAspectRatio: 0.78,
              ),
              itemCount: 30,
              itemBuilder: (context, index) {
                final String imagePath =
                partnerImages[index % partnerImages.length];

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.035),
                    border: Border.all(
                      color: AppColors.textPrimaryLight.withOpacity(0.08),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(screenWidth * 0.032),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.cardDarkBg,
                        child: Icon(
                          Icons.person,
                          color: AppColors.textSecondaryDark,
                          size: screenWidth * 0.065,
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
          margin: EdgeInsets.all(screenWidth * 0.03),
          padding: EdgeInsets.all(screenWidth * 0.045),
          decoration: BoxDecoration(
            color: AppColors.profileCardBg,
            borderRadius: BorderRadius.circular(screenWidth * 0.06),
            border: Border.all(
              color: AppColors.textPrimaryLight.withOpacity(0.05),
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
                      color: AppColors.primaryPink,
                      fontSize: screenWidth * 0.052,
                      letterSpacing: -0.3,
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    CustomText.regular(
                      'Discover unique personalities ready to connect with you. Each AI partner has its own distinct personality and expertise.',
                      color: AppColors.textSecondaryLight,
                      fontSize: screenWidth * 0.033,
                      height: 1.4,
                    ),
                  ],
                ),
              ),

              SizedBox(width: screenWidth * 0.03),

              GestureDetector(
                onTap: _onNextPressed,
                child: Container(
                  width: screenWidth * 0.13,
                  height: screenWidth * 0.13,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryPink,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPink.withOpacity(0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: AppColors.whiteSheetBg,
                    size: screenWidth * 0.065,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- SCREEN 3: Features (MediaQuery Managed) ---
  Widget _buildPage3(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.06,
        vertical: screenHeight * 0.02,
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.01),
          CustomText.bold(
            'Explore Amazing\nFeatures',
            textAlign: TextAlign.center,
            fontSize: screenWidth * 0.07,
            color: const Color(0xFFFF2A7A),
            height: 1.2,
          ),
          SizedBox(height: screenHeight * 0.03),

          ..._features.map((item) =>
              _buildFeatureCard(item, screenWidth, screenHeight)),

          const Spacer(),

          // Single Main "Start Your Journey" Button
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.065,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF2A7A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                ),
                elevation: 4,
              ),
              child: CustomText.bold(
                'Start Your Journey',
                fontSize: screenWidth * 0.045,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      Map<String, dynamic> feature,
      double screenWidth,
      double screenHeight,
      ) {
    return Container(
      height: screenHeight * 0.13,
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFF16131A),
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(
          color: AppColors.accentPink,
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth * 0.025),
            decoration: BoxDecoration(
              color: const Color(0xFFFF2A7A).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            child: Icon(
              feature['icon'] as IconData,
              color: const Color(0xFFFF2A7A),
              size: screenWidth * 0.06,
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.bold(
                  feature['title']!,
                  fontSize: screenWidth * 0.04,
                  color: Colors.white,
                ),
                SizedBox(height: screenHeight * 0.005),
                CustomText.regular(
                  feature['subtitle']!,
                  fontSize: screenWidth * 0.032,
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

  Widget _buildDot(int index, double screenWidth) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
      width: isActive ? screenWidth * 0.045 : screenWidth * 0.02,
      height: screenWidth * 0.02,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFFF2A7A)
            : Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(screenWidth * 0.01),
      ),
    );
  }
}