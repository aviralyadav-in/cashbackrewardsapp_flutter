import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';

export 'app_colors.dart';
export 'app_dimensions.dart';
export 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.mainBackground,
      textTheme: GoogleFonts.frauncesTextTheme(ThemeData.light().textTheme),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBrown,
        secondary: AppColors.deepBrown,
        surface: AppColors.cardBackground,
        onSurface: AppColors.textPrimary,
        onPrimary: AppColors.cardBackground,
      ),
      useMaterial3: true,
      iconTheme: const IconThemeData(
        color: AppColors.primaryBrown,
        size: 24,
      ),
      primaryIconTheme: const IconThemeData(
        color: AppColors.primaryBrown,
        size: 24,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.mainBackground,
        foregroundColor: AppColors.deepBrown,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.screenHeading(),
        iconTheme: const IconThemeData(
          color: AppColors.primaryBrown,
          size: 24,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          side: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBrown,
          foregroundColor: AppColors.cardBackground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
          ),
          textStyle: AppTextStyles.buttonText(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        hintStyle: AppTextStyles.smallDescription(color: AppColors.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
          borderSide: const BorderSide(
            color: AppColors.primaryBrown,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: GoogleFonts.frauncesTextTheme(ThemeData.dark().textTheme),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.deepBrown,
        surface: AppColors.darkCard,
        onSurface: AppColors.darkTextPrimary,
        onPrimary: AppColors.cardBackground,
      ),
      useMaterial3: true,
      iconTheme: const IconThemeData(
        color: AppColors.darkPrimary,
        size: 24,
      ),
      primaryIconTheme: const IconThemeData(
        color: AppColors.darkPrimary,
        size: 24,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.screenHeading(color: AppColors.darkTextPrimary),
        iconTheme: const IconThemeData(
          color: AppColors.darkTextPrimary,
          size: 24,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          side: const BorderSide(
            color: AppColors.darkBorder,
            width: 1,
          ),
        ),
      ),
    );
  }
}
