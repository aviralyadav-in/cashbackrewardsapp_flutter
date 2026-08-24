import 'package:flutter/material.dart';
import '../../models/brand_model.dart';
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
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E90FF),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                if (onViewAllTap != null)
                  InkWell(
                    onTap: onViewAllTap,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E90FF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E90FF),
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: Color(0xFF1E90FF),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Section Child
          child,
        ],
      ),
    );
  }
}

class HorizontalBrandCarousel extends StatelessWidget {
  final List<BrandModel> brands;
  final bool isDark;

  const HorizontalBrandCarousel({
    super.key,
    required this.brands,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 152,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: brands.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final brand = brands[index];
          return SizedBox(
            width: 124,
            child: GridBrandCard(
              brand: brand,
              isDark: isDark,
            ),
          );
        },
      ),
    );
  }
}
