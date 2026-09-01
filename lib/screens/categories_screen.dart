import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/category_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/network_image_with_skeleton.dart';
import 'product_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = '/categories';

  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ScrollController _categoryScrollController = ScrollController();
  String? _lastScrolledCategory;

  // Sorting state
  String _selectedSort = 'Popular';

  // Filter states (multi-select for all 8 categories)
  final Set<String> _selectedPrices = {};
  final Set<String> _selectedBrands = {};
  final Set<String> _selectedFeatures = {};
  final Set<String> _selectedColors = {};
  final Set<String> _selectedTypes = {};
  final Set<String> _selectedSizes = {};
  final Set<String> _selectedPower = {};
  final Set<String> _selectedGenders = {};

  int get _activeFiltersCount =>
      _selectedPrices.length +
      _selectedBrands.length +
      _selectedFeatures.length +
      _selectedColors.length +
      _selectedTypes.length +
      _selectedSizes.length +
      _selectedPower.length +
      _selectedGenders.length;

  void _clearAllFilters() {
    setState(() {
      _selectedPrices.clear();
      _selectedBrands.clear();
      _selectedFeatures.clear();
      _selectedColors.clear();
      _selectedTypes.clear();
      _selectedSizes.clear();
      _selectedPower.clear();
      _selectedGenders.clear();
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final provider = context.read<CategoryProvider>();
      provider.fetchCategories().then((_) {
        if (mounted && provider.selectedCategory != null) {
          _scrollToSelectedCategory(provider.selectedCategory, provider.categories);
        }
      });
    });
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedCategory(String? selectedCategory, List<String> categories) {
    if (selectedCategory == null || categories.isEmpty) return;

    final selectedIndex = categories.indexOf(selectedCategory);
    if (selectedIndex < 0) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_categoryScrollController.hasClients) return;

      final screenWidth = MediaQuery.of(context).size.width;

      double targetOffset = 0.0;
      for (int i = 0; i < selectedIndex; i++) {
        final tp = TextPainter(
          text: TextSpan(
            text: categories[i],
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        targetOffset += tp.width + 36.0 + 10.0;
      }

      final selectedTp = TextPainter(
        text: TextSpan(
          text: categories[selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final selectedWidth = selectedTp.width + 36.0;

      final centeredOffset = targetOffset - (screenWidth / 2) + (selectedWidth / 2) + 16.0;
      final maxScroll = _categoryScrollController.position.maxScrollExtent;
      final clampedOffset = centeredOffset.clamp(0.0, maxScroll);

      _categoryScrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
  }

  List<Product> _getFilteredAndSortedProducts(List<Product> rawProducts) {
    List<Product> filtered = rawProducts.where((product) {
      // 1. Price Filter
      if (_selectedPrices.isNotEmpty) {
        final p = product.finalPrice;
        bool priceMatch = false;
        for (final range in _selectedPrices) {
          if (range == 'Under \$25' && p < 25) priceMatch = true;
          if (range == '\$25 - \$50' && p >= 25 && p <= 50) priceMatch = true;
          if (range == '\$50 - \$100' && p >= 50 && p <= 100) priceMatch = true;
          if (range == '\$100 - \$300' && p >= 100 && p <= 300) priceMatch = true;
          if (range == '\$300 - \$700' && p >= 300 && p <= 700) priceMatch = true;
          if (range == 'Above \$700' && p > 700) priceMatch = true;
        }
        if (!priceMatch) return false;
      }

      // 2. Brand Filter
      if (_selectedBrands.isNotEmpty) {
        final brand = (product.brand ?? '').toLowerCase();
        final title = product.title.toLowerCase();
        bool brandMatch = _selectedBrands.any((b) {
          final lb = b.toLowerCase();
          return (brand.isNotEmpty && brand.contains(lb)) || title.contains(lb);
        });
        if (!brandMatch) return false;
      }

      // 3. Variant Features Filter
      if (_selectedFeatures.isNotEmpty) {
        for (final feat in _selectedFeatures) {
          if (feat == '4★ & Above' && (product.rating == null || product.rating! < 4.0)) return false;
          if (feat == 'Top Rated (4.5★+)' && (product.rating == null || product.rating! < 4.5)) return false;
          if (feat == 'In Stock' && (product.stock != null && product.stock! <= 0)) return false;
          if (feat == 'High Discount (15%+ OFF)' && product.discountPercentage < 15) return false;
          if (feat == 'Wireless / Bluetooth') {
            final text = '${product.title} ${product.description}'.toLowerCase();
            if (!text.contains('wireless') && !text.contains('bluetooth')) return false;
          }
          if (feat == 'Premium Quality') {
            final text = '${product.title} ${product.description}'.toLowerCase();
            if (!text.contains('premium') && (product.rating == null || product.rating! < 4.2)) return false;
          }
        }
      }

      // 4. Color Filter
      if (_selectedColors.isNotEmpty) {
        final text = '${product.title} ${product.description}'.toLowerCase();
        bool colorMatch = _selectedColors.any((c) {
          final lc = c.toLowerCase().split(' ').first;
          return text.contains(lc);
        });
        if (!colorMatch) return false;
      }

      // 5. Type Filter
      if (_selectedTypes.isNotEmpty) {
        final text = '${product.title} ${product.description} ${product.category ?? ''}'.toLowerCase();
        bool typeMatch = _selectedTypes.any((t) {
          final lt = t.toLowerCase().split(' ').first;
          return text.contains(lt);
        });
        if (!typeMatch) return false;
      }

      // 6. Size Filter
      if (_selectedSizes.isNotEmpty) {
        final text = '${product.title} ${product.description}'.toLowerCase();
        bool sizeMatch = _selectedSizes.any((s) {
          final ls = s.toLowerCase();
          return text.contains(ls);
        });
        if (!sizeMatch) return false;
      }

      // 7. Power Consumption Filter
      if (_selectedPower.isNotEmpty) {
        final text = '${product.title} ${product.description}'.toLowerCase();
        bool powerMatch = _selectedPower.any((pw) {
          final lpw = pw.toLowerCase();
          if (lpw.contains('battery') && text.contains('battery')) return true;
          if (lpw.contains('eco') && (text.contains('eco') || text.contains('energy'))) return true;
          if (lpw.contains('low') && (text.contains('low') || text.contains('efficient'))) return true;
          if (lpw.contains('high') && (text.contains('pro') || text.contains('high') || text.contains('gaming'))) return true;
          return text.contains(lpw);
        });
        if (!powerMatch) return false;
      }

      // 8. Gender Filter
      if (_selectedGenders.isNotEmpty) {
        final text = '${product.title} ${product.description} ${product.category ?? ''}'.toLowerCase();
        bool genderMatch = _selectedGenders.any((g) {
          final lg = g.toLowerCase();
          if (lg == 'men' && (text.contains('men') || text.contains('male') || text.contains('man'))) return true;
          if (lg == 'women' && (text.contains('women') || text.contains('female') || text.contains('lady'))) return true;
          if (lg == 'unisex' && (text.contains('unisex') || (!text.contains('men') && !text.contains('women')))) return true;
          if (lg == 'kids' && (text.contains('kid') || text.contains('child') || text.contains('baby') || text.contains('boy') || text.contains('girl'))) return true;
          return text.contains(lg);
        });
        if (!genderMatch) return false;
      }

      return true;
    }).toList();

    // Apply Sorting
    switch (_selectedSort) {
      case 'Discount':
        filtered.sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
        break;
      case 'High Price':
        filtered.sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
        break;
      case 'Low Price':
        filtered.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
        break;
      case 'Popular':
      default:
        filtered.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
    }

    return filtered;
  }

  void _showSortBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sortOptions = [
      'Popular',
      'Discount',
      'High Price',
      'Low Price',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top drag pill
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sort by',
                      style: AppTextStyles.screenHeading(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                      ).copyWith(fontSize: 18),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ),

              Divider(
                height: 1,
                thickness: 1,
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),

              // Centered & properly spaced sort options separated by lines
              ...sortOptions.map((option) {
                final isSelected = _selectedSort == option;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedSort = option;
                        });
                        Navigator.of(ctx).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option,
                                style: AppTextStyles.cardTitle(
                                  color: isSelected
                                      ? (isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown)
                                      : (isDark ? AppColors.darkTextSecondary : AppColors.textPrimary),
                                ).copyWith(
                                  fontSize: 15,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                                size: 22,
                              )
                            else
                              Icon(
                                Icons.radio_button_unchecked_rounded,
                                color: isDark ? AppColors.darkBorder : AppColors.border,
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ],
                );
              }),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context, List<Product> products) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tempPrices = Set<String>.from(_selectedPrices);
    final tempBrands = Set<String>.from(_selectedBrands);
    final tempFeatures = Set<String>.from(_selectedFeatures);
    final tempColors = Set<String>.from(_selectedColors);
    final tempTypes = Set<String>.from(_selectedTypes);
    final tempSizes = Set<String>.from(_selectedSizes);
    final tempPower = Set<String>.from(_selectedPower);
    final tempGenders = Set<String>.from(_selectedGenders);

    final dynamicBrands = products
        .map((p) => p.brand?.trim())
        .where((b) => b != null && b.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    dynamicBrands.sort();

    final filterCategories = [
      'Price',
      'Brand',
      'Variant Features',
      'Color',
      'Type',
      'Size',
      'Power Consumption',
      'Gender',
    ];

    final priceOptions = [
      'Under \$25',
      '\$25 - \$50',
      '\$50 - \$100',
      '\$100 - \$300',
      '\$300 - \$700',
      'Above \$700',
    ];

    final brandOptions = dynamicBrands.isNotEmpty
        ? dynamicBrands
        : ['Apple', 'Samsung', 'Dell', 'HP', 'Lenovo', 'Asus', 'Sony', 'Nike', 'Adidas', 'Zara'];

    final featureOptions = [
      '4★ & Above',
      'Top Rated (4.5★+)',
      'In Stock',
      'High Discount (15%+ OFF)',
      'Wireless / Bluetooth',
      'Premium Quality',
    ];

    final colorOptions = [
      'Black',
      'White',
      'Silver',
      'Grey',
      'Blue',
      'Red',
      'Gold',
      'Green',
      'Pink',
    ];

    final typeOptions = [
      'Standard',
      'Professional',
      'Casual',
      'Gaming',
      'Compact',
      'Organic',
    ];

    final sizeOptions = [
      'Small',
      'Medium',
      'Large',
      'Extra Large (XL)',
      '13" - 14"',
      '15" - 16"',
      '128GB / 256GB',
      '512GB / 1TB',
    ];

    final powerOptions = [
      'Low Power (< 30W)',
      'Standard (30W - 65W)',
      'High Performance (65W+)',
      'Energy Star / Eco',
      'Battery Operated',
    ];

    final genderOptions = [
      'Men',
      'Women',
      'Unisex',
      'Kids',
    ];

    int selectedCategoryIndex = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF18181B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            int getCategorySelectionCount(String cat) {
              switch (cat) {
                case 'Price':
                  return tempPrices.length;
                case 'Brand':
                  return tempBrands.length;
                case 'Variant Features':
                  return tempFeatures.length;
                case 'Color':
                  return tempColors.length;
                case 'Type':
                  return tempTypes.length;
                case 'Size':
                  return tempSizes.length;
                case 'Power Consumption':
                  return tempPower.length;
                case 'Gender':
                  return tempGenders.length;
                default:
                  return 0;
              }
            }

            List<String> currentOptions = [];
            Set<String> targetSet = tempPrices;

            switch (filterCategories[selectedCategoryIndex]) {
              case 'Price':
                currentOptions = priceOptions;
                targetSet = tempPrices;
                break;
              case 'Brand':
                currentOptions = brandOptions;
                targetSet = tempBrands;
                break;
              case 'Variant Features':
                currentOptions = featureOptions;
                targetSet = tempFeatures;
                break;
              case 'Color':
                currentOptions = colorOptions;
                targetSet = tempColors;
                break;
              case 'Type':
                currentOptions = typeOptions;
                targetSet = tempTypes;
                break;
              case 'Size':
                currentOptions = sizeOptions;
                targetSet = tempSizes;
                break;
              case 'Power Consumption':
                currentOptions = powerOptions;
                targetSet = tempPower;
                break;
              case 'Gender':
                currentOptions = genderOptions;
                targetSet = tempGenders;
                break;
            }

            final totalTempCount = tempPrices.length +
                tempBrands.length +
                tempFeatures.length +
                tempColors.length +
                tempTypes.length +
                tempSizes.length +
                tempPower.length +
                tempGenders.length;

            return Container(
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Top Drag Handle
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 4),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header with Title and Clear Filter Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Filters',
                              style: AppTextStyles.screenHeading(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                              ).copyWith(fontSize: 18),
                            ),
                            if (totalTempCount > 0) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBrown,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$totalTempCount',
                                  style: GoogleFonts.fraunces(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.cardBackground,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempPrices.clear();
                              tempBrands.clear();
                              tempFeatures.clear();
                              tempColors.clear();
                              tempTypes.clear();
                              tempSizes.clear();
                              tempPower.clear();
                              tempGenders.clear();
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          ),
                          child: Text(
                            'Clear Filter',
                            style: AppTextStyles.buttonText(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                            ).copyWith(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),

                  // Two-Pane Content: Left Categories, Right Values
                  Expanded(
                    child: Row(
                      children: [
                        // Left Column: Filter Categories
                        Container(
                          width: 140,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.beigeSurface.withValues(alpha: 0.45),
                            border: Border(
                              right: BorderSide(
                                color: isDark ? AppColors.darkBorder : AppColors.border,
                                width: 1,
                              ),
                            ),
                          ),
                          child: ListView.builder(
                            itemCount: filterCategories.length,
                            itemBuilder: (context, index) {
                              final cat = filterCategories[index];
                              final isSelected = selectedCategoryIndex == index;
                              final count = getCategorySelectionCount(cat);

                              return InkWell(
                                onTap: () {
                                  setModalState(() {
                                    selectedCategoryIndex = index;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (isDark ? AppColors.darkCard : AppColors.cardBackground)
                                        : Colors.transparent,
                                    border: isSelected
                                        ? const Border(
                                            left: BorderSide(
                                              color: AppColors.primaryBrown,
                                              width: 3.5,
                                            ),
                                          )
                                        : null,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          cat,
                                          style: AppTextStyles.caption(
                                            color: isSelected
                                                ? (isDark ? AppColors.darkTextPrimary : AppColors.deepBrown)
                                                : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                                          ).copyWith(
                                            fontSize: 13,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      if (count > 0)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryBrown.withValues(alpha: 0.18),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '$count',
                                            style: GoogleFonts.fraunces(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Right Column: Multi-select Options for selected category
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            itemCount: currentOptions.length,
                            separatorBuilder: (context, index) => Divider(
                              height: 1,
                              thickness: 1,
                              color: isDark ? AppColors.darkBorder : AppColors.border,
                            ),
                            itemBuilder: (context, index) {
                              final option = currentOptions[index];
                              final isChecked = targetSet.contains(option);

                              return CheckboxListTile(
                                value: isChecked,
                                activeColor: AppColors.primaryBrown,
                                checkColor: AppColors.cardBackground,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                dense: true,
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text(
                                  option,
                                  style: AppTextStyles.body(
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                  ).copyWith(
                                    fontSize: 13.5,
                                    fontWeight: isChecked ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                                onChanged: (bool? val) {
                                  setModalState(() {
                                    if (val == true) {
                                      targetSet.add(option);
                                    } else {
                                      targetSet.remove(option);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),

                  // Bottom Action Buttons: Close and Apply Filter
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          // Close Button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: isDark ? AppColors.darkBorder : AppColors.border,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 13),
                              ),
                              child: Text(
                                'Close',
                                style: AppTextStyles.buttonText(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                ).copyWith(fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Apply Filter Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedPrices.clear();
                                  _selectedPrices.addAll(tempPrices);

                                  _selectedBrands.clear();
                                  _selectedBrands.addAll(tempBrands);

                                  _selectedFeatures.clear();
                                  _selectedFeatures.addAll(tempFeatures);

                                  _selectedColors.clear();
                                  _selectedColors.addAll(tempColors);

                                  _selectedTypes.clear();
                                  _selectedTypes.addAll(tempTypes);

                                  _selectedSizes.clear();
                                  _selectedSizes.addAll(tempSizes);

                                  _selectedPower.clear();
                                  _selectedPower.addAll(tempPower);

                                  _selectedGenders.clear();
                                  _selectedGenders.addAll(tempGenders);
                                });
                                Navigator.of(ctx).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBrown,
                                foregroundColor: AppColors.cardBackground,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 13),
                              ),
                              child: Text(
                                totalTempCount > 0 ? 'Apply ($totalTempCount)' : 'Apply Filter',
                                style: AppTextStyles.buttonText(
                                  color: AppColors.cardBackground,
                                ).copyWith(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomSortFilterBar(BuildContext context, List<Product> products) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              // SORT BUTTON
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showSortBottomSheet(context),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.swap_vert_rounded,
                            size: 20,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _selectedSort == 'Popular' ? 'Sort' : 'Sort: $_selectedSort',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.buttonText(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                            ).copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Vertical divider line
              Container(
                width: 1,
                height: 28,
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),

              // FILTER BUTTON
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showFilterBottomSheet(context, products),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.filter_list_rounded,
                            size: 20,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Filter',
                            style: AppTextStyles.buttonText(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                            ).copyWith(fontSize: 14),
                          ),
                          if (_activeFiltersCount > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBrown,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$_activeFiltersCount',
                                style: GoogleFonts.fraunces(
                                  color: AppColors.cardBackground,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        final rawProducts = provider.products;
        final displayedProducts = _getFilteredAndSortedProducts(rawProducts);

        final shouldShowBottomBar = provider.categoriesStatus == CategoryStatus.loaded &&
            provider.productsStatus != CategoryStatus.loading &&
            rawProducts.isNotEmpty;

        return Scaffold(
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.darkCard : AppColors.mainBackground,
            foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Categories',
              style: AppTextStyles.screenHeading(
                color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
              ),
            ),
            centerTitle: true,
          ),
          bottomNavigationBar: shouldShowBottomBar
              ? _buildBottomSortFilterBar(context, rawProducts)
              : null,
          body: SafeArea(
            child: () {
              if (provider.categoriesStatus == CategoryStatus.loading &&
                  provider.categories.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: AppColors.primaryBrown),
                      const SizedBox(height: 12),
                      Text(
                        'Loading categories...',
                        style: AppTextStyles.caption(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (provider.categoriesStatus == CategoryStatus.error) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          provider.errorMessage,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: provider.fetchCategories,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBrown,
                            foregroundColor: AppColors.cardBackground,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (provider.categories.isEmpty) {
                return Center(
                  child: Text(
                    'No categories available.',
                    style: AppTextStyles.body(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                    ),
                  ),
                );
              }

              // Trigger auto-scroll whenever selectedCategory updates
              if (provider.selectedCategory != null &&
                  _lastScrolledCategory != provider.selectedCategory) {
                _lastScrolledCategory = provider.selectedCategory;
                _scrollToSelectedCategory(provider.selectedCategory, provider.categories);
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),

                    // ALL CATEGORIES HORIZONTAL SCROLLABLE LIST WITH AUTO-SCROLL
                    SizedBox(
                      height: 46,
                      child: ListView.separated(
                        controller: _categoryScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.categories.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final category = provider.categories[index];
                          final isSelected = provider.selectedCategory == category;

                          return GestureDetector(
                            onTap: () {
                              _clearAllFilters();
                              provider.fetchProductsByCategory(category);
                              _scrollToSelectedCategory(category, provider.categories);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryBrown
                                    : (isDark ? AppColors.darkCard : AppColors.cardBackground),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryBrown
                                      : (isDark ? AppColors.darkBorder : AppColors.border),
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Text(
                                  category,
                                  style: AppTextStyles.caption(
                                    color: isSelected
                                        ? AppColors.cardBackground
                                        : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                                  ).copyWith(
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // PRODUCTS
                    Expanded(
                      child: _buildCategoryProducts(
                        context,
                        provider,
                        displayedProducts,
                      ),
                    ),
                  ],
                ),
              );
            }(),
          ),
        );
      },
    );
  }

  Widget _buildCategoryProducts(
    BuildContext context,
    CategoryProvider provider,
    List<Product> displayedProducts,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (provider.selectedCategory == null &&
        provider.productsStatus == CategoryStatus.initial) {
      return Center(
        child: Text(
          'Choose a category to view products.',
          style: AppTextStyles.body(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
          ),
        ),
      );
    }

    if (provider.productsStatus == CategoryStatus.loading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.primaryBrown),
            const SizedBox(height: 12),
            Text(
              'Loading products...',
              style: AppTextStyles.caption(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (provider.productsStatus == CategoryStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
              ),
              const SizedBox(height: 12),
              Text(
                provider.errorMessage,
                textAlign: TextAlign.center,
                style: AppTextStyles.body(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => provider.fetchProductsByCategory(
                  provider.selectedCategory ?? '',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBrown,
                  foregroundColor: AppColors.cardBackground,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.products.isEmpty) {
      return Center(
        child: Text(
          'No products found for this category.',
          style: AppTextStyles.body(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
          ),
        ),
      );
    }

    if (displayedProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt_off_rounded,
              size: 48,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              'No products match your selected filters.',
              textAlign: TextAlign.center,
              style: AppTextStyles.cardTitle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _clearAllFilters,
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryBrown,
      onRefresh: () async {
        if (provider.selectedCategory != null) {
          await provider.fetchProductsByCategory(
            provider.selectedCategory!,
          );
        }
      },
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.66,
        ),
        itemCount: displayedProducts.length,
        itemBuilder: (context, index) {
          final product = displayedProducts[index];

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: product),
                    settings: RouteSettings(
                      name: ProductDetailScreen.routeName,
                      arguments: product,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                        child: NetworkImageWithSkeleton(
                          imageUrl: product.thumbnail,
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(12),
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 120,
                              color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 32,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Product Name
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ).copyWith(fontSize: 13.5, height: 1.2),
                    ),

                    const SizedBox(height: 3),

                    // Product Description
                    Expanded(
                      child: Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ).copyWith(fontSize: 11, height: 1.2),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Pricing Section
                    if (product.discountPercentage > 0)
                      Row(
                        children: [
                          Text(
                            '\$${product.originalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 10.5,
                              decoration: TextDecoration.lineThrough,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: isDark ? 0.25 : 0.12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                              style: TextStyle(
                                fontSize: 9.5,
                                color: isDark ? Colors.green.shade400 : AppColors.success,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 4),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${product.finalPrice.toStringAsFixed(2)}',
                          style: GoogleFonts.fraunces(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 10,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}