import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

/// Promotional Banner 2: "Cashback Boost"
///
/// Promotes a temporary cashback boost / special savings opportunity
/// with strong visual focus on "2X Cashback", clean hierarchy,
/// bright visible imagery, and KashIQ's soft periwinkle / white / violet palette.
class CashbackBoostPromotionalBanner extends StatelessWidget {
  final bool isDark;
  final String campaignLabel;
  final String headline;
  final String supportingText;
  final String boostHighlight;
  final String ctaText;
  final String? urgencyText;
  final String imageAsset;
  final VoidCallback? onViewStoresTap;

  const CashbackBoostPromotionalBanner({
    super.key,
    required this.isDark,
    this.campaignLabel = 'CASHBACK BOOST',
    this.headline = 'Earn More Cashback Today',
    this.supportingText = 'Get boosted cashback on selected stores',
    this.boostHighlight = 'Up to 2X Cashback',
    this.ctaText = 'View Stores',
    this.urgencyText = 'Limited Time',
    this.imageAsset = 'assets/banners/boost_banner_clean.jpg',
    this.onViewStoresTap,
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
            onTap: onViewStoresTap,
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

                    // 2. SEAMLESS FULL-BLEED 2X MULTIPLIER CAMPAIGN IMAGERY (Flows across entire card)
                    Positioned.fill(
                      child: Image.asset(
                        imageAsset,
                        fit: BoxFit.cover,
                        alignment: Alignment.centerRight,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: isDark ? const Color(0xFF25203F) : const Color(0xFFF3F6FE),
                          child: Center(
                            child: Icon(
                              Icons.bolt_rounded,
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
                              // ROW 1: "CASHBACK BOOST" PILL + OPTIONAL URGENCY ("Limited Time")
                              Wrap(
                                spacing: 5,
                                runSpacing: 3,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
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
                                          Icons.flash_on_rounded,
                                          size: 11,
                                          color: isDark
                                              ? const Color(0xFFC4B5FD)
                                              : const Color(0xFF7C3AED),
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          campaignLabel,
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
                                  if (urgencyText != null &&
                                      urgencyText!.isNotEmpty)
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
                                        children: [
                                          const Icon(
                                            Icons.schedule_rounded,
                                            size: 10.5,
                                            color: Color(0xFFD97706),
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            urgencyText!,
                                            style: const TextStyle(
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

                              // ROW 2: MAIN HEADLINE ("Earn More Cashback Today")
                              Text(
                                headline,
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

                              // ROW 3: VISUAL FOCAL POINT ("Up to 2X Cashback")
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3.5,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF25203F)
                                      : const Color(0xFFF5F3FF),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFF9787F3).withValues(alpha: 0.65),
                                    width: 1.0,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 17,
                                      height: 17,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.accentBlue,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.trending_up_rounded,
                                          size: 10.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      boostHighlight,
                                      style: GoogleFonts.inter(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w900,
                                        color: isDark
                                            ? const Color(0xFFC4B5FD)
                                            : const Color(0xFF6D28D9),
                                        letterSpacing: -0.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),

                              // ROW 4: SUPPORTING TEXT ("Get boosted cashback on selected stores")
                              Text(
                                supportingText,
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

                              // ROW 5: SINGLE PRIMARY CTA BUTTON ("View Stores →")
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
                                  children: [
                                    Text(
                                      ctaText,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
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
