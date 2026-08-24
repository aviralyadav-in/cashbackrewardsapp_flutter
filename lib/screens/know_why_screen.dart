import 'package:flutter/material.dart';
import 'get_help_screen.dart';

class KnowWhyScreen extends StatelessWidget {
  static const String routeName = '/know-why';

  const KnowWhyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF5F5F7),
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
          'Why Is Earnings Pending?',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 19,
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
              // Hero Banner Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161618) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF28282A)
                        : const Color(0xFFE5E5EA),
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
                        color: const Color(0xFF1E90FF)
                            .withValues(alpha: isDark ? 0.18 : 0.1),
                      ),
                      child: const Icon(
                        Icons.hourglass_top_rounded,
                        color: Color(0xFF1E90FF),
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
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your cashback is securely tracked! It simply awaits final confirmation from partner stores.',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                              height: 1.3,
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
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
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
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
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
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
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
                  color: isDark ? const Color(0xFF161618) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF28282A)
                        : const Color(0xFFE5E5EA),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.help_outline_rounded,
                      color: Color(0xFF1E90FF),
                      size: 32,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Still have questions?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Visit our Help Center for detailed guides and round-the-clock support assistance.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(GetHelpScreen.routeName),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E90FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Open Get Help',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                    ? Colors.green
                    : const Color(0xFF1E90FF),
                boxShadow: [
                  BoxShadow(
                    color: (isHighlighted ? Colors.green : const Color(0xFF1E90FF))
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
                    ? const Color(0xFF28282A)
                    : const Color(0xFFE5E5EA),
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
              color: isDark ? const Color(0xFF161618) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isHighlighted
                    ? Colors.green.withValues(alpha: 0.4)
                    : (isDark
                        ? const Color(0xFF28282A)
                        : const Color(0xFFE5E5EA)),
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
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: isHighlighted
                            ? Colors.green
                            : const Color(0xFF1E90FF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                    height: 1.35,
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
        color: isDark ? const Color(0xFF161618) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E90FF)
                  .withValues(alpha: isDark ? 0.16 : 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF1E90FF)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                    height: 1.35,
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
        color: isDark ? const Color(0xFF161618) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
        ),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedIconColor:
              isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          iconColor: const Color(0xFF1E90FF),
          title: Text(
            question,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 14, top: 2),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
