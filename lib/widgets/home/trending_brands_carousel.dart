import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/brand_model.dart';
import '../../models/trending_brand_model.dart';
import '../../theme/app_theme.dart';
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
      height: 140,
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
                color: widget.isDark ? AppColors.darkCard : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                border: Border.all(
                  color: widget.isDark ? AppColors.darkBorder : AppColors.border,
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
                borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
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
                                  width: 34,
                                  height: 34,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: widget.isDark
                                        ? AppColors.darkSurface
                                        : AppColors.beigeSurface,
                                    border: Border.all(
                                      color: widget.isDark
                                          ? AppColors.darkBorder
                                          : AppColors.border,
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: NetworkImageWithSkeleton(
                                      imageUrl: item.brand.logoUrl.isNotEmpty
                                          ? item.brand.logoUrl
                                          : item.brand.bannerUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder: (ctx, err, stack) => Center(
                                        child: Text(
                                          item.brand.name.substring(0, 1),
                                          style: GoogleFonts.fraunces(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: widget.isDark
                                                ? AppColors.darkTextPrimary
                                                : AppColors.primaryBrown,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.brand.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.cardTitle(
                                      color: widget.isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary,
                                    ).copyWith(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              item.tagline,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption(
                                color: widget.isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              item.brand.offerText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption(
                                color: widget.isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.deepBrown,
                              ).copyWith(fontWeight: FontWeight.w700),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: widget.isDark
                                    ? AppColors.darkSurface
                                    : AppColors.beigeSurface,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: widget.isDark
                                      ? AppColors.darkBorder
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                item.brand.cashbackPercentage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.fraunces(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: widget.isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.primaryBrown,
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
