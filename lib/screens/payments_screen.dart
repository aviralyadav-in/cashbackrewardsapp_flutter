import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import 'my_earnings_screen.dart';

class PaymentsScreen extends StatelessWidget {
  static const String routeName = '/payments';

  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
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
          'Payments',
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
              // Available for Withdrawal Banner Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? const [AppColors.darkSurface, AppColors.darkCard]
                        : const [AppColors.primaryBrown, AppColors.deepBrown],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
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
                          'Available to Withdraw',
                          style: AppTextStyles.caption(
                            color: Colors.white.withValues(alpha: 0.8),
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.lock_clock, size: 12, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                'Threshold: ₹250',
                                style: GoogleFonts.fraunces(
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
                      '₹0.00',
                      style: GoogleFonts.fraunces(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You need a minimum of ₹250 confirmed cashback or rewards to request a payout.',
                      style: AppTextStyles.caption(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Withdrawal Methods Section
              Text(
                'PAYOUT METHODS',
                style: GoogleFonts.fraunces(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                ),
              ),

              const SizedBox(height: 10),

              _buildPaymentMethodTile(
                context,
                isDark: isDark,
                icon: Icons.account_balance_rounded,
                title: 'Bank Transfer (NEFT)',
                subtitle: 'Direct transfer to any verified Indian bank account',
                badgeText: 'Instant / 24-48 Hrs',
              ),

              const SizedBox(height: 10),

              _buildPaymentMethodTile(
                context,
                isDark: isDark,
                icon: Icons.card_giftcard_rounded,
                title: 'Amazon Pay Gift Card',
                subtitle: 'Add directly to your Amazon Pay wallet balance',
                badgeText: 'Instant Code',
              ),

              const SizedBox(height: 10),

              _buildPaymentMethodTile(
                context,
                isDark: isDark,
                icon: Icons.qr_code_2_rounded,
                title: 'UPI / VPA Transfer',
                subtitle: 'Transfer to Google Pay, PhonePe, Paytm UPI ID',
                badgeText: 'Instant',
              ),

              const SizedBox(height: 24),

              // How it works info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Payment Guidelines',
                          style: AppTextStyles.sectionHeading(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                          ).copyWith(fontSize: 14.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildGuidelineItem(
                      isDark: isDark,
                      number: '1',
                      text: 'Only confirmed cashback/rewards can be paid out.',
                    ),
                    const SizedBox(height: 6),
                    _buildGuidelineItem(
                      isDark: isDark,
                      number: '2',
                      text: 'Cashback can be transferred to Bank or Amazon Pay.',
                    ),
                    const SizedBox(height: 6),
                    _buildGuidelineItem(
                      isDark: isDark,
                      number: '3',
                      text: 'Rewards can be redeemed as Amazon Pay Gift Cards.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Check Earnings Button
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pushNamed(MyEarningsScreen.routeName),
                icon: const Icon(Icons.account_balance_wallet_outlined, size: 18),
                label: const Text('View Earnings Breakdown'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                  side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.primaryBrown),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
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
              color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown),
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
                      ).copyWith(fontSize: 14),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badgeText,
                        style: GoogleFonts.fraunces(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTextStyles.caption(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineItem({
    required bool isDark,
    required String number,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.fraunces(
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ).copyWith(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
