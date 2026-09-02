import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/brand_model.dart';
import '../../screens/product_detail_screen.dart';
import '../../theme/app_theme.dart';
import '../network_image_with_skeleton.dart';

class GridBrandCard extends StatelessWidget {
  final BrandModel brand;
  final bool isDark;
  final VoidCallback? onTap;

  const GridBrandCard({
    super.key,
    required this.brand,
    required this.isDark,
    this.onTap,
  });

  String _formatRewardsText(String rawText) {
    final trimmed = rawText.trim();
    if (trimmed.isEmpty) return trimmed;
    if (trimmed.contains('\n')) return trimmed;

    // Detect common reward keywords (case-insensitive) at the end of the text
    final keywordPattern = RegExp(
      r'^(.*?)\s+(rewards?|bonus(?:es)?|cashback|off)$',
      caseSensitive: false,
    );
    final match = keywordPattern.firstMatch(trimmed);
    if (match != null) {
      return '${match.group(1)}\n${match.group(2)}';
    }

    // Fallback: If multiple words exist, split before the last word
    final lastSpaceIndex = trimmed.lastIndexOf(' ');
    if (lastSpaceIndex != -1) {
      return '${trimmed.substring(0, lastSpaceIndex)}\n${trimmed.substring(lastSpaceIndex + 1)}';
    }

    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final logoUrl = brand.logoUrl.isNotEmpty
        ? brand.logoUrl
        : (brand.bannerUrl.isNotEmpty
            ? brand.bannerUrl
            : brand.websiteUrl);

    final rewardsText = _formatRewardsText(brand.cashbackPercentage);

    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen.fromBrand(brand),
              ),
            );
          },
      child: Container(
        height: 156,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkCard
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(
            AppDimensions.radiusCard,
          ),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder
                : AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.25 : 0.04,
              ),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            AppDimensions.radiusCard,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ------------------------------------------
              // TOP OFFER
              // ------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.beigeSurface,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.border,
                      width: 0.8,
                    ),
                  ),
                ),
                child: Text(
                  brand.offerText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fraunces(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.deepBrown,
                  ),
                ),
              ),

              // ------------------------------------------
              // LOGO
              // ------------------------------------------
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 44,
                        maxWidth: 92,
                      ),
                      child: NetworkImageWithSkeleton(
                        imageUrl: logoUrl,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              brand.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fraunces(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // ------------------------------------------
              // REWARDS BOX (Always 2 Lines)
              // ------------------------------------------
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 86,
                  height: 35,
                  margin: const EdgeInsets.only(
                    bottom: 6,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2.5,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.deepBrown
                        : AppColors.primaryBrown,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBrown.withValues(
                          alpha: isDark ? 0.15 : 0.25,
                        ),
                        blurRadius: 4,
                        offset: const Offset(0, 1.5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      rewardsText,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: GoogleFonts.fraunces(
                        fontSize: 9.8,
                        height: 1.32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.cardBackground,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}