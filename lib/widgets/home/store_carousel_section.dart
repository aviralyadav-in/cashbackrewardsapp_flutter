import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/brand_asset_helper.dart';
import '../../models/brand_model.dart';
import '../../screens/stores/all_stores_screen.dart';
import '../../screens/stores/store_detail_screen.dart';
import '../../theme/app_theme.dart';
import '../common/network_image_with_skeleton.dart';

/// Reusable horizontal brand/store carousel section for themed subcategories
/// (e.g. Travel & Hotels, Personal Loans, Pharmacy & Health, Highest Cashback).
class StoreCarouselSection extends StatelessWidget {
  final bool isDark;
  final String? iconEmoji;
  final String title;
  final String? subtitle;
  final List<BrandModel> stores;
  final VoidCallback? onViewAllTap;

  const StoreCarouselSection({
    super.key,
    required this.isDark,
    this.iconEmoji,
    required this.title,
    this.subtitle,
    required this.stores,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (stores.isEmpty) return const SizedBox.shrink();

    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final primaryAccent = isDark ? AppColors.darkPrimary : AppColors.primaryBrown;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (iconEmoji != null && iconEmoji!.trim().isNotEmpty) ...[
                Text(
                  iconEmoji!,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 17.5,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty)
                      Text(
                        subtitle!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onViewAllTap ??
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AllStoresScreen(
                            title: title,
                            initialBrands: stores,
                            showCategoryFilter: false,
                          ),
                        ),
                      );
                    },
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: primaryAccent,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 15,
                        color: primaryAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal Brand Cards
        SizedBox(
          height: 182,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: stores.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final store = stores[index];
              return _buildStoreCard(context, store);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStoreCard(BuildContext context, BrandModel store) {
    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final offerLabel = store.offerText.isNotEmpty
        ? store.offerText
        : (store.category.isNotEmpty ? store.category : 'Hot Offer');

    return Container(
      width: 154,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToStoreDetail(context, store),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. TOP OFFER PILL (Positioned above the image)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : const Color(0xFFBFDBFE),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    offerLabel,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextSecondary : const Color(0xFF1D4ED8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 5),

                // 2. STORE/BRAND LOGO / IMAGE
                SizedBox(
                  height: 54,
                  width: double.infinity,
                  child: Center(
                    child: _buildStoreLogo(store.logoUrl, store.name),
                  ),
                ),
                const Spacer(),

                // 3. CASHBACK PILL (Positioned below the image)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF143823) : const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isDark ? const Color(0xFF059669).withValues(alpha: 0.35) : const Color(0xFFA7F3D0),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    store.cashbackPercentage,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 5),

                // 4. "SHOP NOW" CTA BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () => _navigateToStoreDetail(context, store),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.darkPrimary : const Color(0xFF1B1B1E),
                      foregroundColor: isDark ? AppColors.darkButtonText : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Shop Now',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 13.5,
                        ),
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

  void _navigateToStoreDetail(BuildContext context, BrandModel store) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StoreDetailScreen(
          brand: store,
          storeName: store.name,
          cashbackRate: store.cashbackPercentage,
          logoUrl: store.logoUrl,
          category: store.category,
          websiteUrl: store.websiteUrl,
        ),
      ),
    );
  }

  Widget _buildStoreLogo(String logoUrl, String name) {
    String effectiveUrl = logoUrl.trim();
    if (effectiveUrl.isEmpty) {
      effectiveUrl = BrandAssetHelper.getBrandLogo(name);
    } else if (!effectiveUrl.startsWith('assets/')) {
      final local = BrandAssetHelper.findLocalAssetForUrl(effectiveUrl);
      if (local != null) effectiveUrl = local;
    }

    final fallbackAsset = BrandAssetHelper.getBrandLogo(name);

    if (effectiveUrl.startsWith('assets/')) {
      return Image.asset(
        effectiveUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          if (fallbackAsset != effectiveUrl && fallbackAsset.startsWith('assets/')) {
            return Image.asset(
              fallbackAsset,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => _fallbackText(name),
            );
          }
          return _fallbackText(name);
        },
      );
    } else if (effectiveUrl.startsWith('http')) {
      return NetworkImageWithSkeleton(
        imageUrl: effectiveUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          if (fallbackAsset.startsWith('assets/')) {
            return Image.asset(
              fallbackAsset,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => _fallbackText(name),
            );
          }
          return _fallbackText(name);
        },
      );
    }

    return _fallbackText(name);
  }

  Widget _fallbackText(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'S',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
        ),
      ),
    );
  }
}
