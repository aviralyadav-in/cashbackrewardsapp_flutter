import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/brand_model.dart';
import '../../models/category_shopping_models.dart';
import '../../theme/app_theme.dart';
import '../../core/utils/brand_asset_helper.dart';
import '../../widgets/common/network_image_with_skeleton.dart';
import '../products/product_detail_screen.dart';
import '../../services/url_launcher_service.dart';

/// Store coupon model for store detail display
class _StoreCoupon {
  final String code;
  final String title;
  final String discount;
  final String minOrder;
  final String validity;
  final String description;

  const _StoreCoupon({
    required this.code,
    required this.title,
    required this.discount,
    required this.minOrder,
    required this.validity,
    required this.description,
  });
}

/// Category rate tier
class _RateTier {
  final String category;
  final String rate;
  final String type;

  const _RateTier({
    required this.category,
    required this.rate,
    required this.type,
  });
}

class StoreDetailScreen extends StatefulWidget {
  static const String routeName = '/store-detail';

  /// Strips emojis from string to keep headers and titles clean.
  static String cleanTitle(String text) {
    return text
        .replaceAll(
          RegExp(
            r'[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]|[\u{1F600}-\u{1F64F}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}]|[\u{2B50}]|[\u{1F004}-\u{1F0CF}]|[\u{1F900}-\u{1F9FF}]',
            unicode: true,
          ),
          '',
        )
        .trim();
  }

  final CategoryStoreModel? store;
  final BrandModel? brand;
  final String? storeName;
  final String? cashbackRate;
  final String? logoUrl;
  final String? category;
  final String? websiteUrl;

  const StoreDetailScreen({
    super.key,
    this.store,
    this.brand,
    this.storeName,
    this.cashbackRate,
    this.logoUrl,
    this.category,
    this.websiteUrl,
  });

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  late PageController _bannerController;
  late PageController _termsController;
  int _currentBannerIndex = 0;
  int _currentTermsIndex = 0;
  Timer? _autoSlideTimer;

  String get _resolvedName => StoreDetailScreen.cleanTitle(
      widget.store?.name ?? widget.brand?.name ?? widget.storeName ?? 'Store Details');

  String get _resolvedCashback => StoreDetailScreen.cleanTitle(
      widget.store?.cashbackRate ??
          widget.brand?.cashbackPercentage ??
          widget.cashbackRate ??
          '7% Cashback');

  String get _resolvedCategory => StoreDetailScreen.cleanTitle(
      widget.store?.category ?? widget.brand?.category ?? widget.category ?? 'Shopping');

  String get _resolvedLogo {
    final rawLogo = widget.store?.logoUrl ?? widget.brand?.logoUrl ?? widget.logoUrl ?? '';
    if (rawLogo.isNotEmpty && rawLogo.startsWith('assets/')) return rawLogo;
    return BrandAssetHelper.getBrandLogo(_resolvedName, fallback: rawLogo);
  }

  List<String> _getHeroBanners(String storeName) {
    final lower = storeName.toLowerCase();
    final customBanner = widget.brand?.bannerUrl ?? '';
    final List<String> list = [];
    if (customBanner.isNotEmpty && customBanner.startsWith('assets/')) {
      list.add(customBanner);
    } else {
      list.add(BrandAssetHelper.getBrandBanner(storeName));
    }

    if (lower.contains('agoda') || lower.contains('hotel') || lower.contains('stay') || lower.contains('travel')) {
      list.addAll(const [
        'assets/cards/col_travel.jpg',
        'assets/cards/booking.jpg',
        'assets/cards/cleartrip.png',
      ]);
    } else if (lower.contains('myntra') || lower.contains('ajio') || lower.contains('nike') || lower.contains('fashion')) {
      list.addAll(const [
        'assets/cards/col_myntra.jpg',
        'assets/cards/col_ajio.jpg',
        'assets/banners/sneaker_banner_16_9.jpg',
      ]);
    } else if (lower.contains('amazon') || lower.contains('flipkart') || lower.contains('electronic') || lower.contains('croma')) {
      list.addAll(const [
        'assets/cards/col_electronics.jpg',
        'assets/banners/phone_banner_16_9.jpg',
        'assets/banners/headphone_banner_16_9.jpg',
      ]);
    } else {
      list.addAll(const [
        'assets/cards/col_derma.jpg',
        'assets/cards/col_food.jpg',
        'assets/cards/col_shopsy.jpg',
      ]);
    }

    return list.take(4).toList();
  }

