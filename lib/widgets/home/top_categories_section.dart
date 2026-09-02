import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/home_mock_data.dart';
import '../../models/brand_model.dart';
import '../../models/top_category_model.dart';
import '../network_image_with_skeleton.dart';
import 'grid_brand_card.dart';

/// TopCategoriesSection manages category selection state and renders
/// two completely separate, independent UI sections touching directly with ZERO vertical gap:
/// 1. [CategorySelectorSection] — Overall background is FIXED; ONLY the individual selected
///    category image container background changes dynamically.
/// 2. [CategoryOffersSection] — Offers/Cards section whose overall background changes
///    dynamically according to the selected category.
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
  final ScrollController _categoryScrollController = ScrollController();
  int _selectedCategoryIndex = 0;
  bool _showAllCategories = false;

  static const double _itemWidth = 74.0;
  static const double _itemSpacing = 12.0;

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _onCategorySelected(int index) {
    if (_selectedCategoryIndex == index) return;

    setState(() {
      _selectedCategoryIndex = index;
      _showAllCategories = false;
    });

    _autoCenterCategory(index);
  }

  void _autoCenterCategory(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_categoryScrollController.hasClients) return;

      final double screenWidth = MediaQuery.of(context).size.width;
      final double totalItemWidth = _itemWidth + _itemSpacing;

      // Calculate horizontal offset to move the tapped category toward the center
      final double targetOffset =
          (index * totalItemWidth + (_itemWidth / 2)) - (screenWidth / 2);

      final double maxScroll =
          _categoryScrollController.position.maxScrollExtent;
      final double minScroll =
          _categoryScrollController.position.minScrollExtent;
      final double clampedOffset = targetOffset.clamp(minScroll, maxScroll);

      _categoryScrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final categories = HomeMockData.topCategories;
    final activeCategory =
        categories[_selectedCategoryIndex.clamp(0, categories.length - 1)];
    final activeBrands =
        HomeMockData.getBrandsForTopCategory(activeCategory.title);

    // Dynamic pastel background & accent color for the Offers Section & Selected Image Container
    final dynamicOffersBackgroundColor = isDark
        ? activeCategory.darkBackgroundColor
        : activeCategory.backgroundColor;

    final dynamicAccentColor = activeCategory.accentColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // =====================================================================
        // SECTION 1 — CATEGORY SECTION (Dedicated Widget with FIXED background)
        // =====================================================================
        CategorySelectorSection(
          categories: categories,
          selectedIndex: _selectedCategoryIndex,
          onCategorySelected: _onCategorySelected,
          scrollController: _categoryScrollController,
          accentColor: dynamicAccentColor,
          isDark: isDark,
          itemWidth: _itemWidth,
          itemSpacing: _itemSpacing,
        ),

        // ZERO GAP / ZERO MARGIN / ZERO SIZEDBOX / ZERO PADDING BETWEEN SECTIONS

        // =====================================================================
        // SECTION 2 — OFFERS/CARDS SECTION (Dedicated Widget with DYNAMIC background)
        // =====================================================================
        CategoryOffersSection(
          activeCategory: activeCategory,
          brands: activeBrands,
          backgroundColor: dynamicOffersBackgroundColor,
          accentColor: dynamicAccentColor,
          isDark: isDark,
          showAllCategories: _showAllCategories,
          onToggleShowAll: () {
            setState(() {
              _showAllCategories = !_showAllCategories;
            });
          },
        ),
      ],
    );
  }
}

// =============================================================================
// SECTION 1: CATEGORY SELECTOR COMPONENT (Overall Background is FIXED)
// =============================================================================
class CategorySelectorSection extends StatelessWidget {
  final List<TopCategoryItemData> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;
  final ScrollController scrollController;
  final Color accentColor;
  final bool isDark;
  final double itemWidth;
  final double itemSpacing;

