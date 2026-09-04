import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/home_mock_data.dart';
import '../../models/amazon_deal_model.dart';
import '../../models/brand_model.dart';
import '../../screens/top_category_brands_screen.dart';
import '../../theme/app_theme.dart';
import 'amazon_deal_card.dart';

class TopAmazonDealsSection extends StatefulWidget {
  final bool isDark;

  const TopAmazonDealsSection({
    super.key,
    required this.isDark,
  });

  @override
  State<TopAmazonDealsSection> createState() => _TopAmazonDealsSectionState();
}

class _TopAmazonDealsSectionState extends State<TopAmazonDealsSection> {
  String _formatCurrency(num amount) {
    final str = amount.round().toString();
    final reg = RegExp(r'(\d+?)(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final deals = HomeMockData.amazonDealsCatalog;
    final isDark = widget.isDark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header Row
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Top Amazon Deals',
                  maxLines: 2,
                  softWrap: true,
                  style: GoogleFonts.fraunces(
                    fontSize: 18.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: isDark ? Colors.white : const Color(0xFF1E1E24),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Horizontal Slider
          SizedBox(
            height: 275,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: deals.length,
              itemBuilder: (context, index) {
                final deal = deals[index];
                return Container(
                  width: 175,
                  margin: const EdgeInsets.only(right: 12),
                  child: _buildAmazonProductCard(context, deal, isDark),
                );
              },
            ),
          ),
          const SizedBox(height: 14),

          // Bottom View All Button
          Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TopCategoryBrandsScreen(
                        categoryTitle: 'Top Amazon Deals',
                        deals: deals,
                        brands: deals
                            .map(
                              (deal) => BrandModel(
                                name: '${deal.brandName} - ${deal.productName}',
                                logoUrl: deal.imageUrl,
                                bannerUrl: deal.imageUrl,
                                cashbackPercentage:
                                    'Flat ${deal.rewardPercentage.toInt()}% Reward',
                                category: 'Amazon Deals',
                                offerText:
                                    'After Rewards: ₹${_formatCurrency(deal.finalPrice)} (Actual: ₹${_formatCurrency(deal.actualPrice.round())})',
                                websiteUrl: deal.productUrl,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E1E22)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.primaryBrown.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.25 : 0.06,
                        ),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: GoogleFonts.fraunces(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.primaryBrown,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 11,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.primaryBrown,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  Widget _buildAmazonProductCard(
    BuildContext context,
    AmazonDealItemData deal,
    bool isDark,
  ) {
    return AmazonDealCard(
      deal: deal,
      isDark: isDark,
    );
  }
}
