import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import 'get_help_screen.dart';
import 'know_why_screen.dart';
import 'my_order_details_screen.dart';
import 'withdraw_screen.dart';

class MyEarningsScreen extends StatelessWidget {
  static const String routeName = '/my-earnings';
  final VoidCallback? onBack;

  const MyEarningsScreen({super.key, this.onBack});

  void _showInfoDialog(BuildContext context, String title, String content) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        ),
        title: Text(
          title,
          style: AppTextStyles.cardTitle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ),
        ),
        content: Text(
          content,
          style: AppTextStyles.body(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'OK',
              style: AppTextStyles.buttonText(
                color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          onPressed: () {
            if (onBack != null) {
              onBack!();
            } else if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          'My Earnings',
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
              // 1. ALL-TIME EARNINGS CARD
              _AllTimeEarningsCard(
                isDark: isDark,
                onInfoTap: () => _showInfoDialog(
                  context,
                  'All Time Earnings',
                  'This includes all your lifetime confirmed and pending cashback, rewards, and referral earnings.',
                ),
              ),

              const SizedBox(height: 16),

              // 2. CONFIRMED EARNINGS CARD
              _ConfirmedEarningsCard(
                isDark: isDark,
                onWithdrawTap: () {
                  Navigator.of(context).pushNamed(WithdrawScreen.routeName);
                },
              ),

              const SizedBox(height: 14),

              // 3. PENDING EARNINGS CARD
              _PendingEarningsCard(
                isDark: isDark,
                onKnowWhyTap: () {
                  Navigator.of(context).pushNamed(KnowWhyScreen.routeName);
                },
              ),

              const SizedBox(height: 20),

              // 4. ADDITIONAL OPTIONS CARD
              _AdditionalOptionsCard(
                isDark: isDark,
                onOrderDetailsTap: () {
                  Navigator.of(context).pushNamed(MyOrderDetailsScreen.routeName);
                },
                onGetHelpTap: () {
                  Navigator.of(context).pushNamed(GetHelpScreen.routeName);
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 1. ALL-TIME EARNINGS CARD
// ==========================================
class _AllTimeEarningsCard extends StatelessWidget {
  final bool isDark;
  final VoidCallback onInfoTap;

  const _AllTimeEarningsCard({
    required this.isDark,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header Row
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 14, top: 18, bottom: 8),
            child: Row(
              children: [
                Text(
                  'All Time Earnings',
                  style: AppTextStyles.cardSubtitle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: onInfoTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Amount Display (Fraunces Display Typography)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              '₹2,216.30',
              style: AppTextStyles.largeFinancialAmount(
                color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
              ).copyWith(fontSize: 34),
            ),
          ),

          const SizedBox(height: 18),

          // Three Horizontally Arranged Breakdown Sections
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildBreakdownItem(
                    title: 'Cashback',
                    amount: '₹1,350.00',
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
                Expanded(
                  child: _buildBreakdownItem(
                    title: 'Rewards',
                    amount: '₹366.30',
                    icon: Icons.card_giftcard_outlined,
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
                Expanded(
                  child: _buildBreakdownItem(
                    title: 'Referral',
                    amount: '₹500.00',
                    icon: Icons.people_outline_rounded,
                  ),
                ),
              ],
            ),
          ),

          // Footer Note
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: isDark ? AppColors.darkTextMuted : AppColors.primaryBrown,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Earnings will show here within 72 hours of your shopping via CashKaro.',
                    style: AppTextStyles.smallDescription(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
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

  Widget _buildBreakdownItem({
    required String title,
    required String amount,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown),
            const SizedBox(width: 4),
            Text(
              title,
              style: AppTextStyles.smallLabel(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          amount,
          style: GoogleFonts.fraunces(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 2. CONFIRMED EARNINGS CARD
// ==========================================
class _ConfirmedEarningsCard extends StatelessWidget {
  final bool isDark;
  final VoidCallback onWithdrawTap;

  const _ConfirmedEarningsCard({
    required this.isDark,
    required this.onWithdrawTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Icon & Details
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSuccess.withValues(alpha: 0.22)
                  : AppColors.successBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: isDark ? AppColors.darkSuccess : AppColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Confirmed',
                  style: AppTextStyles.cardSubtitle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹1,850.00',
                  style: GoogleFonts.fraunces(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Withdraw Button
          ElevatedButton(
            onPressed: onWithdrawTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBrown,
              foregroundColor: AppColors.cardBackground,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
              ),
            ),
            child: Text(
              'Withdraw',
              style: AppTextStyles.buttonText(
                color: AppColors.cardBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. PENDING EARNINGS CARD
// ==========================================
class _PendingEarningsCard extends StatelessWidget {
  final bool isDark;
  final VoidCallback onKnowWhyTap;

  const _PendingEarningsCard({
    required this.isDark,
    required this.onKnowWhyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Icon & Details
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkWarning.withValues(alpha: 0.22)
                  : AppColors.pendingBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.hourglass_top_rounded,
              color: isDark ? AppColors.darkWarning : AppColors.pending,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending',
                  style: AppTextStyles.cardSubtitle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹366.30',
                  style: GoogleFonts.fraunces(
                    color: isDark ? AppColors.darkWarning : AppColors.pending,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Know Why Button (Secondary Button)
          OutlinedButton(
            onPressed: onKnowWhyTap,
            style: OutlinedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.cardBackground,
              side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border, width: 1.2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
              ),
            ),
            child: Text(
              'Know Why?',
              style: AppTextStyles.buttonText(
                color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 4. ADDITIONAL OPTIONS CARD
// ==========================================
class _AdditionalOptionsCard extends StatelessWidget {
  final bool isDark;
  final VoidCallback onOrderDetailsTap;
  final VoidCallback onGetHelpTap;

  const _AdditionalOptionsCard({
    required this.isDark,
    required this.onOrderDetailsTap,
    required this.onGetHelpTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          // Row 1: My Order Details
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onOrderDetailsTap,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusCard)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                      size: 20,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'My Order Details',
                        style: AppTextStyles.cardTitle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),

          // Row 2: Get Help
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onGetHelpTap,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppDimensions.radiusCard)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.help_outline_rounded,
                      color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                      size: 20,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Get Help',
                        style: AppTextStyles.cardTitle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
