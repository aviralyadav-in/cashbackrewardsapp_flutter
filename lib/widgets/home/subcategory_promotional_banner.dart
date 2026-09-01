import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/subcategory_banner_data.dart';
import '../../theme/app_theme.dart';

class SubcategoryPromotionalBannerWidget extends StatelessWidget {
  final SubcategoryBannerData bannerData;
  final bool isDark;

  const SubcategoryPromotionalBannerWidget({
    super.key,
    required this.bannerData,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final topColor = isDark ? AppColors.darkCard : AppColors.cardBackground;
    final bottomColor = isDark
        ? Color.alphaBlend(bannerData.themeColor.withValues(alpha: 0.22), AppColors.darkBackground)
        : AppColors.beigeSurface;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [topColor, bottomColor],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // TOP SECTION
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // LEFT: Brand Badge, Offer Tag & Headline
                    Expanded(
                      flex: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // BRAND & OFFER TAG ROW
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBrown.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppColors.primaryBrown.withValues(alpha: 0.25),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  bannerData.brandName.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.deepBrown : AppColors.primaryBrown,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  bannerData.offerTag,
                                  style: GoogleFonts.inter(
                                    color: AppColors.cardBackground,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // PROMOTIONAL HEADLINE (Fraunces Display Typography)
                          Text(
                            bannerData.headline,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.fraunces(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // RIGHT: CIRCULAR BRAND/CATEGORY ICON BADGE
                    Expanded(
                      flex: 30,
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryBrown.withValues(alpha: 0.1),
                            border: Border.all(
                              color: AppColors.primaryBrown.withValues(alpha: 0.25),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              bannerData.logoIcon,
                              size: 28,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // BOTTOM SECTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SUPPORTING OFFER DETAILS (LEFT)
                    Expanded(
                      child: Text(
                        bannerData.subText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ).copyWith(fontSize: 12),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // BUTTON (RIGHT)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.deepBrown : AppColors.primaryBrown,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBrown.withValues(alpha: 0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            bannerData.buttonText,
                            style: AppTextStyles.buttonText(
                              color: AppColors.cardBackground,
                            ).copyWith(fontSize: 11),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 12,
                            color: AppColors.cardBackground,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
