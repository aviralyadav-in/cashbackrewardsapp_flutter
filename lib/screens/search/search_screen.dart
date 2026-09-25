import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/brand_model.dart';
import '../../models/universal_search_models.dart';
import '../../providers/search_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/network_image_with_skeleton.dart';
import '../categories/all_categories_screen.dart';
import '../products/product_comparison_screen.dart';
import '../products/product_detail_screen.dart';
import '../products/shopping_confirmation_screen.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final provider = context.read<SearchProvider>();
    if (provider.query.isNotEmpty) {
      _searchController.text = provider.query;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        context.read<SearchProvider>().search(value);
      }
    });
  }

  void _onQuerySubmitted(String value) {
    _debounce?.cancel();
    context.read<SearchProvider>().search(value);
  }

  void _setQuery(String query) {
    _searchController.text = query;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    _debounce?.cancel();
    context.read<SearchProvider>().search(query);
  }

  void _showCouponDialog(BuildContext context, SearchCouponItem coupon, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
        final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
        final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                coupon.store,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                coupon.discount,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                coupon.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: textMuted,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1C2D5A) : const Color(0xFFFAF2E7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF6B4D36) : const Color(0xFFDCC8B3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      coupon.code,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: coupon.code));
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Coupon ${coupon.code} copied!'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: AppColors.primaryBrown,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'COPY',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${coupon.validity} • Min Order: ₹${coupon.minOrder.toInt()}',
                style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: textMuted),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _onStoreTap(SearchStoreItem store) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShoppingConfirmationScreen(
          brand: BrandModel(
            name: store.name,
            logoUrl: store.logoUrl,
            bannerUrl: '',
            cashbackPercentage: store.cashbackRate,
            category: store.category.isNotEmpty ? store.category : 'Shopping',
            offerText: store.cashbackRate,
            websiteUrl: store.websiteUrl.isNotEmpty
                ? store.websiteUrl
                : ProductDetailScreen.resolveStoreUrl(store.name),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.mainBackground,
        foregroundColor: textDark,
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
          'Search',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. UNIVERSAL SEARCH INPUT BAR
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            color: isDark ? AppColors.darkCard : AppColors.mainBackground,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
                cursorColor: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                decoration: InputDecoration(
                  hintText: 'Search products, stores, categories, offers...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                  ),
                  isDense: true,
                  filled: false,
                  fillColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                    size: 22,
                  ),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (context, value, child) {
                      if (value.text.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        color: textMuted,
                        onPressed: () {
                          _searchController.clear();
                          context.read<SearchProvider>().clearSearch();
                        },
                      );
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                onChanged: _onSearchChanged,
                onSubmitted: _onQuerySubmitted,
              ),
            ),
          ),

          // 2. FILTER PILLS (All | Products | Stores | Categories | Offers | Coupons)
          Consumer<SearchProvider>(
            builder: (context, provider, _) {
              return Container(
                height: 42,
                margin: const EdgeInsets.only(bottom: 6),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: UniversalSearchType.values.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final type = UniversalSearchType.values[index];
                    final isSelected = provider.activeFilter == type;

                    return GestureDetector(
                      onTap: () => provider.selectFilter(type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? AppColors.darkPrimary : AppColors.primaryBrown)
                              : (isDark ? const Color(0xFF132247) : const Color(0xFFF3ECE4)),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0)),
                            width: 0.8,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            type.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.darkTextSecondary : AppColors.deepBrown),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          Divider(
            height: 1,
            color: isDark ? const Color(0xFF382A20) : const Color(0xFFEDE3D5),
          ),

          // 3. BODY: Recent Searches / Results / Empty State
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, provider, child) {
                switch (provider.status) {
                  case SearchStatus.loading:
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(color: AppColors.primaryBrown),
                          const SizedBox(height: 12),
                          Text(
                            'Searching products, stores & coupons...',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: textMuted,
                            ),
                          ),
                        ],
                      ),
                    );

                  case SearchStatus.error:
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                            const SizedBox(height: 12),
                            Text(
                              provider.errorMessage,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: textMuted),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => provider.search(provider.query),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBrown,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );

                  case SearchStatus.loaded:
                    if (provider.universalResult.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 54,
                                color: textMuted.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No matching results found.',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Try checking your spelling or searching another brand, store, or coupon keyword.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: textMuted),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return _buildCategorizedResults(context, provider.universalResult, isDark, textDark, textMuted);

                  case SearchStatus.initial:
                    return _buildZeroStateSuggestions(context, provider, isDark, textDark, textMuted);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // ZERO-STATE: RECENT SEARCHES + POPULAR SEARCHES
  // =========================================================================

  Widget _buildZeroStateSuggestions(
    BuildContext context,
    SearchProvider provider,
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Recent Searches Header
        if (provider.recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              InkWell(
                onTap: () => provider.clearRecentSearches(),
                child: Text(
                  'Clear all',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Recent Searches List
          ...provider.recentSearches.map((item) {
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.history_rounded, size: 18, color: textMuted),
              title: Text(
                item,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close_rounded, size: 16),
                color: textMuted,
                onPressed: () => provider.removeRecentSearch(item),
              ),
              onTap: () => _setQuery(item),
            );
          }),
          const SizedBox(height: 20),
        ],

        // Popular Searches Header
        Text(
          'Popular Searches',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        const SizedBox(height: 10),

        // Popular Searches Wrap
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: provider.popularSearches.map((query) {
            return ActionChip(
              label: Text(
                query,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF382316),
                ),
              ),
              backgroundColor: isDark ? const Color(0xFF132247) : const Color(0xFFF6EDE3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
                  width: 0.8,
                ),
              ),
              onPressed: () => _setQuery(query),
            );
          }).toList(),
        ),
      ],
    );
  }

  // =========================================================================
  // CATEGORIZED UNIVERSAL RESULTS LIST
  // =========================================================================

  Widget _buildCategorizedResults(
    BuildContext context,
    UniversalSearchResult result,
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        // 1. PRODUCTS SECTION
        if (result.products.isNotEmpty) ...[
          _buildSectionHeader('🛍️ Products (${result.products.length})', textDark),
          ...result.products.map((product) {
            return _buildProductResultCard(context, product, isDark, textDark, textMuted);
          }),
          const SizedBox(height: 16),
        ],

        // 2. STORES SECTION
        if (result.stores.isNotEmpty) ...[
          _buildSectionHeader('🏬 Stores (${result.stores.length})', textDark),
          ...result.stores.map((store) {
            return _buildStoreResultCard(context, store, isDark, textDark, textMuted);
          }),
          const SizedBox(height: 16),
        ],

        // 3. CATEGORIES SECTION
        if (result.categories.isNotEmpty) ...[
          _buildSectionHeader('🏷️ Categories (${result.categories.length})', textDark),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: result.categories.map((cat) {
                return ActionChip(
                  avatar: const Icon(Icons.grid_view_rounded, size: 16, color: AppColors.primaryBrown),
                  label: Text(
                    cat.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                  backgroundColor: isDark ? const Color(0xFF281D16) : const Color(0xFFF1F5F9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AllCategoriesScreen.routeName);
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 4. OFFERS SECTION
        if (result.offers.isNotEmpty) ...[
          _buildSectionHeader('🔥 Offers (${result.offers.length})', textDark),
          ...result.offers.map((offer) {
            return _buildOfferResultCard(context, offer, isDark, textDark, textMuted);
          }),
          const SizedBox(height: 16),
        ],

        // 5. COUPONS SECTION
        if (result.coupons.isNotEmpty) ...[
          _buildSectionHeader('🎟️ Coupons (${result.coupons.length})', textDark),
          ...result.coupons.map((coupon) {
            return _buildCouponResultCard(context, coupon, isDark, textDark, textMuted);
          }),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, Color textDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
      ),
    );
  }

  // --- 1. PRODUCT CARD ---
  Widget _buildProductResultCard(
    BuildContext context,
    SearchProductItem product,
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: NetworkImageWithSkeleton(
              imageUrl: product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.badge,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Available: ${product.availableAt.join(", ")}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '₹${product.bestEffectivePrice.toInt()}',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: AppColors.successBackground,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '+₹${product.cashbackAmount.toInt()} Cashback',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProductComparisonScreen.fromSearchProduct(product),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Compare Deals',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. STORE CARD ---
  Widget _buildStoreResultCard(
    BuildContext context,
    SearchStoreItem store,
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: NetworkImageWithSkeleton(
              imageUrl: store.logoUrl,
              width: 44,
              height: 44,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.name,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
                Text(
                  'Cashback: ${store.cashbackRate} • ${store.availableOffers} Offers • ${store.availableCoupons} Coupons',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _onStoreTap(store),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              visualDensity: VisualDensity.compact,
              elevation: 0,
            ),
            child: Text(
              'View Store',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. OFFER CARD ---
  Widget _buildOfferResultCard(
    BuildContext context,
    SearchOfferItem offer,
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.store.toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  offer.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.successBackground,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        offer.discount,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      offer.cashback,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShoppingConfirmationScreen(
                    brand: BrandModel(
                      name: offer.store,
                      logoUrl: '',
                      bannerUrl: '',
                      cashbackPercentage: offer.cashback,
                      category: offer.category.isNotEmpty ? offer.category : 'Shopping',
                      offerText: offer.cashback,
                      websiteUrl: ProductDetailScreen.resolveStoreUrl(offer.store),
                    ),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              visualDensity: VisualDensity.compact,
              elevation: 0,
            ),
            child: Text(
              offer.ctaText,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. COUPON CARD ---
  Widget _buildCouponResultCard(
    BuildContext context,
    SearchCouponItem coupon,
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      coupon.discount,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1C2D5A) : const Color(0xFFF4ECE3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        coupon.store,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Min purchase: ₹${coupon.minOrder.toInt()} • ${coupon.validity}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => _showCouponDialog(context, coupon, isDark),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
              side: BorderSide(
                color: isDark ? const Color(0xFF5A4435) : const Color(0xFFE2E8F0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              visualDensity: VisualDensity.compact,
            ),
            child: Text(
              'View Coupon',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
