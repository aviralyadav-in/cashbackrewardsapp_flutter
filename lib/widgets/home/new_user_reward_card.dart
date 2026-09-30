import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

class NewUserRewardCard extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onShopTap;
  final VoidCallback? onReferTap;
  final VoidCallback? onCardTap;

  const NewUserRewardCard({
    super.key,
    required this.isDark,
    this.onShopTap,
    this.onReferTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.darkCard : const Color(0xFFF7F4EE);
    final cardBorder = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textSubtitle = isDark ? AppColors.darkTextMuted : const Color(0xFF64748B);
    final badgeBg = isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9);
    final badgeText = isDark ? AppColors.darkPrimary : const Color(0xFF8A4E1B);
    final iconBoxBg = isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9);
    final buttonBg = isDark ? AppColors.darkPrimary : const Color(0xFF0F172A);
    final buttonText = isDark ? AppColors.darkButtonText : const Color(0xFFFFFFFF);
    final amberColor = isDark ? const Color(0xFFFFB74D) : const Color(0xFFA57022);

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: cardBorder,
            width: 2.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.45)
                  : const Color(0xFF0A1128).withValues(alpha: 0.08),
              blurRadius: 14,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: isDark
                  ? AppColors.darkSurface.withValues(alpha: 0.35)
                  : Colors.white.withValues(alpha: 0.85),
              blurRadius: 6,
              spreadRadius: -1,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Section: Message + Icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.stars_rounded,
                              size: 13,
                              color: badgeText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'WELCOME BONUS',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                                color: badgeText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Big Headline Message
                      Text(
                        'Shop & Earn Real Money in Your Wallet!',
                        style: GoogleFonts.inter(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                          height: 1.25,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Explanatory Subtitle
                      Text(
                        'Shop on Amazon, Flipkart, Myntra & 1500+ stores to get real cashback transferred straight to your bank.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: textSubtitle,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Decorative Shopping Bag Squircle
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: iconBoxBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.shopping_bag_rounded,
                      size: 28,
                      color: isDark ? AppColors.darkPrimary : const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Primary Call to Action Button: "Start Shopping & Earn →"
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onShopTap ?? onCardTap,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: buttonBg,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: buttonBg.withValues(alpha: isDark ? 0.35 : 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 16,
                        color: buttonText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Start Shopping & Earn Cashback',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: buttonText,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: buttonText,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Secondary Option: "Or invite friends to Refer & Earn Flat ₹250 >"
            Center(
              child: InkWell(
                onTap: onReferTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.card_giftcard_rounded,
                        size: 14,
                        color: amberColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Or invite friends and ',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: textSubtitle,
                        ),
                      ),
                      Text(
                        'Refer & Earn Flat ₹20 Cash',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: amberColor,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 9.5,
                        color: amberColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
