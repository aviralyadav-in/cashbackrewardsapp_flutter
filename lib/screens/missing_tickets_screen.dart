import 'package:flutter/material.dart';

class MissingTicketsScreen extends StatefulWidget {
  static const String routeName = '/missing-tickets';

  const MissingTicketsScreen({super.key});

  @override
  State<MissingTicketsScreen> createState() => _MissingTicketsScreenState();
}

class _MissingTicketsScreenState extends State<MissingTicketsScreen> {
  String _selectedFilter = 'All'; // 'All', 'Active', 'Resolved'

  final List<Map<String, dynamic>> _dummyTickets = [
    {
      'ticketId': 'TKT-90821',
      'store': 'Flipkart',
      'orderId': 'FK-88219034',
      'orderDate': '16 Aug 2026',
      'orderAmount': '₹3,499.00',
      'expectedCashback': '₹262.50',
      'status': 'Under Investigation',
      'filterCategory': 'Active',
      'statusColor': Colors.orange,
      'statusIcon': Icons.manage_search_rounded,
      'lastUpdate': 'Yesterday at 04:30 PM',
      'note':
          'Order invoice received. We have escalated tracking with Flipkart affiliate desk. Expected resolution in 3-5 working days.',
    },
    {
      'ticketId': 'TKT-85124',
      'store': 'MakeMyTrip',
      'orderId': 'MMT-661902',
      'orderDate': '10 Aug 2026',
      'orderAmount': '₹5,800.00',
      'expectedCashback': '₹348.00',
      'status': 'Retailer Query',
      'filterCategory': 'Active',
      'statusColor': const Color(0xFF1E90FF),
      'statusIcon': Icons.sync_rounded,
      'lastUpdate': '14 Aug 2026',
      'note':
          'Flight booking confirmation verified. Merchant is validating click session timestamps.',
    },
    {
      'ticketId': 'TKT-71903',
      'store': 'Tata CLiQ',
      'orderId': 'TC-440182',
      'orderDate': '25 Jul 2026',
      'orderAmount': '₹1,450.00',
      'expectedCashback': '₹104.00',
      'status': 'Resolved & Credited',
      'filterCategory': 'Resolved',
      'statusColor': Colors.green,
      'statusIcon': Icons.check_circle_rounded,
      'lastUpdate': '02 Aug 2026',
      'note':
          'Missing cashback of ₹104.00 was approved by Tata CLiQ and added to your confirmed balance.',
    },
  ];

  List<Map<String, dynamic>> get _filteredTickets {
    if (_selectedFilter == 'All') return _dummyTickets;
    return _dummyTickets
        .where((ticket) => ticket['filterCategory'] == _selectedFilter)
        .toList();
  }

  void _showAddTicketModal(BuildContext context, bool isDark) {
    final storeCtrl = TextEditingController();
    final orderIdCtrl = TextEditingController();
    final amountCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF161618) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
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
            const SizedBox(height: 16),
            Text(
              'Add Missing Cashback Ticket',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Fill in your shopping details within 10 days of purchase.',
              style: TextStyle(
                fontSize: 12.5,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: storeCtrl,
              decoration: InputDecoration(
                labelText: 'Store Name (e.g. Amazon, Flipkart)',
                filled: true,
                fillColor:
                    isDark ? const Color(0xFF202024) : const Color(0xFFF7F8FA),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: orderIdCtrl,
              decoration: InputDecoration(
                labelText: 'Order / Transaction ID',
                filled: true,
                fillColor:
                    isDark ? const Color(0xFF202024) : const Color(0xFFF7F8FA),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Order Amount (₹)',
                filled: true,
                fillColor:
                    isDark ? const Color(0xFF202024) : const Color(0xFFF7F8FA),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Ticket submitted successfully! We will track your order within 48 hours.'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
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
                  'Submit Ticket',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTicketDetails(
      BuildContext context, Map<String, dynamic> ticket, bool isDark) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket['store'] as String,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ticket: ${ticket['ticketId']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (ticket['statusColor'] as Color)
                        .withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ticket['status'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ticket['statusColor'] as Color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(
              color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
            ),
            const SizedBox(height: 10),
            _buildDetailLine('Order ID', ticket['orderId'] as String, isDark),
            const SizedBox(height: 8),
            _buildDetailLine(
                'Order Date', ticket['orderDate'] as String, isDark),
            const SizedBox(height: 8),
            _buildDetailLine(
                'Order Amount', ticket['orderAmount'] as String, isDark),
            const SizedBox(height: 8),
            _buildDetailLine('Expected Cashback',
                ticket['expectedCashback'] as String, isDark,
                isHighlight: true),
            const SizedBox(height: 8),
            _buildDetailLine(
                'Last Updated', ticket['lastUpdate'] as String, isDark),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF202024)
                    : const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                ticket['note'] as String,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  height: 1.35,
                ),
              ),
            ),
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
                child: const Text('Close',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailLine(String label, String value, bool isDark,
      {bool isHighlight = false}) {
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
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
            color: isHighlight
                ? const Color(0xFF1E90FF)
                : (isDark ? Colors.white : Colors.black87),
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
          'Missing Cashback',
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
              // Info Banner Header
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange.withValues(alpha: isDark ? 0.2 : 0.1),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: Colors.orange,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Missing Cashback Help',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Did not receive cashback for your order? Submit a ticket within 10 days of purchase and we will trace it.',
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

              const SizedBox(height: 18),

              // Filter Tabs & Ticket Count
              Row(
                children: [
                  _buildFilterTab('All', isDark),
                  const SizedBox(width: 8),
                  _buildFilterTab('Active', isDark),
                  const SizedBox(width: 8),
                  _buildFilterTab('Resolved', isDark),
                ],
              ),

              const SizedBox(height: 16),

              // Ticket Records List
              if (_filteredTickets.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  child: Text(
                    'No $_selectedFilter tickets found.',
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                )
              else
                ..._filteredTickets.map((ticket) {
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
                            _showTicketDetails(context, ticket, isDark),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Header: Store, Ticket ID & Status Badge
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: (ticket['statusColor'] as Color)
                                              .withValues(
                                                  alpha: isDark ? 0.16 : 0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          ticket['statusIcon'] as IconData,
                                          size: 18,
                                          color: ticket['statusColor'] as Color,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ticket['store'] as String,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Ticket: ${ticket['ticketId']}',
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: isDark
                                                  ? Colors.grey.shade400
                                                  : Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (ticket['statusColor'] as Color)
                                          .withValues(
                                              alpha: isDark ? 0.2 : 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      ticket['status'] as String,
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                        color: ticket['statusColor'] as Color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: isDark
                                    ? const Color(0xFF242426)
                                    : const Color(0xFFF0F0F3),
                              ),
                              const SizedBox(height: 12),

                              // Middle Row: Order Info
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order ID: ${ticket['orderId']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.grey.shade800,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Purchased on ${ticket['orderDate']}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Expected Cashback',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        ticket['expectedCashback'] as String,
                                        style: const TextStyle(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF1E90FF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // Bottom Note Preview
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF202024)
                                      : const Color(0xFFF7F8FA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      size: 13,
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        ticket['note'] as String,
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 16),

              // Add Missing Cashback Ticket Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddTicketModal(context, isDark),
                  icon: const Icon(Icons.add_comment_outlined, size: 18),
                  label: const Text('Add Missing Cashback Ticket'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E90FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
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
                fontSize: 12,
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
