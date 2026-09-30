import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/brand_model.dart';
import '../../models/home_discovery_models.dart';
import '../../models/universal_search_models.dart';
import '../../services/category_shopping_service.dart';
import '../../services/search_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/network_image_with_skeleton.dart';
import 'product_detail_screen.dart';
import 'shopping_confirmation_screen.dart';

class ProductComparisonScreen extends StatefulWidget {
  static const String routeName = '/product-comparison';

  final String? productId;
  final String? initialTitle;
  final String? initialBrand;
  final String? initialImageUrl;
  final ProductComparisonData? comparisonData;

  const ProductComparisonScreen({
    super.key,
    this.productId,
    this.initialTitle,
    this.initialBrand,
    this.initialImageUrl,
    this.comparisonData,
  });

  factory ProductComparisonScreen.fromBestDeal(BestDealModel deal) {
    final stores = deal.stores.isNotEmpty
        ? deal.stores.map((s) {
            return StoreComparisonDetail(
              store: s.store,
              price: s.price,
              storeDiscount: s.storeDiscount,
              cashback: s.cashback,
              coupon: s.coupon,
              effectivePrice: s.effectivePrice,
              savings: s.savings,
              isBest: s.isBest,
            );
          }).toList()
        : [
            StoreComparisonDetail(
              store: deal.store,
              price: deal.discountedPrice > 0 ? deal.discountedPrice : deal.originalPrice,
              storeDiscount: deal.originalPrice > deal.discountedPrice
                  ? deal.originalPrice - deal.discountedPrice
                  : 0,
              cashback: deal.cashbackAmount,
              coupon: deal.couponDiscount,
              effectivePrice: deal.effectivePrice,
              savings: deal.effectiveSavings,
              isBest: true,
            ),
          ];

    final data = ProductComparisonData(
      productId: deal.id,
      title: deal.title,
      brand: deal.brand,
      category: deal.category.isNotEmpty ? deal.category : 'Best Deals',
      imageUrl: deal.imageUrl,
      description: 'Stacked multi-store savings comparison for ${deal.title}.',
      bestStore: deal.store,
      bestEffectivePrice: deal.effectivePrice,
      stores: stores,
      smartSavings: SmartSavingsBreakdown(
        productPrice: deal.originalPrice,
        storeDiscount: deal.originalPrice > deal.discountedPrice
            ? deal.originalPrice - deal.discountedPrice
            : 0,
        couponDiscount: deal.couponDiscount,
        bankDiscount: 0,
        cashback: deal.cashbackAmount,
        totalSavings: deal.effectiveSavings,
        effectivePrice: deal.effectivePrice,
        isBestDeal: true,
      ),
    );

    return ProductComparisonScreen(
      productId: deal.id,
      initialTitle: deal.title,
      initialBrand: deal.brand,
      initialImageUrl: deal.imageUrl,
      comparisonData: data,
    );
  }

  factory ProductComparisonScreen.fromSmartSavings(SmartSavingsModel savings) {
    final stores = savings.stores.map((s) {
      return StoreComparisonDetail(
        store: s.store,
        price: s.price,
        storeDiscount: s.storeDiscount,
        cashback: s.cashback,
        coupon: s.coupon,
        effectivePrice: s.effectivePrice,
        savings: s.savings,
        isBest: s.isBest,
      );
    }).toList();

    final data = ProductComparisonData(
      productId: savings.id,
      title: savings.productName,
      brand: savings.brand,
      category: 'Smart Savings',
      imageUrl: savings.imageUrl,
      description: 'Multi-store savings analysis with automated coupon & cashback combination.',
      bestStore: savings.bestStore,
      bestEffectivePrice: savings.effectivePrice,
      stores: stores,
      smartSavings: SmartSavingsBreakdown(
        productPrice: savings.productPrice,
        storeDiscount: savings.storeDiscount,
        couponDiscount: savings.couponDiscount,
        bankDiscount: savings.bankDiscount,
        cashback: savings.cashback,
        totalSavings: savings.totalSavings,
        effectivePrice: savings.effectivePrice,
        isBestDeal: true,
      ),
    );

    return ProductComparisonScreen(
      productId: savings.id,
      initialTitle: savings.productName,
      initialBrand: savings.brand,
      initialImageUrl: savings.imageUrl,
      comparisonData: data,
    );
  }

