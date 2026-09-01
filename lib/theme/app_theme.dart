import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Terracotta Palette
  static const Color terracotta = Color(0xFFC65D45);
  static const Color deepTerracotta = Color(0xFF9E4030);
  static const Color lightTerracotta = Color(0xFFE9A18E);

  // Cream / Warm Neutral Palette
  static const Color cream = Color(0xFFFFF8F0);
  static const Color warmCream = Color(0xFFF7EDE2);
  static const Color ivory = Color(0xFFFFFCF8);

  // Dark & Neutral Text
  static const Color darkBrown = Color(0xFF2E211C);
  static const Color mutedBrown = Color(0xFF79665D);
  static const Color mutedText = Color(0xFF9A887C);
  static const Color softBorder = Color(0xFFE6D5C7);

  // Status & Accents
  static const Color warmAmber = Color(0xFFC88A3D);
  static const Color mutedGreen = Color(0xFF66856B);

  // Dark Theme Palette
  static const Color darkBackground = Color(0xFF19120E);
  static const Color darkCard = Color(0xFF251B15);
  static const Color darkSurface = Color(0xFF30231C);
  static const Color darkBorder = Color(0xFF45332A);
  static const Color darkTextPrimary = Color(0xFFFFF8F0);
  static const Color darkTextSecondary = Color(0xFFC9B8AE);

  // Compatibility / Aliases
  static const Color dodgerBlue = terracotta;
  static const Color lightBackground = cream;
  static const Color lightSurface = ivory;
  static const Color lightTextPrimary = darkBrown;
  static const Color lightTextSecondary = mutedBrown;
  static const Color lightBorder = softBorder;
  static const Color lightStructure = darkBrown;
  static const Color darkStructure = darkBackground;
  static const Color deepNavy = darkBrown;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      colorScheme: const ColorScheme.light(
        primary: AppColors.terracotta,
        secondary: AppColors.deepTerracotta,
        surface: AppColors.ivory,
        onSurface: AppColors.darkBrown,
        onPrimary: Colors.white,
      ),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.darkBrown,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.darkBrown,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: AppColors.darkBrown),
      ),
      cardTheme: CardThemeData(
        color: AppColors.ivory,
        elevation: 2,
        shadowColor: AppColors.darkBrown.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.softBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.ivory,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        labelStyle: const TextStyle(color: AppColors.mutedBrown),
        hintStyle: const TextStyle(color: AppColors.mutedText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.softBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.softBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.terracotta,
            width: 1.8,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deepTerracotta,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.ivory,
        selectedItemColor: AppColors.deepTerracotta,
        unselectedItemColor: AppColors.mutedText,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.terracotta,
        secondary: AppColors.lightTerracotta,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        onPrimary: Colors.white,
      ),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        labelStyle: const TextStyle(color: AppColors.darkTextSecondary),
        hintStyle: const TextStyle(color: AppColors.darkTextSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.terracotta,
            width: 1.8,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deepTerracotta,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.terracotta,
        unselectedItemColor: AppColors.darkTextSecondary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
