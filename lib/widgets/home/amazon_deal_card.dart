import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/amazon_deal_model.dart';
import '../../screens/product_detail_screen.dart';
import '../../theme/app_theme.dart';
import '../network_image_with_skeleton.dart';
import 'dashed_line_painter.dart';

class AmazonDealCard extends StatelessWidget {
  final AmazonDealItemData deal;
  final bool isDark;
  final VoidCallback? onTap;

  const AmazonDealCard({
    super.key,
    required this.deal,
    required this.isDark,
    this.onTap,
  });

  static String formatCurrency(num amount) {
    final str = amount.round().toString();
    final reg = RegExp(r'(\d+?)(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen.fromAmazonDeal(deal),
              ),
            );
          },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP PART: Product Image + Brand + Product Name + Actual Price
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image Container
                      Expanded(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: NetworkImageWithSkeleton(
                              imageUrl: deal.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Brand Name
                      Text(
                        deal.brandName.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.fraunces(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 2),

                      // Product Name
                      Text(
                        deal.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.cardTitle(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ).copyWith(fontSize: 12.5, height: 1.2),
                      ),
                      const SizedBox(height: 4),

                      // Actual Price
                      Row(
                        children: [
                          Text(
                            'Actual Price: ',
                            style: AppTextStyles.caption(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textMuted,
                            ),
                          ),
                          Text(
                            '₹${formatCurrency(deal.actualPrice.round())}',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.lineThrough,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // DASHED DIVIDER LINE
              CustomPaint(
                size: const Size(double.infinity, 1),
                painter: DashedLinePainter(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  dashWidth: 5,
                  dashSpace: 4,
                ),
              ),

              // BOTTOM PART: Reward % + Final Price
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                color: isDark
                    ? AppColors.darkSurface
                    : AppColors.beigeSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'After Rewards of ${deal.rewardPercentage.toStringAsFixed(deal.rewardPercentage % 1 == 0 ? 0 : 1)}%',
                      style: GoogleFonts.fraunces(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.primaryBrown,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'Final Price: ',
                          style: AppTextStyles.caption(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '₹${formatCurrency(deal.finalPrice)}',
                          style: GoogleFonts.fraunces(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.deepBrown,
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
      ),
    );
  }
}
