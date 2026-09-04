import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class WithdrawScreen extends StatefulWidget {
  static const String routeName = '/withdraw';

  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _amountController =
      TextEditingController(text: '500');
  String _selectedMethod = 'upi'; // 'upi', 'bank', 'amazon'

  final List<Map<String, dynamic>> _recentWithdrawals = [
    {
      'id': 'WTH-984210',
      'date': '18 Aug 2026',
      'amount': '₹850.00',
      'method': 'UPI (deepak@okhdfcbank)',
      'status': 'Completed',
      'statusColor': AppColors.success,
    },
    {
      'id': 'WTH-773129',
      'date': '04 Aug 2026',
      'amount': '₹1,250.00',
      'method': 'HDFC Bank (A/C **4129)',
      'status': 'Completed',
      'statusColor': AppColors.success,
    },
    {
      'id': 'WTH-661092',
      'date': '15 Jul 2026',
      'amount': '₹750.00',
      'method': 'Amazon Pay Gift Card',
      'status': 'Completed',
      'statusColor': AppColors.success,
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handleWithdrawalSubmit() {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (amount < 250) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Minimum withdrawal amount is ₹250.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    if (amount > 1850) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Amount exceeds your available balance of ₹1,850.00.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.successBackground,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              'Withdrawal Request Placed!',
              style: AppTextStyles.cardTitle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
              ).copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '₹${amount.toStringAsFixed(2)} will be credited to your selected payment method within 24-48 business hours.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBrown,
                  foregroundColor: AppColors.cardBackground,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  ),
                ),
                child: Text(
                  'Done',
                  style: AppTextStyles.buttonText(color: AppColors.cardBackground).copyWith(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.mainBackground,
        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Withdraw Earnings',
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Available Balance Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryBrown, AppColors.deepBrown],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBrown.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Available for Withdrawal',
                          style: GoogleFonts.fraunces(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.lock_clock,
                                  size: 12, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Min ₹250',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '₹1,850.00',
                      style: GoogleFonts.fraunces(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Confirmed Cashback: ₹1,350.00 • Referral Bonus: ₹500.00',
                      style: GoogleFonts.fraunces(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // 2. Withdrawal Amount Section
              Text(
                'ENTER WITHDRAWAL AMOUNT',
                style: AppTextStyles.smallLabel(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                ).copyWith(letterSpacing: 0.8),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.border,
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.fraunces(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 14, right: 8),
                          child: Text(
                            '₹',
                            style: GoogleFonts.fraunces(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                            ),
                          ),
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                        hintText: '250',
                        hintStyle: AppTextStyles.smallDescription(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textMuted,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? AppColors.darkSurface
                            : AppColors.beigeSurface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Quick amount chips
                    Row(
                      children: [
                        _buildQuickAmountChip('₹250', '250'),
                        const SizedBox(width: 8),
                        _buildQuickAmountChip('₹500', '500'),
                        const SizedBox(width: 8),
                        _buildQuickAmountChip('₹1,000', '1000'),
                        const SizedBox(width: 8),
                        _buildQuickAmountChip('Max (₹1850)', '1850'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // 3. Payment Method Section
              Text(
                'SELECT PAYOUT METHOD',
                style: AppTextStyles.smallLabel(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                ).copyWith(letterSpacing: 0.8),
              ),

              const SizedBox(height: 10),

              _buildPaymentMethodOption(
                isDark: isDark,
                value: 'upi',
                icon: Icons.qr_code_2_rounded,
                title: 'UPI / VPA Transfer',
                subtitle: 'Transfer to deepak@okhdfcbank',
                badgeText: 'Instant',
              ),

              const SizedBox(height: 10),

              _buildPaymentMethodOption(
                isDark: isDark,
                value: 'bank',
                icon: Icons.account_balance_rounded,
                title: 'Bank Transfer (NEFT)',
                subtitle: 'HDFC Bank - A/C No. ending in **4129',
                badgeText: '24-48 Hrs',
              ),

              const SizedBox(height: 10),

              _buildPaymentMethodOption(
                isDark: isDark,
                value: 'amazon',
                icon: Icons.card_giftcard_rounded,
                title: 'Amazon Pay Gift Card',
                subtitle: 'Voucher code sent to your registered email',
                badgeText: 'Instant Code',
              ),

              const SizedBox(height: 20),

              // Withdraw CTA Button
              ElevatedButton.icon(
                onPressed: _handleWithdrawalSubmit,
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('Proceed to Withdraw'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBrown,
                  foregroundColor: AppColors.cardBackground,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  ),
                  elevation: 2,
                  textStyle: AppTextStyles.buttonText(color: AppColors.cardBackground).copyWith(fontSize: 14),
                ),
              ),

              const SizedBox(height: 28),

              // 4. Previous Withdrawals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RECENT WITHDRAWALS',
                    style: AppTextStyles.smallLabel(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                    ).copyWith(letterSpacing: 0.8),
                  ),
                  Text(
                    '${_recentWithdrawals.length} Records',
                    style: AppTextStyles.smallLabel(
                      color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ...List.generate(_recentWithdrawals.length, (index) {
                final item = _recentWithdrawals[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.successBackground,
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: AppColors.success, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['method'] as String,
                              style: AppTextStyles.cardTitle(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              ).copyWith(fontSize: 13.5),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item['id']} • ${item['date']}',
                              style: AppTextStyles.caption(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item['amount'] as String,
                            style: GoogleFonts.fraunces(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['status'] as String,
                            style: AppTextStyles.smallLabel(
                              color: item['statusColor'] as Color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAmountChip(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _amountController.text == value;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _amountController.text = value;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryBrown
                : (isDark ? AppColors.darkSurface : AppColors.beigeSurface),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryBrown
                  : (isDark
                      ? AppColors.darkBorder
                      : AppColors.border),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.buttonText(
                color: isSelected
                    ? AppColors.cardBackground
                    : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
              ).copyWith(fontSize: 11.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption({
    required bool isDark,
    required String value,
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
  }) {
    final isSelected = _selectedMethod == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = value;
        });
      },
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBrown
                : (isDark
                    ? AppColors.darkBorder
                    : AppColors.border),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryBrown.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.darkPrimary : AppColors.primaryBrown)
                    .withValues(alpha: isDark ? 0.18 : 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.cardTitle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ).copyWith(fontSize: 13.5),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.successBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badgeText,
                          style: AppTextStyles.smallLabel(
                            color: AppColors.success,
                          ).copyWith(fontSize: 9.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption(
                      color:
                          isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected
                  ? (isDark ? AppColors.darkPrimary : AppColors.primaryBrown)
                  : (isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
