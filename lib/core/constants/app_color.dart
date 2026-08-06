 import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary & Accent Pink/Magenta Shades
  static const Color primaryPink = Color(0xFFFF2B6D);
  static const Color accentPink = Color(0xFFFF1E56);
  static const Color lightPink = Color(0xFFFF4D88);

  // Background Dark Gradients & Solids
  static const Color bgDarkPurple = Color(0xFF1E0A2A);
  static const Color bgDarkestPurple = Color(0xFF12051B);
  static const Color bgBlack = Color(0xFF0F0F12);
  static const Color cardDarkBg = Color(0xFF1A1A22);
  static const Color profileCardBg = Color(0xFF16161A);
  static const Color profileDividerColor = Color(0xFF222228);
  static const Color whatsappBg = Color(0xFF0F392B);
  static const Color whatsappBorder = Color(0xFF1B6B50);
  static const Color whatsappText = Color(0xFF25D366);
  // Surface & Card Colors
  static const Color cardBorder = Color(0xFF2A2A38);
  static const Color whiteSheetBg = Color(0xFFFFFFFF);
  static const Color inputBgLight = Color(0xFFF7F7FA);
// app_color.dart mein ye naye colors add kar do:

  static const Color reviewCardBg = Color(0xFF161528);
  static const Color insightBadgeBg = Color(0xFF26213B);
  static const Color progressBarTrack = Color(0xFF28233C);
  static const Color backButtonBg = Color(0xFF232238);
  // Text Colors
  static const Color textPrimaryLight = Color(0xFFFFFFFF);
  static const Color textSecondaryLight = Color(0xFFB3B3C3);
  static const Color textPrimaryDark = Color(0xFF1A1A20);
  static const Color textSecondaryDark = Color(0xFF707080);

  // Linear Gradients
  static const RadialGradient splashGradient = RadialGradient(
    center: Alignment.center,
    radius: 1.4,
    colors: [
      Color(0xFF381953), // Exactly 20% lighter version of 0xFF2B0B3A
      Color(0xFF0F0217), // Outer subtle dark edges
    ],
    stops: [0.45, 1.0],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFFF2B6D),
      Color(0xFFFF1E56),
    ],
  );

  static const LinearGradient logoHeartGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF5288),
      Color(0xFFFF1E56),
    ],
  );
}