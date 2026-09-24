import 'package:flutter/material.dart';

class AppColors {
  static const Color forest = Color(0xFF1B7A4B);
  static const Color leaf = Color(0xFF3DDC97);
  static const Color mint = Color(0xFFB8F2D4);
  static const Color ocean = Color(0xFF1565C0);
  static const Color sky = Color(0xFF4FC3F7);
  static const Color ice = Color(0xFFE3F6FF);
  static const Color amber = Color(0xFFFFB74D);
  static const Color coral = Color(0xFFFF6B6B);
  static const Color ink = Color(0xFF13293D);
  static const Color cloud = Color(0xFFF4FBF8);

  static const LinearGradient loginGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [forest, ocean],
  );

  static const LinearGradient homeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [mint, ice],
  );

  // Calendar uses a distinct purple/blue combo so it feels like its own page
  static const LinearGradient calendarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
  );

  static const LinearGradient historyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFDE68A), Color(0xFFB8F2D4)],
  );

  static const LinearGradient cardGradientGreen = LinearGradient(
    colors: [Color(0xFF2ECC71), Color(0xFF17A589)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradientBlue = LinearGradient(
    colors: [Color(0xFF4FC3F7), Color(0xFF1565C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cloud,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.forest,
        primary: AppColors.forest,
        secondary: AppColors.ocean,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.ink,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.forest,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cloud,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.mint, width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.ocean, width: 1.8),
        ),
      ),
    );
  }
}