  const CategorySelectorSection({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
    required this.scrollController,
    required this.accentColor,
    required this.isDark,
    required this.itemWidth,
    required this.itemSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final activeCategory =
        categories[selectedIndex.clamp(0, categories.length - 1)];

    // Category Section keeps its FIXED existing background (transparent / scaffold theme)
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section 1 Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Top Categories',
                      style: GoogleFonts.fraunces(
                        fontSize: 18.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: isDark ? Colors.white : const Color(0xFF1E1E24),
                      ),
                    ),
                  ],
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    activeCategory.title,
                    style: GoogleFonts.fraunces(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Horizontal Category List
          SizedBox(
            height: 114,
            child: ListView.separated(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (context, index) =>
                  SizedBox(width: itemSpacing),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = selectedIndex == index;

                // Dynamic background color when category is selected (replaces yellow)
                final Color activeTabColor = isDark
                    ? cat.darkBackgroundColor
                    : cat.backgroundColor;
                final Color tabBgColor = isSelected
                    ? activeTabColor
                    : activeTabColor.withValues(alpha: 0.0);

                // Category circular image container background color
                final Color imageContainerBg = isDark
                    ? const Color(0xFF1E1E22)
                    : Colors.white;

                return GestureDetector(
                  onTap: () => onCategorySelected(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    width: itemWidth,
                    padding: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: tabBgColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Dynamic Category Image Container
                        AnimatedScale(
                          scale: isSelected ? 1.08 : 0.95,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutBack,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                            width: 58,
                            height: 58,
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: imageContainerBg,
                              border: Border.all(
                                color: isSelected
                                    ? cat.accentColor
                                    : (isDark
                                        ? Colors.white.withValues(alpha: 0.12)
                                        : Colors.black.withValues(alpha: 0.08)),
                                width: isSelected ? 2.5 : 1.0,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: cat.accentColor.withValues(alpha: 0.38),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.04),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: ClipOval(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  NetworkImageWithSkeleton(
                                    imageUrl: cat.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      color: imageContainerBg,
                                      child: Center(
                                        child: Icon(
                                          cat.icon,
                                          size: 22,
                                          color: isSelected
                                              ? cat.accentColor
                                              : (isDark
                                                  ? Colors.grey.shade400
                                                  : Colors.grey.shade600),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: cat.accentColor.withValues(alpha: 0.3),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Category Name Label
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: GoogleFonts.fraunces(
                            fontSize: 12.5,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w700,
                            height: 1.15,
                            color: isSelected
                                ? accentColor
                                : (isDark
                                    ? Colors.grey.shade300
                                    : const Color(0xFF374151)),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          child: Text(cat.title),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SECTION 2: OFFERS / CARDS COMPONENT (Overall Background is DYNAMIC)
// =============================================================================
class CategoryOffersSection extends StatelessWidget {
  final TopCategoryItemData activeCategory;
  final List<BrandModel> brands;
  final Color backgroundColor;
  final Color accentColor;
  final bool isDark;
  final bool showAllCategories;
  final VoidCallback onToggleShowAll;

  const CategoryOffersSection({
    super.key,
    required this.activeCategory,
    required this.brands,
    required this.backgroundColor,
    required this.accentColor,
    required this.isDark,
    required this.showAllCategories,
    required this.onToggleShowAll,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: BoxDecoration(
        color: backgroundColor, // Dynamic category-specific background color
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section 2 Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // AnimatedContainer(
                    //   duration: const Duration(milliseconds: 350),
                    //   width: 4,
                    //   height: 16,
                    //   decoration: BoxDecoration(
                    //     color: accentColor,
                    //     borderRadius: BorderRadius.circular(2),
                    //   ),
                    // ),
                    const SizedBox(width: 8),
                    // Text(
                    //   '${activeCategory.title} Offers',
                    //   style: GoogleFonts.fraunces(
                    //     fontSize: 15,
                    //     fontWeight: FontWeight.w700,
                    //     color: isDark ? Colors.white : const Color(0xFF1E1E24),
                    //   ),
                    // ),
                  ],
                ),
                // Text(
                //   '${brands.length} Stores',
                //   style: GoogleFonts.fraunces(
                //     fontSize: 12,
                //     fontWeight: FontWeight.w600,
                //     color: accentColor,
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Offer Cards Grid (Clean White Cards on Category Themed Background)
          _buildBrandGrid(context),
        ],
      ),
    );
  }

  Widget _buildBrandGrid(BuildContext context) {
    if (brands.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E22) : Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.storefront_outlined,
                size: 30,
                color: accentColor.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 6),
              Text(
                'No stores available for ${activeCategory.title} yet.',
                style: GoogleFonts.fraunces(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final visibleBrands =
        showAllCategories ? brands : brands.take(6).toList();

    // Chunk brands into rows of 3
    final List<List<BrandModel>> rows = [];
    for (var i = 0; i < visibleBrands.length; i += 3) {
      rows.add(
        visibleBrands.sublist(
          i,
          i + 3 > visibleBrands.length ? visibleBrands.length : i + 3,
        ),
      );
    }

    return Column(
      children: [
        ...List.generate(rows.length, (rowIndex) {
          final rowBrands = rows[rowIndex];
          final isLastRow = rowIndex == rows.length - 1;

          return Padding(
            padding: EdgeInsets.only(
              bottom: (isLastRow && brands.length <= 6) ? 0.0 : 10.0,
            ),
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

        // View All / Show Less Toggle Button
        if (brands.length > 6) ...[
          const SizedBox(height: 4),
          Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onToggleShowAll,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E22) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        showAllCategories
                            ? 'Show Less'
                            : 'View All ${brands.length} Stores',
                        style: GoogleFonts.fraunces(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        showAllCategories
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: accentColor,
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
    );
  }
}
