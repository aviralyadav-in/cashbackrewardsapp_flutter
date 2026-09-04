import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'account_settings_screen.dart';
import 'call_us_screen.dart';
import 'get_help_screen.dart';
import 'login_screen.dart';
import 'missing_tickets_screen.dart';
import 'my_earnings_screen.dart';
import 'my_referrals_screen.dart';
import 'payments_history_screen.dart';
import 'payments_screen.dart';
import 'privacy_policy_screen.dart';
import 'refer_earn_screen.dart';
import 'review_us_screen.dart';
import 'your_queries_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  final VoidCallback? onBack;

  const ProfileScreen({super.key, this.onBack});

  void _confirmLogout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        ),
        title: Text(
          'Logout',
          style: AppTextStyles.cardTitle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ),
        ),
        content: Text(
          'Are you sure you want to log out of your account?',
          style: AppTextStyles.body(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonText(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              await userProvider.clearUser();
              final authService = AuthService();
              await authService.signOut();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.cardBackground,
            ),
            child: Text(
              'Logout',
              style: AppTextStyles.buttonText(color: AppColors.cardBackground),
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
          'Profile',
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final firebaseUser = FirebaseAuth.instance.currentUser;

            final userName = userProvider.fullName.isNotEmpty
                ? userProvider.fullName
                : (firebaseUser?.displayName?.trim().isNotEmpty == true
                    ? firebaseUser!.displayName!.trim()
                    : 'CashKaro User');

            final userEmail = userProvider.email.isNotEmpty
                ? userProvider.email
                : (firebaseUser?.email?.trim() ?? '');

            final userPhone = userProvider.phoneNumber.isNotEmpty
                ? userProvider.phoneNumber
                : (firebaseUser?.phoneNumber?.trim() ?? '');

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2. USER SUMMARY SECTION
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
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello,',
                                    style: AppTextStyles.caption(
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userName,
                                    style: GoogleFonts.fraunces(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                                    ),
                                  ),
                                  if (userEmail.isNotEmpty || userPhone.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    if (userEmail.isNotEmpty)
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.email_outlined,
                                            size: 14,
                                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              userEmail,
                                              style: AppTextStyles.body(
                                                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (userPhone.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone_outlined,
                                            size: 14,
                                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            userPhone,
                                            style: AppTextStyles.body(
                                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(context).pushNamed(AccountSettingsScreen.routeName),
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (isDark ? AppColors.darkPrimary : AppColors.primaryBrown).withValues(alpha: isDark ? 0.2 : 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                                ),
                              ),
                              tooltip: 'Edit Profile',
                              splashRadius: 24,
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Two Summary Cards: Total Cashback & Total Rewards
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                                  borderRadius: BorderRadius.circular(12),
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
                                          Icons.account_balance_wallet_outlined,
                                          size: 16,
                                          color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Total Cashback',
                                          style: AppTextStyles.smallLabel(
                                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '₹0.0',
                                      style: GoogleFonts.fraunces(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                                  borderRadius: BorderRadius.circular(12),
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
                                          Icons.card_giftcard_outlined,
                                          size: 16,
                                          color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Total Rewards',
                                          style: AppTextStyles.smallLabel(
                                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '₹0.0',
                                      style: GoogleFonts.fraunces(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 4. CASHBACK & REWARDS SECTION
                  _ProfileSectionHeader(title: 'Cashback & Rewards', isDark: isDark),
                  _ProfileOptionTile(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'My Earnings',
                    isDark: isDark,
                    onTap: () => Navigator.of(context).pushNamed(MyEarningsScreen.routeName),
                  ),
                  _ProfileOptionTile(
                    icon: Icons.payment_outlined,
                    title: 'Payments',
                    isDark: isDark,
                    onTap: () => Navigator.of(context).pushNamed(PaymentsScreen.routeName),
                  ),
                  _ProfileOptionTile(
                    icon: Icons.history_rounded,
                    title: 'Payments History',
                    isDark: isDark,
                    onTap: () => Navigator.of(context).pushNamed(PaymentsHistoryScreen.routeName),
                  ),
                  _ProfileOptionTile(
                    icon: Icons.confirmation_number_outlined,
                    title: 'Missing Cashback',
                    isDark: isDark,
                    onTap: () => Navigator.of(context).pushNamed(MissingTicketsScreen.routeName),
                  ),
                  _ProfileOptionTile(
                    icon: Icons.question_answer_outlined,
                    title: 'Your Queries',
                    isDark: isDark,
                    onTap: () => Navigator.of(context).pushNamed(YourQueriesScreen.routeName),
                  ),

                  // 5. REFERRALS SECTION
                  _ProfileSectionHeader(title: 'Referrals', isDark: isDark),
                  _ProfileOptionTile(
                    icon: Icons.card_giftcard_rounded,
                    title: 'Refer & Earn',
                    isDark: isDark,
                    onTap: () => Navigator.of(context).pushNamed(ReferEarnScreen.routeName),
                  ),
                  _ProfileOptionTile(
                    icon: Icons.people_outline_rounded,
                    title: 'My Referrals',
                    isDark: isDark,
                    onTap: () => Navigator.of(context).pushNamed(MyReferralsScreen.routeName),
                  ),

                  // 6. SUPPORT & FEEDBACK SECTION
                  _ProfileSectionHeader(title: 'Support & Feedback', isDark: isDark),
                  _ProfileOptionTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Get Help',
                    isDark: isDark,
                    onTap: () => Navigator.of(context).pushNamed(GetHelpScreen.routeName),
                  ),
                  _ProfileOptionTile(
                    icon: Icons.call_outlined,
                    title: 'Call Us',
                    isDark: isDark,
                    onTap: () => Navigator.of(context).pushNamed(CallUsScreen.routeName),
                  ),
                  _ProfileOptionTile(
                    icon: Icons.star_border_rounded,
                    title: 'Review Us',
                    isDark: isDark,
                    onTap: () => Navigator.of(context).pushNamed(ReviewUsScreen.routeName),
                  ),

                  // 7. PRIVACY POLICY
                  _ProfileSectionHeader(title: 'Legal & Privacy', isDark: isDark),
                  _ProfileOptionTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    isDark: isDark,
                    onTap: () => Navigator.of(context).pushNamed(PrivacyPolicyScreen.routeName),
                  ),

                  // 8. THEME SETTINGS
                  _ProfileSectionHeader(title: 'App Theme', isDark: isDark),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                    child: Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          leading: Icon(
                            themeProvider.isDarkMode
                                ? Icons.dark_mode_outlined
                                : Icons.light_mode_outlined,
                            color: AppColors.primaryBrown,
                          ),
                          title: Text(
                            'Dark Mode',
                            style: AppTextStyles.cardTitle(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            themeProvider.isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
                            style: AppTextStyles.caption(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                            ),
                          ),
                          trailing: Switch(
                            value: themeProvider.isDarkMode,
                            activeThumbColor: AppColors.primaryBrown,
                            onChanged: (_) {
                              themeProvider.toggleTheme();
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 9. LOGOUT BUTTON
                  _ProfileOptionTile(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    isDark: isDark,
                    isDestructive: true,
                    onTap: () => _confirmLogout(context),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// REUSABLE PROFILE COMPONENTS
// ==========================================
class _ProfileSectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _ProfileSectionHeader({
    required this.title,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 16, bottom: 8),
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

class _ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileOptionTile({
    required this.icon,
    required this.title,
    required this.isDark,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isDestructive
                      ? AppColors.error
                      : (isDark ? AppColors.darkPrimary : AppColors.primaryBrown),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.cardTitle(
                      color: isDestructive
                          ? AppColors.error
                          : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
