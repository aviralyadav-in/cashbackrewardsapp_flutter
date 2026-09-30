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

  // Dark Theme Neutral Base (Deep Aubergine + Layered Plum System)
  static const Color darkBackground = Color(0xFF171426);      // Level 1: Deep Aubergine Canvas (#171426)
  static const Color darkCard = Color(0xFF242039);            // Level 2: Primary Cards, BottomBar, Sheets, Dialogs (#242039)
  static const Color darkCardElevated = Color(0xFF302A4B);    // Level 3: Elevated Cards (#302A4B)
  static const Color darkSurface = Color(0xFF302A4B);         // Level 3: Input Fields & Nested Containers (#302A4B)
  static const Color darkBorder = Color(0xFF49415F);          // Muted Plum Card/Input Borders & Dividers (#49415F)

  // 30% SECONDARY (SUPPORT) (UI Structure, Headers, Borders, Icons, Content)
  static const Color navyDark = Color(0xFF2D274B);            // Primary text & headings (#2D274B) - LIGHT MODE ONLY
  static const Color navyDeep = Color(0xFF2D274B);            // Midnight Plum
  static const Color navyMedium = Color(0xFF9787F3);          // Supporting Violet Accent
  static const Color slateBlue = Color(0xFF9787F3);           // Mid-tone supporting violet
  static const Color iceBlue = Color(0xFFEAEFFE);             // Soft periwinkle tint for pills/highlights

  // Light Mode Text Colors (100% UNTOUCHED)
  static const Color text = Color(0xFF2D274B);                // Primary heading/title text (#2D274B)
  static const Color textPrimary = Color(0xFF2D274B);         // Highest contrast Deep Plum
  static const Color textSoft = Color(0xFF4D456E);            // Secondary readable plum-slate
  static const Color textSecondary = Color(0xFF4D456E);       // Supporting text
  static const Color textMuted = Color(0xFF6B6488);           // Captions, subtle metadata

  // Dark Mode Text Colors (High-Contrast & Readable)
  static const Color darkTextPrimary = Color(0xFFF8FAFC);     // Crisp White Headings, Values & Prices (#F8FAFC)
  static const Color darkTextSecondary = Color(0xFFC5BCEB);   // Pale Lavender Subtitles & Descriptions (#C5BCEB)
  static const Color darkTextMuted = Color(0xFF958BAF);       // Soft Lavender Gray Hint Text & Metadata (#958BAF)
  static const Color darkTextDisabled = Color(0xFF766D91);    // Muted Lavender Disabled Text (#766D91)

  // Borders & Dividers
  static const Color border = Color(0xFFD6DCF8);              // Harmonized periwinkle-slate border (Light mode)
  static const Color softBorder = Color(0xFFE4E9FC);          // Soft divider (Light mode)

  // 10% ACCENT (HIGHLIGHT) (CTAs, Important Actions, Key Buttons, Active Badges)
  static const Color accentBlue = Color(0xFF9787F3);          // Electric Violet CTA (#9787F3)
  static const Color primaryBlue = Color(0xFF9787F3);         // Vivid Violet
  static const Color cyanAccent = Color(0xFF9787F3);          // Violet Highlight
  static const Color darkPrimary = Color(0xFF9787F3);         // Electric Violet in Dark Mode (#9787F3)
  static const Color darkButtonText = Color(0xFF211A3C);      // Dark Plum Text/Icons on Violet Buttons (#211A3C)

  // Dark Mode Icon Colors
  static const Color darkIconActive = Color(0xFF9787F3);      // Active icons (#9787F3)
  static const Color darkIconNormal = Color(0xFFC5BCEB);      // Normal icons (#C5BCEB)
  static const Color darkIconDisabled = Color(0xFF766D91);    // Disabled icons (#766D91)

  // Status & Badges
  static const Color success = Color(0xFF10B981);             // Crisp Emerald Green (Light)
  static const Color successBackground = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);             // Amber (Light)
  static const Color pending = Color(0xFFF59E0B);
  static const Color pendingBackground = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFEF4444);               // Clear Red
  static const Color errorBackground = Color(0xFFFEF2F2);
  static const Color darkSuccess = Color(0xFF34D399);         // Bright Mint Green (#34D399)
  static const Color darkWarning = Color(0xFFFBBF24);         // Bright Amber (#FBBF24)
  static const Color darkError = Color(0xFFEF4444);           // Clear Red (#EF4444)

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
  static Color iconColor(bool isDark) => isDark ? darkIconNormal : navyDark;
}
