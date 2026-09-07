import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/category_group_model.dart';
import '../providers/category_provider.dart';
import '../theme/app_theme.dart';
import 'categories_screen.dart';

/// Data model representing a category display item
class CategoryDisplayItem {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final String groupId;
  final String? subcategorySlug;
  final List<String> keywords;

  const CategoryDisplayItem({
    required this.id,
    required this.title,
    this.subtitle = '',
    required this.emoji,
    required this.groupId,
    this.subcategorySlug,
    this.keywords = const [],
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

  // 8 Popular Categories shown in the 3-column grid (deduplicated & comprehensive)
  static const List<CategoryDisplayItem> _popularCategories = [
    CategoryDisplayItem(
      id: 'fashion',
      title: 'Fashion',
      emoji: '👗',
      groupId: 'fashion',
      subcategorySlug: 'all',
      keywords: ['clothes', 'shirt', 'dress', 'top', 'shoes', 'bags', 'jewellery', 'watches', 'sunglasses'],
    ),
    CategoryDisplayItem(
      id: 'electronics',
      title: 'Mobiles & Tech',
      emoji: '📱',
      groupId: 'electronics',
      subcategorySlug: 'all',
      keywords: ['smartphones', 'phones', 'mobiles', 'laptops', 'tablets', 'gadgets', 'tech', 'electronics'],
    ),
    CategoryDisplayItem(
      id: 'home_living',
      title: 'Home & Living',
      emoji: '🏠',
      groupId: 'home_living',
      subcategorySlug: 'all',
      keywords: ['home', 'decor', 'furniture', 'kitchen', 'dining'],
    ),
    CategoryDisplayItem(
      id: 'beauty',
      title: 'Beauty & Care',
      emoji: '💄',
      groupId: 'beauty',
      subcategorySlug: 'all',
      keywords: ['beauty', 'cosmetics', 'skincare', 'perfumes', 'fragrances'],
    ),
    CategoryDisplayItem(
      id: 'food_groceries',
      title: 'Food & Groceries',
      emoji: '🛒',
      groupId: 'groceries',
      subcategorySlug: 'all',
      keywords: ['groceries', 'food', 'staples', 'kitchen', 'essentials', 'snacks'],
    ),
    CategoryDisplayItem(
      id: 'sports_fitness',
      title: 'Sports & Fitness',
      emoji: '🏋️',
      groupId: 'sports',
      subcategorySlug: 'all',
      keywords: ['sports', 'fitness', 'gym', 'workout', 'accessories'],
    ),
    CategoryDisplayItem(
      id: 'footwear',
      title: 'Footwear',
      emoji: '👟',
      groupId: 'footwear',
      subcategorySlug: 'all',
      keywords: ['shoes', 'sneakers', 'heels', 'boots', 'sandals'],
    ),
    CategoryDisplayItem(
      id: 'automotive',
      title: 'Automotive & Bikes',
      emoji: '🚗',
      groupId: 'automotive',
      subcategorySlug: 'all',
      keywords: ['vehicle', 'cars', 'bikes', 'motorcycles', 'automotive'],
    ),
  ];

  // Comprehensive list of All Categories shown in the grouped card list (NO DUPLICATES)
  static const List<CategoryDisplayItem> _allCategoriesList = [
    CategoryDisplayItem(
      id: 'fashion_main',
      title: 'Fashion & Apparel',
      subtitle: 'Shirts, Dresses, Tops, Bags, Shoes & Jewellery',
      emoji: '👗',
      groupId: 'fashion',
      subcategorySlug: 'all',
      keywords: ['clothing', 'men', 'women', 'apparel', 'fashion', 'jewellery', 'jewelry', 'watches'],
    ),
    CategoryDisplayItem(
      id: 'electronics_main',
      title: 'Mobiles, Laptops & Electronics',
      subtitle: 'Smartphones, Laptops, Tablets & Audio Tech',
      emoji: '📱',
      groupId: 'electronics',
      subcategorySlug: 'all',
      keywords: [
        'smartphones',
        'phones',
        'mobiles',
        'laptops',
        'tablets',
        'gadgets',
        'tech',
        'electronics',
        'computers',
        'macbook',
        'audio',
        'headphones',
        'chargers',
        'accessories',
      ],
    ),
    CategoryDisplayItem(
      id: 'home_living_main',
      title: 'Home & Living',
      subtitle: 'Furniture, Home Decor & Kitchen Dining',
      emoji: '🏠',
      groupId: 'home_living',
      subcategorySlug: 'all',
      keywords: ['living', 'interior', 'decoration', 'appliances'],
    ),
    CategoryDisplayItem(
      id: 'beauty_care_main',
      title: 'Beauty & Personal Care',
      subtitle: 'Skincare, Makeup & Luxury Fragrances',
      emoji: '💄',
      groupId: 'beauty',
      subcategorySlug: 'all',
      keywords: ['care', 'glow', 'skin', 'cosmetics', 'perfume'],
    ),
    CategoryDisplayItem(
      id: 'groceries_main',
      title: 'Food & Groceries',
      subtitle: 'Daily Staples, Food & Kitchen Essentials',
      emoji: '🛒',
      groupId: 'groceries',
      subcategorySlug: 'all',
      keywords: ['groceries', 'food', 'pantry', 'staples', 'essentials'],
    ),
    CategoryDisplayItem(
      id: 'sports_fitness_main',
      title: 'Sports & Fitness',
      subtitle: 'Sports Gear, Fitness Equipment & Outdoors',
      emoji: '🏋️',
      groupId: 'sports',
      subcategorySlug: 'all',
      keywords: ['workout', 'exercise', 'training', 'athletics'],
    ),
    CategoryDisplayItem(
      id: 'footwear_main',
      title: 'Footwear & Shoes',
      subtitle: "Men's & Women's Footwear & Sneakers",
      emoji: '👟',
      groupId: 'footwear',
      subcategorySlug: 'all',
      keywords: ['footwear', 'shoes', 'running', 'boots'],
    ),
    CategoryDisplayItem(
      id: 'bags_luggage',
      title: 'Bags & Luggage',
      subtitle: 'Handbags, Backpacks & Travel Luggage',
      emoji: '🎒',
      groupId: 'fashion',
      subcategorySlug: 'womens-bags',
      keywords: ['bags', 'purse', 'handbag', 'backpack', 'tote'],
    ),
    CategoryDisplayItem(
      id: 'fragrances_perfumes',
      title: 'Fragrances & Perfumes',
      subtitle: 'Luxury Scents, Colognes & Deodorants',
      emoji: '🌸',
      groupId: 'beauty',
      subcategorySlug: 'fragrances',
      keywords: ['perfumes', 'cologne', 'scent', 'deodorant'],
    ),
    CategoryDisplayItem(
      id: 'skincare_sub',
      title: 'Skin Care',
      subtitle: 'Moisturizers, Serums, Cleansers & Sunscreen',
      emoji: '✨',
      groupId: 'beauty',
      subcategorySlug: 'skin-care',
      keywords: ['serum', 'cream', 'face', 'cleanser'],
    ),
    CategoryDisplayItem(
      id: 'kitchen_dining',
      title: 'Kitchen & Dining',
      subtitle: 'Cookware, Utensils & Tableware',
      emoji: '🍳',
      groupId: 'home_living',
      subcategorySlug: 'kitchen-accessories',
      keywords: ['cooking', 'pans', 'pots', 'dining'],
    ),
    CategoryDisplayItem(
      id: 'furniture_decor',
      title: 'Furniture & Decor',
      subtitle: 'Living Room, Bedroom & Office Decor',
      emoji: '🛋️',
      groupId: 'home_living',
      subcategorySlug: 'furniture',
      keywords: ['sofa', 'table', 'chair', 'bed', 'decor'],
    ),
    CategoryDisplayItem(
      id: 'sunglasses_eyewear',
      title: 'Sunglasses & Eyewear',
      subtitle: 'Designer Frames, Shades & UV Protection',
      emoji: '🕶️',
      groupId: 'fashion',
      subcategorySlug: 'sunglasses',
      keywords: ['glasses', 'shades', 'frames', 'sun'],
    ),
    CategoryDisplayItem(
      id: 'automotive_vehicles',
      title: 'Automotive & Vehicles',
      subtitle: 'Cars, Bikes, Motorcycles & Motor Gear',
      emoji: '🚗',
      groupId: 'automotive',
      subcategorySlug: 'all',
      keywords: ['cars', 'bikes', 'motorcycle', 'vehicles'],
    ),
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
    final group = CategoryGroup.findById(item.groupId);
    final subcat = item.subcategorySlug ?? 'all';

    provider.selectCategoryGroup(group, subcategorySlug: subcat);
    Navigator.of(context).pushNamed(
      CategoriesScreen.routeName,
      arguments: {
        'groupId': item.groupId,
        'subcategorySlug': subcat,
      },
    );
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

    // Filter categories based on search input (checks title, subtitle, and subcategory keywords)
    final filteredPopular = _popularCategories.where((cat) {
      if (trimmedQuery.isEmpty) return true;
      return cat.title.toLowerCase().contains(trimmedQuery) ||
          cat.keywords.any((k) => k.toLowerCase().contains(trimmedQuery));
    }).toList();

    final filteredAll = _allCategoriesList.where((cat) {
      if (trimmedQuery.isEmpty) return true;
      return cat.title.toLowerCase().contains(trimmedQuery) ||
          cat.subtitle.toLowerCase().contains(trimmedQuery) ||
          cat.keywords.any((k) => k.toLowerCase().contains(trimmedQuery));
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
                      fontSize: 20,
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

              // Title & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.fraunces(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor,
                      ),
                    ),
                    if (item.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ).copyWith(fontSize: 12),
                      ),
                    ],
                  ],
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


