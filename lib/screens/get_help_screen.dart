import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GetHelpScreen extends StatelessWidget {
  static const String routeName = '/get-help';

  const GetHelpScreen({super.key});

  void _showHelpDetailModal(BuildContext context, String title, String content) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.help_outline_rounded, color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.screenHeading(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                ).copyWith(fontSize: 17),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: AppTextStyles.body(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Got It',
              style: AppTextStyles.buttonText(
                color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _contactSupport(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.headset_mic_rounded, color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown, size: 26),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Support',
                      style: AppTextStyles.screenHeading(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                      ).copyWith(fontSize: 18),
                    ),
                    Text(
                      'We usually respond within 24 hours',
                      style: AppTextStyles.caption(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            _ContactTile(
              icon: Icons.email_outlined,
              title: 'Email Support',
              subtitle: 'support@CashKaro.com',
              isDark: isDark,
              onTap: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Support request sent to support@CashKaro.com',
                      style: AppTextStyles.body(color: AppColors.cardBackground),
                    ),
                    backgroundColor: AppColors.primaryBrown,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _ContactTile(
              icon: Icons.call_outlined,
              title: 'Toll-Free Helpline',
              subtitle: '1800-CashKaro (1800-227-4828)',
              isDark: isDark,
              onTap: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Helpline: 1800-CashKaro (Mon-Sat 10AM-7PM)',
                      style: AppTextStyles.body(color: AppColors.cardBackground),
                    ),
                    backgroundColor: AppColors.primaryBrown,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Get Help',
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Banner Card
              Container(
                padding: const EdgeInsets.all(18),
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
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.primaryBrown.withValues(alpha: 0.25)
                            : AppColors.beigeSurface,
                      ),
                      child: Icon(
                        Icons.help_center_rounded,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How can we help you?',
                            style: AppTextStyles.sectionHeading(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                            ).copyWith(fontSize: 15.5),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Explore support topics or contact our help team below.',
                            style: AppTextStyles.caption(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _SectionTitle(title: 'Help Categories', isDark: isDark),

              // 1. Frequently Asked Questions
              _HelpTopicTile(
                icon: Icons.quiz_outlined,
                title: 'Frequently Asked Questions',
                description: 'Quick answers about shopping, cashback tracking, and payouts.',
                isDark: isDark,
                onTap: () => _showHelpDetailModal(
                  context,
                  'Frequently Asked Questions',
                  '1. How do I earn Cashback?\nAlways start your shopping by clicking store links inside CashKaro. Shop normally and complete your payment.\n\n2. How long does Cashback tracking take?\nCashback usually tracks within 24 to 72 hours of placing an order.\n\n3. When can I withdraw my earnings?\nOnce your store returns/exchange window closes, your cashback changes from Pending to Confirmed and can be withdrawn to your bank account.',
                ),
              ),

              // 2. Cashback Related Issues
              _HelpTopicTile(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Cashback Related Issues',
                description: 'Missing cashback, pending status delays, or tracking queries.',
                isDark: isDark,
                onTap: () => _showHelpDetailModal(
                  context,
                  'Cashback Related Issues',
                  'If your cashback did not track automatically:\n\n• Wait 24-72 hours after purchase.\n• Ensure ad-blockers were turned off while shopping.\n• Submit a Missing Cashback Ticket from Profile > Missing Cashback.\n\nOur audit team will trace your order with the partner retailer.',
                ),
              ),

              // 3. Payment & Withdrawal Issues
              _HelpTopicTile(
                icon: Icons.payment_outlined,
                title: 'Payment & Withdrawal Issues',
                description: 'NEFT bank transfers, UPI payouts, or wallet credit status.',
                isDark: isDark,
                onTap: () => _showHelpDetailModal(
                  context,
                  'Payment & Withdrawal Issues',
                  'Minimum withdrawal threshold is ₹250 confirmed cashback.\n\nWithdrawal Methods:\n• Direct Bank Transfer (NEFT)\n• Amazon Pay Gift Cards\n• UPI Transfer\n\nPayout processing takes 1-3 business days upon submission.',
                ),
              ),

              // 4. Referral Related Issues
              _HelpTopicTile(
                icon: Icons.card_giftcard_outlined,
                title: 'Referral Related Issues',
                description: 'Invite links, referral bonuses, and friend commission rules.',
                isDark: isDark,
                onTap: () => _showHelpDetailModal(
                  context,
                  'Referral Related Issues',
                  'How Referral Bonus Works:\n\n• Share your unique referral link with friends.\n• Earn 10% referral cashback whenever your friends earn cashback for life!\n• Ensure your friends sign up directly using your link.',
                ),
              ),

              // 5. Account Related Issues
              _HelpTopicTile(
                icon: Icons.person_outline_rounded,
                title: 'Account Related Issues',
                description: 'Updating email, phone number, name, or login security.',
                isDark: isDark,
                onTap: () => _showHelpDetailModal(
                  context,
                  'Account Related Issues',
                  'You can update your Full Name, Email Address, and Phone Number anytime in Profile > Account Settings.\n\nAll personal data is encrypted and protected with strict privacy controls.',
                ),
              ),

              // 6. Contact Support Topic
              _HelpTopicTile(
                icon: Icons.support_agent_rounded,
                title: 'Contact Support',
                description: 'Get directly in touch with our customer service team.',
                isDark: isDark,
                onTap: () => _contactSupport(context),
              ),

              const SizedBox(height: 20),

              // Bottom Contact Support Card Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.headset_mic_outlined,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                      size: 36,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Still Need Help?',
                      style: AppTextStyles.sectionHeading(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                      ).copyWith(fontSize: 16.5),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Our dedicated support team is available Mon-Sat (10 AM - 7 PM) to assist you.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => _contactSupport(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBrown,
                          foregroundColor: AppColors.cardBackground,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.call_rounded, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Contact Us',
                              style: AppTextStyles.buttonText(
                                color: AppColors.cardBackground,
                              ).copyWith(fontSize: 14.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionTitle({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.primaryBrown,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppTextStyles.sectionHeading(
              color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
            ).copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _HelpTopicTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isDark;
  final VoidCallback onTap;

  const _HelpTopicTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primaryBrown.withValues(alpha: 0.25)
                        : AppColors.beigeSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.cardTitle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ).copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: AppTextStyles.caption(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.beigeSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusNormal)),
        leading: Icon(icon, color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown, size: 22),
        title: Text(
          title,
          style: AppTextStyles.cardTitle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.caption(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown),
      ),
    );
  }
}
