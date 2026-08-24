import 'package:flutter/material.dart';
import 'get_help_screen.dart';
import 'know_why_screen.dart';
import 'my_order_details_screen.dart';
import 'withdraw_screen.dart';

class MyEarningsScreen extends StatelessWidget {
  static const String routeName = '/my-earnings';

  const MyEarningsScreen({super.key});

  void _showInfoDialog(BuildContext context, String title, String content) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF161618) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Color(0xFF1E90FF),
                fontWeight: FontWeight.bold,
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
          'My Earnings',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
        color: isDark ? const Color(0xFF161618) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: onInfoTap,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: Color(0xFF1E90FF),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Amount Display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              '₹2,216.30',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Three Horizontally Arranged Breakdown Sections
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C1C1F) : const Color(0xFFF8F9FA),
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
                  color: const Color(0xFF1E90FF).withValues(alpha: isDark ? 0.25 : 0.18),
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
                  color: const Color(0xFF1E90FF).withValues(alpha: isDark ? 0.25 : 0.18),
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
                const Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: Color(0xFF1E90FF),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Earnings will show here within 72 hours of your shopping via Cashback & Rewards.',
                    style: TextStyle(
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      fontSize: 11.5,
                      height: 1.3,
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
            Icon(icon, size: 14, color: const Color(0xFF1E90FF)),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          amount,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.bold,
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
        color: isDark ? const Color(0xFF161618) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
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
              color: const Color(0xFF1E90FF).withValues(alpha: isDark ? 0.12 : 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF1E90FF),
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
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹1,850.00',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          // Withdraw Button
          ElevatedButton(
            onPressed: onWithdrawTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E90FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 3,
              shadowColor: const Color(0xFF1E90FF).withValues(alpha: 0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Withdraw',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
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
        color: isDark ? const Color(0xFF161618) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
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
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.hourglass_top_rounded,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
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
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹366.30',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          // Know Why Button
          OutlinedButton(
            onPressed: onKnowWhyTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1E90FF),
              side: const BorderSide(color: Color(0xFF1E90FF), width: 1.2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Know Why?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E90FF),
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
        color: isDark ? const Color(0xFF161618) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
        ),
      ),
      child: Column(
        children: [
          // Row 1: My Order Details
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onOrderDetailsTap,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Row(
                  children: [
                    const Icon(
                      Icons.receipt_long_rounded,
                      color: Color(0xFF1E90FF),
                      size: 20,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'My Order Details',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark ? Colors.grey : Colors.grey.shade400,
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
            color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
          ),

          // Row 2: Get Help
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onGetHelpTap,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Row(
                  children: [
                    const Icon(
                      Icons.help_outline_rounded,
                      color: Color(0xFF1E90FF),
                      size: 20,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Get Help',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark ? Colors.grey : Colors.grey.shade400,
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
