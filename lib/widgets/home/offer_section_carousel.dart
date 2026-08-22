import 'package:flutter/material.dart';
import '../../screens/offer_section_screen.dart';
import '../network_image_with_skeleton.dart';

class OfferSectionCarouselWidget extends StatelessWidget {
  final String title;
  final List<OfferSectionItem> items;
  final VoidCallback onViewAllTap;

  const OfferSectionCarouselWidget({
    super.key,
    required this.title,
    required this.items,
    required this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
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
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: onViewAllTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
        const SizedBox(height: 12),

        // Horizontal Carousel
        SizedBox(
          height: 195,
          child: items.isEmpty
              ? const Center(child: Text('No offers available'))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: onViewAllTap,
                        child: Container(
                          width: 155,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF161618) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF2E2E2E)
                                  : const Color(0xFFE5E5EA),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Image section
                                Expanded(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      NetworkImageWithSkeleton(
                                        imageUrl: item.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: isDark
                                                ? const Color(0xFF242426)
                                                : Colors.grey.shade200,
                                            child: Icon(
                                              Icons.image_not_supported_outlined,
                                              size: 32,
                                              color: Colors.grey.shade500,
                                            ),
                                          );
                                        },
                                      ),

                                      // Cashback badge
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade700,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            item.cashbackTag,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Card info
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        item.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.priceOrRate,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF1E90FF),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1E90FF).withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              item.storeName.toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1E90FF),
                                              ),
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
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
