import 'package:flutter/material.dart';

class AppColors {
  // Global CashKaro Palette
  static const Color primaryBrown = Color(0xFF4A2C20);
  static const Color deepBrown = Color(0xFF351C15);
  static const Color mediumBrown = Color(0xFF6B4636);

  // Backgrounds & Surfaces
  static const Color background = Color(0xFFFAF5ED);
  static const Color mainBackground = Color(0xFFFAF5ED);
  static const Color beige = Color(0xFFF3E6D0);
  static const Color beigeSurface = Color(0xFFF3E6D0);
  static const Color card = Color(0xFFFFFDF8);
  static const Color cardBackground = Color(0xFFFFFDF8);

  // Text Colors
  static const Color text = Color(0xFF2B1B16);
  static const Color textPrimary = Color(0xFF2B1B16);
  static const Color textSoft = Color(0xFF765F52);
  static const Color textSecondary = Color(0xFF765F52);
  static const Color textMuted = Color(0xFF9A887C);

  // Border & Outlines
  static const Color border = Color(0xFFD8C5AF);
  static const Color softBorder = Color(0xFFD8C5AF);

  // Status & Badges
  static const Color success = Color(0xFF5E7A57);
  static const Color successBackground = Color(0xFFE7EEE1);

  static const Color warning = Color(0xFFA9762E);
  static const Color pending = Color(0xFFA9762E);
  static const Color pendingBackground = Color(0xFFF4E8D2);

  static const Color error = Color(0xFFA2422F);
  static const Color errorBackground = Color(0xFFF5E3DE);

  // Dark Theme Palette
  static const Color darkBackground = Color(0xFF1B1410);
  static const Color darkCard = Color(0xFF261D18);
  static const Color darkSurface = Color(0xFF322721);
  static const Color darkBorder = Color(0xFF4A3B33);
  static const Color darkTextPrimary = Color(0xFFFAF5ED);
  static const Color darkTextSecondary = Color(0xFFD4C5B9);
  static const Color darkTextMuted = Color(0xFFB5A499);
  static const Color darkPrimary = Color(0xFFE29D62);
  static const Color darkSuccess = Color(0xFF81C784);
  static const Color darkWarning = Color(0xFFFFB74D);

  /// Resolves the theme-aware icon color matching the brown brand in light mode and warm caramel in dark mode.
  static Color iconColor(bool isDark) => isDark ? darkPrimary : primaryBrown;

  // Aliases for compatibility
  static const Color terracotta = primaryBrown;
  static const Color deepTerracotta = deepBrown;
  static const Color lightTerracotta = beigeSurface;
  static const Color cream = background;
  static const Color warmCream = beige;
  static const Color ivory = card;
  static const Color darkBrownColor = deepBrown;
  static const Color mutedBrown = textSecondary;
  static const Color dodgerBlue = primaryBrown;
  static const Color lightBackground = background;
  static const Color lightSurface = card;
  static const Color lightTextPrimary = textPrimary;
  static const Color lightTextSecondary = textSecondary;
  static const Color lightBorder = border;
  static const Color lightStructure = deepBrown;
  static const Color darkStructure = darkBackground;
  static const Color deepNavy = deepBrown;
  static const Color warmAmber = warning;
  static const Color mutedGreen = success;
}
