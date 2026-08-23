import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
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

  const ProfileScreen({super.key});

  void _confirmLogout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF161618) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(
            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                fontWeight: FontWeight.bold,
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
              backgroundColor: const Color(0xFF1E90FF),
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF161618) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
                    : 'Cashback User');

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
                      color: isDark ? const Color(0xFF161618) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
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
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black87,
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
                                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              userEmail,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
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
                                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            userPhone,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
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
                                  color: const Color(0xFF1E90FF).withValues(alpha: isDark ? 0.2 : 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Color(0xFF1E90FF),
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
                                  color: isDark ? const Color(0xFF1C1C1F) : const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF28282A) : const Color(0xFFEFEFF4),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.account_balance_wallet_outlined,
                                          size: 16,
                                          color: Color(0xFF1E90FF),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Total Cashback',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '₹0.0',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: isDark ? Colors.white : Colors.black87,
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
                                  color: isDark ? const Color(0xFF1C1C1F) : const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF28282A) : const Color(0xFFEFEFF4),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.card_giftcard_outlined,
                                          size: 16,
                                          color: Color(0xFF1E90FF),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Total Rewards',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '₹0.0',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: isDark ? Colors.white : Colors.black87,
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

                  // 3. ACCOUNT SETTINGS
                  // _ProfileOptionTile(
                  //   icon: Icons.settings_outlined,
                  //   title: 'Account Settings',
                  //   isDark: isDark,
                  //   onTap: () => Navigator.of(context).pushNamed(AccountSettingsScreen.routeName),
                  // ),

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
                  color: isDark ? const Color(0xFF161618) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
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
                        color: const Color(0xFF1E90FF),
                      ),
                      title: Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        themeProvider.isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      trailing: Switch(
                        value: themeProvider.isDarkMode,
                        activeThumbColor: const Color(0xFF1E90FF),
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
              color: const Color(0xFF1E90FF),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
              letterSpacing: 0.2,
            ),
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
        color: isDark ? const Color(0xFF161618) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
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
                  color: const Color(0xFF1E90FF),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: isDestructive
                          ? const Color(0xFFEF4444)
                          : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
