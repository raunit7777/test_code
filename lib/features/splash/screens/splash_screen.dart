// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart'; // ✅ Added GoRouter Import
//
// import '../../../core/constants/app_color.dart';
// import '../../../core/storage/loacal_storage.dart';
// import '../../../routes/routes_name.dart'; // ✅ RoutesName import
// import '../../../shared/weget/loader.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkAuthAndNavigate();
//   }
//
//   void _checkAuthAndNavigate() {
//     Future.delayed(const Duration(seconds: 3), () {
//       if (!mounted) return;
//
//       // 🔍 Local Storage se Token / User ID check karein
//       final token = LocalStorage.getToken();
//       final userId = LocalStorage.getUserId();
//
//       final bool isLoggedIn = (token != null && token.isNotEmpty) ||
//           (userId != null && userId.isNotEmpty);
//
//       if (isLoggedIn) {
//         // ✅ User Logged In: Go to Main Bottom Navigation Screen
//         context.goNamed('mainNav');
//       } else {
//         // ❌ Not Logged In: Go to Onboarding Screen
//         context.goNamed('onboarding');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: AppColors.splashGradient,
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Spacer(flex: 3),
//
//               // Circular Black Logo Container
//               Container(
//                 width: 220,
//                 height: 220,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.black,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: 0.3),
//                       blurRadius: 12,
//                       spreadRadius: 2,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Image.asset(
//                     'assets/logo2.png',
//                     width: 140,
//                     height: 140,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 50),
//
//               // Main Text
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 32.0),
//                 child: Text(
//                   'Your Perfect Indian AI\nCompanion',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: AppColors.textPrimaryLight,
//                     fontSize: 22,
//                     fontWeight: FontWeight.w400,
//                     height: 1.4,
//                     letterSpacing: 0.2,
//                   ),
//                 ),
//               ),
//
//               const Spacer(flex: 2),
//
//               // Orbiting Dots Loader
//               OrbitingDotsLoader(
//                 size: 50.0,
//                 dotColor: AppColors.primaryPink,
//                 circleColor: AppColors.primaryPink.withValues(alpha: 0.3),
//               ),
//
//               const Spacer(flex: 2),
//
//               // Bottom Loader Text
//               Text(
//                 'Hang tight! Love is loading...',
//                 style: TextStyle(
//                   color: AppColors.textPrimaryLight.withValues(alpha: 0.8),
//                   fontSize: 14,
//                   fontWeight: FontWeight.w300,
//                   letterSpacing: 0.2,
//                 ),
//               ),
//
//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_color.dart';
import '../../../core/storage/loacal_storage.dart';
import '../../../routes/routes_name.dart';
import '../../../shared/weget/loader.dart';
import '../../profile/provider/profile_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAppFlow();
  }

  Future<void> _initializeAppFlow() async {
    // 1️⃣ Wait for initial splash animation delay (3 Seconds)
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    // 2️⃣ Check App Version & Force Update Status from API
    final bool isUpdateRequired = await _checkForForcedUpdate();

    // 3️⃣ If Force Update is required, dialog will be displayed & navigation stops.
    if (!isUpdateRequired && mounted) {
      _checkAuthAndNavigate();
    }
  }

  /// 🟢 Force Update Checker Logic
  Future<bool> _checkForForcedUpdate() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;

      final policyModel =
      await ref.read(policyProvider.notifier).fetchPolicyData();

      // If data is null or empty, skip forced update check and allow navigation
      if (policyModel?.data == null || policyModel!.data!.isEmpty) {
        return false;
      }

      final configData = policyModel.data!.firstWhere(
            (e) => e.pageType == 'CONFIG' || e.sId != null,
        orElse: () => policyModel.data!.first,
      );

      // 🟢 Mapping attributes safely with fallback values
      final String minVersion = '1.0.0';
      final bool forceUpdate = false;
      final String playStoreUrl =
          'https://play.google.com/store/apps/details?id=com.fc.infinity_loved';
      final String appStoreUrl =
          'https://apps.apple.com/app/idYOUR_APP_ID';

      final bool isVersionOutdated =
      _isVersionLower(currentVersion, minVersion);

      if (forceUpdate || isVersionOutdated) {
        if (mounted) {
          _showForcedUpdateDialog(playStoreUrl, appStoreUrl);
        }
        return true;
      }
    } catch (e) {
      debugPrint('⚠️ Error checking app version update: $e');
    }

    return false;
  }

  /// Helper: Compare Semantic Version numbers (e.g. 1.0.0 vs 1.0.1)
  bool _isVersionLower(String current, String minRequired) {
    try {
      final List<int> currentParts =
      current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final List<int> minParts =
      minRequired.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      for (int i = 0; i < minParts.length; i++) {
        final int currentNum = i < currentParts.length ? currentParts[i] : 0;
        if (currentNum < minParts[i]) return true;
        if (currentNum > minParts[i]) return false;
      }
    } catch (_) {}
    return false;
  }

  /// 🟢 Non-Dismissible Forced Update Dialog
  void _showForcedUpdateDialog(String playStoreUrl, String appStoreUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: const Color(0xFF1E1E20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: AppColors.cardBorder, width: 0.8),
            ),
            title: const Row(
              children: [
                Icon(Icons.system_update_rounded, color: AppColors.primaryPink),
                SizedBox(width: 10),
                Text(
                  'Update Required',
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            content: const Text(
              'A new version of Infinity Love is available with important improvements. Please update to continue.',
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    if (Platform.isAndroid) {
                      try {
                        final updateInfo = await InAppUpdate.checkForUpdate();
                        if (updateInfo.updateAvailability ==
                            UpdateAvailability.updateAvailable) {
                          await InAppUpdate.performImmediateUpdate();
                          return;
                        }
                      } catch (e) {
                        debugPrint("Play Store In-App Update failed: $e");
                      }
                    }

                    final String targetUrl =
                    Platform.isAndroid ? playStoreUrl : appStoreUrl;
                    final Uri uri = Uri.parse(targetUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: const Text(
                    'Update Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _checkAuthAndNavigate() {
    final token = LocalStorage.getToken();
    final userId = LocalStorage.getUserId();

    final bool isLoggedIn = (token != null && token.isNotEmpty) ||
        (userId != null && userId.isNotEmpty);

    if (isLoggedIn) {
      context.goNamed('mainNav');
    } else {
      context.goNamed('onboarding');
    }
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