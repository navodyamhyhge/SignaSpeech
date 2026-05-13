// lib/core/app_theme.dart
// SignaSpeech Design System - Matches the "High-Trust Blue" design tokens
// Primary: #003d9b | Primary Container: #0052cc | Background: #f8f9fa

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // ── Primary palette ──────────────────────────────────────────────────────
  static const Color primary = Color(0xFF003D9B);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF0052CC);
  static const Color onPrimaryContainer = Color(0xFFC4D2FF);

  // ── Secondary palette ─────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF585F6A);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFDCE3F0);
  static const Color onSecondaryContainer = Color(0xFF5E6570);

  // ── Tertiary palette ──────────────────────────────────────────────────────
  static const Color tertiary = Color(0xFF3A4457);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF515B6F);
  static const Color onTertiaryContainer = Color(0xFFC9D3EB);
  static const Color tertiaryFixed = Color(0xFFD9E3FB);

  // ── Surface / Background ──────────────────────────────────────────────────
  static const Color surface = Color(0xFFF8F9FA);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F4F5);
  static const Color surfaceContainer = Color(0xFFEDEEEF);
  static const Color surfaceContainerHigh = Color(0xFFE7E8E9);
  static const Color surfaceContainerHighest = Color(0xFFE1E3E4);

  // ── On-surface ────────────────────────────────────────────────────────────
  static const Color onSurface = Color(0xFF191C1D);
  static const Color onSurfaceVariant = Color(0xFF434654);

  // ── Outline ───────────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF737685);
  static const Color outlineVariant = Color(0xFFC3C6D6);

  // ── Error ─────────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);

  // ── Primary fixed ─────────────────────────────────────────────────────────
  static const Color primaryFixed = Color(0xFFDAE2FF);
  static const Color primaryFixedDim = Color(0xFFB2C5FF);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onPrimary,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: Color(0xFF93000A),
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        shadow: Colors.black,
        scrim: Colors.black,
        inverseSurface: Color(0xFF2E3132),
        onInverseSurface: Color(0xFFF0F1F2),
        inversePrimary: Color(0xFFB2C5FF),
      ),
      textTheme: _buildTextTheme(),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white.withOpacity(0.9),
        foregroundColor: AppColors.primary,
        elevation: 0,
        titleTextStyle: GoogleFonts.lexend(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.onPrimary,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.lexend(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.outlineVariant, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryContainer, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: GoogleFonts.publicSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceVariant,
        ),
        hintStyle: GoogleFonts.publicSans(
          fontSize: 16,
          color: AppColors.outline,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.outlineVariant, width: 0.5),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryContainer,
        unselectedItemColor: AppColors.outline,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      // display → Lexend 40px bold (for large translated text)
      displayLarge: GoogleFonts.lexend(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: AppColors.onSurface,
      ),
      // headlineLarge → Lexend 28px semibold
      headlineLarge: GoogleFonts.lexend(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      ),
      // headlineMedium → Lexend 22px semibold
      headlineMedium: GoogleFonts.lexend(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      ),
      // headlineSmall → Lexend 18px semibold
      headlineSmall: GoogleFonts.lexend(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      ),
      // bodyLarge → Public Sans 18px regular
      bodyLarge: GoogleFonts.publicSans(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      // bodyMedium → Public Sans 16px regular
      bodyMedium: GoogleFonts.publicSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      // bodySmall → Public Sans 14px regular
      bodySmall: GoogleFonts.publicSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
      ),
      // labelLarge → Public Sans 14px semibold (button labels)
      labelLarge: GoogleFonts.publicSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.onSurface,
      ),
      // labelMedium → Public Sans 12px medium
      labelMedium: GoogleFonts.publicSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}
