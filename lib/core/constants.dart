import 'package:flutter/material.dart';

/// ==============================
/// 🎨 COLORS
/// ==============================
class AppColors {
  // Backgrounds
  static const Color bg = Color(0xFFF5F7FA);
  static const Color scaffold = Color(0xFFF5F7FA);

  // Primary
  static const Color primary = Color(0xFF1A5FD0);
  static const Color primaryLight = Color(0xFF4F8DF7);
  static const Color primaryDark = Color(0xFF0D47A1);

  // Surfaces
  static const Color white = Colors.white;
  static const Color card = Colors.white;

  // Text
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMid = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // Borders & UI
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE5E7EB);

  // States
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
}

/// ==============================
/// 📝 TEXT STYLES
/// ==============================
class AppText {
  static const TextStyle title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 16,
    color: AppColors.textMid,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textMid,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle small = TextStyle(
    fontSize: 12,
    color: AppColors.textLight,
  );
}

/// ==============================
/// 🔤 STRINGS
/// ==============================
class AppStrings {
  static const String appName = "Signify AI";
  static const String tagline = "Empowering Voices";

  // Auth
  static const String login = "Login";
  static const String signup = "Sign Up";
  static const String welcomeBack = "Welcome Back";

  static const String email = "Email Address";
  static const String password = "Password";
  static const String fullName = "Full Name";

  static const String forgotPassword = "Forgot?";
  static const String noAccount = "Don't have an account?";
  static const String haveAccount = "Already have an account?";

  // Home
  static const String startDetection = "Start Detection";
  static const String openCamera = "Open Camera";
  static const String translationHistory = "Translation History";

  // Misc
  static const String continueWith = "OR CONTINUE WITH";
}