import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const String routeName = '/privacy-policy';

  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
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
              // Header Card
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
                        Icons.privacy_tip_rounded,
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
                            'Your Privacy Matters',
                            style: AppTextStyles.sectionHeading(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                            ).copyWith(fontSize: 15.5),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Last updated: August 2026. Please review our data protection guidelines.',
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

              // 1. Introduction
              _PolicySectionCard(
                icon: Icons.info_outline_rounded,
                title: '1. Introduction',
                content:
                    'Welcome to CashKaro. We are committed to protecting your privacy and ensuring your personal information is handled in a safe and responsible manner. This policy outlines how we collect, use, and safeguard your data.',
                isDark: isDark,
              ),

              // 2. Information We Collect
              _PolicySectionCard(
                icon: Icons.inventory_2_outlined,
                title: '2. Information We Collect',
                content:
                    'We collect personal details provided directly by you when using our platform:\n\n'
                    '• Full Name & Email Address\n'
                    '• Phone Number for account verification\n'
                    '• Cashback tracking links & store exit logs\n'
                    '• Payment withdrawal details (Bank account, UPI, Amazon Pay)',
                isDark: isDark,
              ),

              // 3. How We Use Your Information
              _PolicySectionCard(
                icon: Icons.settings_applications_outlined,
                title: '3. How We Use Your Information',
                content:
                    'Your data is processed strictly for essential app functionalities:\n\n'
                    '• Accurately tracking cashback and affiliate store purchases\n'
                    '• Processing withdrawal requests & payout transfers\n'
                    '• Providing customer support and missing ticket resolution\n'
                    '• Sending important account status updates and notifications',
                isDark: isDark,
              ),

              // 4. Account & Authentication
              _PolicySectionCard(
                icon: Icons.security_rounded,
                title: '4. Account & Authentication',
                content:
                    'User accounts are authenticated using secure Firebase Authentication services. We store unique Firebase User IDs (UIDs) as primary keys to manage profile state and prevent duplicate account creation.',
                isDark: isDark,
              ),

              // 5. Cashback & Transactions
              _PolicySectionCard(
                icon: Icons.payments_outlined,
                title: '5. Cashback & Transactions',
                content:
                    'Transaction details are synchronized with partner retailers to verify order confirmation and calculate cashback eligibility. We do not store or process your credit card, debit card, or net banking passwords.',
                isDark: isDark,
              ),

              // 6. Data Security
              _PolicySectionCard(
                icon: Icons.lock_outline_rounded,
                title: '6. Data Security',
                content:
                    'We employ industry-standard SSL encryption and secure cloud infrastructure to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
                isDark: isDark,
              ),

              // 7. Third-Party Services
              _PolicySectionCard(
                icon: Icons.hub_outlined,
                title: '7. Third-Party Services',
                content:
                    'When you tap on partner store links (e.g. Amazon, Flipkart, Myntra), you are redirected to third-party merchant sites. Merchant sites have independent privacy policies which we recommend reviewing.',
                isDark: isDark,
              ),

              // 8. Data Retention
              _PolicySectionCard(
                icon: Icons.history_toggle_off_rounded,
                title: '8. Data Retention',
                content:
                    'We retain user profile data for as long as your account remains active. You may request account deactivation or data removal by contacting customer support.',
                isDark: isDark,
              ),

              // 9. Your Rights
              _PolicySectionCard(
                icon: Icons.verified_user_outlined,
                title: '9. Your Rights',
                content:
                    'You retain full rights to view, edit, or update your registered name, email, and phone number at any time via Account Settings inside the Profile section of the app.',
                isDark: isDark,
              ),

              // 10. Contact Us
              _PolicySectionCard(
                icon: Icons.mail_outline_rounded,
                title: '10. Contact Us',
                content:
                    'If you have any questions or concerns regarding this Privacy Policy, please contact our Data Protection Officer at:\n\n'
                    'Email: privacy@CashKaro.com\n'
                    'Helpline: 1800-CashKaro (1800-227-4828)',
                isDark: isDark,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PolicySectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final bool isDark;

  const _PolicySectionCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              Icon(icon, color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.cardTitle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ).copyWith(fontSize: 14.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: AppTextStyles.body(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