  List<_RateTier> _getRateTiers(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('agoda')) {
      return const [
        _RateTier(category: 'Hotel Bookings (Domestic & Asia)', rate: '7.0%', type: 'Real Cashback'),
        _RateTier(category: 'Hotel Bookings (International/Europe/US)', rate: '6.0%', type: 'Real Cashback'),
        _RateTier(category: 'Flight + Hotel Combo Bookings', rate: '4.5%', type: 'Real Cashback'),
        _RateTier(category: 'Activities & City Experiences', rate: '5.0%', type: 'Real Cashback'),
      ];
    } else if (lower.contains('myntra')) {
      return const [
        _RateTier(category: "Men's & Women's Apparel", rate: '8.5%', type: 'Real Cashback'),
        _RateTier(category: 'Footwear & Sneakers', rate: '7.0%', type: 'Real Cashback'),
        _RateTier(category: 'Accessories & Watches', rate: '6.0%', type: 'Real Cashback'),
        _RateTier(category: 'Beauty & Personal Care', rate: '5.0%', type: 'Real Cashback'),
        _RateTier(category: 'All Other Categories', rate: '4.0%', type: 'Real Cashback'),
      ];
    } else if (lower.contains('ajio')) {
      return const [
        _RateTier(category: 'AJIO Trends & Clothing', rate: '7.0%', type: 'Real Cashback'),
        _RateTier(category: 'AJIO Luxe Brands', rate: '5.5%', type: 'Real Cashback'),
        _RateTier(category: 'Footwear & Bags', rate: '6.0%', type: 'Real Cashback'),
        _RateTier(category: 'All Other Orders', rate: '3.5%', type: 'Real Cashback'),
      ];
    } else if (lower.contains('amazon')) {
      return const [
        _RateTier(category: 'Fashion & Luggage', rate: '6.5%', type: 'Rewards'),
        _RateTier(category: 'Home & Kitchen', rate: '5.0%', type: 'Rewards'),
        _RateTier(category: 'Beauty & Grooming', rate: '4.5%', type: 'Rewards'),
        _RateTier(category: 'Electronics & Mobiles', rate: '2.5%', type: 'Rewards'),
      ];
    } else if (lower.contains('flipkart')) {
      return const [
        _RateTier(category: 'Fashion & Footwear', rate: '6.0%', type: 'Real Cashback'),
        _RateTier(category: 'Home Furniture & Decor', rate: '5.0%', type: 'Real Cashback'),
        _RateTier(category: 'Electronics & Appliances', rate: '2.5%', type: 'Real Cashback'),
      ];
    }