  factory ProductComparisonScreen.fromSearchProduct(SearchProductItem product) {
    final data = ProductComparisonData(
      productId: product.id,
      title: product.title,
      brand: product.brand,
      category: product.category,
      imageUrl: product.imageUrl,
      description: product.description,
      bestStore: product.bestStore,
      bestEffectivePrice: product.bestEffectivePrice,
      stores: product.stores,
      smartSavings: SmartSavingsBreakdown(
        productPrice: product.originalPrice,
        storeDiscount: product.stores.isNotEmpty ? product.stores.first.storeDiscount : 500,
        couponDiscount: product.couponDiscount,
        bankDiscount: 0,
        cashback: product.cashbackAmount,
        totalSavings: product.originalPrice - product.bestEffectivePrice,
        effectivePrice: product.bestEffectivePrice,
        isBestDeal: true,
      ),
    );

    return ProductComparisonScreen(
      productId: product.id,
      initialTitle: product.title,
      initialBrand: product.brand,
      initialImageUrl: product.imageUrl,
      comparisonData: data,
    );
  }

  factory ProductComparisonScreen.fromCompareId(
    String productId, {
    String? initialTitle,
    String? initialBrand,
    String? initialImageUrl,
    String? initialCategory,
  }) {
    return ProductComparisonScreen(
      productId: productId,
      initialTitle: initialTitle,
      initialBrand: initialBrand,
      initialImageUrl: initialImageUrl,
    );
  }

  @override
  State<ProductComparisonScreen> createState() => _ProductComparisonScreenState();
}

