import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/brand_model.dart';
import '../../screens/product_detail_screen.dart';
import '../../theme/app_theme.dart';
import '../network_image_with_skeleton.dart';

class GridBrandCard extends StatelessWidget {
  final BrandModel brand;
  final bool isDark;
  final VoidCallback? onTap;
  final int? columnIndex;

  const GridBrandCard({
    super.key,
    required this.brand,
    required this.isDark,
    this.onTap,
    this.columnIndex,
  });

  int get _effectiveColumnIndex {
    if (columnIndex != null) {
      return columnIndex! % 3;
    }
    return brand.name.hashCode.abs() % 3;
  }

  Color _getHeaderBackgroundColor(int colIndex) {
    if (isDark) {
      switch (colIndex) {
        case 0: // Soft warm peach (dark)
          return const Color(0xFF3E281C);
        case 1: // Soft sage green (dark)
          return const Color(0xFF223620);
        case 2: // Soft sky blue (dark)
        default:
          return const Color(0xFF1B2F42);
      }
    } else {
      switch (colIndex) {
        case 0: // Soft warm peach (light)
          return const Color(0xFFFDE8D8);
        case 1: // Soft sage green (light)
          return const Color(0xFFD8E8D2);
        case 2: // Soft sky blue (light)
        default:
          return const Color(0xFFD2E8F6);
      }
    }
  }

  Color _getHeaderTextColor(int colIndex) {
    if (isDark) {
      switch (colIndex) {
        case 0:
          return const Color(0xFFFFDFCC);
        case 1:
          return const Color(0xFFD3EED0);
        case 2:
        default:
          return const Color(0xFFCBE6FC);
      }
    } else {
      switch (colIndex) {
        case 0:
          return const Color(0xFF321E14);
        case 1:
          return const Color(0xFF1E2D1A);
        case 2:
        default:
          return const Color(0xFF16293A);
      }
    }
  }

  bool _isLiveOrSale(String text) {
    final lower = text.toLowerCase();
    return lower.contains('live') || lower.contains('sale') || lower.contains('hot');
  }

  String _cleanOfferText(String rawText) {
    final trimmed = rawText.trim();
    if (trimmed.isEmpty) return 'Special Offer';
    if (trimmed.length <= 22) return trimmed;

    // Detect compact discount or offer phrase within longer marketing copy
    final match = RegExp(
      r'(?:upto|up to|flat)?\s*\d+(?:[.-]\d+)?%?\s*(?:-\s*\d+%?)?\s*(?:off|cashback|rewards)?',
      caseSensitive: false,
    ).firstMatch(trimmed);

    if (match != null && match.group(0)!.trim().length >= 4) {
      final extracted = match.group(0)!.trim();
      if (!extracted.toLowerCase().contains('off') &&
          !extracted.toLowerCase().contains('cashback') &&
          !extracted.toLowerCase().contains('rewards')) {
        return '$extracted Off';
      }
      return extracted;
    }

    return trimmed;
  }

  List<String> _splitRewardsText(String rawText) {
    final trimmed = rawText.trim();
    if (trimmed.isEmpty) return ['', ''];
    if (trimmed.contains('\n')) {
      final parts = trimmed.split('\n');
      return [parts[0], parts.length > 1 ? parts[1] : ''];
    }

    // Detect common reward keywords at the end
    final keywordPattern = RegExp(
      r'^(.*?)\s+(rewards?|bonus(?:es)?|cashback|off)$',
      caseSensitive: false,
    );
    final match = keywordPattern.firstMatch(trimmed);
    if (match != null) {
      return [match.group(1) ?? '', match.group(2) ?? ''];
    }

    // Fallback: If multiple words, split before the last word
    final lastSpaceIndex = trimmed.lastIndexOf(' ');
    if (lastSpaceIndex != -1) {
      return [
        trimmed.substring(0, lastSpaceIndex),
        trimmed.substring(lastSpaceIndex + 1),
      ];
    }

    return [trimmed, ''];
  }

  @override
  Widget build(BuildContext context) {
    final logoUrl = brand.logoUrl.isNotEmpty
        ? brand.logoUrl
        : (brand.bannerUrl.isNotEmpty
            ? brand.bannerUrl
            : brand.websiteUrl);

    final colIndex = _effectiveColumnIndex;
    final headerBgColor = _getHeaderBackgroundColor(colIndex);
    final headerTextColor = _getHeaderTextColor(colIndex);
    final offerText = _cleanOfferText(brand.offerText);
    final showLiveDot = _isLiveOrSale(brand.offerText);
    final rewardParts = _splitRewardsText(brand.cashbackPercentage);
    final rewardLine1 = rewardParts[0];
    final rewardLine2 = rewardParts[1];

    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen.fromBrand(brand),
              ),
            );
          },
      child: Container(
        height: 158,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF231A15) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? const Color(0xFF3F3027)
                : const Color(0xFFE8DFD5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.3 : 0.05,
              ),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ------------------------------------------
              // TOP OFFER BANNER ("Off %" Section)
              // ------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 6.5,
                ),
                decoration: BoxDecoration(
                  color: headerBgColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.04),
                      width: 0.8,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        offerText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fraunces(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: headerTextColor,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                    if (showLiveDot) ...[
                      const SizedBox(width: 4.5),
                      Container(
                        width: 5.5,
                        height: 5.5,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ------------------------------------------
              // BRAND LOGO
              // ------------------------------------------
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 46,
                        maxWidth: 94,
                      ),
                      child: NetworkImageWithSkeleton(
                        imageUrl: logoUrl,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              brand.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fraunces(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // ------------------------------------------
              // REWARDS PILL BUTTON (Two Lines)
              // ------------------------------------------
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2C1910)
                      : const Color(0xFF382218),
                  borderRadius: BorderRadius.circular(10),
                  border: isDark
                      ? Border.all(
                          color: const Color(0xFF4B3224),
                          width: 0.8,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.3 : 0.16,
                      ),
                      blurRadius: 4,
                      offset: const Offset(0, 1.5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      rewardLine1,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fraunces(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.18,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (rewardLine2.isNotEmpty)
                      Text(
                        rewardLine2,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.fraunces(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.18,
                          letterSpacing: 0.2,
                        ),
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