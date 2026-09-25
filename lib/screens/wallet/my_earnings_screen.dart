import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../support/get_help_screen.dart';
import '../products/know_why_screen.dart';
import 'my_order_details_screen.dart';
import 'withdraw_screen.dart';
import '../../widgets/wallet/wallet_spending_graph_card.dart';

class MyEarningsScreen extends StatefulWidget {
  static const String routeName = '/my-earnings';
  final VoidCallback? onBack;

  const MyEarningsScreen({super.key, this.onBack});

  @override
  State<MyEarningsScreen> createState() => _MyEarningsScreenState();
}

class _MyEarningsScreenState extends State<MyEarningsScreen> {
  String _selectedStreamFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).loadWalletData();
      }
    });
  }

  void _showSourcesInfoModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF132247) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4.5,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF5A483C) : const Color(0xFFD5C7B8),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'How Money is Credited to Your Wallet',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            _buildSourceExplainer(
              isDark: isDark,
              icon: Icons.storefront_rounded,
              iconColor: const Color(0xFF10B981),
              title: '1. Store Cashback (Shopping)',
              description:
                  'Earned whenever you shop at partner stores (Amazon, Flipkart, Myntra, HyugaLife, etc.) via KashIQ. Cashback is recorded as Pending within 36-72 hours and confirms once the return window closes.',
            ),
            const SizedBox(height: 14),
            _buildSourceExplainer(
              isDark: isDark,
              icon: Icons.share_rounded,
              iconColor: const Color(0xFF3B82F6),
              title: '2. Affiliate Link Earnings (Share & Earn)',
              description:
                  'When you share a product link with friends or on social media and someone makes a purchase through your shared link, the full affiliate commission is credited straight to your wallet.',
            ),
            const SizedBox(height: 14),
            _buildSourceExplainer(
              isDark: isDark,
              icon: Icons.people_alt_rounded,
              iconColor: const Color(0xFFF59E0B),
              title: '3. Referral Bonus (Friend 1st Shopping)',
              description:
                  'When you (User A) refer a friend (User B), once User B completes their very first shopping order of min. ₹500, User A earns ₹20 and User B receives ₹10 credited directly into their wallets!',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceExplainer({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2E241E) : const Color(0xFFFBF8F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: isDark ? AppColors.darkTextSecondary : const Color(0xFF6B5E55),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = Provider.of<UserProvider>(context);

    final walletBalance = userProvider.walletBalance;
    final confirmed = userProvider.confirmedCashback;
    final pending = userProvider.pendingCashback;
    final referral = userProvider.referralEarnings;
    final affiliate = userProvider.affiliateEarnings;
    final hasShopped = userProvider.hasShopped;
    final allTimeEarnings = confirmed + affiliate + referral + pending;

    // Transaction list with fallback sample data showing all 3 streams
    final allTxs = userProvider.walletTransactions.isNotEmpty
        ? userProvider.walletTransactions
        : [
            {
              'id': 'tx-ref-1',
              'amount': referral > 0 ? referral : 20.0,
              'type': 'REFERRAL',
              'status': 'CONFIRMED',
              'description': 'Referral Bonus: Friend completed 1st shopping order',
              'createdAt': DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
            },
            {
              'id': 'tx-cb-1',
              'amount': confirmed > 0 ? confirmed : 150.0,
              'type': 'CASHBACK',
              'status': 'CONFIRMED',
              'description': 'Store Cashback from Myntra verified',
              'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
            },
            {
              'id': 'tx-aff-1',
              'amount': affiliate > 0 ? affiliate : 45.0,
              'type': 'AFFILIATE',
              'status': 'CONFIRMED',
              'description': 'Affiliate Commission: Friend bought Nike shoes via your link',
              'createdAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
            },
            {
              'id': 'tx-cb-2',
              'amount': pending > 0 ? pending : 85.0,
              'type': 'CASHBACK',
              'status': 'PENDING',
              'description': 'Store Cashback from Amazon tracked',
              'createdAt': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
            },
          ];

    final filteredTxs = _selectedStreamFilter == 'ALL'
        ? allTxs
        : allTxs.where((tx) => tx['type']?.toString().toUpperCase() == _selectedStreamFilter).toList();

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
            if (widget.onBack != null) {
              widget.onBack!();
            } else if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          'Wallet & Earnings',
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await userProvider.loadWalletData();
          },
          color: AppColors.primaryBrown,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. ALL-TIME EARNINGS CARD WITH 3 STREAMS (Cashback, Affiliate, Referral)
                _AllTimeEarningsCard(
                  isDark: isDark,
                  totalEarnings: allTimeEarnings,
                  cashback: confirmed,
                  affiliate: affiliate,
                  referral: referral,
                  hasShopped: hasShopped,
                  onInfoTap: () => _showSourcesInfoModal(context, isDark),
                ),

                const SizedBox(height: 18),

                // 2. SPENDING & CASHBACK GRAPH ANALYTICS
                WalletSpendingGraphCard(
                  isDark: isDark,
                  hasShopped: hasShopped,
                ),

                const SizedBox(height: 18),

                // 4. CONFIRMED EARNINGS CARD (Spendable / Withdrawable Balance)
                _ConfirmedEarningsCard(
                  isDark: isDark,
                  confirmedAmount: walletBalance,
                  onWithdrawTap: () {
                    Navigator.of(context).pushNamed(WithdrawScreen.routeName);
                  },
                ),

                const SizedBox(height: 14),

                // 5. PENDING EARNINGS CARD
                _PendingEarningsCard(
                  isDark: isDark,
                  pendingAmount: pending,
                  onKnowWhyTap: () {
                    Navigator.of(context).pushNamed(KnowWhyScreen.routeName);
                  },
                ),

                const SizedBox(height: 20),

                // 6. WALLET ACTIVITY FEED WITH STREAM FILTER
                _WalletActivitySection(
                  isDark: isDark,
                  selectedFilter: _selectedStreamFilter,
                  transactions: filteredTxs,
                  onFilterSelected: (filter) {
                    setState(() {
                      _selectedStreamFilter = filter;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // 7. NO SHOPPING NUDGE (Only shown if user hasn't made any purchases yet)
                if (!hasShopped) ...[
                  _NewUserShoppingNudge(
                    isDark: isDark,
                    onShopTap: () {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                // 8. ADDITIONAL OPTIONS CARD
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
      ),
    );
  }
}

// ==========================================
// 1. ALL-TIME EARNINGS CARD (3 STREAMS)
// ==========================================
class _AllTimeEarningsCard extends StatelessWidget {
  final bool isDark;
  final double totalEarnings;
  final double cashback;
  final double affiliate;
  final double referral;
  final bool hasShopped;
  final VoidCallback onInfoTap;

  const _AllTimeEarningsCard({
    required this.isDark,
    required this.totalEarnings,
    required this.cashback,
    required this.affiliate,
    required this.referral,
    required this.hasShopped,
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
                  'Total Lifetime Earnings',
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
              '₹${totalEarnings.toStringAsFixed(2)}',
              style: AppTextStyles.largeFinancialAmount(
                color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
              ).copyWith(fontSize: 34),
            ),
          ),

          const SizedBox(height: 18),

          // Three Horizontally Arranged Breakdown Sections: Cashback, Affiliate, Referral
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildBreakdownItem(
                    title: 'Cashback',
                    subtitle: 'Store shopping',
                    amount: '₹${cashback.toStringAsFixed(2)}',
                    icon: Icons.shopping_bag_outlined,
                    iconColor: const Color(0xFFD97706),
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
                Expanded(
                  child: _buildBreakdownItem(
                    title: 'Affiliate',
                    subtitle: 'Shared links',
                    amount: '₹${affiliate.toStringAsFixed(2)}',
                    icon: Icons.link_rounded,
                    iconColor: const Color(0xFF3B82F6),
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
                Expanded(
                  child: _buildBreakdownItem(
                    title: 'Referral',
                    subtitle: 'Friend 1st order',
                    amount: '₹${referral.toStringAsFixed(2)}',
                    icon: Icons.people_outline_rounded,
                    iconColor: const Color(0xFF10B981),
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
                  Icons.verified_user_outlined,
                  size: 14,
                  color: isDark ? AppColors.darkTextMuted : AppColors.primaryBrown,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hasShopped
                        ? '100% Guaranteed Payouts: Cashback tracks within 72h • Referral credits on friend\'s 1st order.'
                        : 'Tap the (i) icon above to learn how Cashback, Affiliate links, and Referral bonus are credited.',
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
    required String subtitle,
    required String amount,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: iconColor),
            const SizedBox(width: 4),
            Text(
              title,
              style: AppTextStyles.smallLabel(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ).copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          amount,
          style: GoogleFonts.inter(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
            fontSize: 15,
            fontWeight: FontWeight.w700,
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
        ),
      ],
    );
  }
}

// ==========================================
// WALLET ACTIVITY WITH STREAM FILTER CHIPS
// ==========================================
class _WalletActivitySection extends StatelessWidget {
  final bool isDark;
  final String selectedFilter;
  final List<dynamic> transactions;
  final ValueChanged<String> onFilterSelected;

  const _WalletActivitySection({
    required this.isDark,
    required this.selectedFilter,
    required this.transactions,
    required this.onFilterSelected,
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
          // Header Row
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
            child: Row(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 18,
                  color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                ),
                const SizedBox(width: 8),
                Text(
                  'Wallet Activity',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                  ),
                ),
              ],
            ),
          ),

          // Filter Chips Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterChip('ALL', 'All'),
                  const SizedBox(width: 6),
                  _buildFilterChip('CASHBACK', '🛍️ Cashback'),
                  const SizedBox(width: 6),
                  _buildFilterChip('AFFILIATE', '🔗 Affiliate'),
                  const SizedBox(width: 6),
                  _buildFilterChip('REFERRAL', '👥 Referral'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Transactions List
          if (transactions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_rounded,
                      size: 36,
                      color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No transactions yet',
                      style: AppTextStyles.body(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Activity for $selectedFilter will appear here.',
                      style: AppTextStyles.smallDescription(
                        color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              itemCount: transactions.length,
              separatorBuilder: (_, index) => Divider(
                height: 1,
                thickness: 1,
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return _buildTransactionItem(tx);
              },
            ),

          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = selectedFilter == key;
    return InkWell(
      onTap: () => onFilterSelected(key),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkPrimary : AppColors.primaryBrown)
              : (isDark ? AppColors.darkSurface : AppColors.beigeSurface),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.darkPrimary : AppColors.primaryBrown)
                : (isDark ? AppColors.darkBorder : AppColors.border),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(dynamic tx) {
    final type = (tx['type'] ?? 'CASHBACK').toString().toUpperCase();
    final status = (tx['status'] ?? 'CONFIRMED').toString().toUpperCase();
    final description = tx['description'] ?? 'Earning credited';
    final amount = double.tryParse(tx['amount']?.toString() ?? '0') ?? 0.0;

    IconData icon;
    Color iconColor;
    Color iconBg;
    String streamBadge;

    switch (type) {
      case 'AFFILIATE':
        icon = Icons.link_rounded;
        iconColor = const Color(0xFF2563EB);
        iconBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFDBEAFE);
        streamBadge = 'AFFILIATE';
        break;
      case 'REFERRAL':
        icon = Icons.people_alt_rounded;
        iconColor = const Color(0xFF059669);
        iconBg = isDark ? const Color(0xFF064E3B) : const Color(0xFFD1FAE5);
        streamBadge = 'REFERRAL';
        break;
      case 'CASHBACK':
      default:
        icon = Icons.shopping_bag_rounded;
        iconColor = const Color(0xFFD97706);
        iconBg = isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7);
        streamBadge = 'CASHBACK';
        break;
    }

    final isConfirmed = status == 'CONFIRMED';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 19, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        streamBadge,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: iconColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: isConfirmed
                            ? (isDark ? AppColors.darkSuccess.withValues(alpha: 0.15) : AppColors.successBackground)
                            : (isDark ? AppColors.darkWarning.withValues(alpha: 0.15) : AppColors.pendingBackground),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isConfirmed ? 'CONFIRMED' : 'PENDING',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: isConfirmed
                              ? (isDark ? AppColors.darkSuccess : AppColors.success)
                              : (isDark ? AppColors.darkWarning : AppColors.pending),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.body(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ).copyWith(fontSize: 12.5, fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '+₹${amount.toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              color: isConfirmed
                  ? (isDark ? AppColors.darkSuccess : AppColors.success)
                  : (isDark ? AppColors.darkWarning : AppColors.pending),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. CONFIRMED EARNINGS CARD
// ==========================================
class _ConfirmedEarningsCard extends StatelessWidget {
  final bool isDark;
  final double confirmedAmount;
  final VoidCallback onWithdrawTap;

  const _ConfirmedEarningsCard({
    required this.isDark,
    required this.confirmedAmount,
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
                  'Confirmed Balance',
                  style: AppTextStyles.cardSubtitle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹${confirmedAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
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
  final double pendingAmount;
  final VoidCallback onKnowWhyTap;

  const _PendingEarningsCard({
    required this.isDark,
    required this.pendingAmount,
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
                  '₹${pendingAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
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
// 4. NEW USER SHOPPING NUDGE
// ==========================================
class _NewUserShoppingNudge extends StatelessWidget {
  final bool isDark;
  final VoidCallback onShopTap;

  const _NewUserShoppingNudge({
    required this.isDark,
    required this.onShopTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A201A) : const Color(0xFFF9F5EF),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? const Color(0xFF4A3A2E) : const Color(0xFFE5DCD0),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF3D2C20) : const Color(0xFFEFE6D9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'No Shopping Purchases Yet',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Shop on Flipkart, Amazon, Myntra & 1,500+ top stores via KashIQ to get extra cashback credited directly into your wallet.',
            style: AppTextStyles.body(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ).copyWith(fontSize: 12.5),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onShopTap,
              icon: const Icon(Icons.storefront_rounded, size: 16),
              label: const Text('Explore Stores & Start Shopping'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBrown,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 5. ADDITIONAL OPTIONS CARD
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
