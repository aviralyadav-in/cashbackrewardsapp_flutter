import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/home_mock_data.dart';
import '../../models/brand_model.dart';
import '../../models/home_discovery_models.dart';
import '../../providers/home_provider.dart';
import '../../services/brand_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/network_image_with_skeleton.dart';
import '../products/product_detail_screen.dart';
import 'store_detail_screen.dart';

class AllStoresScreen extends StatefulWidget {
  static const String routeName = '/all-stores';

  final List<FeaturedStoreModel>? initialStores;
  final List<BrandModel>? initialBrands;
  final String? title;
  final bool? showCategoryFilter;

  const AllStoresScreen({
    super.key,
    this.initialStores,
    this.initialBrands,
    this.title,
    this.showCategoryFilter,
  });

  @override
  State<AllStoresScreen> createState() => _AllStoresScreenState();
}

class _AllStoresScreenState extends State<AllStoresScreen> {
  final TextEditingController _searchController = TextEditingController();
  final BrandService _brandService = BrandService();

  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<BrandModel> _loadedBrands = [];
  bool _isLoading = true;

  static const List<String> _categories = [
    'All',
    'Popular',
    'Fashion',
    'Electronics',
    'Beauty',
    'Shopping',
    'Health',
  ];

  @override
  void initState() {
    super.initState();
    _loadAllStores();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllStores() async {
    try {
      final brandsFromService = await _brandService.loadBrands();
      if (mounted) {
        setState(() {
          _loadedBrands = brandsFromService;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loadedBrands = HomeMockData.popularBrandsCatalog;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final homeProvider = context.watch<HomeProvider>();

    final showCategoryFilter = widget.showCategoryFilter ?? (widget.initialBrands == null);

    final List<BrandModel> allStores;
    if (widget.initialBrands != null) {
      allStores = widget.initialBrands!;
    } else {
      // Merge featured stores from HomeProvider with brands catalog
      final featuredStores = widget.initialStores ?? homeProvider.featuredStores;
      final Map<String, BrandModel> storesMap = {};

      // 1. Add featured stores first
      for (final fs in featuredStores) {
        storesMap[fs.name.toLowerCase()] = BrandModel(
          name: fs.name,
          logoUrl: fs.logoUrl,
          bannerUrl: '',
          cashbackPercentage: fs.cashbackRate,
          category: 'Popular',
          offerText: '${fs.totalOffers} Offers • ${fs.totalCoupons} Coupons',
          websiteUrl: fs.websiteUrl.isNotEmpty
              ? fs.websiteUrl
              : ProductDetailScreen.resolveStoreUrl(fs.name),
        );
      }

      // 2. Add loaded brands from JSON
      for (final b in _loadedBrands) {
        final key = b.name.toLowerCase();
        if (!storesMap.containsKey(key)) {
          storesMap[key] = b;
        }
      }

      // 3. Add catalog brands from mock data
      for (final b in HomeMockData.popularBrandsCatalog) {
        final key = b.name.toLowerCase();
        if (!storesMap.containsKey(key)) {
          storesMap[key] = b;
        }
      }

      allStores = storesMap.values.toList();
    }

    // Filter stores
    final filteredStores = allStores.where((s) {
      final matchesCategory = !showCategoryFilter ||
          _selectedCategory == 'All' ||
          s.category.toLowerCase().contains(_selectedCategory.toLowerCase()) ||
          (_selectedCategory == 'Fashion' &&
              (s.name.toLowerCase().contains('myntra') ||
                  s.name.toLowerCase().contains('ajio') ||
                  s.name.toLowerCase().contains('nike') ||
                  s.name.toLowerCase().contains('zara'))) ||
          (_selectedCategory == 'Electronics' &&
              (s.name.toLowerCase().contains('amazon') ||
                  s.name.toLowerCase().contains('flipkart') ||
                  s.name.toLowerCase().contains('reliance') ||
                  s.name.toLowerCase().contains('croma'))) ||
          (_selectedCategory == 'Beauty' &&
              (s.name.toLowerCase().contains('nykaa') ||
                  s.name.toLowerCase().contains('dot') ||
                  s.name.toLowerCase().contains('caffeine') ||
                  s.name.toLowerCase().contains('derma') ||
                  s.name.toLowerCase().contains('aqualogica') ||
                  s.name.toLowerCase().contains('foxtale')));

      final q = _searchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          s.name.toLowerCase().contains(q) ||
          s.category.toLowerCase().contains(q) ||
          s.cashbackPercentage.toLowerCase().contains(q) ||
          s.offerText.toLowerCase().contains(q);

      return matchesCategory && matchesQuery;
    }).toList();

    final bgColor = isDark ? AppColors.darkBackground : AppColors.mainBackground;
    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textDark = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final primaryAccent = isDark ? AppColors.darkPrimary : AppColors.accentBlue;

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
              widget.title ?? 'All Partner Stores',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
            Text(
              '${filteredStores.length} Verified Stores with Cashback',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: textMuted,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input Field
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              color: isDark ? AppColors.darkCard : AppColors.mainBackground,
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    color: textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search 50+ stores, brands, or deals...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: textMuted,
                    ),
                    prefixIcon: Icon(Icons.search_rounded, color: primaryAccent, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.close_rounded, color: textMuted, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ),

            // Category Filter Pills (Only shown when showCategoryFilter is true)
            if (showCategoryFilter)
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryAccent
                            : (isDark ? AppColors.darkSurface : AppColors.surfaceSubtle),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? primaryAccent
                              : borderColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          cat,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 4),

            // Stores Grid
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryAccent),
                      ),
                    )
                  : filteredStores.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.storefront_outlined,
                                size: 54,
                                color: textMuted.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No stores found for "$_searchQuery"',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Try clearing your search or selecting "All"',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.72,
                          ),
                          itemCount: filteredStores.length,
                          itemBuilder: (context, index) {
                            final store = filteredStores[index];
                            return _buildStoreCard(
                              context,
                              store,
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
      ),
    );
  }

  Widget _buildStoreCard(
    BuildContext context,
    BrandModel store,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color textDark,
    Color textMuted,
    Color primaryAccent,
  ) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => StoreDetailScreen(brand: store),
              ),
            );
          },
          child: Column(
            children: [
              // Upper half
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildStoreLogo(store.logoUrl, store.name, isDark),
                      ),
                    ),
                  ),
                ),
              ),

              // Lower half
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Category or Offer Text
                      Text(
                        store.offerText.isNotEmpty ? store.offerText : store.category,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: primaryAccent,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),

                      const Spacer(),

                      // Cashback Rate Pill
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: borderColor,
                          ),
                        ),
                        child: Text(
                          store.cashbackPercentage,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: primaryAccent,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // "Shop Now" Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 28,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryAccent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => StoreDetailScreen(brand: store),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Shop & Earn',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 3),
                              const Icon(Icons.arrow_forward_rounded, size: 11),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreLogo(String logoUrl, String name, bool isDark) {
    if (logoUrl.startsWith('http://') || logoUrl.startsWith('https://')) {
      return NetworkImageWithSkeleton(
        imageUrl: logoUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            _buildFallbackInitial(name, isDark),
      );
    } else if (logoUrl.startsWith('assets/')) {
      return Image.asset(
        logoUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            _buildFallbackInitial(name, isDark),
      );
    }
    return _buildFallbackInitial(name, isDark);
  }

  Widget _buildFallbackInitial(String name, bool isDark) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'S';
    return Container(
      color: isDark ? AppColors.darkSurface : AppColors.surfaceSubtle,
      child: Center(
        child: Text(
          initial,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
          ),
        ),
      ),
    );
  }
}
