import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/category_shopping_models.dart';
import '../../services/category_shopping_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/network_image_with_skeleton.dart';
import '../products/product_detail_screen.dart';

class SubcategoryDetailScreen extends StatefulWidget {
  static const String routeName = '/subcategory-detail';

  final String categoryId;
  final String subcategoryId;
  final String subcategoryTitle;
  final String? parentCategoryTitle;

  const SubcategoryDetailScreen({
    super.key,
    required this.categoryId,
    required this.subcategoryId,
    required this.subcategoryTitle,
    this.parentCategoryTitle,
  });

  @override
  State<SubcategoryDetailScreen> createState() => _SubcategoryDetailScreenState();
}

class _SubcategoryDetailScreenState extends State<SubcategoryDetailScreen> {
  final CategoryShoppingService _service = CategoryShoppingService();

  late SubcategoryDetailResponse _data;
  String _selectedFilter = 'All';
  String _selectedStyle = 'All';

  @override
  void initState() {
    super.initState();
    // Instantly load data on frame 0 to avoid white screen
    _data = CategoryShoppingService.getFallbackSubcategoryDetail(
      widget.categoryId,
      widget.subcategoryId,
    );

    // Silently fetch fresh data in background
    _loadSubcategoryData();
  }

  Future<void> _loadSubcategoryData() async {
    try {
      final res = await _service.fetchSubcategoryDetail(
        widget.categoryId,
        widget.subcategoryId,
      );

      if (mounted) {
        setState(() {
          _data = res;
        });
      }
    } catch (_) {}
  }

  static String _tag(String value) =>
      value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

  bool _matches(String? value, String selected) =>
      value != null && value.isNotEmpty && _tag(value) == _tag(selected);

  void _navigateToProductDetails(BuildContext context, CategoryDealModel deal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen.fromCategoryDeal(
          deal,
          categoryName: widget.parentCategoryTitle ?? _data.subcategory.categoryName ?? _data.subcategory.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.mainBackground;
    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final primaryAccent = isDark ? AppColors.darkPrimary : AppColors.primaryBrown;

    final parentTitle = _data.subcategory.categoryName ?? widget.parentCategoryTitle ?? 'Category';
    final title = widget.subcategoryTitle;

    final filters = _data.filters;
    final subFiltersMap = _data.subFilters;
    final hasSubFilters = subFiltersMap.containsKey(_selectedFilter);
    final subFilterList = hasSubFilters ? (subFiltersMap[_selectedFilter] as List<dynamic>? ?? []) : [];

    // Filter on product tags (gender / product type / style), not on title text
    final allProducts = _data.products;
    final displayProducts = allProducts.where((p) {
      if (_selectedFilter != 'All') {
        final matchesType = _matches(p.productType, _selectedFilter) ||
            _matches(p.subcategoryId, _selectedFilter);
        final matchesGender = _matches(p.gender, _selectedFilter);
        if (!matchesType && !matchesGender) return false;
      }
      if (hasSubFilters && _selectedStyle != 'All') {
        if (!_matches(p.style, _selectedStyle) && !_matches(p.gender, _selectedStyle)) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryAccent,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 17.5,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
            Text(
              '$parentTitle → $title',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: textMuted,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Primary Filter Bar (e.g. All, Men, Women, Shirts, T-Shirts...)
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.mainBackground,
                    border: Border(
                      bottom: BorderSide(color: borderColor.withValues(alpha: 0.5), width: 0.8),
                    ),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: filters.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final f = filters[index];
                      final isSelected = _selectedFilter == f;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFilter = f;
                            _selectedStyle = 'All';
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryAccent
                                : (isDark ? AppColors.darkSurface : const Color(0xFFF3ECE4)),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? primaryAccent
                                  : (isDark ? AppColors.darkBorder : const Color(0xFFE2D4C6)),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              f,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? (isDark ? AppColors.darkButtonText : Colors.white)
                                    : (isDark ? AppColors.darkTextPrimary : const Color(0xFF1E3A8A)),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Secondary Sub-filter bar (e.g. for Shirts: Casual, Formal, Oversized)
                if (hasSubFilters && subFilterList.isNotEmpty)
                  Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : const Color(0xFFFAF6F0),
                    ),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: subFilterList.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 6),
                      itemBuilder: (context, index) {
                        final sf = subFilterList[index].toString();
                        final isSelected = _selectedStyle == sf;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedStyle = sf;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primaryAccent.withValues(alpha: 0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? primaryAccent : borderColor,
                                width: 0.8,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                sf,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? primaryAccent : textMuted,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Products Count & Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Text(
                        'Best Deals & Price Comparisons',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${displayProducts.length} Items',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ),

                // Products List
                Expanded(
                  child: displayProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 50,
                                color: textMuted.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'No products found for this filter',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Try selecting "All" above',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                          itemCount: displayProducts.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final deal = displayProducts[index];
                            return _buildProductCard(
                              context,
                              deal,
                              isDark,
                              cardBg,
                              borderColor,
                              textDark,
                              textMuted,
                              primaryAccent,
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    CategoryDealModel deal,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color textDark,
    Color textMuted,
    Color primaryAccent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToProductDetails(context, deal),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image with badge
                Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : const Color(0xFFFAF6F0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 0.8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: NetworkImageWithSkeleton(
                          imageUrl: deal.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (deal.badge.isNotEmpty)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            deal.badge,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFF3BD8B),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: primaryAccent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              deal.store,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: primaryAccent,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${deal.cashbackPercentage.toInt()}% Cashback',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.green.shade700,
                            ),
                          ),
                          const Spacer(),
                          if (deal.couponDiscount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '₹${deal.couponDiscount.toInt()} OFF',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        deal.title,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Prices
                      Row(
                        children: [
                          Text(
                            '₹${deal.discountedPrice.toInt()}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: textDark,
                            ),
                          ),
                          if (deal.originalPrice > deal.discountedPrice) ...[
                            const SizedBox(width: 6),
                            Text(
                              '₹${deal.originalPrice.toInt()}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                                color: textMuted,
                              ),
                            ),
                          ],
                          // Brand/store offer
                          if (deal.discountPercentage > 0) ...[
                            const SizedBox(width: 6),
                            Text(
                              '${deal.discountPercentage.toInt()}% OFF',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Compare Deals CTA
                      Row(
                        children: [
                          Text(
                            'Save ₹${deal.effectiveSavings.toInt()}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkSuccess : Colors.green.shade700,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryAccent,
                              foregroundColor: isDark ? AppColors.darkButtonText : Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => _navigateToProductDetails(context, deal),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified_outlined, size: 13),
                                const SizedBox(width: 4),
                                Text(
                                  'View Deal',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
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
          ),
        ),
      ),
    );
  }
}
