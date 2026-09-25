import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/home_discovery_models.dart';
import '../../screens/deals/coupon_detail_screen.dart';
import '../../theme/app_theme.dart';
import '../common/network_image_with_skeleton.dart';

class HomeCouponsSection extends StatelessWidget {
  final bool isDark;
  final List<HomeCouponModel> coupons;
  final VoidCallback onViewAllTap;

  const HomeCouponsSection({
    super.key,
    required this.isDark,
    required this.coupons,
    required this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (coupons.isEmpty) return const SizedBox.shrink();

    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '🎟️ Coupons',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
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
                          color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal Carousel of Minimal, High-Impact Coupon Cards
        SizedBox(
          height: 142,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: coupons.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final coupon = coupons[index];
              return _buildCouponCard(context, coupon);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCouponCard(BuildContext context, HomeCouponModel coupon) {
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;

    final resolvedLogo = coupon.logoUrl.isNotEmpty
        ? coupon.logoUrl
        : HomeCouponModel.resolveLogo(coupon.store);

    return Container(
      width: 228,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
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
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CouponDetailScreen(coupon: coupon),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1. BRAND LOGO + BRAND NAME (Top Row)
                Row(
                  children: [
                    // Brand Logo Container (Prominent & Elevated)
                    Container(
                      width: 38,
                      height: 38,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF132247) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: resolvedLogo.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: NetworkImageWithSkeleton(
                                imageUrl: resolvedLogo,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildBrandMonogram(coupon.store, primaryAccent),
                              ),
                            )
                          : _buildBrandMonogram(coupon.store, primaryAccent),
                    ),
                    const SizedBox(width: 10),

                    // Brand Name & Verified Tag
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coupon.store,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                size: 11,
                                color: Colors.green.shade600,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'Verified',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // 2. DISCOUNT / OFFER AMOUNT (Fraunces Display Font)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    coupon.discount,
                    style: GoogleFonts.inter(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: primaryAccent,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // 3. CLEAN SUBTEXT / METADATA ROW (No coupon code, no Shop Now button)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Min ₹${coupon.minOrder.toInt()} • ${coupon.validity}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: primaryAccent.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandMonogram(String store, Color accent) {
    final initial = store.isNotEmpty ? store.substring(0, 1).toUpperCase() : '?';
    return Center(
      child: Text(
        initial,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: accent,
        ),
      ),
    );
  }
}
