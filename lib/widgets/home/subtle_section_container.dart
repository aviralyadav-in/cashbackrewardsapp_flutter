import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/brand_model.dart';
import '../../theme/app_theme.dart';
import 'grid_brand_card.dart';

class SubtleSectionContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isDark;
  final List<Color> lightGradientColors;
  final List<Color> darkGradientColors;
  final VoidCallback? onViewAllTap;

  const SubtleSectionContainer({
    super.key,
    required this.title,
    required this.child,
    required this.isDark,
    required this.lightGradientColors,
    required this.darkGradientColors,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = isDark ? darkGradientColors : lightGradientColors;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 0.8,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    softWrap: true,
                    style: GoogleFonts.fraunces(
                      fontSize: 18.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: isDark ? Colors.white : const Color(0xFF1E1E24),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          child,
          if (onViewAllTap != null) ...[
            const SizedBox(height: 14),
            Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onViewAllTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1E22)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.primaryBrown.withValues(alpha: 0.35),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.25 : 0.06,
                          ),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View All',
                          style: GoogleFonts.fraunces(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.primaryBrown,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 11,
                          color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.primaryBrown,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
          ],
        ],
      ),
    );
  }
}

class GridCardsSection extends StatelessWidget {
  final List<BrandModel> brands;
  final bool isDark;
  final bool isExpanded;
  final int initialCount;

  const GridCardsSection({
    super.key,
    required this.brands,
    required this.isDark,
    this.isExpanded = false,
    this.initialCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    final displayBrands = isExpanded ? brands : brands.take(initialCount).toList();

    // Chunk into 3-column rows
    final List<List<BrandModel>> rows = [];
    for (var i = 0; i < displayBrands.length; i += 3) {
      rows.add(
        displayBrands.sublist(
          i,
          i + 3 > displayBrands.length ? displayBrands.length : i + 3,
        ),
      );
    }

    return Column(
      children: List.generate(rows.length, (rowIndex) {
        final rowBrands = rows[rowIndex];
        final isLastRow = rowIndex == rows.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLastRow ? 0.0 : 10.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: GridBrandCard(
                    brand: rowBrands[0],
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: rowBrands.length > 1
                      ? GridBrandCard(
                          brand: rowBrands[1],
                          isDark: isDark,
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: rowBrands.length > 2
                      ? GridBrandCard(
                          brand: rowBrands[2],
                          isDark: isDark,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