class _ProductComparisonScreenState extends State<ProductComparisonScreen> {
  late ProductComparisonData _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.comparisonData != null) {
      _data = widget.comparisonData!;
      _isLoading = false;
    } else {
      _fetchComparison();
    }
  }

  Future<void> _fetchComparison() async {
    final prodId = widget.productId ?? 'prod-shirt-1';

    try {
      final catService = CategoryShoppingService();
      final smartRes = await catService.compareProduct(prodId);

      final stores = smartRes.stores.map((s) {
        return StoreComparisonDetail(
          store: s.store,
          price: s.productPrice,
          storeDiscount: s.storeDiscount,
          cashback: s.cashback,
          coupon: s.couponDiscount,
          effectivePrice: s.effectiveCost,
          savings: s.totalSavings,
          isBest: s.isBestDeal,
          bankDiscount: s.bankDiscount,
          payNow: s.payNow,
          eligibility: s.eligibility,
          shopUrl: s.shopUrl,
        );
      }).toList();

      final data = ProductComparisonData(
        productId: smartRes.productId,
        title: smartRes.title.isNotEmpty ? smartRes.title : widget.initialTitle ?? '',
        brand: smartRes.brand.isNotEmpty ? smartRes.brand : widget.initialBrand ?? '',
        category: smartRes.category.isNotEmpty ? smartRes.category : 'Shopping',
        imageUrl: smartRes.imageUrl.isNotEmpty ? smartRes.imageUrl : widget.initialImageUrl ?? '',
        description: 'Multi-store price comparison with transparent savings calculation.',
        bestStore: smartRes.bestDeal.store,
        bestEffectivePrice: smartRes.bestDeal.effectiveCost,
        stores: stores,
        smartSavings: SmartSavingsBreakdown(
          productPrice: smartRes.originalPrice > 0 ? smartRes.originalPrice : (stores.isNotEmpty ? stores.first.price : 2999),
          storeDiscount: stores.isNotEmpty ? stores.first.storeDiscount : 200,
          couponDiscount: stores.isNotEmpty ? stores.first.coupon : 300,
          bankDiscount: stores.isNotEmpty ? stores.first.bankDiscount : 150,
          cashback: smartRes.bestDeal.potentialCashback,
          totalSavings: smartRes.totalSavings,
          effectivePrice: smartRes.bestDeal.effectiveCost,
          isBestDeal: true,
        ),
      );

      if (mounted) {
        setState(() {
          _data = data;
          _isLoading = false;
        });
        return;
      }
    } catch (_) {}

    final service = SearchService();
    final res = await service.getProductComparison(prodId);
    if (mounted) {
      setState(() {
        _data = res;
        _isLoading = false;
      });
    }
  }

  void _onShopOnStore(StoreComparisonDetail store) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShoppingConfirmationScreen(
          brand: BrandModel(
            name: store.store,
            logoUrl: '',
            bannerUrl: '',
            cashbackPercentage: '₹${store.cashback.toInt()} Cashback',
            category: 'Shopping',
            offerText: '₹${store.cashback.toInt()} Cashback',
            websiteUrl: ProductDetailScreen.resolveStoreUrl(store.store),
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
    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
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
          'Price Comparison',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBrown),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. PRODUCT HEADER CARD
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: NetworkImageWithSkeleton(
                            imageUrl: _data.imageUrl.isNotEmpty
                                ? _data.imageUrl
                                : widget.initialImageUrl ?? '',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _data.brand.toUpperCase(),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.primaryBrown,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _data.title,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textDark,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Category: ${_data.category}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. BEST DEAL HIGHLIGHT BANNER
                    Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [AppColors.darkCardElevated, AppColors.darkCard]
                            : const [Color(0xFFFAF1E4), Color(0xFFF5E4D0)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.darkPrimary.withValues(alpha: 0.6) : const Color(0xFF2563EB).withValues(alpha: 0.6),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkPrimary : const Color(0xFF2563EB),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.emoji_events_rounded,
                                size: 20,
                                color: isDark ? AppColors.darkButtonText : Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '🏆 BEST DEAL — ${_data.bestStore}',
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Save up to ₹${_data.smartSavings.totalSavings.toInt()} with stacked discounts & cashback!',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.darkPrimary
                                          : const Color(0xFF8C430B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pay Now: ₹${(_data.smartSavings.productPrice - _data.smartSavings.storeDiscount - _data.smartSavings.couponDiscount).toInt()}  •  Cashback: ₹${_data.smartSavings.cashback.toInt()}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: textDark,
                              ),
                            ),
                            InkWell(
                              onTap: () => _showHowYouSaveModal(context, _data.smartSavings, isDark),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF5E4332) : const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'See How You Save',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? const Color(0xFFF3BD8B) : AppColors.primaryBrown,
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Icon(
                                      Icons.info_outline_rounded,
                                      size: 13,
                                      color: isDark ? const Color(0xFFF3BD8B) : AppColors.primaryBrown,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. MULTI-STORE COMPARISON
                  Text(
                    'Compare Across Stores',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 10),

                  ..._data.stores.map((store) {
                    return _buildStoreCard(context, store, textDark, textMuted, isDark);
                  }),
                  const SizedBox(height: 20),

                  // 4. SMART SAVINGS CALCULATION BREAKDOWN
                  Text(
                    'Smart Savings Engine Breakdown',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildSmartSavingsTable(context, _data.smartSavings, textDark, textMuted, isDark),
                  const SizedBox(height: 24),
                ],
              ),
            ),
      bottomNavigationBar: _isLoading
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                    width: 0.8,
                  ),
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Best Effective Price',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: textMuted,
                          ),
                        ),
                        Text(
                          '₹${_data.bestEffectivePrice.toInt()}',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        final bestStore = _data.stores.firstWhere(
                          (s) => s.isBest,
                          orElse: () => _data.stores.first,
                        );
                        _onShopOnStore(bestStore);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                        foregroundColor: isDark ? AppColors.darkButtonText : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Shop Best Deal',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward_rounded, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStoreCard(
    BuildContext context,
    StoreComparisonDetail store,
    Color textDark,
    Color textMuted,
    bool isDark,
  ) {
    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final borderColor = store.isBest
        ? (isDark ? AppColors.darkPrimary : const Color(0xFF2563EB))
        : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: store.isBest ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                store.store,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              const SizedBox(width: 8),
              if (store.isBest)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkPrimary : const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '🏆 Best Deal',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Effective Price',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: textMuted,
                    ),
                  ),
                  Text(
                    '₹${store.effectivePrice.toInt()}',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: store.isBest
                          ? (isDark ? AppColors.darkSuccess : const Color(0xFF10B981))
                          : textDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : const Color(0xFFEDE4D8),
          ),
          const SizedBox(height: 10),

          // Savings breakdown row with transparent savings math
          Row(
            children: [
              _buildMiniMetric('Pay Now', '₹${store.payNow.toInt()}', textDark),
              const SizedBox(width: 12),
              _buildMiniMetric('Cashback', '₹${store.cashback.toInt()}', isDark ? AppColors.darkPrimary : AppColors.primaryBrown),
              const SizedBox(width: 12),
              _buildMiniMetric('Effective', '₹${store.effectivePrice.toInt()}', isDark ? AppColors.darkSuccess : const Color(0xFF10B981)),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _onShopOnStore(store),
                style: ElevatedButton.styleFrom(
                  backgroundColor: store.isBest
                      ? (isDark ? AppColors.darkPrimary : AppColors.primaryBrown)
                      : (isDark ? AppColors.darkSurface : const Color(0xFFEFE4D6)),
                  foregroundColor: store.isBest
                      ? (isDark ? AppColors.darkButtonText : Colors.white)
                      : (isDark ? AppColors.darkTextPrimary : AppColors.deepBrown),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  visualDensity: VisualDensity.compact,
                  elevation: 0,
                ),
                child: Text(
                  'Shop Now',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (store.eligibility.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.credit_card_rounded, size: 12, color: textMuted),
                const SizedBox(width: 4),
                Text(
                  store.eligibility,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showHowYouSaveModal(BuildContext context, SmartSavingsBreakdown savings, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final cardBg = isDark ? AppColors.darkCard : Colors.white;
        final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
        final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
        final primaryAccent = isDark ? AppColors.darkPrimary : AppColors.primaryBrown;

        final payNow = savings.productPrice - savings.storeDiscount - savings.couponDiscount;

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
              Row(
                children: [
                  Icon(Icons.savings_rounded, color: primaryAccent, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Complete Savings Breakdown',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Transparent breakdown of checkout cost and verified wallet cashback',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: textMuted,
                ),
              ),
              const SizedBox(height: 16),
              _buildBreakdownRow('Product Price / MRP', '₹${savings.productPrice.toInt()}', textDark),
              const SizedBox(height: 6),
              _buildBreakdownRow('Store Discount', '-₹${savings.storeDiscount.toInt()}', isDark ? AppColors.darkSuccess : const Color(0xFF10B981)),
              const SizedBox(height: 6),
              _buildBreakdownRow('Coupon Discount', '-₹${savings.couponDiscount.toInt()}', isDark ? AppColors.darkSuccess : const Color(0xFF10B981)),
              Divider(height: 18, color: isDark ? AppColors.darkBorder : const Color(0xFFEDE4D8)),
              _buildBreakdownRow('Pay Now at Checkout', '₹${payNow.toInt()}', primaryAccent),
              const SizedBox(height: 6),
              _buildBreakdownRow('Potential Cashback to Wallet', '+₹${savings.cashback.toInt()}', isDark ? AppColors.darkPrimary : AppColors.primaryBrown),
              Divider(height: 18, color: isDark ? AppColors.darkBorder : const Color(0xFFEDE4D8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Potential Total Benefit', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13, color: textDark)),
                  Text('₹${savings.totalSavings.toInt()}', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w800, color: const Color(0xFF10B981))),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Effective Cost', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14, color: textDark)),
                  Text('₹${savings.effectivePrice.toInt()}', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: primaryAccent)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMiniMetric(String label, String val, Color valColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 9.5,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          val,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: valColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSmartSavingsTable(
    BuildContext context,
    SmartSavingsBreakdown calc,
    Color textDark,
    Color textMuted,
    bool isDark,
  ) {
    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          _buildBreakdownRow('MRP / Base Price', '₹${calc.productPrice.toInt()}', textDark),
          const SizedBox(height: 6),
          _buildBreakdownRow('Merchant Store Discount', '-₹${calc.storeDiscount.toInt()}', isDark ? AppColors.darkSuccess : const Color(0xFF10B981)),
          const SizedBox(height: 6),
          _buildBreakdownRow('Coupon Discount', '-₹${calc.couponDiscount.toInt()}', isDark ? AppColors.darkSuccess : const Color(0xFF10B981)),
          const SizedBox(height: 6),
          _buildBreakdownRow('Real Cashback to KashIQ Wallet', '+₹${calc.cashback.toInt()}', isDark ? AppColors.darkPrimary : AppColors.primaryBrown),
          Divider(
            height: 20,
            color: isDark ? AppColors.darkBorder : const Color(0xFFEDE4D8),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Savings',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              Text(
                '₹${calc.totalSavings.toInt()}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Final Effective Cost',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              Text(
                '₹${calc.effectivePrice.toInt()}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String val, Color valColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 12.5),
        ),
        Text(
          val,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valColor,
          ),
        ),
      ],
    );
  }
}
