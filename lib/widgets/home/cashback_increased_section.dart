import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/home_discovery_models.dart';
import '../../theme/app_theme.dart';
import '../common/network_image_with_skeleton.dart';

class CashbackIncreasedSection extends StatelessWidget {
  final bool isDark;
  final List<CashbackIncreaseModel> increases;
  final Function(CashbackIncreaseModel item) onItemTap;

  const CashbackIncreasedSection({
    super.key,
    required this.isDark,
    required this.increases,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    // Conditionally hide when no cashback increase data exists
    if (increases.isEmpty) return const SizedBox.shrink();

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
                '📈 Cashback Increased',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: (isDark ? const Color(0xFF10B981) : const Color(0xFF059669))
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Boosted Rates',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal Carousel
        SizedBox(
          height: 138,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: increases.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = increases[index];
              return _buildIncreaseCard(context, item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIncreaseCard(BuildContext context, CashbackIncreaseModel item) {
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);

    return InkWell(
      onTap: () => onItemTap(item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 260,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Logo & Store & Badge
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: NetworkImageWithSkeleton(
                    imageUrl: item.logoUrl,
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.store,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    item.badge,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                ),
              ],
            ),

            // Middle Row: Rate increase badge (5% -> 12%)
            Row(
              children: [
                Text(
                  'Cashback increased: ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: textMuted,
                  ),
                ),
                Text(
                  '${item.previousRate} → ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: textMuted,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  item.newRate,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),

            // Bottom CTA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Shop Now →',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
