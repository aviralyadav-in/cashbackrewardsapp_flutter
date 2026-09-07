import 'package:flutter/material.dart';

/// Represents an individual subcategory (e.g. "Women Dresses", "Men Shirts", "Laptops")
class SubCategoryItem {
  final String id;
  final String title;
  final String slug;
  final String emoji;

  const SubCategoryItem({
    required this.id,
    required this.title,
    required this.slug,
    this.emoji = '🏷️',
  });
}

/// Represents a top-level category group/department (e.g. "Fashion", "Electronics")
/// containing multiple related subcategories from the catalog.
class CategoryGroup {
  final String id;
  final String title;
  final String emoji;
  final String description;
  final IconData icon;
  final List<SubCategoryItem> subcategories;

  const CategoryGroup({
    required this.id,
    required this.title,
    required this.emoji,
    required this.description,
    required this.icon,
    required this.subcategories,
  });

  /// All slugs included in this category group
  List<String> get allSlugs => subcategories.map((s) => s.slug).toList();

  // ===========================================================================
  // PREDEFINED SYSTEM CATEGORY GROUPS (Deduplicated, Comprehensive)
  // ===========================================================================

  static const CategoryGroup fashion = CategoryGroup(
    id: 'fashion',
    title: 'Fashion',
    emoji: '👗',
    description: 'Shirts, Dresses, Tops, Shoes, Bags & Jewellery',
    icon: Icons.checkroom_rounded,
    subcategories: [
      SubCategoryItem(
        id: 'mens-shirts',
        title: "Men's Shirts",
        slug: 'mens-shirts',
        emoji: '👕',
      ),
      SubCategoryItem(
        id: 'womens-dresses',
        title: "Women's Dresses",
        slug: 'womens-dresses',
        emoji: '👗',
      ),
      SubCategoryItem(
        id: 'tops',
        title: 'Tops & Blouses',
        slug: 'tops',
        emoji: '👚',
      ),
      SubCategoryItem(
        id: 'womens-bags',
        title: 'Bags & Luggage',
        slug: 'womens-bags',
        emoji: '👜',
      ),
      SubCategoryItem(
        id: 'womens-jewellery',
        title: 'Jewellery',
        slug: 'womens-jewellery',
        emoji: '💍',
      ),
      SubCategoryItem(
        id: 'mens-shoes',
        title: "Men's Shoes",
        slug: 'mens-shoes',
        emoji: '👞',
      ),
      SubCategoryItem(
        id: 'womens-shoes',
        title: "Women's Shoes",
        slug: 'womens-shoes',
        emoji: '👠',
      ),
      SubCategoryItem(
        id: 'mens-watches',
        title: "Men's Watches",
        slug: 'mens-watches',
        emoji: '⌚',
      ),
      SubCategoryItem(
        id: 'womens-watches',
        title: "Women's Watches",
        slug: 'womens-watches',
        emoji: '⌚',
      ),
      SubCategoryItem(
        id: 'sunglasses',
        title: 'Sunglasses',
        slug: 'sunglasses',
        emoji: '🕶️',
      ),
    ],
  );

  static const CategoryGroup electronics = CategoryGroup(
    id: 'electronics',
    title: 'Mobiles, Laptops & Electronics',
    emoji: '📱',
    description: 'Smartphones, Laptops, Tablets & Audio Tech',
    icon: Icons.devices_rounded,
    subcategories: [
      SubCategoryItem(
        id: 'smartphones',
        title: 'Smartphones',
        slug: 'smartphones',
        emoji: '📱',
      ),
      SubCategoryItem(
        id: 'laptops',
        title: 'Laptops',
        slug: 'laptops',
        emoji: '💻',
      ),
      SubCategoryItem(
        id: 'tablets',
        title: 'Tablets',
        slug: 'tablets',
        emoji: '📲',
      ),
      SubCategoryItem(
        id: 'mobile-accessories',
        title: 'Mobile Accessories',
        slug: 'mobile-accessories',
        emoji: '🎧',
      ),
    ],
  );

