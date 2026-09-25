import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/home_discovery_models.dart';
import '../../providers/home_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/network_image_with_skeleton.dart';
import '../products/product_detail_screen.dart';

class AllTrendingDealsScreen extends StatefulWidget {
  static const String routeName = '/all-trending-deals';

  final List<TrendingDealModel> deals;

  const AllTrendingDealsScreen({
    super.key,
    this.deals = const [],
  });

  @override
  State<AllTrendingDealsScreen> createState() => _AllTrendingDealsScreenState();
}

class _AllTrendingDealsScreenState extends State<AllTrendingDealsScreen> {
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

    final allDeals = widget.deals.isNotEmpty
        ? widget.deals
        : (Provider.of<HomeProvider>(context, listen: false).trendingDeals);

    final q = _searchQuery.trim().toLowerCase();
    final filteredDeals = allDeals.where((d) {
      if (q.isEmpty) return true;
      return d.productName.toLowerCase().contains(q) ||
          d.brand.toLowerCase().contains(q) ||
          d.store.toLowerCase().contains(q) ||
          d.discount.toLowerCase().contains(q) ||
          d.cashback.toLowerCase().contains(q);
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
              ' Trending Deals',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
            Text(
              '${filteredDeals.length} Hot Deals Trending Today',
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
                    hintText: 'Search trending deals, products, or stores...',
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
                            Icons.trending_up_rounded,
                            size: 54,
                            color: textMuted.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No deals found for "$_searchQuery"'
                                : 'No trending deals right now',
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
                        childAspectRatio: 0.76,
                      ),
                      itemCount: filteredDeals.length,
                      itemBuilder: (context, index) {
                        final deal = filteredDeals[index];
                        return _buildTrendingDealCard(
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

  Widget _buildTrendingDealCard(
    BuildContext context,
    TrendingDealModel deal,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color textDark,
    Color textMuted,
    Color primaryAccent,
  ) {
    final effectivePrice = deal.cashbackAmount > 0
        ? (deal.price - deal.cashbackAmount).toInt()
        : deal.price.toInt();
    final highlightText = deal.cashbackAmount > 0
        ? '₹$effectivePrice • ${deal.cashback}'
        : (deal.discount.isNotEmpty
            ? '₹${deal.price.toInt()} • ${deal.discount}'
            : '₹${deal.price.toInt()}');

    return Container(
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
                builder: (_) => ProductDetailScreen.fromTrendingDeal(deal),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circular Image Container
                Container(
                  width: 58,
                  height: 58,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1712) : const Color(0xFFFAF6F0),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: ClipOval(
                    child: NetworkImageWithSkeleton(
                      imageUrl: deal.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.local_fire_department_rounded,
                          size: 24,
                          color: primaryAccent,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Deal Title
                Text(
                  deal.productName,
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 2),

                // Store & Brand Subtitle
                Text(
                  '${deal.store.toUpperCase()} • ${deal.brand.isNotEmpty ? deal.brand : "Trending"}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    color: textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                // Price / Cashback Highlight Pill
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4.5),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1C2D5A) : const Color(0xFFF7EFE6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? const Color(0xFF5E4332) : const Color(0xFFE2D1C0),
                    ),
                  ),
                  child: Text(
                    highlightText,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: primaryAccent,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 8),

                // "Shop & Earn" Action Button
                SizedBox(
                  width: double.infinity,
                  height: 32,
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
                          builder: (_) => ProductDetailScreen.fromTrendingDeal(deal),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Shop & Earn',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_rounded, size: 12),
                      ],
                    ),
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
