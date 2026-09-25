import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/coupon_optimizer_service.dart';
import '../../services/url_launcher_service.dart';
import '../../theme/app_theme.dart';

class SmartCouponOptimizerScreen extends StatefulWidget {
  static const String routeName = '/smart-coupon-optimizer';

  final String? initialStore;
  final double? initialCartValue;

  const SmartCouponOptimizerScreen({
    super.key,
    this.initialStore,
    this.initialCartValue,
  });

  @override
  State<SmartCouponOptimizerScreen> createState() =>
      _SmartCouponOptimizerScreenState();
}

class _SmartCouponOptimizerScreenState
    extends State<SmartCouponOptimizerScreen> {
  final TextEditingController _cartController = TextEditingController();

  late String _selectedStore;
  String _selectedBank = 'None';
  double _cartValue = 2499.0;
  CouponOptimizationSummary? _summary;

  static const List<String> _stores = [
    'Myntra',
    'AJIO',
    'Flipkart',
    'Amazon',
    'Nykaa',
    'Swiggy',
    'All Stores',
  ];

  static const List<double> _quickAmounts = [
    499,
    999,
    1499,
    1999,
    2499,
    3499,
    4999,
    9999,
  ];

  static const List<String> _banks = [
    'None',
    'HDFC Bank',
    'ICICI Bank',
    'SBI Card',
    'Axis Bank',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStore = widget.initialStore ?? 'Myntra';
    _cartValue = widget.initialCartValue ?? 2499.0;
    _cartController.text = _cartValue.toInt().toString();
    _runOptimization();
  }

  @override
  void dispose() {
    _cartController.dispose();
    super.dispose();
  }

  void _runOptimization() {
    final parsed = double.tryParse(_cartController.text.trim()) ?? _cartValue;
    setState(() {
      _cartValue = parsed > 0 ? parsed : 500;
      _summary = CouponOptimizerService.optimize(
        store: _selectedStore,
        cartValue: _cartValue,
        bankCard: _selectedBank == 'None' ? null : _selectedBank,
      );
    });
  }

  void _copyCoupon(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              'Coupon "$code" copied to clipboard!',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryBrown,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
        title: Text(
          '⚡ Smart Coupon Optimizer',
          style: GoogleFonts.inter(
            fontSize: 18.5,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.cardBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: textDark),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Recalculate',
            onPressed: _runOptimization,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // Subtitle / explanation header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF132247), const Color(0xFF1C2D5A)]
                    : [const Color(0xFFF9F1E8), const Color(0xFFF1F5F9)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 0.8),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.primaryBrown,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI-Powered Coupon Stacking',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Enter your cart value & choose store to find the single highest-saving coupon.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: textMuted,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 1. SELECT STORE
          Text(
            '1. Select Store',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _stores.map((store) {
                final isSelected = _selectedStore == store;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(store),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _selectedStore = store;
                        });
                        _runOptimization();
                      }
                    },
                    selectedColor: AppColors.primaryBrown,
                    labelStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.darkTextPrimary : AppColors.deepBrown),
                    ),
                    backgroundColor: cardBg,
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryBrown : borderColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),

          // 2. ENTER CART VALUE
          Text(
            '2. Your Order / Cart Value (₹)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: TextField(
              controller: _cartController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 14, right: 8),
                  child: Center(
                    widthFactor: 0,
                    child: Text(
                      '₹',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBrown,
                      ),
                    ),
                  ),
                ),
                hintText: 'e.g. 2499',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  color: textMuted.withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.primaryBrown),
                  onPressed: _runOptimization,
                ),
              ),
              onSubmitted: (_) => _runOptimization(),
            ),
          ),
          const SizedBox(height: 10),

          // Quick cart value chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _quickAmounts.map((amt) {
                final isCurrent = _cartValue == amt;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ActionChip(
                    label: Text('₹${amt.toInt()}'),
                    onPressed: () {
                      _cartController.text = amt.toInt().toString();
                      _runOptimization();
                    },
                    backgroundColor: isCurrent
                        ? AppColors.primaryBrown.withValues(alpha: 0.15)
                        : (isDark ? const Color(0xFF132247) : const Color(0xFFF3EFE9)),
                    labelStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isCurrent ? AppColors.primaryBrown : textMuted,
                    ),
                    side: BorderSide(
                      color: isCurrent ? AppColors.primaryBrown : borderColor,
                      width: 0.8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),

          // 3. PAYMENT METHOD (BANK CARD)
          Row(
            children: [
              Text(
                '3. Bank Card / Payment Offer',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              const Spacer(),
              Text(
                'Optional Stacking',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBrown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBank,
                isExpanded: true,
                dropdownColor: cardBg,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryBrown),
                items: _banks.map((b) {
                  return DropdownMenuItem<String>(
                    value: b,
                    child: Text(
                      b == 'None' ? '💳 No specific bank card' : '💳 $b (Instant Discount)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedBank = val;
                    });
                    _runOptimization();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 22),

          // OPTIMIZE BUTTON
          ElevatedButton(
            onPressed: _runOptimization,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBrown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt_rounded, size: 22),
                const SizedBox(width: 8),
                Text(
                  '⚡ Find Maximum Savings Coupon',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // RESULTS SECTION
          if (_summary != null) ...[
            _buildResultsSection(context, _summary!, textDark, textMuted, borderColor, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildResultsSection(
    BuildContext context,
    CouponOptimizationSummary summary,
    Color textDark,
    Color textMuted,
    Color borderColor,
    bool isDark,
  ) {
    final best = summary.bestCoupon;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Row(
          children: [
            Text(
              'Optimization Results',
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.successBackground,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Save Up to ₹${summary.maxPossibleSavings.toInt()}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // WINNING COUPON HERO CARD
        if (best != null) ...[
          _buildWinningCouponCard(context, best, summary, textDark, textMuted, isDark),
          const SizedBox(height: 18),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF132247) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.primaryBrown, size: 28),
                const SizedBox(height: 8),
                Text(
                  'No direct coupons eligible for ₹${summary.cartValue.toInt()} yet.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Check the unlockable coupons below to see how much more to add to your cart.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
        ],

        // UNLOCK MORE SAVINGS (If available)
        if (summary.unlockableCoupons.isNotEmpty) ...[
          _buildUnlockableSection(summary.unlockableCoupons, textDark, textMuted, isDark),
          const SizedBox(height: 18),
        ],

        // ALL OTHER ELIGIBLE COUPONS
        if (summary.eligibleCoupons.length > 1) ...[
          Text(
            'All Tested Alternative Coupons',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
          ),
          const SizedBox(height: 10),
          ...summary.eligibleCoupons.skip(1).map((res) {
            return _buildAlternativeCouponCard(res, textDark, textMuted, borderColor, isDark);
          }),
        ],
      ],
    );
  }

  Widget _buildWinningCouponCard(
    BuildContext context,
    OptimizedCouponResult best,
    CouponOptimizationSummary summary,
    Color textDark,
    Color textMuted,
    bool isDark,
  ) {
    final coupon = best.coupon;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2E2218), const Color(0xFF382B20)]
              : [const Color(0xFFFFF9F2), const Color(0xFFF9EFE4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBrown.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Winner Ribbon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF4A3424) : AppColors.primaryBrown,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_rounded, color: Color(0xFFFFD700), size: 18),
                const SizedBox(width: 8),
                Text(
                  'WINNING BEST COUPON (MAXIMUM SAVINGS)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  coupon.store,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFFE8D1),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Coupon Code Box & Copy Button
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1712) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? const Color(0xFF5A4434) : const Color(0xFFE2E8F0),
                            style: BorderStyle.solid,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              coupon.code,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                                color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              coupon.discount,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () => _copyCoupon(coupon.code),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBrown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: Text(
                        'Copy',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Description
                Text(
                  coupon.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: textMuted,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 14),

                // SAVINGS WATERFALL BREAKDOWN
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF221A14) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        'Original Cart Value',
                        '₹${best.originalCartValue.toInt()}',
                        textDark,
                        isBold: false,
                      ),
                      const SizedBox(height: 6),
                      _buildSummaryRow(
                        'Promo Coupon Discount (${coupon.code})',
                        '-₹${best.couponDiscountAmount.toInt()}',
                        AppColors.success,
                        isBold: true,
                      ),
                      if (best.bankDiscountAmount > 0) ...[
                        const SizedBox(height: 6),
                        _buildSummaryRow(
                          'Bank Card Offer (${best.bankOfferApplied ?? 'Card Offer'})',
                          '-₹${best.bankDiscountAmount.toInt()}',
                          AppColors.success,
                          isBold: true,
                        ),
                      ],
                      if (best.cashbackAmount > 0) ...[
                        const SizedBox(height: 6),
                        _buildSummaryRow(
                          'KashIQ Real Cashback (${coupon.cashback})',
                          '-₹${best.cashbackAmount.toInt()}',
                          isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                          isBold: true,
                        ),
                      ],
                      const Divider(height: 18),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL SAVINGS',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: AppColors.success,
                                ),
                              ),
                              Text(
                                '₹${best.totalSavings.toInt()} OFF',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'FINAL PAYABLE',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: textMuted,
                                ),
                              ),
                              Text(
                                '₹${best.finalEffectivePrice.toInt()}',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Direct CTA
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _copyCoupon(coupon.code);
                      UrlLauncherService.openUrl(
                        'https://www.${coupon.store.toLowerCase().replaceAll(' ', '')}.com',
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryBrown,
                      side: const BorderSide(color: AppColors.primaryBrown, width: 1.2),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.open_in_new_rounded, size: 16),
                    label: Text(
                      'Copy Code & Shop on ${coupon.store}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String title,
    String value,
    Color valueColor, {
    bool isBold = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
              color: isBold ? null : const Color(0xFF88796E),
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildUnlockableSection(
    List<OptimizedCouponResult> unlockables,
    Color textDark,
    Color textMuted,
    bool isDark,
  ) {
    final topUnlockable = unlockables.first;
    final coupon = topUnlockable.coupon;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2216) : const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFF97316).withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_open_rounded, color: Color(0xFFF97316), size: 18),
              const SizedBox(width: 8),
              Text(
                'Unlock Even Bigger Savings!',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Add just ₹${topUnlockable.amountNeededToUnlock.toInt()} more to reach ₹${coupon.minOrder.toInt()} and unlock code "${coupon.code}" for ${coupon.discount}!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: textDark,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_cartValue / coupon.minOrder).clamp(0.0, 1.0),
            backgroundColor: const Color(0xFFFED7AA),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF97316)),
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeCouponCard(
    OptimizedCouponResult result,
    Color textDark,
    Color textMuted,
    Color borderColor,
    bool isDark,
  ) {
    final coupon = result.coupon;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF132247) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF33261D) : const Color(0xFFF5ECE2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        coupon.code,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      coupon.discount,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Saves ₹${result.totalSavings.toInt()}  •  Pay ₹${result.finalEffectivePrice.toInt()}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.primaryBrown),
            tooltip: 'Copy Code',
            onPressed: () => _copyCoupon(coupon.code),
          ),
        ],
      ),
    );
  }
}
