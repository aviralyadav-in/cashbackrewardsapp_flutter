import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/brand_model.dart';
import '../../screens/all_stores_screen.dart';
import '../../screens/store_detail_screen.dart';
import '../../theme/app_theme.dart';
import '../network_image_with_skeleton.dart';

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
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;

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
          height: 194,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
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
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);

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
          onTap: () {
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
          },
          child: Column(
            children: [
              // Upper half
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildStoreLogo(store.logoUrl, store.name),
                      ),
                    ),
                  ),
                ),
              ),

              // Lower half
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      // Offer Tag / Description
                      Text(
                        store.offerText.isNotEmpty ? store.offerText : store.category,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? const Color(0xFF2563EB) : const Color(0xFF2563EB),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),

                      const Spacer(),

                      // Cashback Rate Highlight Pill
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1C2D5A) : const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? const Color(0xFF7A4A28) : const Color(0xFFFBD7B3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          store.cashbackPercentage,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF2563EB),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
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
  }

  Widget _buildStoreLogo(String logoUrl, String name) {
    if (logoUrl.startsWith('assets/')) {
      return Image.asset(
        logoUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _fallbackText(name),
      );
    } else if (logoUrl.startsWith('http')) {
      return NetworkImageWithSkeleton(
        imageUrl: logoUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _fallbackText(name),
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
          color: const Color(0xFF2563EB),
        ),
      ),
    );
  }
}
