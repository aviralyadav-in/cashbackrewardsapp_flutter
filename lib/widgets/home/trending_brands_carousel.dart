import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/brand_model.dart';
import '../../models/trending_brand_model.dart';
import '../network_image_with_skeleton.dart';

class TrendingBrandsCarouselWidget extends StatefulWidget {
  final List<TrendingBannerItemData> items;
  final bool isDark;
  final Function(BrandModel brand) onBrandTap;

  const TrendingBrandsCarouselWidget({
    super.key,
    required this.items,
    required this.isDark,
    required this.onBrandTap,
  });

  @override
  State<TrendingBrandsCarouselWidget> createState() =>
      _TrendingBrandsCarouselWidgetState();
}

class _TrendingBrandsCarouselWidgetState
    extends State<TrendingBrandsCarouselWidget> {
  late PageController _pageController;
  Timer? _autoSlideTimer;
  static const int _kInfiniteInitialPage = 5000;

  @override
  void initState() {
    super.initState();
    final initialPage = widget.items.isNotEmpty
        ? _kInfiniteInitialPage - (_kInfiniteInitialPage % widget.items.length)
        : 0;

    _pageController = PageController(
      initialPage: initialPage,
      viewportFraction: 0.84,
    );

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    if (widget.items.isEmpty) return;

    _autoSlideTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted || !_pageController.hasClients) return;
      final nextPage = _pageController.page!.round() + 1;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 135,
      child: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final actualIndex = index % widget.items.length;
          final item = widget.items[actualIndex];

          return GestureDetector(
            onTap: () => widget.onBrandTap(item.brand),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: widget.isDark ? const Color(0xFF161618) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isDark
                      ? const Color(0xFF28282A)
                      : const Color(0xFFE5E5EA),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: widget.isDark ? 0.3 : 0.04,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  children: [
                    // Left Image Part (38%)
                    SizedBox(
                      width: 105,
                      height: double.infinity,
                      child: NetworkImageWithSkeleton(
                        imageUrl: item.brand.bannerUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Right Content Part (62%)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: widget.isDark
                                        ? const Color(0xFF242426)
                                        : Colors.grey.shade100,
                                    border: Border.all(
                                      color: const Color(0xFF1E90FF)
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: NetworkImageWithSkeleton(
                                      imageUrl: item.brand.logoUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder: (ctx, err, stack) => Center(
                                        child: Text(
                                          item.brand.name.substring(0, 1),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E90FF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.brand.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              item.tagline,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                color: widget.isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              item.brand.offerText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: widget.isDark
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade800,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E90FF).withValues(
                                  alpha: widget.isDark ? 0.16 : 0.1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.brand.cashbackPercentage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E90FF),
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
        },
      ),
    );
  }
}
