import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/home_discovery_models.dart';
import '../../theme/app_theme.dart';
import '../network_image_with_skeleton.dart';

class BestDealsSection extends StatelessWidget {
  final bool isDark;
  final List<BestDealModel> deals;
  final VoidCallback? onViewAllTap;
  final Function(BestDealModel deal) onShopNow;

  const BestDealsSection({
    super.key,
    required this.isDark,
    required this.deals,
    this.onViewAllTap,
    required this.onShopNow,
  });

  @override
  Widget build(BuildContext context) {
    if (deals.isEmpty) return const SizedBox.shrink();

    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;
    final displayDeals = deals.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Best Deals For You',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              if (onViewAllTap != null)
                InkWell(
                  onTap: onViewAllTap,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Row(
                      children: [
                        Text(
                          'View All',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: primaryAccent,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: primaryAccent,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal Carousel of Showcase Best Deals Cards (Top 4-5 Deals)
        SizedBox(
          height: 216,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: displayDeals.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final deal = displayDeals[index];
              return _buildDealCard(context, deal, textDark, textMuted, primaryAccent);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDealCard(
    BuildContext context,
    BestDealModel deal,
    Color textDark,
    Color textMuted,
    Color primaryAccent,
  ) {
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);

    // Compute prices & savings
    final effectivePrice = deal.effectivePrice.toInt();
    final originalPrice = deal.originalPrice.toInt();
    final savings = deal.effectiveSavings > 0
        ? deal.effectiveSavings.toInt()
        : (originalPrice > effectivePrice ? originalPrice - effectivePrice : 0);
    final cashbackPct = deal.cashbackPercentage.toInt() > 0 ? deal.cashbackPercentage.toInt() : 10;
    final storeName = deal.store.isNotEmpty ? deal.store : 'Store';
    final brandName = deal.brand.isNotEmpty ? deal.brand.toUpperCase() : 'BRAND';

    return Container(
      width: 164,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onShopNow(deal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP IMAGE CONTAINER WITH BADGES
              SizedBox(
                height: 76,
                width: 164,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [const Color(0xFF2E1317), const Color(0xFF4A181E)]
                                  : [const Color(0xFF6E101A), const Color(0xFF941B26), const Color(0xFF5A0D15)],
                            ),
                          ),
                          child: NetworkImageWithSkeleton(
                            imageUrl: deal.imageUrl,
                            height: 76,
                            width: 164,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Icon(
                                Icons.local_mall_outlined,
                                size: 26,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Top Left Badge: ★ Cashback Pill with Frosted Blurred Background
                    Positioned(
                      top: 6,
                      left: 6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6.5, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE11D48).withValues(alpha: 0.68),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 0.8,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '★',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '$cashbackPct% Cashback',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Top Right Badge: Store Name (Solid White Pill)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        constraints: const BoxConstraints(maxWidth: 72),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          storeName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E1E24),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. BOTTOM DETAILS AREA
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // BRAND NAME & TITLE (Cleaned main product name)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            brandName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            _cleanTitle(deal.title),
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                              color: textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),

                      // PRICING ROW: [₹3,740] [₹5,999]
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '₹$effectivePrice',
                            style: GoogleFonts.inter(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                              color: textDark,
                            ),
                          ),
                          if (originalPrice > effectivePrice) ...[
                            const SizedBox(width: 5),
                            Text(
                              '₹$originalPrice',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF9E9E9E),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),

                      // GREEN SAVINGS PILL: [Save ₹$savings] (Just above Shop Best Deal button)
                      if (savings > 0)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF133E2B) : const Color(0xFFE6F7EE),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isDark ? const Color(0xFF1E6B47) : const Color(0xFFA3E6C5),
                              width: 0.8,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Save ₹$savings',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                      // ACTION BUTTON: [Shop Best Deal →]
                      SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () => onShopNow(deal),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? AppColors.darkPrimary : const Color(0xFF1B1B1E),
                            foregroundColor: isDark ? const Color(0xFF1E1712) : Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Shop Best Deal',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 13.5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Trims bulky model suffixes and specs to keep the main product name clean
  String _cleanTitle(String title) {
    String clean = title.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim();
    if (clean.length > 20) {
      clean = clean
          .replaceAll(
            RegExp(
              r'\s+(with|and|wireless|anc|headphones|smartwatch|display|react|regular fit).*$',
              caseSensitive: false,
            ),
            '',
          )
          .trim();
    }
    return clean.isNotEmpty ? clean : title;
  }
}
