import 'package:flutter/material.dart';
import '../models/brand_model.dart';
import '../screens/shopping_confirmation_screen.dart';
import '../services/brand_service.dart';
import 'network_image_with_skeleton.dart';

class CashbackBannerCarousel extends StatefulWidget {
  const CashbackBannerCarousel({super.key});

  @override
  State<CashbackBannerCarousel> createState() => _CashbackBannerCarouselState();
}

class _CashbackBannerCarouselState extends State<CashbackBannerCarousel> {
  static const int _kInitialPage = 10000;
  late final PageController _pageController;
  final BrandService _brandService = BrandService();

  List<BrandModel> _brands = [];
  bool _isLoading = true;
  int _currentPage = _kInitialPage;

  @override
  void initState() {
    super.initState();
    // viewportFraction: 0.85 creates the next-banner peek effect on the right edge.
    // initialPage: 10000 allows infinite circular swiping in both left and right directions without boundaries.
    _pageController = PageController(viewportFraction: 0.85, initialPage: _kInitialPage);
    _fetchBrands();
  }

  Future<void> _fetchBrands() async {
    final list = await _brandService.loadBrands();
    if (mounted) {
      setState(() {
        _brands = list;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBannerTap(BrandModel brand) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShoppingConfirmationScreen(brand: brand),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF1E90FF),
          ),
        ),
      );
    }

    if (_brands.isEmpty) {
      return const SizedBox.shrink();
    }

    final activeIndex = ((_currentPage % _brands.length) + _brands.length) % _brands.length;

    return Column(
      children: [
        // HORIZONTAL SWIPEABLE CAROUSEL WITH PEEK EFFECT & INFINITE CIRCULAR LOOP
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final actualIndex = ((index % _brands.length) + _brands.length) % _brands.length;
              final brand = _brands[actualIndex];

              return Padding(
                // Margin creates visible horizontal spacing between cards
                padding: const EdgeInsets.only(right: 12.0, left: 2.0),
                child: GestureDetector(
                  onTap: () => _onBannerTap(brand),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF151D2A) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE5E5EA),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // BACKGROUND BANNER IMAGE WITH GRADIENT OVERLAY
                          Positioned.fill(
                            child: NetworkImageWithSkeleton(
                              imageUrl: brand.bannerUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF0F2F5),
                                  child: Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 60,
                                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                                  ),
                                );
                              },
                            ),
                          ),

                          // GRADIENT OVERLAY FOR TEXT READABILITY
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.85),
                                    Colors.black.withValues(alpha: 0.55),
                                    Colors.black.withValues(alpha: 0.15),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // CARD CONTENT: LOGO, TITLE, CASHBACK BADGE
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // TOP ROW: LOGO & CATEGORY
                                Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipOval(
                                        child: NetworkImageWithSkeleton(
                                          imageUrl: brand.logoUrl,
                                          width: 28,
                                          height: 28,
                                          fit: BoxFit.contain,
                                          shape: BoxShape.circle,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Center(
                                              child: Text(
                                                brand.name.substring(0, 1).toUpperCase(),
                                                style: const TextStyle(
                                                  color: Color(0xFF1E90FF),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            brand.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (brand.category.isNotEmpty)
                                            Text(
                                              brand.category,
                                              style: TextStyle(
                                                color: Colors.white.withValues(alpha: 0.8),
                                                fontSize: 11,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // BOTTOM ROW: CASHBACK BADGE & SHOP ACTION
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFF1E90FF), Color(0xFF0066CC)],
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF1E90FF).withValues(alpha: 0.4),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              brand.cashbackPercentage,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          if (brand.offerText.isNotEmpty) ...[
                                            const SizedBox(height: 6),
                                            Text(
                                              brand.offerText,
                                              style: TextStyle(
                                                color: Colors.white.withValues(alpha: 0.9),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.25),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 18,
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

        const SizedBox(height: 12),

        // CAROUSEL DOT INDICATORS
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_brands.length, (index) {
            final isActive = activeIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: isActive
                    ? const Color(0xFF1E90FF)
                    : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
              ),
            );
          }),
        ),
      ],
    );
  }
}
