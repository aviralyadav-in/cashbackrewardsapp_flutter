import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/brand_model.dart';
import '../../theme/app_theme.dart';
import 'grid_brand_card.dart';

/// Clean, elegant subcategory section inside a stylized container box.
/// Encapsulates section header and horizontally swipable full-sized brand cards.
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark ? darkGradientColors : lightGradientColors,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF2E2A38) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header Row: Title on Left, View All on Right
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: isDark ? Colors.white : const Color(0xFF1E1E24),
                      ),
                    ),
                  ],
                ),
                if (onViewAllTap != null)
                  InkWell(
                    onTap: onViewAllTap,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View All',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.primaryBrown,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 10,
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primaryBrown,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Swipable Cards Area: Smooth, clipped horizontal scrolling
          child,
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

/// Horizontally Swipable Brand Cards Section with full-sized cards
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
    final displayBrands = isExpanded ? brands : brands;

    if (displayBrands.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 256,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        itemCount: displayBrands.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 156,
            child: GridBrandCard(
              brand: displayBrands[index],
              isDark: isDark,
              columnIndex: index,
            ),
          );
        },
      ),
    );
  }
}

typedef SwipableCardsSection = GridCardsSection;
