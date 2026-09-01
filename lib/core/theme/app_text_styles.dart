import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Screen Heading: Fraunces 24px 700 #351C15
  static TextStyle screenHeading({Color color = AppColors.deepBrown}) =>
      GoogleFonts.fraunces(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.3,
      );

  static TextStyle screenTitle({Color color = AppColors.deepBrown}) =>
      screenHeading(color: color);

  // Large Financial Amount: Fraunces 30px 700 #351C15
  static TextStyle largeFinancialAmount({Color color = AppColors.deepBrown}) =>
      GoogleFonts.fraunces(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.5,
      );

  static TextStyle amount({Color color = AppColors.deepBrown}) =>
      largeFinancialAmount(color: color);

  // Section Heading: Inter 16px 700 #351C15
  static TextStyle sectionHeading({Color color = AppColors.deepBrown}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle sectionTitle({Color color = AppColors.deepBrown}) =>
      sectionHeading(color: color);

  // Card Title: Inter 14px 700 #2B1B16
  static TextStyle cardTitle({Color color = AppColors.textPrimary}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color,
      );

  // Card Subtitle: Inter 12px 400 #765F52
  static TextStyle cardSubtitle({Color color = AppColors.textSecondary}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      );

  // Body Text: Inter 13.5px 400 #765F52
  static TextStyle body({Color color = AppColors.textSecondary}) =>
      GoogleFonts.inter(
        fontSize: 13.5,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.4,
      );

  // Small Description: Inter 12px 400 #9A887C
  static TextStyle smallDescription({Color color = AppColors.textMuted}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle caption({Color color = AppColors.textMuted}) =>
      smallDescription(color: color);

  // Button Text: Inter 13px 700
  static TextStyle buttonText({Color color = AppColors.cardBackground}) =>
      GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.2,
      );

  static TextStyle button({Color color = AppColors.cardBackground}) =>
      buttonText(color: color);

  // Navigation Text: Inter 10.5px 600
  static TextStyle navLabel({Color color = AppColors.deepBrown}) =>
      GoogleFonts.inter(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        color: color,
      );

  // Small Labels: Inter 11px 600 #9A887C
  static TextStyle smallLabel({Color color = AppColors.textMuted}) =>
      GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
      );

  // Input Text: Inter 13px #2B1B16
  static TextStyle input({Color color = AppColors.textPrimary}) =>
      GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle inputText({Color color = AppColors.textPrimary}) =>
      input(color: color);

  // Hint Text: Inter 12-13px #9A887C
  static TextStyle hint({Color color = AppColors.textMuted}) =>
      GoogleFonts.inter(
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle hintText({Color color = AppColors.textMuted}) =>
      hint(color: color);

  // Important Percentage: Fraunces 20–24px 700 #351C15
  static TextStyle importantPercentage({
    double fontSize = 22,
    Color color = AppColors.deepBrown,
  }) =>
      GoogleFonts.fraunces(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle percentage({Color color = AppColors.deepBrown}) =>
      importantPercentage(color: color);

  // Important Cashback Amount: Fraunces 18–22px 700 #351C15
  static TextStyle cashbackAmount({
    double fontSize = 20,
    Color color = AppColors.deepBrown,
  }) =>
      GoogleFonts.fraunces(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color,
      );
}
