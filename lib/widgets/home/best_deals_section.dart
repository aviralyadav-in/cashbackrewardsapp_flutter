import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/brand_asset_helper.dart';
import '../../models/home_discovery_models.dart';
import '../../theme/app_theme.dart';
import '../common/network_image_with_skeleton.dart';

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
          height: 195,
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

    // OFF / Discount percentage above image
    final offText = deal.discountPercentage > 0
        ? '${deal.discountPercentage.toInt()}% OFF'
        : (savings > 0 ? '₹$savings OFF' : 'BEST DEAL');

    // Cashback text just above Shop Now button
    final cashbackText = deal.cashbackAmount > 0
        ? '+₹${deal.cashbackAmount.toInt()} Cashback'
        : (deal.cashbackPercentage > 0
            ? '+${deal.cashbackPercentage.toInt()}% Cashback'
            : 'Bonus Cashback');

    return Container(
      width: 156,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
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
          borderRadius: BorderRadius.circular(14),
          onTap: () => onShopNow(deal),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TOP: DISCOUNT / OFF BADGE (Image ke upar kitna off hai)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF143823) : const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF059669).withValues(alpha: 0.35)
                          : const Color(0xFFA7F3D0),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    offText,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 3),

                // 2. PRODUCT IMAGE
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: _buildProductImage(deal),
                  ),
                ),
                const SizedBox(height: 3),

                // 3. PRODUCT NAME (Full width, Brand naam hataya gaya)
                Text(
                  _cleanTitle(deal.title),
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),

                // 4. PRICE SECTION: Effective Price + Store Selling Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '₹$effectivePrice',
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                        color: textDark,
                      ),
                    ),
                    if (deal.discountedPrice > effectivePrice) ...[
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '₹${deal.discountedPrice.toInt()}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: textMuted,
                            decoration: TextDecoration.lineThrough,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                if (deal.discountedPrice > effectivePrice)
                  Text(
                    '₹${deal.discountedPrice.toInt()} at ${deal.store.isNotEmpty ? deal.store : "store"}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const Spacer(),

                // 5. CASHBACK BADGE (Shop Now button ke just upar cashback kitna milega)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 2.5),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E3A8A).withValues(alpha: 0.35)
                        : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF2563EB).withValues(alpha: 0.3)
                          : const Color(0xFFBFDBFE),
                      width: 0.6,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bolt_rounded,
                        size: 13.5,
                        color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1D4ED8),
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          cashbackText,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                            letterSpacing: -0.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                // 6. "SHOP NOW" CTA PILL BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 26,
                  child: ElevatedButton(
                    onPressed: () => onShopNow(deal),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.darkPrimary : const Color(0xFF1B1B1E),
                      foregroundColor: isDark ? const Color(0xFF1E1712) : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Shop Now',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the product image properly fitted without container box
  Widget _buildProductImage(BestDealModel deal) {
    String resolvedUrl = deal.imageUrl.trim();
    if (resolvedUrl.isEmpty) {
      resolvedUrl = BrandAssetHelper.getProductImage(deal.title, category: deal.category);
    } else if (!resolvedUrl.startsWith('assets/')) {
      final local = BrandAssetHelper.findLocalAssetForUrl(resolvedUrl);
      if (local != null) resolvedUrl = local;
    }

    final fallbackAsset = BrandAssetHelper.getProductImage(deal.title, category: deal.category);

    if (resolvedUrl.startsWith('assets/')) {
      return Image.asset(
        resolvedUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          if (fallbackAsset != resolvedUrl && fallbackAsset.startsWith('assets/')) {
            return Image.asset(
              fallbackAsset,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => _fallbackIcon(),
            );
          }
          return _fallbackIcon();
        },
      );
    } else if (resolvedUrl.startsWith('http')) {
      return NetworkImageWithSkeleton(
        imageUrl: resolvedUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            fallbackAsset,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => _fallbackIcon(),
          );
        },
      );
    }

    return Image.asset(
      fallbackAsset,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => _fallbackIcon(),
    );
  }

  Widget _fallbackIcon() {
    return Center(
      child: Icon(
        Icons.local_mall_outlined,
        size: 26,
        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
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
