import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';
import '../theme/app_theme.dart';
import 'categories_screen.dart';

/// Data model representing a category item with display title, emoji, and target query.
class CategoryDisplayItem {
  final String id;
  final String title;
  final String emoji;
  final String query;

  const CategoryDisplayItem({
    required this.id,
    required this.title,
    required this.emoji,
    required this.query,
  });
}

class AllCategoriesScreen extends StatefulWidget {
  static const String routeName = '/all-categories';

  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // 8 Popular Categories shown in the 3-column grid (matching screenshots)
  static const List<CategoryDisplayItem> _popularCategories = [
    CategoryDisplayItem(id: 'fashion', title: 'Fashion', emoji: '👕', query: 'mens-shirts'),
    CategoryDisplayItem(id: 'electronics', title: 'Electronics', emoji: '📱', query: 'smartphones'),
    CategoryDisplayItem(id: 'home_living', title: 'Home & Living', emoji: '🏠', query: 'home-decoration'),
    CategoryDisplayItem(id: 'beauty', title: 'Beauty', emoji: '💄', query: 'beauty'),
    CategoryDisplayItem(id: 'travel', title: 'Travel', emoji: '✈️', query: 'vehicle'),
    CategoryDisplayItem(id: 'food', title: 'Food', emoji: '🍔', query: 'groceries'),
    CategoryDisplayItem(id: 'health_fitness', title: 'Health & Fitness', emoji: '🏋️', query: 'sports-accessories'),
    CategoryDisplayItem(id: 'footwear', title: 'Footwear', emoji: '👟', query: 'mens-shoes'),
  ];

