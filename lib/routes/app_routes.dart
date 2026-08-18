// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinity_love/features/chat/chat_screen.dart';
import 'package:infinity_love/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/bottom_nav.dart';
import '../features/chat/chat_screen_3.dart';
import '../features/custmization/model_custmization.dart';
import '../features/describe_image/subcription_screen.dart';
import '../features/home/chat_screen_2.dart';
import '../features/profile/model_profile_screen.dart';
import '../features/splash/screens/on_boading_screen.dart';
import '../features/splash/screens/splash_screen.dart';
//
// // ✅ Manual Riverpod Provider (Doesn't need build_runner / .g.dart)
// final routerProvider = Provider<GoRouter>((ref) {
//
//   final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
//   return GoRouter(
//     initialLocation: RoutesName.splash,
//     debugLogDiagnostics: true,
//     routes: [
//       // 1. Splash Screen
//       GoRoute(
//         path: RoutesName.splash,
//         name: 'splash',
//         builder: (context, state) => const SplashScreen(),
//       ),
//
//       // 2. Onboarding Screen
//       GoRoute(
//         path: RoutesName.onboarding,
//         name: 'onboarding',
//         builder: (context, state) => const OnboardingScreen(),
//       ),
//
//       // 3. Login Screen
//       GoRoute(
//         path: RoutesName.login,
//         name: 'login',
//         builder: (context, state) => const LoginScreen(),
//       ),
//
//       // 4. OTP Screen (with Mobile Param)
//       GoRoute(
//         path: RoutesName.otp,
//         name: 'otp',
//         builder: (context, state) {
//           final mobile = state.extra as String? ?? '';
//           return OtpScreen(phoneNumber: mobile);
//         },
//       ),
//
//       // 5. Bottom Navigation
//       GoRoute(
//         path: RoutesName.bottomNavBar,
//         name: 'mainNav',
//         builder: (context, state) =>  MainNavigationScreen(),
//       ),
//       GoRoute(
//         path: RoutesName.modelProfileDetailScreen,
//         name: 'modelProfile',
//         builder: (context, state) {
//           // 🔴 FIX: Extra se sId dynamic pass karna
//           final String sId = state.extra as String;
//           return ModelProfileDetailScreen(sId: sId);
//         },
//       ),
//
//       GoRoute(
//         path: RoutesName.chatScreen,
//         name: 'chatScreen',
//         builder: (context, state) {
//           final extraData = state.extra as Map<String, dynamic>?;
//           final String? sId = extraData?['sId'] as String?;
//           final String? imageUrl = extraData?['image'] as String?;
//
//           return ChatScreen(
//             sId: sId,
//             imageUrl: imageUrl,
//           );
//         },
//       ),
//
//       GoRoute(
//         path: RoutesName.chatScreen2,
//         name: 'chatScreen2',
//         builder: (context, state) {
//           final extraData = state.extra as Map<String, dynamic>?;
//           final String? sId = extraData?['sId'] as String?;
//           final String? imageUrl = extraData?['image'] as String?;
//
//           return ChatScreen2(
//             sId: sId,
//             imageUrl: imageUrl,
//           );
//         },
//       ),
//
//
//
//     ],
//   );
// });

// 🟢 TOP-LEVEL GLOBAL NAVIGATOR KEY (ApiClient se redirect ke liye compulsory hai)
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey, // 👈 🟢 Pass Global Key Here
    initialLocation: RoutesName.splash,
    debugLogDiagnostics: true,
    routes: [
      // 1. Splash Screen
      GoRoute(
        path: RoutesName.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // 2. Onboarding Screen
      GoRoute(
        path: RoutesName.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // 3. Login Screen
      GoRoute(
        path: RoutesName.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // 4. OTP Screen (with Mobile Param)
      GoRoute(
        path: RoutesName.otp,
        name: 'otp',
        builder: (context, state) {
          final mobile = state.extra as String? ?? '';
          return OtpScreen(phoneNumber: mobile);
        },
      ),

      // 5. Bottom Navigation
      GoRoute(
        path: RoutesName.bottomNavBar,
        name: 'mainNav',
        builder: (context, state) => MainNavigationScreen(),
      ),

      GoRoute(
        path: RoutesName.subriptionScreen,
        name: 'premium',
        builder: (context, state) => const PremiumSubscriptionScreen(),
      ),
      // 6. Model Profile Detail
      GoRoute(
        path: RoutesName.modelProfileDetailScreen,
        name: 'modelProfile',
        builder: (context, state) {
          final String sId = (state.extra as String?) ?? '';
          return ModelProfileDetailScreen(sId: sId);
        },
      ),
      GoRoute(
        path: RoutesName.customizePersonalityScreen,
        name: 'aiedit',
        builder: (context, state) {
          // Only receiving sId string from state.extra
          final String sId = (state.extra as String?) ?? '';

          return CustomizePersonalityScreen(
            userId: sId,
          );
        },
      ),

      // 7. Chat Screen
      GoRoute(
        path: RoutesName.chatScreen,
        name: 'chatScreen',
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>?;
          final String? sId = extraData?['sId'] as String?;
          final String? imageUrl = extraData?['image'] as String?;
          final String? name = extraData?['name'] as String?;

          return ChatScreen(
            sId: sId,
            imageUrl: imageUrl,
            name: name,
          );
        },
      ),

      // 8. Chat Screen 2
      GoRoute(
        path: RoutesName.chatScreen2,
        name: 'chatScreen2',
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>?;
          final String? sId = extraData?['sId'] as String?;
          final String? imageUrl = extraData?['image'] as String?;

          return ChatScreen2(
            sId: sId,
            imageUrl: imageUrl,
          );
        },
      ),
      GoRoute(
        path: RoutesName.chatScreen3,
        name: 'chatScreen3',
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>?;
          final String? sId = extraData?['sId'] as String?;
          final String? id = extraData?['id'] as String? ??
              extraData?['_id']
                  as String?; // 🟢 Fixed lowercase 'id' extraction with '_id' fallback
          final String? imageUrl = extraData?['image'] as String?;
          final String? name = extraData?['name'] as String?;

          return ChatScreen3(
            sId: sId,
            id: id, // 🟢 Fixed case mismatch variable (id)
            imageUrl: imageUrl,
            name: name,
          );
        },
      ),
    ],
  );
});
