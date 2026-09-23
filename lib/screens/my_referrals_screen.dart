import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import 'refer_earn_screen.dart';

class MyReferralsScreen extends StatefulWidget {
  static const String routeName = '/my-referrals';

  const MyReferralsScreen({super.key});

  @override
  State<MyReferralsScreen> createState() => _MyReferralsScreenState();
}

class _MyReferralsScreenState extends State<MyReferralsScreen> {
  bool _isLoading = true;
  int _totalReferred = 0;
  double _referralEarnings = 0.0;
  List<Map<String, dynamic>> _referredUsers = [];
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchReferrals();
  }

  Future<void> _fetchReferrals() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final res = await userProvider.getUserReferrals();
      if (mounted && res != null && res['success'] == true) {
        setState(() {
          _totalReferred = res['totalReferred'] is int
              ? res['totalReferred'] as int
              : int.tryParse(res['totalReferred'].toString()) ?? 0;
          _referralEarnings = res['referralEarnings'] != null
              ? double.tryParse(res['referralEarnings'].toString()) ?? 0.0
              : (res['totalCoins'] != null
                  ? double.tryParse(res['totalCoins'].toString()) ?? 0.0
                  : 0.0);
          _referredUsers = (res['referredUsers'] as List<dynamic>?)
                  ?.map((e) => Map<String, dynamic>.from(e as Map))
                  .toList() ??
              [];
          _transactions = (res['transactions'] as List<dynamic>?)
                  ?.map((e) => Map<String, dynamic>.from(e as Map))
                  .toList() ??
              [];
          _isLoading = false;
        });
        return;
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              '$label copied to clipboard!',
              style: AppTextStyles.body(color: AppColors.cardBackground),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryBrown,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = Provider.of<UserProvider>(context);
    final myCode = userProvider.referralCode.isNotEmpty
        ? userProvider.referralCode
        : 'KASH100';
    final referralLink = 'https://kashiq.app/refer/$myCode';

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
          'My Referrals',
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchReferrals,
          color: AppColors.primaryBrown,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Referral Stats Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        isDark: isDark,
                        icon: Icons.people_alt_rounded,
                        title: 'Total Referred',
                        value: _isLoading ? '...' : '$_totalReferred',
                        subtext: 'Friends joined',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        isDark: isDark,
                        icon: Icons.account_balance_wallet_rounded,
                        title: 'Referral Cash',
                        value: _isLoading
                            ? '...'
                            : '₹${(userProvider.referralEarnings > 0 ? userProvider.referralEarnings : _referralEarnings).toStringAsFixed(0)}',
                        subtext: '₹20 / invite',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Program Banner Card
                Container(
                  padding: const EdgeInsets.all(16),
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
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.card_giftcard_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Earn ₹20 Cash + 10% Forever',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Get ₹20 bonus cash for every friend who signs up with your code, plus 10% cashback for life.',
                              style: AppTextStyles.caption(
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Copy Referral Code & Link Box
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'YOUR REFERRAL CODE',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _copyToClipboard(context, myCode, 'Referral code'),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.copy_rounded,
                                  size: 14,
                                  color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Copy Code',
                                  style: AppTextStyles.caption(
                                    color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                                  ).copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        myCode,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: isDark ? AppColors.darkPrimary : AppColors.deepBrown,
                        ),
                      ),
                      const Divider(height: 20),
                      Text(
                        'YOUR REFERRAL LINK',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.beigeSurface.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                referralLink,
                                style: AppTextStyles.cardTitle(
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                ).copyWith(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.copy_rounded,
                                size: 18,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                              ),
                              onPressed: () => _copyToClipboard(context, referralLink, 'Referral link'),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              tooltip: 'Copy Link',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Referred Friends List / Empty State
                Text(
                  'REFERRED FRIENDS (${_referredUsers.length})',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                  ),
                ),

                const SizedBox(height: 12),

                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: AppColors.primaryBrown),
                    ),
                  )
                else if (_referredUsers.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.people_outline_rounded,
                          size: 48,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No Referrals Yet',
                          style: AppTextStyles.sectionHeading(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                          ).copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Share your code $myCode with your friends. As soon as they sign up with your code, you will earn ₹20 cash bonus and they will appear here.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pushNamed(ReferEarnScreen.routeName),
                          icon: const Icon(Icons.share_rounded, size: 16),
                          label: Text(
                            'Invite Friends Now',
                            style: AppTextStyles.buttonText(color: AppColors.cardBackground),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBrown,
                            foregroundColor: AppColors.cardBackground,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _referredUsers.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = _referredUsers[index];
                      final name = item['name'] as String? ?? 'Friend';
                      final phone = item['phoneNumber'] as String? ?? '';

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isDark
                                  ? AppColors.darkPrimary.withValues(alpha: 0.2)
                                  : AppColors.beigeSurface,
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.darkPrimary : AppColors.deepBrown,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: AppTextStyles.cardTitle(
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                    ),
                                  ),
                                  if (phone.isNotEmpty)
                                    Text(
                                      phone,
                                      style: AppTextStyles.caption(
                                        color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.monetization_on, color: Colors.green, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    '+50',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                if (_transactions.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'REFERRAL CASH HISTORY',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _transactions.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final tx = _transactions[index];
                      final desc = tx['description'] as String? ?? 'Referral reward';
                      final rawAmount = tx['amount'];
                      final formattedAmt = rawAmount is num
                          ? rawAmount.toStringAsFixed(0)
                          : (double.tryParse(rawAmount?.toString() ?? '0')?.toStringAsFixed(0) ?? '0');

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.payments_rounded, color: Colors.green, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                desc,
                                style: AppTextStyles.body(
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                ).copyWith(fontSize: 13),
                              ),
                            ),
                            Text(
                              '+₹$formattedAmt',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required String value,
    required String subtext,
  }) {
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
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTextStyles.caption(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: AppTextStyles.smallLabel(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