    return [
      _RateTier(category: 'Primary Store Orders', rate: _resolvedCashback, type: 'Real Cashback'),
      const _RateTier(category: 'Existing Customer Orders', rate: '3.5%', type: 'Real Cashback'),
      const _RateTier(category: 'Special Promo Events', rate: 'Up to 10%', type: 'Bonus'),
    ];
  }

  List<_StoreCoupon> _getCouponsForStore(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('agoda')) {
      return const [
        _StoreCoupon(
          code: 'AGODAHOTEL',
          title: 'Flat 10% Extra Discount',
          discount: '10% OFF',
          minOrder: 'No Min Order',
          validity: 'Valid till 31 Oct',
          description: 'Applicable on select international and domestic stays.',
        ),
        _StoreCoupon(
          code: 'STAYMORE',
          title: 'Special Long Stay Voucher',
          discount: '15% OFF',
          minOrder: 'Min. 3 Nights',
          validity: 'Valid till 15 Nov',
          description: 'Valid on partner resort villas and vacation rentals.',
        ),
      ];
    } else if (lower.contains('myntra')) {
      return const [
        _StoreCoupon(
          code: 'MYNTRA500',
          title: 'Flat ₹500 OFF',
          discount: '₹500 OFF',
          minOrder: 'Min. Order ₹2,499',
          validity: 'Valid till 30 Sep',
          description: 'Applicable on select Fashion and Footwear collections.',
        ),
        _StoreCoupon(
          code: 'FASHION15',
          title: 'Extra 15% OFF',
          discount: '15% OFF',
          minOrder: 'Min. Order ₹1,499',
          validity: 'Valid till 25 Sep',
          description: 'Max discount up to ₹450 on leading apparel brands.',
        ),
      ];
    } else if (lower.contains('ajio')) {
      return const [
        _StoreCoupon(
          code: 'AJIOMAN10',
          title: 'Extra 10% OFF',
          discount: '10% OFF',
          minOrder: 'Min. Order ₹1,999',
          validity: 'Valid till 15 Oct',
          description: 'Valid on Trends & AJIO Luxe collections.',
        ),
      ];
    }

    return [
      _StoreCoupon(
        code: '${_resolvedName.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '')}SPECIAL',
        title: 'Special Partner Voucher',
        discount: 'Flat 10% OFF',
        minOrder: 'Min. Order ₹999',
        validity: 'Valid this month',
        description: 'Exclusive partner discount combined with KashIQ Cashback.',
      ),
    ];
  }

  static const List<String> _termsSnippets = [
    'Only use coupon codes mentioned on KashIQ and official store website to guarantee cashback tracking.',
    'Do not visit other coupon or price comparison sites or browser extensions after clicking from KashIQ.',
    'Cashback is calculated on the net order amount excluding GST, delivery charges, and wallet credits.',
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _termsController = PageController();

    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      if (_bannerController.hasClients) {
        final heroBanners = _getHeroBanners(_resolvedName);
        if (heroBanners.length > 1) {
          final nextIndex = (_currentBannerIndex + 1) % heroBanners.length;
          _bannerController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _bannerController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  Future<void> _handleShopNow() async {
    var targetUrl = (widget.websiteUrl ?? widget.brand?.websiteUrl ?? '').trim();
    if (targetUrl.isEmpty) {
      targetUrl = ProductDetailScreen.resolveStoreUrl(_resolvedName);
    }

    HapticFeedback.lightImpact();

    if (mounted) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.rocket_launch_rounded,
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Opening $_resolvedName... Cashback will be auto-tracked!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: primaryAccent,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    var success = await UrlLauncherService.openUrl(targetUrl);
    if (!success) {
      final fallback = ProductDetailScreen.resolveStoreUrl(_resolvedName);
      if (fallback != targetUrl) {
        success = await UrlLauncherService.openUrl(fallback);
      }
    }

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open $_resolvedName website. Please check your internet connection.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showCashbackRatesSheet(BuildContext context, bool isDark) {
    final rateTiers = _getRateTiers(_resolvedName);
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              Row(
                children: [
                  Text(
                    '$_resolvedName Cashback Rates',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: textMuted, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Category-wise rate breakdown applicable on your purchases.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: textMuted,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1712) : const Color(0xFFFAF6F0),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFF423226) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: rateTiers.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: isDark ? const Color(0xFF423226) : const Color(0xFFE2E8F0),
                    ),
                    itemBuilder: (context, index) {
                      final tier = rateTiers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                tier.category,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textDark,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryAccent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                tier.rate,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: primaryAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAccent,
                    foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _handleShopNow();
                  },
                  child: Text(
                    'Shop & Earn Now',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDetailExplanation(BuildContext context, String title, String explanation, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) {
        final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
        final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
        final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
        final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;

        return AlertDialog(
          backgroundColor: cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
          ),
          content: Text(
            explanation,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: textMuted,
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Got It',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color: primaryAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAllTermsSheet(BuildContext context, bool isDark) {
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    'Terms & Conditions',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: textMuted, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '• Cashback will be added to your KashIQ wallet as "Pending" within 36 hours.\n\n'
                '• Cashback will be confirmed within 60 days post completion of your booking or delivery return period.\n\n'
                '• Only use coupons listed on KashIQ and the official merchant website.\n\n'
                '• Do not visit other coupon or comparison websites after clicking out from KashIQ.\n\n'
                '• If you cancel, return, or exchange the order, cashback will be cancelled.\n\n'
                '• Real cashback can be transferred directly to your Bank Account or UPI once confirmed.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  height: 1.5,
                  color: textMuted,
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFFAF6F0);
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;

    final heroBanners = _getHeroBanners(_resolvedName);
    final coupons = _getCouponsForStore(_resolvedName);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. TOP HERO BANNER CAROUSEL WITH OVERLAY BUTTONS & PILLS
                  Stack(
                    children: [
                      // Banner PageView
                      SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: PageView.builder(
                          controller: _bannerController,
                          itemCount: heroBanners.length,
                          onPageChanged: (idx) {
                            setState(() {
                              _currentBannerIndex = idx;
                            });
                          },
                          itemBuilder: (context, index) {
                            return NetworkImageWithSkeleton(
                              imageUrl: heroBanners[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 250,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: isDark ? const Color(0xFF2D221A) : const Color(0xFFF3ECE4),
                                child: Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 48,
                                    color: textMuted.withValues(alpha: 0.4),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Gradient overlay on bottom of banner for seamless look
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.5),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Floating Top Action Buttons (Back & Share)
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Circular Back Button
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF2C2018).withValues(alpha: 0.92)
                                        : Colors.white.withValues(alpha: 0.92),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: borderColor,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.12),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: textDark,
                                    size: 20,
                                  ),
                                ),
                              ),

                              // Circular Share Button
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text:
                                          'Check out $_resolvedName on KashIQ and earn $_resolvedCashback!',
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Store link copied to clipboard!',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: isDark ? const Color(0xFF0F172A) : Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      backgroundColor: primaryAccent,
                                      duration: const Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF2C2018).withValues(alpha: 0.92)
                                        : Colors.white.withValues(alpha: 0.92),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: borderColor,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.12),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.share_outlined,
                                    color: textDark,
                                    size: 19,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Pill-Style Page Indicators (overlay bottom)
                      Positioned(
                        bottom: 14,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(heroBanners.length, (index) {
                            final isActive = _currentBannerIndex == index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: isActive ? 28 : 20,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? (isDark ? primaryAccent : Colors.white)
                                    : Colors.white.withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),

                  // 2. BRAND LOGO BOX (Positioned below carousel on the left)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Container(
                      width: 96,
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: borderColor,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _resolvedLogo.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: NetworkImageWithSkeleton(
                                imageUrl: _resolvedLogo,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildBrandMonogram(_resolvedName, primaryAccent),
                              ),
                            )
                          : _buildBrandMonogram(_resolvedName, primaryAccent),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 3. CASHBACK HEADLINE (Flat ~2%~ 7% Cashback on all orders)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: textDark,
                              height: 1.15,
                            ),
                            children: [
                              const TextSpan(text: 'Flat '),
                              TextSpan(
                                text: '2%',
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: textMuted,
                                  decorationThickness: 2,
                                  color: textMuted,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 26,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Warm Brand Cashback Highlight Text
                        Text(
                          _resolvedCashback.toLowerCase().contains('cashback')
                              ? _resolvedCashback
                              : '$_resolvedCashback Cashback',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: primaryAccent,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Subtitle
                        Text(
                          _resolvedCategory.toLowerCase().contains('travel') ||
                                  _resolvedName.toLowerCase().contains('agoda')
                              ? 'on all $_resolvedName Hotel Bookings'
                              : 'on all $_resolvedName Orders',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: textMuted,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // View Cashback Rates -> Button
                        GestureDetector(
                          onTap: () => _showCashbackRatesSheet(context, isDark),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View Cashback Rates',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: primaryAccent,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 15,
                                color: primaryAccent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 4. IMPORTANT DETAILS SECTION (3 Clean Cards)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Important Details',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Top Row: Card 1 (Tracks in 36 Hours) & Card 2 (Confirms in 60 Days)
                        Row(
                          children: [
                            Expanded(
                              child: _buildImportantDetailCard(
                                title: 'Cashback tracks in',
                                value: '36',
                                subtitle: 'Hours',
                                isDark: isDark,
                                cardBg: cardBg,
                                borderColor: borderColor,
                                textDark: textDark,
                                valueColor: primaryAccent,
                                onTap: () => _showDetailExplanation(
                                  context,
                                  'Cashback Tracking Time',
                                  'Your purchase on $_resolvedName is tracked and recorded as "Pending" in your KashIQ wallet within 36 hours.',
                                  isDark,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildImportantDetailCard(
                                title: 'Cashback confirms in',
                                value: '60',
                                subtitle: 'Days',
                                isDark: isDark,
                                cardBg: cardBg,
                                borderColor: borderColor,
                                textDark: textDark,
                                valueColor: primaryAccent,
                                onTap: () => _showDetailExplanation(
                                  context,
                                  'Cashback Confirmation Period',
                                  'After completion of the booking stay or product return window, cashback is verified and confirmed within 60 days.',
                                  isDark,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Card 3: Cashback on App Orders? YES
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 44) / 2,
                          child: _buildImportantDetailCard(
                            title: 'Cashback on $_resolvedName app orders?',
                            value: 'YES',
                            subtitle: '',
                            isDark: isDark,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            textDark: textDark,
                            valueColor: primaryAccent,
                            onTap: () => _showDetailExplanation(
                              context,
                              'App Orders Eligible',
                              'Both website and official mobile app orders are fully eligible for cashback when initiated through KashIQ.',
                              isDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  // 5. IMPORTANT TERMS & CONDITIONS SECTION (Card carousel)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Important Terms & Conditions',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Terms Card Carousel Container
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                              height: 75,
                              child: PageView.builder(
                                controller: _termsController,
                                itemCount: _termsSnippets.length,
                                onPageChanged: (idx) {
                                  setState(() {
                                    _currentTermsIndex = idx;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _termsSnippets[index],
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: textDark,
                                            height: 1.4,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Clean Announcement Icon Container (No emoji)
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? AppColors.darkSurface
                                              : const Color(0xFFF1F5F9),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: borderColor,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.campaign_outlined,
                                            size: 24,
                                            color: primaryAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Dots indicator for Terms
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_termsSnippets.length, (index) {
                            final isActive = _currentTermsIndex == index;
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2.5),
                              width: isActive ? 6 : 5,
                              height: isActive ? 6 : 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive
                                    ? primaryAccent
                                    : (isDark ? Colors.white24 : borderColor),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 8),

                        // View All Terms & Conditions ->
                        GestureDetector(
                          onTap: () => _showAllTermsSheet(context, isDark),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'View All Terms & Conditions',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: primaryAccent,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14,
                                  color: primaryAccent,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 6. ACTIVE STORE COUPONS SECTION (Extra Value)
                  if (coupons.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Vouchers for $_resolvedName',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: coupons.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final coupon = coupons[index];
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            coupon.title,
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: textDark,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            coupon.description,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 11.5,
                                              color: textMuted,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            coupon.validity,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.success,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryAccent.withValues(alpha: 0.1),
                                        foregroundColor: primaryAccent,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          side: BorderSide(color: primaryAccent, width: 0.8),
                                        ),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: coupon.code));
                                        HapticFeedback.lightImpact();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Voucher code "${coupon.code}" copied!'),
                                            backgroundColor: primaryAccent,
                                            duration: const Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        coupon.code,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                          color: primaryAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // 7. STICKY BOTTOM ACTION BUTTON
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: cardBg,
              border: Border(
                top: BorderSide(color: borderColor, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAccent,
                    foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _handleShopNow,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Earn Cashback on $_resolvedName',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantDetailCard({
    required String title,
    required String value,
    required String subtitle,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textDark,
    required Color valueColor,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 12, 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textDark,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),

          // Big Brand Value + Arrow Circle Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: valueColor,
                      height: 1.0,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                  ],
                ],
              ),

              // Small circular arrow button
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: borderColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 13,
                      color: valueColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBrandMonogram(String name, Color primaryAccent) {
    final clean = StoreDetailScreen.cleanTitle(name);
    final initial = clean.isNotEmpty ? clean[0].toUpperCase() : 'S';
    return Center(
      child: Text(
        initial,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: primaryAccent,
        ),
      ),
    );
  }
}
