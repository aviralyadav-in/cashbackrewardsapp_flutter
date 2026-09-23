import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/home_discovery_models.dart';
import '../../theme/app_theme.dart';
import '../network_image_with_skeleton.dart';

class PriceDropsSection extends StatelessWidget {
  final bool isDark;
  final List<PriceDropModel> priceDrops;
  final VoidCallback onViewAllTap;
  final Function(PriceDropModel item) onItemTap;

  const PriceDropsSection({
    super.key,
    required this.isDark,
    required this.priceDrops,
    required this.onViewAllTap,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    // Hide section completely when no price drops data exists
    if (priceDrops.isEmpty) return const SizedBox.shrink();

    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '📉 Price Drops',
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

        // Horizontal Carousel
        SizedBox(
          height: 188,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: priceDrops.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = priceDrops[index];
              return _buildPriceDropCard(context, item, textDark, textMuted);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriceDropCard(
    BuildContext context,
    PriceDropModel item,
    Color textDark,
    Color textMuted,
  ) {
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);

    return InkWell(
      onTap: () => onItemTap(item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 255,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: NetworkImageWithSkeleton(
                imageUrl: item.imageUrl,
                width: 78,
                height: 78,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Info Body
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.brand.toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.productName,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Pricing: Was -> Now
                  Row(
                    children: [
                      Text(
                        'Now: ₹${item.nowPrice.toInt()}',
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '₹${item.wasPrice.toInt()}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: textMuted,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Price Drop Badge & Cashback
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.priceDropBadge,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFDC2626),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+ ${item.cashback}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
