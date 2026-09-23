import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/home_discovery_models.dart';
import '../providers/home_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/network_image_with_skeleton.dart';
import 'coupon_detail_screen.dart';

class AllCouponsScreen extends StatefulWidget {
  static const String routeName = '/all-coupons';

  final List<HomeCouponModel>? initialCoupons;

  const AllCouponsScreen({super.key, this.initialCoupons});

  @override
  State<AllCouponsScreen> createState() => _AllCouponsScreenState();
}

class _AllCouponsScreenState extends State<AllCouponsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStore = 'All';

  static const List<HomeCouponModel> _fallbackCoupons = [
    HomeCouponModel(
      id: 'cp-1',
      code: 'MYNTRA500',
      store: 'Myntra',
      discount: '₹500 OFF',
      minOrder: 2499,
      cashback: 'Up to 12%',
      validity: 'Valid till 30 Sep',
      description: 'Applicable on orders above ₹2,499 across all footwear and apparel.',
      logoUrl: 'assets/cards/myntra.jpg',
      applicableOn: 'Men & Women Fashion, Footwear & Accessories',
      successRate: '98% Success Rate',
      terms: [
        'Valid on orders with minimum cart value of ₹2,499',
        'Applicable once per user per calendar month',
        'Cannot be clubbed with select flash sale vouchers',
        'Extra cashback tracks automatically within 24 hours of dispatch',
      ],
    ),
    HomeCouponModel(
      id: 'cp-2',
      code: 'AJIOMAN10',
      store: 'AJIO',
      discount: '10% OFF',
      minOrder: 1999,
      cashback: 'Up to 10%',
      validity: 'Valid till 15 Oct',
      description: 'Extra 10% instant discount on premium fashion brands on AJIO.',
      logoUrl: 'assets/cards/ajio-coupons.jpg',
      applicableOn: 'AJIO Luxe & Trendsetter Catalog',
      successRate: '95% Success Rate',
      terms: [
        'Valid on minimum cart value of ₹1,999',
        'Applicable on eligible products with coupon flag',
        'Max instant discount capped at ₹1,000',
      ],
    ),
    HomeCouponModel(
      id: 'cp-3',
      code: 'AMZTECH250',
      store: 'Amazon',
      discount: '₹250 OFF',
      minOrder: 1500,
      cashback: 'Up to 8%',
      validity: 'Valid today only',
      description: 'Instant discount voucher on computer accessories and audio gear.',
      logoUrl: 'assets/cards/amazon.jpg',
      applicableOn: 'Electronics, Keyboards, Audio & PC Peripherals',
      successRate: '99% Success Rate',
      terms: [
        'Valid on electronic items fulfilled by Amazon',
        'Minimum order value ₹1,500',
        'Applicable on prepaid payment methods',
      ],
    ),
    HomeCouponModel(
      id: 'cp-4',
      code: 'FLIPKART400',
      store: 'Flipkart',
      discount: '₹400 OFF',
      minOrder: 2999,
      cashback: 'Up to 6%',
      validity: 'Valid till 28 Sep',
      description: 'Flat ₹400 voucher on home appliances and kitchen gadgets.',
      logoUrl: 'assets/cards/flipkart-electronics.png',
      applicableOn: 'Kitchen Appliances & Small Home Electronics',
      successRate: '94% Success Rate',
      terms: [
        'Valid on home & kitchen category items',
        'Minimum transaction of ₹2,999',
        'Instant discount credited during final checkout',
      ],
    ),
    HomeCouponModel(
      id: 'cp-5',
      code: 'NYKAAGLOW',
      store: 'Nykaa',
      discount: '15% OFF',
      minOrder: 1299,
      cashback: 'Up to 15%',
      validity: 'Valid till Sunday',
      description: 'Extra 15% discount on top skincare & beauty essentials.',
      logoUrl: 'assets/cards/nykaa.jpg',
      applicableOn: 'Skincare, Makeup & Fragrances',
      successRate: '97% Success Rate',
      terms: [
        'Valid on all cosmetic and self-care items above ₹1,299',
        'Max discount ₹500',
      ],
    ),
    HomeCouponModel(
      id: 'cp-6',
      code: 'NIKE500',
      store: 'Nike',
      discount: '₹500 OFF',
      minOrder: 2999,
      cashback: 'Up to 10%',
      validity: 'Valid till 30 Sep',
      description: 'Flat ₹500 discount on orders above ₹2,999 on Nike Official.',
      logoUrl: 'assets/logos/nike.svg',
      applicableOn: 'Nike Running, Training & Lifestyle Footwear',
      successRate: '96% Success Rate',
      terms: [
        'Applicable on official store purchase above ₹2,999',
        'Excluded on limited-edition SNKRS drops',
      ],
    ),
    HomeCouponModel(
      id: 'cp-7',
      code: 'DOTKEY20',
      store: 'Dot & Key',
      discount: '20% OFF',
      minOrder: 899,
      cashback: 'Up to 12%',
      validity: 'Limited Time',
      description: 'Flat 20% OFF on all fruit-forward skincare serums & moisturizers.',
      logoUrl: 'assets/cards/dotandkey-coupons.png',
      applicableOn: 'Entire Dot & Key Skincare Catalog',
      successRate: '99% Success Rate',
      terms: [
        'Valid on cart values over ₹899',
        'No maximum discount ceiling',
      ],
    ),
    HomeCouponModel(
      id: 'cp-8',
      code: 'MCF250',
      store: 'MCaffeine',
      discount: '₹250 OFF',
      minOrder: 999,
      cashback: 'Up to 18%',
      validity: 'Valid till 10 Oct',
      description: 'Instant ₹250 discount on caffeinated face wash & body scrubs.',
      logoUrl: 'assets/cards/mcaffeine-coupons.jpg',
      applicableOn: 'Body Scrubs, Face Polishing & Hair Care',
      successRate: '95% Success Rate',
      terms: [
        'Minimum cart value ₹999 required',
        'Free shipping included with this voucher',
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final homeProvider = context.watch<HomeProvider>();

    // Merge provider coupons with comprehensive fallback list
    final dynamicCoupons = widget.initialCoupons ?? homeProvider.coupons;
    final Map<String, HomeCouponModel> mergedMap = {};
    for (final c in dynamicCoupons) {
      mergedMap[c.code] = c;
    }
    for (final c in _fallbackCoupons) {
      if (!mergedMap.containsKey(c.code)) {
        mergedMap[c.code] = c;
      }
    }
    final allCoupons = mergedMap.values.toList();

    // Extract unique stores for filtering
    final storeSet = <String>{'All'};
    for (final c in allCoupons) {
      if (c.store.isNotEmpty) {
        storeSet.add(c.store);
      }
    }
    final storeList = storeSet.toList();

    // Filter coupons
    final filteredCoupons = allCoupons.where((c) {
      final matchesStore = _selectedStore == 'All' ||
          c.store.toLowerCase() == _selectedStore.toLowerCase();
      final q = _searchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          c.code.toLowerCase().contains(q) ||
          c.store.toLowerCase().contains(q) ||
          c.discount.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q);
      return matchesStore && matchesQuery;
    }).toList();

    final bgColor = isDark ? AppColors.darkBackground : AppColors.mainBackground;
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;

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
              'All Coupons',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
            Text(
              '${filteredCoupons.length} Active Verified Coupons',
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
                  color: isDark ? const Color(0xFF1E1712) : Colors.white,
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
                    hintText: 'Search coupon, store, or discount...',
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

            // Store Filter Chips
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: storeList.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final store = storeList[index];
                  final isSelected = _selectedStore == store;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedStore = store;
                      });
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
                          store,
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



            const SizedBox(height: 4),

            // Coupons List
            Expanded(
              child: filteredCoupons.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.confirmation_number_outlined,
                            size: 54,
                            color: textMuted.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No coupons found for "$_searchQuery"',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Try selecting another store or clearing the search',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: textMuted,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: filteredCoupons.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final coupon = filteredCoupons[index];
                        return _buildCouponCard(
                          context,
                          coupon,
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

  Widget _buildCouponCard(
    BuildContext context,
    HomeCouponModel coupon,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color textDark,
    Color textMuted,
    Color primaryAccent,
  ) {
    final resolvedLogo = coupon.logoUrl.isNotEmpty
        ? coupon.logoUrl
        : HomeCouponModel.resolveLogo(coupon.store);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Open full Coupon Details screen instead of modal
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CouponDetailScreen(coupon: coupon),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. BRAND LOGO + BRAND NAME (Top Row)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Large & Clearly Visible Brand Logo
                    Container(
                      width: 52,
                      height: 52,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2018) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: resolvedLogo.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: NetworkImageWithSkeleton(
                                imageUrl: resolvedLogo,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildBrandMonogram(coupon.store, primaryAccent),
                              ),
                            )
                          : _buildBrandMonogram(coupon.store, primaryAccent),
                    ),
                    const SizedBox(width: 14),

                    // Brand Name & Verified Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  coupon.store,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: textDark,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.verified_rounded,
                                        size: 11, color: Colors.green.shade700),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Verified',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            coupon.validity,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Indicative Navigation Arrow
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primaryAccent.withValues(alpha: isDark ? 0.15 : 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: primaryAccent,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 2. CLEARLY DISPLAYED DISCOUNT / OFFER AMOUNT (Prominent Fraunces)
                Text(
                  coupon.discount,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: primaryAccent,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),

                // Description (Clean & Minimal)
                Text(
                  coupon.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: textMuted,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Subtle separator
                Divider(
                  height: 1,
                  thickness: 0.8,
                  color: borderColor.withValues(alpha: 0.7),
                ),

                const SizedBox(height: 10),

                // 3. MINIMAL METADATA FOOTER (No coupon code, no Shop Now button)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF132247) : const Color(0xFFF7EFE6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Min order: ₹${coupon.minOrder.toInt()}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                        ),
                      ),
                    ),
                    if (coupon.cashback.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '+ ${coupon.cashback} Cashback',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      'Tap for details',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: primaryAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandMonogram(String store, Color accent) {
    final initial = store.isNotEmpty ? store.substring(0, 1).toUpperCase() : '?';
    return Center(
      child: Text(
        initial,
        style: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: accent,
        ),
      ),
    );
  }
}
