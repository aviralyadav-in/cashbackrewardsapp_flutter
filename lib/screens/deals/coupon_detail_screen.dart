import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/home_discovery_models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/network_image_with_skeleton.dart';
import '../products/product_detail_screen.dart';
import '../../services/url_launcher_service.dart';

class CouponDetailScreen extends StatefulWidget {
  static const String routeName = '/coupon-detail';

  final HomeCouponModel coupon;

  const CouponDetailScreen({
    super.key,
    required this.coupon,
  });

  @override
  State<CouponDetailScreen> createState() => _CouponDetailScreenState();
}

class _CouponDetailScreenState extends State<CouponDetailScreen> {
  bool _isCopied = false;

  void _handleCopyCode() {
    Clipboard.setData(ClipboardData(text: widget.coupon.code));
    HapticFeedback.mediumImpact();

    setState(() {
      _isCopied = true;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E1712),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFF16A34A),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Coupon Code ',
                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13),
                    ),
                    TextSpan(
                      text: widget.coupon.code,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFFFBBF24),
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text: ' copied to clipboard!',
                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  Future<void> _handleGoToStore() async {
    final storeName = widget.coupon.store;
    final targetUrl = ProductDetailScreen.resolveStoreUrl(storeName);

    HapticFeedback.lightImpact();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Opening $storeName... Code ${widget.coupon.code} copied & cashback active!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFFA5A00),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    await UrlLauncherService.openUrl(targetUrl);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final coupon = widget.coupon;

    final bg = isDark ? AppColors.darkBackground : AppColors.mainBackground;
    final cardBg = isDark ? AppColors.darkCard : AppColors.cardBackground;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textDark = isDark ? AppColors.darkTextPrimary : AppColors.deepBrown;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final primaryAccent = isDark ? AppColors.darkPrimary : AppColors.primaryBrown;

    final resolvedLogo = coupon.logoUrl.isNotEmpty
        ? coupon.logoUrl
        : HomeCouponModel.resolveLogo(coupon.store);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.mainBackground,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Coupon Details',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. TOP HERO: BRAND LOGO + BRAND NAME + OFFER HEADLINE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Large Brand Logo Container (Clearly Visible & Elevated)
                        Container(
                          width: 84,
                          height: 84,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2C2018) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? const Color(0xFF5A4435) : const Color(0xFFE2E8F0),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: resolvedLogo.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: NetworkImageWithSkeleton(
                                    imageUrl: resolvedLogo,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => _buildBrandMonogram(coupon.store, primaryAccent),
                                  ),
                                )
                              : _buildBrandMonogram(coupon.store, primaryAccent),
                        ),
                        const SizedBox(height: 14),

                        // Brand Name (Prominent & Clean)
                        Text(
                          coupon.store.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: primaryAccent,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Discount Title
                        Text(
                          coupon.discount,
                          style: GoogleFonts.inter(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // Description
                        Text(
                          coupon.description,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: textMuted,
                            height: 1.45,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),

                        // Success Rate & Verified Partner Badges
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          alignment: WrapAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: isDark ? 0.2 : 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.bolt_rounded, size: 14, color: Colors.green.shade700),
                                  const SizedBox(width: 3),
                                  Text(
                                    coupon.successRate,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: (isDark ? AppColors.darkPrimary : AppColors.primaryBrown)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified_rounded, size: 14, color: primaryAccent),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Verified Partner',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: primaryAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 2. REVEALED COUPON VOUCHER CODE BOX
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF281C15) : const Color(0xFFFBF4EB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? const Color(0xFF6B4D36) : const Color(0xFFDFCABA),
                        width: 1.4,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.confirmation_number_outlined, size: 16, color: primaryAccent),
                            const SizedBox(width: 6),
                            Text(
                              'OFFICIAL COUPON VOUCHER',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: primaryAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1510) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? const Color(0xFF7A5940) : const Color(0xFFD4BBA5),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                coupon.code,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 3,
                                  color: textDark,
                                ),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: _handleCopyCode,
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: (isDark ? AppColors.darkPrimary : AppColors.primaryBrown)
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    _isCopied ? Icons.check_circle_rounded : Icons.copy_rounded,
                                    size: 16,
                                    color: primaryAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap "Copy Code" at the bottom to paste at checkout.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 3. KEY OFFER SPECIFICATIONS GRID
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Offer Details & Requirements',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Applies To
                        _buildDetailRow(
                          icon: Icons.category_outlined,
                          title: 'Applies To',
                          value: coupon.applicableOn,
                          textDark: textDark,
                          textMuted: textMuted,
                          primaryAccent: primaryAccent,
                          isDark: isDark,
                        ),
                        Divider(height: 20, color: borderColor.withValues(alpha: 0.6)),

                        // Minimum Order Value
                        _buildDetailRow(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Minimum Order Value',
                          value: coupon.minOrder > 0
                              ? '₹${coupon.minOrder.toInt()} (Cart total before discounts)'
                              : 'No minimum order required',
                          textDark: textDark,
                          textMuted: textMuted,
                          primaryAccent: primaryAccent,
                          isDark: isDark,
                        ),
                        Divider(height: 20, color: borderColor.withValues(alpha: 0.6)),

                        // Expiry / Validity
                        _buildDetailRow(
                          icon: Icons.event_available_outlined,
                          title: 'Validity / Expiry',
                          value: '${coupon.validity} (Limited period promotional offer)',
                          textDark: textDark,
                          textMuted: textMuted,
                          primaryAccent: primaryAccent,
                          isDark: isDark,
                        ),
                        if (coupon.cashback.isNotEmpty) ...[
                          Divider(height: 20, color: borderColor.withValues(alpha: 0.6)),
                          // Extra Cashback
                          _buildDetailRow(
                            icon: Icons.account_balance_wallet_outlined,
                            title: 'Extra KashIQ Cashback',
                            value: '${coupon.cashback} added to your wallet automatically',
                            textDark: textDark,
                            textMuted: textMuted,
                            primaryAccent: const Color(0xFF16A34A),
                            isDark: isDark,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 4. TERMS & CONDITIONS SECTION
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.shield_outlined, size: 16, color: primaryAccent),
                            const SizedBox(width: 8),
                            Text(
                              'Important Terms & Conditions',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...coupon.terms.map((term) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: primaryAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    term,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      height: 1.4,
                                      color: textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 5. STICKY BOTTOM ACTION BAR: COPY CODE & GO TO STORE
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: cardBg,
              border: Border(top: BorderSide(color: borderColor, width: 1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Action 1: COPY CODE
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _handleCopyCode,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _isCopied ? const Color(0xFF16A34A) : primaryAccent,
                            width: 1.4,
                          ),
                          foregroundColor: _isCopied ? const Color(0xFF16A34A) : primaryAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        icon: Icon(
                          _isCopied ? Icons.check_circle_rounded : Icons.copy_rounded,
                          size: 16,
                          color: _isCopied ? const Color(0xFF16A34A) : primaryAccent,
                        ),
                        label: Text(
                          _isCopied ? 'COPIED!' : 'Copy Code',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Action 2: GO TO STORE
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _handleGoToStore,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        icon: const Icon(Icons.open_in_new_rounded, size: 16),
                        label: Text(
                          'Go to Store',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandMonogram(String storeName, Color accent) {
    final initial = storeName.isNotEmpty ? storeName[0].toUpperCase() : 'S';
    return Center(
      child: Text(
        initial,
        style: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: accent,
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    required Color textDark,
    required Color textMuted,
    required Color primaryAccent,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryAccent.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 17, color: primaryAccent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