  static const CategoryGroup homeLiving = CategoryGroup(
    id: 'home_living',
    title: 'Home & Living',
    emoji: '🏠',
    description: 'Furniture, Home Decor & Kitchen Dining',
    icon: Icons.home_rounded,
    subcategories: [
      SubCategoryItem(
        id: 'home-decoration',
        title: 'Home Decoration',
        slug: 'home-decoration',
        emoji: '🏺',
      ),
      SubCategoryItem(
        id: 'furniture',
        title: 'Furniture',
        slug: 'furniture',
        emoji: '🛋️',
      ),
      SubCategoryItem(
        id: 'kitchen-accessories',
        title: 'Kitchen Accessories',
        slug: 'kitchen-accessories',
        emoji: '🍳',
      ),
    ],
  );

  static const CategoryGroup beauty = CategoryGroup(
    id: 'beauty',
    title: 'Beauty & Care',
    emoji: '💄',
    description: 'Cosmetics, Skincare & Fragrances',
    icon: Icons.face_retouching_natural_rounded,
    subcategories: [
      SubCategoryItem(
        id: 'beauty',
        title: 'Beauty & Cosmetics',
        slug: 'beauty',
        emoji: '💄',
      ),
      SubCategoryItem(
        id: 'skin-care',
        title: 'Skin Care',
        slug: 'skin-care',
        emoji: '✨',
      ),
      SubCategoryItem(
        id: 'fragrances',
        title: 'Fragrances & Perfumes',
        slug: 'fragrances',
        emoji: '🌸',
      ),
    ],
  );

  static const CategoryGroup groceries = CategoryGroup(
    id: 'groceries',
    title: 'Food & Groceries',
    emoji: '🛒',
    description: 'Daily Staples, Food & Kitchen Essentials',
    icon: Icons.shopping_basket_rounded,
    subcategories: [
      SubCategoryItem(
        id: 'groceries',
        title: 'Groceries & Essentials',
        slug: 'groceries',
        emoji: '🛒',
      ),
    ],
  );

  static const CategoryGroup sports = CategoryGroup(
    id: 'sports',
    title: 'Sports & Fitness',
    emoji: '🏋️',
    description: 'Sports Gear, Fitness & Outdoors',
    icon: Icons.fitness_center_rounded,
    subcategories: [
      SubCategoryItem(
        id: 'sports-accessories',
        title: 'Sports Accessories',
        slug: 'sports-accessories',
        emoji: '⚽',
      ),
    ],
  );

  static const CategoryGroup footwear = CategoryGroup(
    id: 'footwear',
    title: 'Footwear',
    emoji: '👟',
    description: "Men's & Women's Footwear & Sneakers",
    icon: Icons.directions_walk_rounded,
    subcategories: [
      SubCategoryItem(
        id: 'mens-shoes',
        title: "Men's Shoes",
        slug: 'mens-shoes',
        emoji: '👞',
      ),
      SubCategoryItem(
        id: 'womens-shoes',
        title: "Women's Shoes",
        slug: 'womens-shoes',
        emoji: '👠',
      ),
    ],
  );

  static const CategoryGroup automotive = CategoryGroup(
    id: 'automotive',
    title: 'Automotive & Bikes',
    emoji: '🚗',
    description: 'Vehicles, Motorcycles & Accessories',
    icon: Icons.directions_car_rounded,
    subcategories: [
      SubCategoryItem(
        id: 'vehicle',
        title: 'Vehicles & Cars',
        slug: 'vehicle',
        emoji: '🚗',
      ),
      SubCategoryItem(
        id: 'motorcycle',
        title: 'Motorcycles & Bikes',
        slug: 'motorcycle',
        emoji: '🏍️',
      ),
    ],
  );

  /// All category groups in presentation order
  static const List<CategoryGroup> allGroups = [
    fashion,
    electronics,
    homeLiving,
    beauty,
    groceries,
    sports,
    footwear,
    automotive,
  ];

  /// Find group by ID (e.g. 'fashion', 'electronics')
  static CategoryGroup findById(String id) {
    return allGroups.firstWhere(
      (g) => g.id.toLowerCase() == id.toLowerCase(),
      orElse: () => fashion,
    );
  }

  /// Find group that contains a given subcategory slug
  static CategoryGroup findGroupForSlug(String slug) {
    final cleanSlug = slug.trim().toLowerCase().replaceAll(' ', '-');
    for (final group in allGroups) {
      if (group.id == cleanSlug ||
          group.subcategories.any((s) => s.slug.toLowerCase() == cleanSlug)) {
        return group;
      }
    }
    return fashion;
  }
}
