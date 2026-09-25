import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/home_discovery_models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/network_image_with_skeleton.dart';
import '../products/product_detail_screen.dart';

class AllBestDealsScreen extends StatefulWidget {
  static const String routeName = '/all-best-deals';

  final List<BestDealModel> deals;
  final String? title;

  const AllBestDealsScreen({
    super.key,
    required this.deals,
    this.title,
  });

  @override
  State<AllBestDealsScreen> createState() => _AllBestDealsScreenState();
}

class _AllBestDealsScreenState extends State<AllBestDealsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

    final q = _searchQuery.trim().toLowerCase();
    final filteredDeals = widget.deals.where((d) {
      if (q.isEmpty) return true;
      return d.title.toLowerCase().contains(q) ||
          d.brand.toLowerCase().contains(q) ||
          d.store.toLowerCase().contains(q) ||
          d.category.toLowerCase().contains(q);
    }).toList();

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
              widget.title ?? 'Top Deals',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
            Text(
              '${filteredDeals.length} Deals Available',
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
            // Search Input Field matching AllStoresScreen
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
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
                    hintText: 'Search best deals, brands, or stores...',
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

            const SizedBox(height: 4),

            // Deals Grid matching Pharmacy & Health view all cards
            Expanded(
              child: filteredDeals.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 54,
                            color: textMuted.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No deals found for "$_searchQuery"'
                                : 'No deals available right now',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textDark,
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
                        childAspectRatio: 0.60,
                      ),
                      itemCount: filteredDeals.length,
                      itemBuilder: (context, index) {
                        final deal = filteredDeals[index];
                        return _buildDealCard(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealCard(
    BuildContext context,
    BestDealModel deal,
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
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
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
                builder: (_) => ProductDetailScreen.fromBestDeal(deal),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full-Width Product Image Banner + Badges
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Container(
                      color: isDark ? const Color(0xFF1E1712) : const Color(0xFFFAF6F0),
                      child: NetworkImageWithSkeleton(
                        imageUrl: deal.imageUrl,
                        height: 106,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 106,
                          width: double.infinity,
                          color: isDark ? const Color(0xFF1E1712) : const Color(0xFFF5EFE6),
                          child: Center(
                            child: Icon(
                              Icons.local_offer_rounded,
                              size: 32,
                              color: primaryAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Best Deal Badge (Top Left)
                  if (deal.badge.isNotEmpty)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          deal.badge,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFFD580),
                          ),
                        ),
                      ),
                    ),

                  // Store Tag (Top Right)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF132247) : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        deal.store,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Product Details Body
              Padding(
                padding: const EdgeInsets.fromLTRB(9, 6, 9, 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand
                    Text(
                      deal.brand.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: primaryAccent,
                        letterSpacing: 0.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),

                    // Title
                    Text(
                      deal.title,
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),

                    // Pricing: Effective Price + Store Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '₹${deal.effectivePrice.toInt()}',
                              style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: primaryAccent,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(width: 5),
                            if (deal.originalPrice > deal.effectivePrice)
                              Text(
                                '₹${deal.originalPrice.toInt()}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: textMuted,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        if (deal.discountedPrice > 0 && deal.discountedPrice != deal.effectivePrice)
                          Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Text(
                              '₹${deal.discountedPrice.toInt()} at ${deal.store}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Offers & Cashback: Stacked Vertically
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Offer Line (Green)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_offer_rounded,
                              size: 13,
                              color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                deal.effectiveSavings > 0
                                    ? 'Save ₹${deal.effectiveSavings.toInt()}'
                                    : (deal.discountPercentage > 0
                                        ? '${deal.discountPercentage.toInt()}% OFF'
                                        : 'Best Price Deal'),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),

                        // Cashback Line (Red)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.stars_rounded,
                              size: 13,
                              color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${deal.cashbackPercentage.toInt()}% Cashback',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action Button: Shop Best Deal
              Padding(
                padding: const EdgeInsets.fromLTRB(9, 0, 9, 6),
                child: SizedBox(
                  width: double.infinity,
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen.fromBestDeal(deal),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                    ),
                    child: Text(
                      'Shop Best Deal',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
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
}
