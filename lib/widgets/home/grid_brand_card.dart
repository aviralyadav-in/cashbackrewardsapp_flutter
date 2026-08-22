import 'package:flutter/material.dart';
import '../../models/brand_model.dart';
import '../network_image_with_skeleton.dart';
import 'brand_confirmation_dialog.dart';

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
    final imageUrl = brand.logoUrl.isNotEmpty
        ? brand.logoUrl
        : (brand.bannerUrl.isNotEmpty ? brand.bannerUrl : brand.websiteUrl);

    return GestureDetector(
      onTap: onTap ?? () => showBrandConfirmationDialog(context, brand),
      child: Container(
        height: 148,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161618) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top: Offer / Discount % Tag
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF242426) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                brand.offerText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),

            // Center: Brand Image / Logo + Brand Name
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Logo Container
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF222225) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF333336)
                              : const Color(0xFFEEEEEE),
                          width: 0.8,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: NetworkImageWithSkeleton(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: isDark
                                  ? const Color(0xFF242426)
                                  : Colors.grey.shade200,
                              child: const Icon(
                                Icons.storefront_outlined,
                                size: 18,
                                color: Color(0xFF1E90FF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Brand Name
                    Text(
                      brand.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom: Cashback / Reward % Badge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3.5),
              decoration: BoxDecoration(
                color: const Color(0xFF1E90FF)
                    .withValues(alpha: isDark ? 0.16 : 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                brand.cashbackPercentage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E90FF),
                ),
              ),
            ),
          ],
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
