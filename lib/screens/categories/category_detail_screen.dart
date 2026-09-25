import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/category_shopping_models.dart';
import '../../services/app_cashback_engine.dart';
import '../../services/category_shopping_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/network_image_with_skeleton.dart';
import '../stores/all_stores_screen.dart';
import '../products/product_detail_screen.dart';
import '../stores/store_detail_screen.dart';
import 'subcategory_detail_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  static const String routeName = '/category-detail';

  final String categoryId;
  final String? categoryTitle;

  const CategoryDetailScreen({
    super.key,
    required this.categoryId,
    this.categoryTitle,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final CategoryShoppingService _service = CategoryShoppingService();

  late CategoryDetailResponse _categoryData;

  @override
  void initState() {
    super.initState();
    // Instantly populate category data with zero network delay (NO WHITE SCREEN)
    _categoryData = CategoryShoppingService.getFallbackCategoryDetail(
      widget.categoryId,
      categoryTitle: widget.categoryTitle,
    );

    // Silently merge in any extra backend data
    _loadCategoryData();
  }

  Future<void> _loadCategoryData() async {
    try {
      final data = await _service.fetchCategoryDetail(
        widget.categoryId,
        categoryTitle: widget.categoryTitle,
      );
      if (mounted) {
        setState(() {
          _categoryData = data;
        });
      }
    } catch (_) {}
  }

  IconData _resolveIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'checkroom':
        return Icons.checkroom_rounded;
      case 'roller_skating':
        return Icons.skateboarding_rounded;
      case 'watch':
        return Icons.watch_outlined;
      case 'male':
        return Icons.man_rounded;
      case 'female':
        return Icons.woman_rounded;
      case 'smartphone':
        return Icons.smartphone_rounded;
      case 'laptop':
        return Icons.laptop_chromebook_rounded;
      case 'tv':
        return Icons.tv_rounded;
      case 'headphones':
        return Icons.headphones_rounded;
      case 'photo_camera':
        return Icons.photo_camera_rounded;
      case 'brush':
        return Icons.brush_rounded;
      case 'spa':
        return Icons.spa_rounded;
      case 'face':
        return Icons.face_rounded;
      case 'chair':
        return Icons.chair_rounded;
      case 'kitchen':
        return Icons.kitchen_rounded;
      case 'flight':
      case 'flights':
        return Icons.flight_rounded;
      case 'hotel':
      case 'hotels':
        return Icons.hotel_rounded;
      case 'directions_bus':
      case 'bus':
        return Icons.directions_bus_rounded;
      case 'train':
      case 'trains':
        return Icons.train_rounded;
      case 'beach_access':
      case 'holidays':
        return Icons.beach_access_rounded;
      case 'delivery_dining':
      case 'delivery':
        return Icons.delivery_dining_rounded;
      case 'restaurant':
      case 'dineout':
        return Icons.restaurant_rounded;
      case 'local_pizza':
      case 'pizza':
        return Icons.local_pizza_rounded;
      case 'local_cafe':
      case 'cafes':
        return Icons.local_cafe_rounded;
      case 'bakery_dining':
      case 'bakery':
        return Icons.bakery_dining_rounded;
      case 'sanitizer':
      case 'fragrances':
        return Icons.sanitizer_rounded;
      case 'health_and_safety':
      case 'wellness':
        return Icons.health_and_safety_rounded;
      case 'egg':
      case 'dairy':
        return Icons.egg_rounded;
      case 'eco':
      case 'fruits':
        return Icons.eco_rounded;
      case 'fastfood':
      case 'snacks':
        return Icons.fastfood_rounded;
      case 'cleaning_services':
      case 'cleaning':
        return Icons.cleaning_services_rounded;
      case 'credit_card':
      case 'cashback_cards':
        return Icons.credit_card_rounded;
      case 'shopping_cart':
      case 'shopping_cards':
        return Icons.shopping_cart_rounded;
      case 'local_gas_station':
      case 'fuel_cards':
        return Icons.local_gas_station_rounded;
      case 'card_giftcard':
      case 'lifetime_free':
        return Icons.card_giftcard_rounded;
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;
      case 'sunglasses':
        return Icons.visibility_outlined;
      case 'directions_run':
        return Icons.directions_run_rounded;
      case 'work':
        return Icons.work_outline_rounded;
      case 'microwave':
        return Icons.microwave_outlined;
      case 'living':
        return Icons.living_outlined;
      case 'inventory_2':
        return Icons.inventory_2_outlined;
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      case 'hiking':
        return Icons.hiking_rounded;
      case 'directions_car':
        return Icons.directions_car_rounded;
      case 'two_wheeler':
        return Icons.two_wheeler_rounded;
      default:
        return Icons.category_outlined;
    }
  }

  void _navigateToStoreDetail(BuildContext context, CategoryStoreModel store) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StoreDetailScreen(
          store: store,
          category: _categoryData.category.name,
        ),
      ),
    );
  }

  void _navigateToProductDetails(BuildContext context, CategoryDealModel deal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen.fromCategoryDeal(
          deal,
          categoryName: _categoryData.category.name,
        ),
      ),
    );
  }

  void _showAllSubcategoriesSheet(BuildContext context, bool isDark) {
    final subcategories = _categoryData.subcategories;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
        final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
        final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'All ${_categoryData.category.name} Subcategories',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: subcategories.map((sub) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SubcategoryDetailScreen(
                            categoryId: widget.categoryId,
                            subcategoryId: sub.id,
                            subcategoryTitle: sub.name,
                            parentCategoryTitle: _categoryData.category.name,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1C2D5A) : const Color(0xFFFAF2E7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_resolveIcon(sub.icon), size: 18, color: primaryAccent),
                          const SizedBox(width: 8),
                          Text(
                            sub.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textDark,
                            ),
                          ),
                          if (sub.itemCount.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Text(
                              '(${sub.itemCount})',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
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

    final categoryName = _categoryData.category.name.isNotEmpty ? _categoryData.category.name : (widget.categoryTitle ?? 'Category');
    final categoryDesc = _categoryData.category.description;

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
        title: Text(
          categoryName,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: primaryAccent,
        onRefresh: _loadCategoryData,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 30),
          children: [
                  // SECTION 2: COMPACT CATEGORY HEADER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1712) : const Color(0xFFFAF6F0),
                      border: Border(
                        bottom: BorderSide(color: borderColor.withValues(alpha: 0.6), width: 0.8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryAccent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'CATEGORY',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: primaryAccent,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              categoryName,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          categoryDesc,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: textMuted,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // SECTION 3: SHOP BY SUBCATEGORY
                  if (_categoryData.subcategories.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            'Shop by Subcategory',
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: textDark,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () => _showAllSubcategoriesSheet(context, isDark),
                            borderRadius: BorderRadius.circular(6),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              child: Row(
                                children: [
                                  Text(
                                    'View All',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: primaryAccent,
                                    ),
                                  ),
                                  Icon(Icons.chevron_right_rounded, size: 15, color: primaryAccent),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 94,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _categoryData.subcategories.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final sub = _categoryData.subcategories[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SubcategoryDetailScreen(
                                    categoryId: widget.categoryId,
                                    subcategoryId: sub.id,
                                    subcategoryTitle: sub.name,
                                    parentCategoryTitle: categoryName,
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              width: 86,
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: borderColor, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF1C2D5A) : const Color(0xFFFAF2E7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(_resolveIcon(sub.icon), size: 20, color: primaryAccent),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    sub.name,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: textDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // SECTION 4: POPULAR BRANDS & STORES
                  if (_categoryData.popularStores.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            'Popular Brands & Stores',
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: textDark,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AllStoresScreen()),
                              );
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              child: Row(
                                children: [
                                  Text(
                                    'View All Stores',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: primaryAccent,
                                    ),
                                  ),
                                  Icon(Icons.chevron_right_rounded, size: 15, color: primaryAccent),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 164,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _categoryData.popularStores.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final store = _categoryData.popularStores[index];
                          return Container(
                            width: 130,
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderColor, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _navigateToStoreDetail(context, store),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: isDark ? const Color(0xFF1E1712) : const Color(0xFFFAF6F0),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: borderColor, width: 0.8),
                                        ),
                                        child: ClipOval(
                                          child: NetworkImageWithSkeleton(
                                            imageUrl: store.logoUrl,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Center(
                                                child: Text(
                                                  store.name.isNotEmpty ? store.name[0] : 'S',
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    color: primaryAccent,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        store.name,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: textDark,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 2),
                                      // Brand/store offer
                                      Text(
                                        storeOfferLabel(store.cashbackRate),
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          color: primaryAccent,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                      // KashIQ cashback (smart deal engine rate)
                                      Text(
                                        AppCashbackEngine.cashbackLabel(store.name),
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.green.shade700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 26,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(color: primaryAccent, width: 1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () => _navigateToStoreDetail(context, store),
                                          child: Text(
                                            'View Store',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w700,
                                              color: primaryAccent,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // SECTION 6: BEST DEALS FOR CATEGORY
                  if (_categoryData.bestDeals.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            '🔥 Best $categoryName Deals',
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: textDark,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Curated Savings',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categoryData.bestDeals.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final deal = _categoryData.bestDeals[index];
                        return _buildCategoryDealCard(
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
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildCategoryDealCard(
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
                // Product Image with Best Deal Badge
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
                                '₹${deal.couponDiscount.toInt()} Coupon',
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
