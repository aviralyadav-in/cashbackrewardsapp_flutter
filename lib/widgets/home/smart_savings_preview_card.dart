import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/home_discovery_models.dart';
import '../../theme/app_theme.dart';
import '../common/network_image_with_skeleton.dart';

class SmartSavingsPreviewCard extends StatelessWidget {
  final bool isDark;
  final SmartSavingsModel? smartSavings;
  final VoidCallback onSeeSavingsTap;

  const SmartSavingsPreviewCard({
    super.key,
    required this.isDark,
    required this.smartSavings,
    required this.onSeeSavingsTap,
  });

  @override
  Widget build(BuildContext context) {
    if (smartSavings == null) return const SizedBox.shrink();

    final item = smartSavings!;
    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardElevated : const Color(0xFFF1F5F9),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                  width: 0.8,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.calculate_rounded,
                    size: 18,
                    color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '🧮 Smart Savings Engine',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.successBackground,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Multi-Offer Stacking',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                // Product Brief Row
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: NetworkImageWithSkeleton(
                        imageUrl: item.imageUrl,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.brand.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                            ),
                          ),
                          Text(
                            item.productName,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Best deal currently at ${item.bestStore}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Calculation Stack breakdown Preview
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : const Color(0xFFF9F6F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _buildCalcRow('Product Price', '₹${item.productPrice.toInt()}', textDark),
                      const SizedBox(height: 4),
                      _buildCalcRow('Store Discount', '-₹${item.storeDiscount.toInt()}', const Color(0xFF10B981)),
                      const SizedBox(height: 4),
                      _buildCalcRow('Coupon Discount', '-₹${item.couponDiscount.toInt()}', const Color(0xFF10B981)),
                      const SizedBox(height: 4),
                      _buildCalcRow('Cashback Earned', '+₹${item.cashback.toInt()}', isDark ? AppColors.darkPrimary : AppColors.primaryBrown),
                      Divider(
                        height: 14,
                        color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Potential Total Savings',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: textDark,
                            ),
                          ),
                          Text(
                            '₹${item.totalSavings.toInt()}',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: onSeeSavingsTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                      foregroundColor: isDark ? AppColors.darkButtonText : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'See How You Save',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalcRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
