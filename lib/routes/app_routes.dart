import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/bottom_nav.dart';
import '../features/chat/chat_screen.dart';
import '../features/chat/chat_screen_3.dart';
import '../features/custmization/model_custmization.dart';
import '../features/describe_image/subcription_screen.dart';
import '../features/home/chat_screen_2.dart';
import '../features/profile/model_profile_screen.dart';
import '../features/splash/screens/on_boading_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import 'routes_name.dart';

/// Top-level Global Navigator Key bound to GoRouter
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
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

      // 4. OTP Screen
      GoRoute(
        path: RoutesName.otp,
        name: 'otp',
        builder: (context, state) {
          final mobile = state.extra as String? ?? '';
          return OtpScreen(phoneNumber: mobile);
        },
      ),

      // 5. Bottom Navigation Bar
      GoRoute(
        path: RoutesName.bottomNavBar,
        name: 'mainNav',
        builder: (context, state) => MainNavigationScreen(),
      ),

      // 6. Premium Subscription
      GoRoute(
        path: RoutesName.subriptionScreen,
        name: 'premium',
        builder: (context, state) => const PremiumSubscriptionScreen(),
      ),

      // 7. Model Profile Detail
      GoRoute(
        path: RoutesName.modelProfileDetailScreen,
        name: 'modelProfile',
        builder: (context, state) {
          final String sId = (state.extra as String?) ?? '';
          return ModelProfileDetailScreen(sId: sId);
        },
      ),

      // 8. Customize Personality / AI Edit
      GoRoute(
        path: RoutesName.customizePersonalityScreen,
        name: 'aiedit',
        builder: (context, state) {
          final String sId = (state.extra as String?) ?? '';
          return CustomizePersonalityScreen(
            userId: sId,
          );
        },
      ),

      // 9. Standard Chat Screen ('chatScreen')
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

      // 10. Chat Route Alias ('chat' - deep linking / push notifications)
      GoRoute(
        path: RoutesName.chat,
        name: 'chat',
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

      // 11. Roleplay Chat Screen ('chatScreen2')
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

      // 12. Explicit Roleplay Route Registration ('roleplayChat')
      GoRoute(
        path: RoutesName.roleplayChat,
        name: 'roleplayChat',
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

      // 13. Companion Chat Screen ('chatScreen3')
      GoRoute(
        path: RoutesName.chatScreen3,
        name: 'chatScreen3',
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>?;
          final String? sId = extraData?['sId'] as String?;
          final String? id = extraData?['id'] as String? ?? extraData?['_id'] as String?;
          final String? imageUrl = extraData?['image'] as String?;
          final String? name = extraData?['name'] as String?;

          return ChatScreen3(
            sId: sId,
            id: id,
            imageUrl: imageUrl,
            name: name,
          );
        },
      ),
    ],
  );
});
