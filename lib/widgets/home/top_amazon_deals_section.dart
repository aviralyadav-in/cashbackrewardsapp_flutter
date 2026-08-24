import 'package:flutter/material.dart';
import '../../data/home_mock_data.dart';
import '../../models/amazon_deal_model.dart';
import '../../models/brand_model.dart';
import '../../screens/product_detail_screen.dart';
import '../../screens/top_category_brands_screen.dart';
import '../network_image_with_skeleton.dart';
import 'dashed_line_painter.dart';

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E90FF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Top Amazon Deals',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TopCategoryBrandsScreen(
                        categoryTitle: 'Top Amazon Deals',
                        brands: deals
                            .map(
                              (deal) => BrandModel(
                                name: '${deal.brandName} - ${deal.productName}',
                                logoUrl:
                                    'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
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
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E90FF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E90FF),
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 10,
                        color: Color(0xFF1E90FF),
                      ),
                    ],
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
        ],
      ),
    );
  }

  Widget _buildAmazonProductCard(
    BuildContext context,
    AmazonDealItemData deal,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen.fromAmazonDeal(deal),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161618) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP PART: Product Image + Brand + Product Name + Actual Price
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image Container
                      Expanded(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: NetworkImageWithSkeleton(
                              imageUrl: deal.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Brand Name
                      Text(
                        deal.brandName.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),

                      // Product Name
                      Text(
                        deal.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Actual Price
                      Row(
                        children: [
                          Text(
                            'Actual Price: ',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            '₹${_formatCurrency(deal.actualPrice.round())}',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.lineThrough,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // DASHED DIVIDER LINE
              CustomPaint(
                size: const Size(double.infinity, 1),
                painter: DashedLinePainter(
                  color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
                  dashWidth: 5,
                  dashSpace: 4,
                ),
              ),

              // BOTTOM PART: Reward % + Final Price
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                color: isDark
                    ? const Color(0xFF1E90FF).withValues(alpha: 0.08)
                    : const Color(0xFF1E90FF).withValues(alpha: 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'After Rewards of ${deal.rewardPercentage.toStringAsFixed(deal.rewardPercentage % 1 == 0 ? 0 : 1)}%',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E90FF),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'Final Price: ',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          '₹${_formatCurrency(deal.finalPrice)}',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : Colors.black87,
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
    );
  }
}
