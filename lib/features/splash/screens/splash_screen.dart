import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ✅ Added GoRouter Import

import '../../../core/constants/app_color.dart';
import '../../../core/storage/loacal_storage.dart';
import '../../../routes/routes_name.dart'; // ✅ RoutesName import
import '../../../shared/weget/loader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      // 🔍 Local Storage se Token / User ID check karein
      final token = LocalStorage.getToken();
      final userId = LocalStorage.getUserId();

      final bool isLoggedIn = (token != null && token.isNotEmpty) ||
          (userId != null && userId.isNotEmpty);

      if (isLoggedIn) {
        // ✅ User Logged In: Go to Main Bottom Navigation Screen
        context.goNamed('mainNav');
      } else {
        // ❌ Not Logged In: Go to Onboarding Screen
        context.goNamed('onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // Circular Black Logo Container
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/logo2.png',
                    width: 140,
                    height: 140,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // Main Text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Your Perfect Indian AI\nCompanion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Orbiting Dots Loader
              OrbitingDotsLoader(
                size: 50.0,
                dotColor: AppColors.primaryPink,
                circleColor: AppColors.primaryPink.withValues(alpha: 0.3),
              ),

              const Spacer(flex: 2),

              // Bottom Loader Text
              Text(
                'Hang tight! Love is loading...',
                style: TextStyle(
                  color: AppColors.textPrimaryLight.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.2,
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}