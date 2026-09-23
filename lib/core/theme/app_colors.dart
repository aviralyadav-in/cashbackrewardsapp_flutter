import 'package:flutter/material.dart';

class AppColors {
  // ===========================================================================
  // 60-30-10 PERIWINKLE / VIOLET / MIDNIGHT PLUM DESIGN SYSTEM
  // ===========================================================================

  // 60% NEUTRAL BASE (Backgrounds, Surfaces, Containers, Large Canvas Areas)
  static const Color background = Color(0xFFEAEFFE);          // Soft Periwinkle Canvas (#EAEFFE)
  static const Color mainBackground = Color(0xFFEAEFFE);      // Light mode canvas (#EAEFFE)
  static const Color card = Colors.white;                     // Pure White elevated card
  static const Color cardBackground = Colors.white;           // Pure White surface
  static const Color surface = Colors.white;
  static const Color surfaceSubtle = Color(0xFFF3F6FE);       // Subtle container tint

  // Dark Theme Neutral Base (Anchored around #2D274B)
  static const Color darkBackground = Color(0xFF1E1A33);      // Deep plum canvas
  static const Color darkCard = Color(0xFF2D274B);            // Elevated #2D274B Midnight Plum card
  static const Color darkSurface = Color(0xFF25203F);         // Deep plum container surface
  static const Color darkBorder = Color(0xFF3F3765);          // Dark mode subtle plum border

  // 30% SECONDARY (SUPPORT) (UI Structure, Headers, Borders, Icons, Content)
  static const Color navyDark = Color(0xFF2D274B);            // Primary text & headings (#2D274B)
  static const Color navyDeep = Color(0xFF2D274B);            // Midnight Plum
  static const Color navyMedium = Color(0xFF9787F3);          // Supporting Violet Accent
  static const Color slateBlue = Color(0xFF9787F3);           // Mid-tone supporting violet
  static const Color iceBlue = Color(0xFFEAEFFE);             // Soft periwinkle tint for pills/highlights

  // Light Mode Text Colors
  static const Color text = Color(0xFF2D274B);                // Primary heading/title text (#2D274B)
  static const Color textPrimary = Color(0xFF2D274B);         // Highest contrast Deep Plum
  static const Color textSoft = Color(0xFF4D456E);            // Secondary readable plum-slate
  static const Color textSecondary = Color(0xFF4D456E);       // Supporting text
  static const Color textMuted = Color(0xFF6B6488);           // Captions, subtle metadata

  // Dark Mode Text Colors
  static const Color darkTextPrimary = Color(0xFFF8FAFC);     // High-contrast white
  static const Color darkTextSecondary = Color(0xFFB4A8E8);   // Soft Lavender Muted
  static const Color darkTextMuted = Color(0xFF8C82B0);       // Lavender Muted

  // Borders & Dividers
  static const Color border = Color(0xFFD6DCF8);              // Harmonized periwinkle-slate border
  static const Color softBorder = Color(0xFFE4E9FC);          // Soft divider

  // 10% ACCENT (HIGHLIGHT) (CTAs, Important Actions, Key Buttons, Active Badges)
  static const Color accentBlue = Color(0xFF9787F3);          // Electric Violet / Lilac CTA (#9787F3)
  static const Color primaryBlue = Color(0xFF9787F3);         // Vivid Violet
  static const Color cyanAccent = Color(0xFF9787F3);          // Violet Highlight
  static const Color darkPrimary = Color(0xFF9787F3);         // Vibrant Violet in Dark Mode

  // Status & Badges
  static const Color success = Color(0xFF10B981);             // Crisp Emerald Green
  static const Color successBackground = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);             // Amber
  static const Color pending = Color(0xFFF59E0B);
  static const Color pendingBackground = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFEF4444);               // Clear Red
  static const Color errorBackground = Color(0xFFFEF2F2);
  static const Color darkSuccess = Color(0xFF34D399);
  static const Color darkWarning = Color(0xFFFBBF24);

  // Backward-compatibility aliases
  static const Color primaryBrown = Color(0xFF2D274B);        // Mapped to Midnight Deep Plum
  static const Color deepBrown = Color(0xFF2D274B);           // Mapped to Midnight Deep Plum
  static const Color mediumBrown = Color(0xFF9787F3);         // Mapped to Violet
  static const Color beige = Color(0xFFF3F6FE);              // Mapped to Clean Surface Subtle
  static const Color beigeSurface = Color(0xFFF3F6FE);       // Mapped to Clean Surface Subtle
  static const Color terracotta = accentBlue;
  static const Color deepTerracotta = navyDeep;
  static const Color lightTerracotta = iceBlue;
  static const Color cream = background;
  static const Color warmCream = surfaceSubtle;
  static const Color ivory = card;
  static const Color darkBrownColor = darkBackground;
  static const Color mutedBrown = textSecondary;
  static const Color dodgerBlue = accentBlue;
  static const Color lightBackground = background;
  static const Color lightSurface = card;
  static const Color lightTextPrimary = textPrimary;
  static const Color lightTextSecondary = textSecondary;
  static const Color lightBorder = border;
  static const Color lightStructure = navyDark;
  static const Color darkStructure = darkBackground;
  static const Color deepNavy = navyDeep;
  static const Color warmAmber = warning;
  static const Color mutedGreen = success;

  /// Resolves the theme-aware icon color
  static Color iconColor(bool isDark) => isDark ? darkPrimary : navyDark;
}
