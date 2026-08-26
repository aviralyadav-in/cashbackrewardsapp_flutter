import 'package:flutter/material.dart';
import '../../models/brand_model.dart';
import '../../screens/product_detail_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    // Prefer clean logoUrl, fallback to bannerUrl or website favicon
    final logoUrl = brand.logoUrl.isNotEmpty
        ? brand.logoUrl
        : (brand.bannerUrl.isNotEmpty ? brand.bannerUrl : brand.websiteUrl);

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
          color: isDark ? const Color(0xFF18181B) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. FULL-WIDTH TOP OFFER STRIP
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF242428)
                      : const Color(0xFFF3F4F6),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? const Color(0xFF2E2E32) : const Color(0xFFEBEBEF),
                      width: 0.8,
                    ),
                  ),
                ),
                child: Text(
                  brand.offerText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFE4E4E7) : const Color(0xFF374151),
                  ),
                ),
              ),

              // 2. LARGE LOGO SECTION (Occupies largest area of the card)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: NetworkImageWithSkeleton(
                      imageUrl: logoUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          brand.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white70 : const Color(0xFF1E90FF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 3. PROMINENT BLUE REWARD BUTTON
              Container(
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E90FF),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E90FF).withValues(alpha: 0.28),
                      blurRadius: 4,
                      offset: const Offset(0, 1.5),
                    ),
                  ],
                ),
                child: Text(
                  brand.cashbackPercentage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.1,
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

class GridCardsSection extends StatelessWidget {
  final List<BrandModel> brands;
  final bool isDark;
  final bool isExpanded;
  final int initialCount;

  const GridCardsSection({
    super.key,
    required this.brands,
    required this.isDark,
    required this.isExpanded,
    this.initialCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    final displayBrands = isExpanded || brands.length <= initialCount
        ? brands
        : brands.sublist(0, initialCount);

    final List<List<BrandModel>> rows = [];
    for (var i = 0; i < displayBrands.length; i += 3) {
      rows.add(
        displayBrands.sublist(
            i, i + 3 > displayBrands.length ? displayBrands.length : i + 3),
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
