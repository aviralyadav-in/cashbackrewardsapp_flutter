import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/category_shopping_models.dart';
import '../services/category_shopping_service.dart';
import '../theme/app_theme.dart';
import '../widgets/network_image_with_skeleton.dart';
import 'product_detail_screen.dart';

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
    final cleanCat = widget.categoryId.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');
    final cleanSub = widget.subcategoryId.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');
    _data = CategoryShoppingService.getFallbackSubcategoryDetail(
      cleanCat,
      cleanSub,
      filter: _selectedFilter,
      style: _selectedStyle,
    );

    // Silently fetch fresh data in background
    _loadSubcategoryData();
  }

  Future<void> _loadSubcategoryData() async {
    try {
      final res = await _service.fetchSubcategoryDetail(
        widget.categoryId,
        widget.subcategoryId,
        filter: _selectedFilter,
        style: _selectedStyle,
      );

      if (mounted) {
        setState(() {
          _data = res;
        });
      }
    } catch (_) {}
  }

  void _navigateToProductDetails(BuildContext context, CategoryDealModel deal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen.fromCategoryDeal(
          deal,
          categoryName: widget.parentCategoryTitle ?? 'Fashion',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.mainBackground;
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;

    final parentTitle = widget.parentCategoryTitle ?? 'Category';
    final title = widget.subcategoryTitle;

    final filters = _data.filters;
    final subFiltersMap = _data.subFilters;
    final hasSubFilters = _selectedFilter == 'Shirts' && subFiltersMap.containsKey('Shirts');
    final subFilterList = hasSubFilters ? (subFiltersMap['Shirts'] as List<dynamic>? ?? []) : [];

    // Filter products locally as well to guarantee immediate client response
    final allProducts = _data.products;
    final displayProducts = allProducts.where((p) {
      if (_selectedFilter != 'All') {
        final matchesSubcat = p.title.toLowerCase().contains(_selectedFilter.toLowerCase());
        final matchesGender = p.gender != null && p.gender!.toLowerCase() == _selectedFilter.toLowerCase();
        if (!matchesSubcat && !matchesGender) return false;
      }
      if (hasSubFilters && _selectedStyle != 'All') {
        final matchesStyle = p.style != null && p.style!.toLowerCase() == _selectedStyle.toLowerCase();
        final matchesGender = p.gender != null && p.gender!.toLowerCase() == _selectedStyle.toLowerCase();
        if (!matchesStyle && !matchesGender) return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.mainBackground,
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
                          _loadSubcategoryData();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryAccent
                                : (isDark ? const Color(0xFF281F19) : const Color(0xFFF3ECE4)),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? primaryAccent
                                  : (isDark ? const Color(0xFF453528) : const Color(0xFFE2D4C6)),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              f,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
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
                      color: isDark ? const Color(0xFF1E1712) : const Color(0xFFFAF6F0),
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
                        color: isDark ? const Color(0xFF1E1712) : const Color(0xFFFAF6F0),
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
                          const SizedBox(width: 6),
                          Text(
                            '₹${deal.originalPrice.toInt()}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                              color: textMuted,
                            ),
                          ),
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
                              color: Colors.green.shade700,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryAccent,
                              foregroundColor: Colors.white,
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
