import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import 'my_earnings_screen.dart';
import 'payments_history_screen.dart';
import 'withdraw_screen.dart';

class PaymentsScreen extends StatefulWidget {
  static const String routeName = '/payments';

  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).loadWalletData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = Provider.of<UserProvider>(context);

    final remainingBalance = userProvider.remainingBalance;
    final confirmed = userProvider.confirmedCashback;
    final affiliate = userProvider.affiliateEarnings;
    final referral = userProvider.referralEarnings;
    final lifetimeEarnings = confirmed + affiliate + referral;
    final isEligible = remainingBalance >= 250.0;
    final diffToThreshold = (250.0 - remainingBalance).clamp(0.0, 250.0);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.mainBackground,
        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.navyDark,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Payments & Payouts',
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.history_rounded,
              color: isDark ? AppColors.darkTextPrimary : AppColors.navyDark,
            ),
            tooltip: 'Payout History',
            onPressed: () => Navigator.of(context).pushNamed(PaymentsHistoryScreen.routeName),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await userProvider.loadWalletData();
          },
          color: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // =============================================================
                // 1. AVAILABLE TO WITHDRAW BANNER CARD (DYNAMIC FROM DATABASE)
                // =============================================================
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? const [Color(0xFF25203F), Color(0xFF1E1A33)]
                          : const [AppColors.navyDark, Color(0xFF3F3765)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
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
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet_rounded,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Remaining Balance (Withdrawable)',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isEligible
                                  ? const Color(0xFF10B981).withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isEligible
                                    ? const Color(0xFF10B981)
                                    : Colors.white.withValues(alpha: 0.25),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isEligible ? Icons.check_circle_rounded : Icons.lock_clock,
                                  size: 12,
                                  color: isEligible ? const Color(0xFF6EE7B7) : Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isEligible ? 'Eligible to Payout' : 'Min. Payout: ₹250',
                                  style: GoogleFonts.inter(
                                    color: isEligible ? const Color(0xFF6EE7B7) : Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '₹${remainingBalance.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isEligible
                            ? 'Your wallet balance meets the ₹250 threshold. You can withdraw your cash instantly!'
                            : 'You need ₹${diffToThreshold.toStringAsFixed(2)} more confirmed cashback or rewards to reach the ₹250 payout threshold.',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11.5,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await Navigator.of(context).pushNamed(WithdrawScreen.routeName);
                            if (mounted) {
                              userProvider.loadWalletData();
                            }
                          },
                          icon: const Icon(Icons.payments_outlined, size: 16),
                          label: Text(
                            isEligible ? 'Withdraw to Bank / UPI' : 'Request Withdrawal',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // =============================================================
                // 2. EARNINGS CONTRIBUTION BREAKDOWN TRAY (LIFETIME DATABASE DATA)
                // =============================================================
                Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.pie_chart_outline_rounded,
                                size: 16,
                                color: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Earnings Overview',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Lifetime: ₹${lifetimeEarnings.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFF6EE7B7) : const Color(0xFF047857),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildBreakdownPillar(
                              title: 'Cashback',
                              subtitle: 'Store shopping',
                              amount: '₹${confirmed.toStringAsFixed(2)}',
                              icon: Icons.shopping_bag_outlined,
                              iconColor: const Color(0xFFD97706),
                              isDark: isDark,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 38,
                            color: isDark ? AppColors.darkBorder : AppColors.border,
                          ),
                          Expanded(
                            child: _buildBreakdownPillar(
                              title: 'Share & Earn',
                              subtitle: 'Shared deals',
                              amount: '₹${affiliate.toStringAsFixed(2)}',
                              icon: Icons.share_rounded,
                              iconColor: const Color(0xFF3B82F6),
                              isDark: isDark,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 38,
                            color: isDark ? AppColors.darkBorder : AppColors.border,
                          ),
                          Expanded(
                            child: _buildBreakdownPillar(
                              title: 'Referral',
                              subtitle: 'Friend orders',
                              amount: '₹${referral.toStringAsFixed(2)}',
                              icon: Icons.people_outline_rounded,
                              iconColor: const Color(0xFF10B981),
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // =============================================================
                // 3. PAYOUT METHODS SECTION
                // =============================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PAYOUT METHODS',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                      ),
                    ),
                    Text(
                      'Tap to withdraw',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                _buildPaymentMethodTile(
                  context,
                  isDark: isDark,
                  icon: Icons.account_balance_rounded,
                  title: 'Bank Transfer (NEFT)',
                  subtitle: 'Direct transfer to any verified Indian bank account',
                  badgeText: 'Instant / 24-48h',
                  onTap: () async {
                    await Navigator.of(context).pushNamed(WithdrawScreen.routeName);
                    if (mounted) userProvider.loadWalletData();
                  },
                ),

                const SizedBox(height: 10),

                _buildPaymentMethodTile(
                  context,
                  isDark: isDark,
                  icon: Icons.card_giftcard_rounded,
                  title: 'Amazon Pay Gift Card',
                  subtitle: 'Add directly to your Amazon Pay wallet balance',
                  badgeText: 'Instant Code',
                  onTap: () async {
                    await Navigator.of(context).pushNamed(WithdrawScreen.routeName);
                    if (mounted) userProvider.loadWalletData();
                  },
                ),

                const SizedBox(height: 10),

                _buildPaymentMethodTile(
                  context,
                  isDark: isDark,
                  icon: Icons.qr_code_2_rounded,
                  title: 'UPI / VPA Transfer',
                  subtitle: 'Transfer to Google Pay, PhonePe, Paytm UPI ID',
                  badgeText: 'Instant Payout',
                  onTap: () async {
                    await Navigator.of(context).pushNamed(WithdrawScreen.routeName);
                    if (mounted) userProvider.loadWalletData();
                  },
                ),

                const SizedBox(height: 22),

                // =============================================================
                // 4. PAYMENT GUIDELINES INFO CARD
                // =============================================================
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
                            size: 16,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Payment Guidelines',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1E1E24),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildGuidelineItem(
                        isDark: isDark,
                        number: '1',
                        text: 'Only confirmed cashback, share & earn, and referral rewards can be paid out.',
                      ),
                      const SizedBox(height: 6),
                      _buildGuidelineItem(
                        isDark: isDark,
                        number: '2',
                        text: 'Lifetime earnings are never lost on payout; only available remaining balance is withdrawn.',
                      ),
                      const SizedBox(height: 6),
                      _buildGuidelineItem(
                        isDark: isDark,
                        number: '3',
                        text: 'Cashback can be transferred to UPI, Indian Bank Accounts, or Amazon Pay.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // =============================================================
                // 5. NAVIGATION ACTION BUTTONS
                // =============================================================
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pushNamed(PaymentsHistoryScreen.routeName),
                        icon: const Icon(Icons.history_rounded, size: 16),
                        label: const Text('Payout History'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.primaryBrown),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pushNamed(MyEarningsScreen.routeName),
                        icon: const Icon(Icons.account_balance_wallet_outlined, size: 16),
                        label: const Text('My Earnings'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBrown,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownPillar({
    required String title,
    required String subtitle,
    required String amount,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: iconColor),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            amount,
            style: GoogleFonts.inter(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 9.5,
            color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPaymentMethodTile(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      child: Container(
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
                color: isDark ? AppColors.darkSurface : AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: isDark ? AppColors.darkPrimary : AppColors.accentBlue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: isDark ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badgeText,
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkSuccess : AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ],
        ),
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
          width: 17,
          height: 17,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.surfaceSubtle,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
          child: Text(
            number,
            style: GoogleFonts.inter(
              fontSize: 9.5,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
