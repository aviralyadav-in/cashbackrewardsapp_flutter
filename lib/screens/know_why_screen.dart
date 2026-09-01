import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import 'get_help_screen.dart';

class KnowWhyScreen extends StatelessWidget {
  static const String routeName = '/know-why';

  const KnowWhyScreen({super.key});

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
          'Why Is Earnings Pending?',
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ).copyWith(fontSize: 19),
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
              // Hero Banner Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.border,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.primaryBrown.withValues(alpha: 0.25)
                            : AppColors.beigeSurface,
                      ),
                      child: Icon(
                        Icons.hourglass_top_rounded,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Understanding Pending Status',
                            style: AppTextStyles.sectionHeading(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                            ).copyWith(fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your cashback is securely tracked! It simply awaits final confirmation from partner stores.',
                            style: AppTextStyles.caption(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Step-by-Step Lifecycle Section
              Text(
                'CASHBACK LIFECYCLE',
                style: GoogleFonts.fraunces(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                ),
              ),

              const SizedBox(height: 12),

              _buildTimelineStep(
                context,
                isDark: isDark,
                stepNumber: '1',
                title: 'Order Placed & Tracked',
                subtitle: 'Takes 24 to 72 hours',
                description:
                    'When you shop via our links, the store notifies us and the cashback shows as Pending in your earnings.',
                isFirst: true,
                isLast: false,
                icon: Icons.shopping_bag_outlined,
              ),

              _buildTimelineStep(
                context,
                isDark: isDark,
                stepNumber: '2',
                title: 'Return & Cancellation Window',
                subtitle: 'Takes 30 to 90 days',
                description:
                    'Stores wait for the return/exchange period to end to verify the order was not returned or cancelled.',
                isFirst: false,
                isLast: false,
                icon: Icons.sync_problem_rounded,
              ),

              _buildTimelineStep(
                context,
                isDark: isDark,
                stepNumber: '3',
                title: 'Store Pays Commission',
                subtitle: 'Verification Completed',
                description:
                    'Once verified, the retailer transfers the affiliate commission to us.',
                isFirst: false,
                isLast: false,
                icon: Icons.verified_user_outlined,
              ),

              _buildTimelineStep(
                context,
                isDark: isDark,
                stepNumber: '4',
                title: 'Confirmed & Ready to Withdraw',
                subtitle: 'Available Instantly',
                description:
                    'Cashback is converted to Confirmed balance and you can transfer it straight to your Bank or UPI.',
                isFirst: false,
                isLast: true,
                icon: Icons.account_balance_wallet_rounded,
                isHighlighted: true,
              ),

              const SizedBox(height: 24),

              // Key Reasons Section
              Text(
                'TOP REASONS FOR PENDING STATUS',
                style: GoogleFonts.fraunces(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                ),
              ),

              const SizedBox(height: 10),

              _buildReasonCard(
                isDark: isDark,
                icon: Icons.assignment_return_outlined,
                title: 'Return / Replacement Period',
                content:
                    'Retailers (e.g. Amazon, Flipkart, Myntra) will not confirm cashback until their standard 15-30 day return and replacement window has lapsed.',
              ),

              const SizedBox(height: 10),

              _buildReasonCard(
                isDark: isDark,
                icon: Icons.shield_outlined,
                title: 'Fraud & Duplicate Prevention',
                content:
                    'Store partners perform automated reconciliation to filter out fraudulent orders, bulk reseller accounts, or coupon code conflicts.',
              ),

              const SizedBox(height: 10),

              _buildReasonCard(
                isDark: isDark,
                icon: Icons.schedule_rounded,
                title: 'Monthly Billing Cycles',
                content:
                    'Most merchants process and validate affiliate orders on monthly or bi-monthly audit cycles before releasing confirmed funds.',
              ),

              const SizedBox(height: 24),

              // Frequently Asked Questions
              Text(
                'FREQUENTLY ASKED QUESTIONS',
                style: GoogleFonts.fraunces(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                ),
              ),

              const SizedBox(height: 10),

              _buildFaqItem(
                isDark: isDark,
                question: 'Can I withdraw Pending cashback?',
                answer:
                    'No. Pending cashback cannot be withdrawn until it changes to Confirmed status. Once confirmed, you need a minimum of ₹250 to withdraw.',
              ),

              const SizedBox(height: 10),

              _buildFaqItem(
                isDark: isDark,
                question: 'What happens if I cancel or return my order?',
                answer:
                    'If an order is cancelled, returned, or refunded, the retailer will not pay commission, and the pending cashback will be marked as Cancelled.',
              ),

              const SizedBox(height: 10),

              _buildFaqItem(
                isDark: isDark,
                question: 'What if my cashback is pending past 90 days?',
                answer:
                    'If a pending transaction has exceeded the estimated confirmation date, please raise a ticket via Missing Cashback or contact our support team.',
              ),

              const SizedBox(height: 24),

              // Need Help CTA
              Container(
                padding: const EdgeInsets.all(18),
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
                    Icon(
                      Icons.help_outline_rounded,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                      size: 32,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Still have questions?',
                      style: AppTextStyles.sectionHeading(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                      ).copyWith(fontSize: 15.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Visit our Help Center for detailed guides and round-the-clock support assistance.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(GetHelpScreen.routeName),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBrown,
                          foregroundColor: AppColors.cardBackground,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
                          ),
                        ),
                        child: Text(
                          'Open Get Help',
                          style: AppTextStyles.buttonText(
                            color: AppColors.cardBackground,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStep(
    BuildContext context, {
    required bool isDark,
    required String stepNumber,
    required String title,
    required String subtitle,
    required String description,
    required bool isFirst,
    required bool isLast,
    required IconData icon,
    bool isHighlighted = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step Indicator with vertical line
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isHighlighted
                    ? AppColors.success
                    : AppColors.primaryBrown,
                boxShadow: [
                  BoxShadow(
                    color: (isHighlighted ? AppColors.success : AppColors.primaryBrown)
                        .withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 58,
                color: isDark
                    ? AppColors.darkBorder
                    : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 14),
        // Step Content Card
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
              border: Border.all(
                color: isHighlighted
                    ? AppColors.success.withValues(alpha: 0.4)
                    : (isDark
                        ? AppColors.darkBorder
                        : AppColors.border),
              ),
            ),
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
                    Text(
                      subtitle,
                      style: AppTextStyles.smallLabel(
                        color: isHighlighted
                            ? AppColors.success
                            : (isDark ? AppColors.darkTextSecondary : AppColors.primaryBrown),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.caption(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReasonCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryBrown.withValues(alpha: 0.25)
                  : AppColors.beigeSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ).copyWith(fontSize: 13.5),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: AppTextStyles.caption(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({
    required bool isDark,
    required String question,
    required String answer,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedIconColor:
              isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
          iconColor: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
          title: Text(
            question,
            style: AppTextStyles.cardTitle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ).copyWith(fontSize: 13.5, fontWeight: FontWeight.w600),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 14, top: 2),
              child: Text(
                answer,
                style: AppTextStyles.body(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ).copyWith(fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
