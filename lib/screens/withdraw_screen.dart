import 'package:flutter/material.dart';

class WithdrawScreen extends StatefulWidget {
  static const String routeName = '/withdraw';

  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _amountController =
      TextEditingController(text: '500');
  String _selectedMethod = 'upi'; // 'upi', 'bank', 'amazon'

  final List<Map<String, dynamic>> _recentWithdrawals = [
    {
      'id': 'WTH-984210',
      'date': '18 Aug 2026',
      'amount': '₹850.00',
      'method': 'UPI (deepak@okhdfcbank)',
      'status': 'Completed',
      'statusColor': Colors.green,
    },
    {
      'id': 'WTH-773129',
      'date': '04 Aug 2026',
      'amount': '₹1,250.00',
      'method': 'HDFC Bank (A/C **4129)',
      'status': 'Completed',
      'statusColor': Colors.green,
    },
    {
      'id': 'WTH-661092',
      'date': '15 Jul 2026',
      'amount': '₹750.00',
      'method': 'Amazon Pay Gift Card',
      'status': 'Completed',
      'statusColor': Colors.green,
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handleWithdrawalSubmit() {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (amount < 250) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Minimum withdrawal amount is ₹250.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    if (amount > 1850) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Amount exceeds your available balance of ₹1,850.00.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF161618) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withValues(alpha: 0.15),
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: Colors.green, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              'Withdrawal Request Placed!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '₹${amount.toStringAsFixed(2)} will be credited to your selected payment method within 24-48 business hours.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E90FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          'Withdraw Earnings',
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
              // 1. Available Balance Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E90FF), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E90FF).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Available for Withdrawal',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.lock_clock,
                                  size: 12, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Min ₹250',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '₹1,850.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Confirmed Cashback: ₹1,350.00 • Referral Bonus: ₹500.00',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // 2. Withdrawal Amount Section
              Text(
                'ENTER WITHDRAWAL AMOUNT',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161618) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF28282A)
                        : const Color(0xFFE5E5EA),
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 14, right: 8),
                          child: Text(
                            '₹',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E90FF),
                            ),
                          ),
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                        hintText: '250',
                        hintStyle: TextStyle(
                          color: isDark
                              ? Colors.grey.shade600
                              : Colors.grey.shade400,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF202024)
                            : const Color(0xFFF7F8FA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Quick amount chips
                    Row(
                      children: [
                        _buildQuickAmountChip('₹250', '250'),
                        const SizedBox(width: 8),
                        _buildQuickAmountChip('₹500', '500'),
                        const SizedBox(width: 8),
                        _buildQuickAmountChip('₹1,000', '1000'),
                        const SizedBox(width: 8),
                        _buildQuickAmountChip('Max (₹1850)', '1850'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // 3. Payment Method Section
              Text(
                'SELECT PAYOUT METHOD',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 10),

              _buildPaymentMethodOption(
                isDark: isDark,
                value: 'upi',
                icon: Icons.qr_code_2_rounded,
                title: 'UPI / VPA Transfer',
                subtitle: 'Transfer to deepak@okhdfcbank',
                badgeText: 'Instant',
              ),

              const SizedBox(height: 10),

              _buildPaymentMethodOption(
                isDark: isDark,
                value: 'bank',
                icon: Icons.account_balance_rounded,
                title: 'Bank Transfer (NEFT)',
                subtitle: 'HDFC Bank - A/C No. ending in **4129',
                badgeText: '24-48 Hrs',
              ),

              const SizedBox(height: 10),

              _buildPaymentMethodOption(
                isDark: isDark,
                value: 'amazon',
                icon: Icons.card_giftcard_rounded,
                title: 'Amazon Pay Gift Card',
                subtitle: 'Voucher code sent to your registered email',
                badgeText: 'Instant Code',
              ),

              const SizedBox(height: 20),

              // Withdraw CTA Button
              ElevatedButton.icon(
                onPressed: _handleWithdrawalSubmit,
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('Proceed to Withdraw'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E90FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFF1E90FF).withValues(alpha: 0.35),
                ),
              ),

              const SizedBox(height: 28),

              // 4. Previous Withdrawals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RECENT WITHDRAWALS',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    '${_recentWithdrawals.length} Records',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E90FF),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ...List.generate(_recentWithdrawals.length, (index) {
                final item = _recentWithdrawals[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161618) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF28282A)
                          : const Color(0xFFE5E5EA),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.withValues(alpha: 0.12),
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: Colors.green, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['method'] as String,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item['id']} • ${item['date']}',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item['amount'] as String,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['status'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: item['statusColor'] as Color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAmountChip(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _amountController.text == value;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _amountController.text = value;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1E90FF)
                : (isDark ? const Color(0xFF202024) : const Color(0xFFF2F4F7)),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF1E90FF)
                  : (isDark
                      ? const Color(0xFF333336)
                      : const Color(0xFFE5E5EA)),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.grey.shade300 : Colors.grey.shade800),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption({
    required bool isDark,
    required String value,
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
  }) {
    final isSelected = _selectedMethod == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = value;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161618) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1E90FF)
                : (isDark
                    ? const Color(0xFF28282A)
                    : const Color(0xFFE5E5EA)),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF1E90FF).withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E90FF)
                    .withValues(alpha: isDark ? 0.16 : 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: const Color(0xFF1E90FF)),
            ),
            const SizedBox(width: 12),
            Expanded(
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade500
                              .withValues(alpha: isDark ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.green.shade400
                                : Colors.green.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.5,
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected
                  ? const Color(0xFF1E90FF)
                  : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