  // Comprehensive list of All Categories shown in the grouped card list (matching screenshots)
  static const List<CategoryDisplayItem> _allCategoriesList = [
    CategoryDisplayItem(id: 'fashion', title: 'Fashion', emoji: '👕', query: 'mens-shirts'),
    CategoryDisplayItem(id: 'electronics', title: 'Electronics', emoji: '📱', query: 'smartphones'),
    CategoryDisplayItem(id: 'home_living', title: 'Home & Living', emoji: '🏠', query: 'home-decoration'),
    CategoryDisplayItem(id: 'beauty', title: 'Beauty', emoji: '💄', query: 'beauty'),
    CategoryDisplayItem(id: 'travel', title: 'Travel', emoji: '✈️', query: 'vehicle'),
    CategoryDisplayItem(id: 'food', title: 'Food', emoji: '🍔', query: 'groceries'),
    CategoryDisplayItem(id: 'health_fitness', title: 'Health & Fitness', emoji: '🏋️', query: 'sports-accessories'),
    CategoryDisplayItem(id: 'footwear', title: 'Footwear', emoji: '👟', query: 'mens-shoes'),
    CategoryDisplayItem(id: 'groceries', title: 'Groceries & Essentials', emoji: '🛒', query: 'groceries'),
    CategoryDisplayItem(id: 'jewellery', title: 'Jewellery & Watches', emoji: '💍', query: 'womens-jewellery'),
    CategoryDisplayItem(id: 'bags', title: 'Bags & Luggage', emoji: '🎒', query: 'womens-bags'),
    CategoryDisplayItem(id: 'fragrances', title: 'Fragrances & Perfumes', emoji: '🌸', query: 'fragrances'),
    CategoryDisplayItem(id: 'mobile_accessories', title: 'Mobile & Tech', emoji: '🎧', query: 'mobile-accessories'),
    CategoryDisplayItem(id: 'automotive', title: 'Automotive & Bikes', emoji: '🚗', query: 'motorcycle'),
    CategoryDisplayItem(id: 'sunglasses', title: 'Sunglasses & Eyewear', emoji: '🕶️', query: 'sunglasses'),
    CategoryDisplayItem(id: 'kitchen', title: 'Kitchen & Dining', emoji: '🍳', query: 'kitchen-accessories'),
    CategoryDisplayItem(id: 'sports', title: 'Sports & Outdoors', emoji: '⚽', query: 'sports-accessories'),
    CategoryDisplayItem(id: 'furniture', title: 'Furniture & Decor', emoji: '🛋️', query: 'furniture'),
    CategoryDisplayItem(id: 'skincare', title: 'Skin Care', emoji: '✨', query: 'skin-care'),
    CategoryDisplayItem(id: 'laptops', title: 'Laptops & Computers', emoji: '💻', query: 'laptops'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CategoryProvider>();
      if (provider.categories.isEmpty) {
        provider.fetchCategories();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategoryTap(CategoryDisplayItem item) {
    final provider = context.read<CategoryProvider>();
    String targetCategory = item.query;

    if (provider.categories.isNotEmpty) {
      final cleanTarget = item.query.trim().toLowerCase().replaceAll(RegExp(r"[\s\-_']+"), '');
      int foundIndex = provider.categories.indexWhere(
        (cat) => cat.toLowerCase().replaceAll(RegExp(r"[\s\-_']+"), '') == cleanTarget,
      );

      if (foundIndex == -1) {
        final lowerTitle = item.title.trim().toLowerCase().replaceAll(' ', '-');
        foundIndex = provider.categories.indexWhere(
          (cat) => cat.toLowerCase().replaceAll(' ', '-') == lowerTitle,
        );
      }

      if (foundIndex == -1) {
        foundIndex = provider.categories.indexWhere(
          (cat) =>
              cat.toLowerCase().contains(item.id.replaceAll('_', '')) ||
              item.title.toLowerCase().contains(cat.toLowerCase()),
        );
      }

      if (foundIndex != -1) {
        targetCategory = provider.categories[foundIndex];
      }
    }

    provider.fetchProductsByCategory(targetCategory);
    Navigator.of(context).pushNamed(CategoriesScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.darkBackground : AppColors.mainBackground;
    final cardBgColor = isDark ? AppColors.darkCard : AppColors.cardBackground;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.deepBrown;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final iconContainerBg = isDark ? AppColors.darkSurface : AppColors.beigeSurface;

    final trimmedQuery = _searchQuery.trim().toLowerCase();

    // Filter categories based on search input
    final filteredPopular = _popularCategories.where((cat) {
      if (trimmedQuery.isEmpty) return true;
      return cat.title.toLowerCase().contains(trimmedQuery) || cat.query.toLowerCase().contains(trimmedQuery);
    }).toList();

    final filteredAll = _allCategoriesList.where((cat) {
      if (trimmedQuery.isEmpty) return true;
      return cat.title.toLowerCase().contains(trimmedQuery) || cat.query.toLowerCase().contains(trimmedQuery);
    }).toList();

    final bool hasNoResults = trimmedQuery.isNotEmpty && filteredPopular.isEmpty && filteredAll.isEmpty;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top App Bar / Header
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: titleColor,
                    ),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    tooltip: 'Back',
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Categories',
                    style: AppTextStyles.screenHeading(
                      color: titleColor,
                    ).copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  style: GoogleFonts.fraunces(
                    fontSize: 14,
                    color: primaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search categories...',
                    hintStyle: GoogleFonts.fraunces(
                      fontSize: 14,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear_rounded,
                              color: AppColors.textMuted,
                              size: 18,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Scrollable Content
            Expanded(
              child: hasNoResults
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: iconContainerBg,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.search_off_rounded,
                                  size: 32,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No categories found',
                              style: AppTextStyles.cardTitle(
                                color: titleColor,
                              ).copyWith(fontSize: 17),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'No match for "$_searchQuery". Try another keyword.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.caption(
                                color: secondaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label: const Text('Clear search'),
                              style: TextButton.styleFrom(
                                foregroundColor: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SECTION 1: POPULAR CATEGORIES
                          if (filteredPopular.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  const Text(
                                    '🔥',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Popular Categories',
                                    style: GoogleFonts.fraunces(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w700,
                                      color: titleColor,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),

                            // 3-Column Grid for Popular Categories
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredPopular.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1.05,
                              ),
                              itemBuilder: (context, index) {
                                final item = filteredPopular[index];
                                return _buildPopularGridCard(
                                  item: item,
                                  cardBgColor: cardBgColor,
                                  borderColor: borderColor,
                                  iconContainerBg: iconContainerBg,
                                  titleColor: titleColor,
                                  isDark: isDark,
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],

                          // SECTION 2: ALL CATEGORIES
                          if (filteredAll.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  const Text(
                                    '📁',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'All Categories',
                                    style: GoogleFonts.fraunces(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w700,
                                      color: titleColor,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Grouped Card Container for All Categories
                            Container(
                              decoration: BoxDecoration(
                                color: cardBgColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: borderColor,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filteredAll.length,
                                  separatorBuilder: (context, index) => Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: isDark
                                        ? AppColors.darkBorder.withValues(alpha: 0.6)
                                        : borderColor.withValues(alpha: 0.5),
                                    indent: 14,
                                    endIndent: 14,
                                  ),
                                  itemBuilder: (context, index) {
                                    final item = filteredAll[index];
                                    return _buildAllCategoryListItem(
                                      item: item,
                                      iconContainerBg: iconContainerBg,
                                      primaryTextColor: primaryTextColor,
                                      isDark: isDark,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularGridCard({
    required CategoryDisplayItem item,
    required Color cardBgColor,
    required Color borderColor,
    required Color iconContainerBg,
    required Color titleColor,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onCategoryTap(item),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji / Icon Container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconContainerBg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: Text(
                    item.emoji,
                    style: const TextStyle(
                      fontSize: 21,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Category Label
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.fraunces(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllCategoryListItem({
    required CategoryDisplayItem item,
    required Color iconContainerBg,
    required Color primaryTextColor,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onCategoryTap(item),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Emoji Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconContainerBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    item.emoji,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Title
              Expanded(
                child: Text(
                  item.title,
                  style: GoogleFonts.fraunces(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: primaryTextColor,
                  ),
                ),
              ),

              // Trailing Chevron
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: isDark ? AppColors.darkBorder : const Color(0xFFC0AFA2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

