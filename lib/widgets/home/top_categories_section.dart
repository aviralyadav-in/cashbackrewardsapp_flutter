import 'package:flutter/material.dart';
import '../../data/home_mock_data.dart';
import '../../models/brand_model.dart';
import 'grid_brand_card.dart';

class TopCategoriesSection extends StatefulWidget {
  final bool isDark;

  const TopCategoriesSection({
    super.key,
    required this.isDark,
  });

  @override
  State<TopCategoriesSection> createState() => _TopCategoriesSectionState();
}

class _TopCategoriesSectionState extends State<TopCategoriesSection> {
  String _selectedCategoryTitle = 'Most Popular';

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final activeBrands = HomeMockData.getBrandsForTopCategory(_selectedCategoryTitle);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. SECTION HEADER
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
              'Top Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // 2. HORIZONTAL CATEGORIES SCROLL LIST
        SizedBox(
          height: 98,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: HomeMockData.topCategories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final cat = HomeMockData.topCategories[index];
              final isSelected = _selectedCategoryTitle == cat.title;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryTitle = cat.title;
                  });
                },
                child: SizedBox(
                  width: 72,
                  child: Column(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? const Color(0xFF1E90FF)
                              : (isDark
                                  ? const Color(0xFF1E1E20)
                                  : const Color(0xFF1E90FF).withValues(alpha: 0.08)),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF1E90FF)
                                : (isDark
                                    ? const Color(0xFF2C2C2E)
                                    : const Color(0xFF1E90FF).withValues(alpha: 0.2)),
                            width: isSelected ? 2 : 1.2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF1E90FF).withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Icon(
                            cat.icon,
                            size: 26,
                            color: isSelected ? Colors.white : const Color(0xFF1E90FF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat.title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          height: 1.15,
                          color: isSelected
                              ? const Color(0xFF1E90FF)
                              : (isDark ? Colors.grey.shade300 : Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 14),

        // 3. WEBSITES & BRAND BANNERS GRID (3 CARDS PER ROW)
        _buildBrandGridContainer(context, activeBrands, isDark),
      ],
    );
  }

  Widget _buildBrandGridContainer(
      BuildContext context, List<BrandModel> brands, bool isDark) {
    if (brands.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF141416) : const Color(0xFFF2F3F6),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            'No websites available for $_selectedCategoryTitle yet.',
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    // Chunk brands into rows of 3
    final List<List<BrandModel>> rows = [];
    for (var i = 0; i < brands.length; i += 3) {
      rows.add(
        brands.sublist(i, i + 3 > brands.length ? brands.length : i + 3),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141416) : const Color(0xFFF2F3F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
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
      ),
    );
  }
}
