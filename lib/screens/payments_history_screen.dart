import 'package:flutter/material.dart';

class PaymentsHistoryScreen extends StatefulWidget {
  static const String routeName = '/payments-history';

  const PaymentsHistoryScreen({super.key});

  @override
  State<PaymentsHistoryScreen> createState() => _PaymentsHistoryScreenState();
}

class _PaymentsHistoryScreenState extends State<PaymentsHistoryScreen> {
  String _selectedFilter = 'All'; // 'All', 'UPI', 'Bank', 'Amazon Pay'

  final List<Map<String, dynamic>> _paymentRecords = [
    {
      'txnId': 'TXN-984210982',
      'refNo': 'UPI984210982341',
      'date': '18 Aug 2026',
      'time': '02:45 PM',
      'amount': '₹850.00',
      'method': 'UPI Transfer',
      'methodDetail': 'deepak@okhdfcbank',
      'methodCategory': 'UPI',
      'type': 'Cashback Withdrawal',
      'status': 'Successful',
      'statusColor': Colors.green,
      'icon': Icons.qr_code_2_rounded,
    },
    {
      'txnId': 'NEFT-773129401',
      'refNo': 'HDFC8819024519',
      'date': '04 Aug 2026',
      'time': '11:20 AM',
      'amount': '₹1,250.00',
      'method': 'Bank Transfer (NEFT)',
      'methodDetail': 'HDFC Bank - A/C ending in **4129',
      'methodCategory': 'Bank',
      'type': 'Referral & Cashback Payout',
      'status': 'Successful',
      'statusColor': Colors.green,
      'icon': Icons.account_balance_rounded,
    },
    {
      'txnId': 'APAY-661092184',
      'refNo': 'GC8821093412',
      'date': '15 Jul 2026',
      'time': '05:15 PM',
      'amount': '₹750.00',
      'method': 'Amazon Pay Gift Card',
      'methodDetail': 'Sent to deepak***@gmail.com',
      'methodCategory': 'Amazon Pay',
      'type': 'Rewards Redemption',
      'status': 'Successful',
      'statusColor': Colors.green,
      'icon': Icons.card_giftcard_rounded,
    },
    {
      'txnId': 'TXN-540918231',
      'refNo': 'UPI540918231908',
      'date': '28 Jun 2026',
      'time': '04:10 PM',
      'amount': '₹1,400.00',
      'method': 'UPI Transfer',
      'methodDetail': 'deepak@okhdfcbank',
      'methodCategory': 'UPI',
      'type': 'Cashback Withdrawal',
      'status': 'Successful',
      'statusColor': Colors.green,
      'icon': Icons.qr_code_2_rounded,
    },
  ];

  List<Map<String, dynamic>> get _filteredRecords {
    if (_selectedFilter == 'All') return _paymentRecords;
    return _paymentRecords
        .where((record) => record['methodCategory'] == _selectedFilter)
        .toList();
  }

  void _showReceiptModal(
      BuildContext context, Map<String, dynamic> record, bool isDark) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withValues(alpha: isDark ? 0.2 : 0.1),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Payout Completed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    record['amount'] as String,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E90FF),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Divider(
              color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
            ),
            const SizedBox(height: 10),
            _buildReceiptRow('Transaction ID', record['txnId'] as String, isDark),
            const SizedBox(height: 8),
            _buildReceiptRow('Bank Reference', record['refNo'] as String, isDark),
            const SizedBox(height: 8),
            _buildReceiptRow('Payment Method', record['method'] as String, isDark),
            const SizedBox(height: 8),
            _buildReceiptRow('Destination', record['methodDetail'] as String, isDark),
            const SizedBox(height: 8),
            _buildReceiptRow(
                'Date & Time', '${record['date']} at ${record['time']}', isDark),
            const SizedBox(height: 8),
            _buildReceiptRow('Payout Type', record['type'] as String, isDark),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E90FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Close Receipt',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
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
          'Payments History',
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
              // Summary Stats Card
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
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      isDark: isDark,
                      label: 'Total Paid Out',
                      value: '₹4,250.00',
                      valueColor: const Color(0xFF1E90FF),
                    ),
                    Container(
                      height: 36,
                      width: 1,
                      color: isDark
                          ? const Color(0xFF28282A)
                          : const Color(0xFFE5E5EA),
                    ),
                    _buildSummaryItem(
                      isDark: isDark,
                      label: 'Successful',
                      value: '${_paymentRecords.length}',
                      valueColor: Colors.green,
                    ),
                    Container(
                      height: 36,
                      width: 1,
                      color: isDark
                          ? const Color(0xFF28282A)
                          : const Color(0xFFE5E5EA),
                    ),
                    _buildSummaryItem(
                      isDark: isDark,
                      label: 'Processing',
                      value: '0',
                      valueColor: Colors.orange,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Filter Tabs
              Row(
                children: [
                  _buildFilterTab('All', isDark),
                  const SizedBox(width: 8),
                  _buildFilterTab('UPI', isDark),
                  const SizedBox(width: 8),
                  _buildFilterTab('Bank', isDark),
                  const SizedBox(width: 8),
                  _buildFilterTab('Amazon Pay', isDark),
                ],
              ),

              const SizedBox(height: 16),

              // Transactions List
              if (_filteredRecords.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  child: Text(
                    'No $_selectedFilter payouts found.',
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                )
              else
                ..._filteredRecords.map((record) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF161618) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF28282A)
                            : const Color(0xFFE5E5EA),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.25 : 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () =>
                            _showReceiptModal(context, record, isDark),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Icon
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E90FF).withValues(
                                      alpha: isDark ? 0.16 : 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  record['icon'] as IconData,
                                  color: const Color(0xFF1E90FF),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Description
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      record['method'] as String,
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      record['methodDetail'] as String,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${record['txnId']} • ${record['date']}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark
                                            ? Colors.grey.shade500
                                            : Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Amount & Status
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    record['amount'] as String,
                                    style: const TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1E90FF),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: (record['statusColor'] as Color)
                                          .withValues(
                                              alpha: isDark ? 0.2 : 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      record['status'] as String,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: record['statusColor'] as Color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required bool isDark,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTab(String label, bool isDark) {
    final isSelected = _selectedFilter == label;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFilter = label;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1E90FF)
                : (isDark ? const Color(0xFF161618) : Colors.white),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF1E90FF)
                  : (isDark
                      ? const Color(0xFF28282A)
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
                    : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
