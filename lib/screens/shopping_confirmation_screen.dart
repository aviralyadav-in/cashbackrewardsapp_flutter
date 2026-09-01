import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/brand_model.dart';
import '../services/url_launcher_service.dart';
import '../theme/app_theme.dart';
import '../widgets/network_image_with_skeleton.dart';

class ShoppingConfirmationScreen extends StatelessWidget {
  static const String routeName = '/shopping-confirmation';

  final BrandModel brand;

  const ShoppingConfirmationScreen({
    super.key,
    required this.brand,
  });

  Future<void> _handleShopNow(BuildContext context) async {
    final success = await UrlLauncherService.openUrl(brand.websiteUrl);

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open ${brand.name} website: ${brand.websiteUrl}'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.mainBackground,
        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          brand.name,
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              // BRAND HEADER CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Brand Logo
                    Container(
                      width: 90,
                      height: 90,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.border,
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: NetworkImageWithSkeleton(
                          imageUrl: brand.logoUrl,
                          width: 66,
                          height: 66,
                          fit: BoxFit.contain,
                          shape: BoxShape.circle,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                brand.name.substring(0, 1).toUpperCase(),
                                style: GoogleFonts.fraunces(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Brand Name
                    Text(
                      brand.name,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.screenHeading(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                      ).copyWith(fontSize: 22),
                    ),

                    const SizedBox(height: 6),

                    // Category Tag
                    if (brand.category.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          brand.category,
                          style: AppTextStyles.smallLabel(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.deepBrown,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),
                    Divider(color: isDark ? AppColors.darkBorder : AppColors.border),
                    const SizedBox(height: 16),

                    // Cashback Rate Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBrown,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBrown.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            brand.cashbackPercentage,
                            style: GoogleFonts.fraunces(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Offer Details
                    if (brand.offerText.isNotEmpty)
                      Text(
                        brand.offerText,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // CONFIRMATION NOTICE
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'You are about to be redirected to ${brand.name}. Shop as normal to earn guaranteed cashback!',
                        style: AppTextStyles.body(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // SHOP NOW BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _handleShopNow(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: AppColors.cardBackground,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                    ),
                  ),
                  icon: const Icon(Icons.open_in_new, size: 20),
                  label: Text(
                    'Shop Now at ${brand.name}',
                    style: AppTextStyles.buttonText(
                      color: AppColors.cardBackground,
                    ).copyWith(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
