import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

/// A bright, clean promotional campaign banner for KashIQ.
/// Communicates a time-sensitive "Mega Savings / Extra Cashback" event
/// with clear content hierarchy, bright shopping visuals, and KashIQ's soft
/// periwinkle / clean white / violet color palette without heavy dark navy tones.
class MegaSavingsPromotionalBanner extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onExploreTap;

  const MegaSavingsPromotionalBanner({
    super.key,
    required this.isDark,
    this.onExploreTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFD6DCF8);
    final textDark = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 168,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onExploreTap,
            borderRadius: BorderRadius.circular(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth;

                return Stack(
                  children: [
                    // 1. CLEAN LIGHT CANVAS BASE (Soft Periwinkle-White gradient)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? const [
                                    Color(0xFF25203F),
                                    Color(0xFF2D274B),
                                  ]
                                : const [
                                    Colors.white,
                                    Color(0xFFF4F7FF),
                                  ],
                          ),
                        ),
                      ),
                    ),

                    // 2. SEAMLESS FULL-BLEED SHOPPING IMAGERY (Flows across entire card)
                    Positioned.fill(
                      child: Image.asset(
                        'assets/banners/shopping_banner_clean.jpg',
                        fit: BoxFit.cover,
                        alignment: Alignment.centerRight,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: isDark ? const Color(0xFF25203F) : const Color(0xFFF3F6FE),
                          child: Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 44,
                              color: AppColors.accentBlue.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 3. SEAMLESS ORGANIC GRADIENT MERGE (Softly merges white text backing into studio background - NO hard division)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: isDark
                                ? [
                                    const Color(0xFF25203F).withValues(alpha: 0.94),
                                    const Color(0xFF25203F).withValues(alpha: 0.88),
                                    const Color(0xFF25203F).withValues(alpha: 0.45),
                                    const Color(0xFF25203F).withValues(alpha: 0.0),
                                  ]
                                : [
                                    Colors.white.withValues(alpha: 0.94),
                                    Colors.white.withValues(alpha: 0.85),
                                    Colors.white.withValues(alpha: 0.40),
                                    Colors.white.withValues(alpha: 0.0),
                                  ],
                            stops: const [0.0, 0.35, 0.60, 0.85],
                          ),
                        ),
                      ),
                    ),

                    // 4. LEFT CONTENT COLUMN (Clean, high-contrast, zero-overflow responsive layout)
                    Positioned(
                      top: 12,
                      left: 14,
                      bottom: 12,
                      width: cardWidth * 0.55,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 212,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ROW 1: CAMPAIGN TAG ("LIMITED TIME") + URGENCY ("Ends Soon")
                              Wrap(
                                spacing: 5,
                                runSpacing: 3,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  // Small campaign label
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.accentBlue.withValues(alpha: 0.22)
                                          : const Color(0xFFEDE9FE),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: const Color(0xFF9787F3),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.bolt_rounded,
                                          size: 11,
                                          color: isDark
                                              ? const Color(0xFFC4B5FD)
                                              : const Color(0xFF7C3AED),
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          'LIMITED TIME',
                                          style: GoogleFonts.inter(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.5,
                                            color: isDark
                                                ? const Color(0xFFC4B5FD)
                                                : const Color(0xFF7C3AED),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Urgency element: "Ends Soon"
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6.5,
                                      vertical: 2.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF3C7),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: const Color(0xFFF59E0B),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.timer_outlined,
                                          size: 10.5,
                                          color: Color(0xFFD97706),
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          'Ends Soon',
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFFD97706),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),

                              // ROW 2: MAIN HEADLINE ("Extra Cashback. Bigger Savings.")
                              Text(
                                'Extra Cashback.\nBigger Savings.',
                                style: GoogleFonts.inter(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w900,
                                  color: textDark,
                                  height: 1.15,
                                  letterSpacing: -0.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),

                              // ROW 3: BENEFIT HIGHLIGHT ("Up to ₹500 Extra Cashback")
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3.5,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF25203F)
                                      : const Color(0xFFF5F3FF),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: const Color(0xFF9787F3).withValues(alpha: 0.65),
                                    width: 0.9,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.stars_rounded,
                                      size: 13,
                                      color: isDark
                                          ? const Color(0xFFC4B5FD)
                                          : const Color(0xFF7C3AED),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Up to ₹500 Extra Cashback',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w800,
                                        color: isDark
                                            ? const Color(0xFFC4B5FD)
                                            : const Color(0xFF6D28D9),
                                        letterSpacing: -0.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),

                              // ROW 4: SUPPORTING TEXT ("Get extra cashback on selected stores & deals")
                              Text(
                                'Get extra cashback on selected stores & deals',
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                  color: textMuted,
                                  letterSpacing: -0.1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 7),

                              // ROW 5: SINGLE PRIMARY CTA BUTTON ("Explore Now →")
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 5.5,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF9787F3),
                                      Color(0xFF8270EB),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF9787F3).withValues(alpha: 0.35),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'Explore Now',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 12.5,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
