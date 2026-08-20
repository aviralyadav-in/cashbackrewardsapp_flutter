import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const String routeName = '/privacy-policy';

  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF5F5F7);
    final cardColor = isDark ? const Color(0xFF161618) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtextColor = isDark ? Colors.grey.shade300 : Colors.grey.shade800;
    final borderColor = isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        foregroundColor: textColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            color: textColor,
            fontSize: 19,
            fontWeight: FontWeight.bold,
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
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor),
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
                        color: const Color(0xFF1E90FF).withValues(alpha: 0.12),
                      ),
                      child: const Icon(
                        Icons.privacy_tip_rounded,
                        color: Color(0xFF1E90FF),
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
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Last updated: August 2026. Please review our data protection guidelines.',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
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
                cardColor: cardColor,
                textColor: textColor,
                subtextColor: subtextColor,
                borderColor: borderColor,
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
                cardColor: cardColor,
                textColor: textColor,
                subtextColor: subtextColor,
                borderColor: borderColor,
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
                cardColor: cardColor,
                textColor: textColor,
                subtextColor: subtextColor,
                borderColor: borderColor,
              ),

              // 4. Account & Authentication
              _PolicySectionCard(
                icon: Icons.security_rounded,
                title: '4. Account & Authentication',
                content:
                    'User accounts are authenticated using secure Firebase Authentication services. We store unique Firebase User IDs (UIDs) as primary keys to manage profile state and prevent duplicate account creation.',
                isDark: isDark,
                cardColor: cardColor,
                textColor: textColor,
                subtextColor: subtextColor,
                borderColor: borderColor,
              ),

              // 5. Cashback & Transactions
              _PolicySectionCard(
                icon: Icons.payments_outlined,
                title: '5. Cashback & Transactions',
                content:
                    'Transaction details are synchronized with partner retailers to verify order confirmation and calculate cashback eligibility. We do not store or process your credit card, debit card, or net banking passwords.',
                isDark: isDark,
                cardColor: cardColor,
                textColor: textColor,
                subtextColor: subtextColor,
                borderColor: borderColor,
              ),

              // 6. Data Security
              _PolicySectionCard(
                icon: Icons.lock_outline_rounded,
                title: '6. Data Security',
                content:
                    'We employ industry-standard SSL encryption and secure cloud infrastructure to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
                isDark: isDark,
                cardColor: cardColor,
                textColor: textColor,
                subtextColor: subtextColor,
                borderColor: borderColor,
              ),

              // 7. Third-Party Services
              _PolicySectionCard(
                icon: Icons.hub_outlined,
                title: '7. Third-Party Services',
                content:
                    'When you tap on partner store links (e.g. Amazon, Flipkart, Myntra), you are redirected to third-party merchant sites. Merchant sites have independent privacy policies which we recommend reviewing.',
                isDark: isDark,
                cardColor: cardColor,
                textColor: textColor,
                subtextColor: subtextColor,
                borderColor: borderColor,
              ),

              // 8. Data Retention
              _PolicySectionCard(
                icon: Icons.history_toggle_off_rounded,
                title: '8. Data Retention',
                content:
                    'We retain user profile data for as long as your account remains active. You may request account deactivation or data removal by contacting customer support.',
                isDark: isDark,
                cardColor: cardColor,
                textColor: textColor,
                subtextColor: subtextColor,
                borderColor: borderColor,
              ),

              // 9. Your Rights
              _PolicySectionCard(
                icon: Icons.verified_user_outlined,
                title: '9. Your Rights',
                content:
                    'You retain full rights to view, edit, or update your registered name, email, and phone number at any time via Account Settings inside the Profile section of the app.',
                isDark: isDark,
                cardColor: cardColor,
                textColor: textColor,
                subtextColor: subtextColor,
                borderColor: borderColor,
              ),

              // 10. Contact Us
              _PolicySectionCard(
                icon: Icons.mail_outline_rounded,
                title: '10. Contact Us',
                content:
                    'If you have any questions or concerns regarding this Privacy Policy, please contact our Data Protection Officer at:\n\n'
                    'Email: privacy@cashkaro.com\n'
                    'Helpline: 1800-CASHKARO (1800-227-4527)',
                isDark: isDark,
                cardColor: cardColor,
                textColor: textColor,
                subtextColor: subtextColor,
                borderColor: borderColor,
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
  final Color cardColor;
  final Color textColor;
  final Color subtextColor;
  final Color borderColor;

  const _PolicySectionCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
    required this.subtextColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1E90FF), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.5,
              color: subtextColor,
            ),
          ),
        ],
      ),
    );
  }
}
