import 'package:flutter/material.dart';

class OrderRecord {
  final String orderId, store, category, date, amount, cashback, rate, status, expectedDate;
  final Color statusColor;
  final IconData icon;

  const OrderRecord({
    required this.orderId,
    required this.store,
    required this.category,
    required this.date,
    required this.amount,
    required this.cashback,
    required this.rate,
    required this.status,
    required this.statusColor,
    required this.expectedDate,
    required this.icon,
  });
}

class MyOrderDetailsScreen extends StatefulWidget {
  static const String routeName = '/my-order-details';

  const MyOrderDetailsScreen({super.key});

  @override
  State<MyOrderDetailsScreen> createState() => _MyOrderDetailsScreenState();
}

class _MyOrderDetailsScreenState extends State<MyOrderDetailsScreen> {
  String _selectedFilter = 'All';

  final List<OrderRecord> _orders = const [
    OrderRecord(
      orderId: '#OD-982341',
      store: 'Amazon',
      category: 'Electronics & Gadgets',
      date: '21 Aug 2026',
      amount: '₹3,499.00',
      cashback: '₹262.40',
      rate: '7.5% Cashback',
      status: 'Pending',
      statusColor: Colors.orange,
      expectedDate: 'Expected by 25 Oct 2026',
      icon: Icons.shopping_bag_outlined,
    ),
    OrderRecord(
      orderId: '#OD-872190',
      store: 'Myntra',
      category: 'Fashion & Apparel',
      date: '18 Aug 2026',
      amount: '₹1,299.00',
      cashback: '₹103.90',
      rate: '8% Cashback',
      status: 'Pending',
      statusColor: Colors.orange,
      expectedDate: 'Expected by 18 Oct 2026',
      icon: Icons.checkroom_outlined,
    ),
    OrderRecord(
      orderId: '#OD-761239',
      store: 'Flipkart',
      category: 'Home & Kitchen',
      date: '11 Aug 2026',
      amount: '₹4,890.00',
      cashback: '₹489.00',
      rate: '10% Cashback',
      status: 'Confirmed',
      statusColor: Colors.green,
      expectedDate: 'Confirmed on 20 Aug 2026',
      icon: Icons.storefront_outlined,
    ),
    OrderRecord(
      orderId: '#OD-650182',
      store: 'Ajio',
      category: 'Footwear & Accessories',
      date: '28 Jul 2026',
      amount: '₹899.00',
      cashback: '₹71.90',
      rate: '8% Cashback',
      status: 'Confirmed',
      statusColor: Colors.green,
      expectedDate: 'Confirmed on 12 Aug 2026',
      icon: Icons.local_mall_outlined,
    ),
    OrderRecord(
      orderId: '#OD-549102',
      store: 'Nykaa',
      category: 'Beauty & Personal Care',
      date: '14 Jul 2026',
      amount: '₹2,150.00',
      cashback: '₹172.00',
      rate: '8% Cashback',
      status: 'Confirmed',
      statusColor: Colors.green,
      expectedDate: 'Confirmed on 01 Aug 2026',
      icon: Icons.spa_outlined,
    ),
  ];

  List<OrderRecord> get _filteredOrders => _selectedFilter == 'All'
      ? _orders
      : _orders.where((o) => o.status == _selectedFilter).toList();

  void _showOrderDetailModal(BuildContext context, OrderRecord o, bool isDark) {
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
                      o.store,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Order ID: ${o.orderId}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: o.statusColor.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    o.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: o.statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA)),
            const SizedBox(height: 12),
            _buildDetailRow('Category', o.category, isDark),
            const SizedBox(height: 10),
            _buildDetailRow('Order Date', o.date, isDark),
            const SizedBox(height: 10),
            _buildDetailRow('Order Amount', o.amount, isDark),
            const SizedBox(height: 10),
            _buildDetailRow('Cashback Rate', o.rate, isDark),
            const SizedBox(height: 10),
            _buildDetailRow('Total Cashback', o.cashback, isDark, isHighlight: true),
            const SizedBox(height: 10),
            _buildDetailRow('Timeline Note', o.expectedDate, isDark),
            const SizedBox(height: 24),
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
                child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String val, bool isDark, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        Text(
          val,
          style: TextStyle(
            fontSize: 13.5,
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
          'My Order Details',
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
          padding: const EdgeInsets.all(16.0),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('Total Orders', '${_orders.length}', isDark, const Color(0xFF1E90FF)),
                    _buildDivider(isDark),
                    _buildStat('Confirmed', '₹732.90', isDark, Colors.green),
                    _buildDivider(isDark),
                    _buildStat('Pending', '₹366.30', isDark, Colors.orange),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Filter Tabs
              Row(
                children: ['All', 'Confirmed', 'Pending']
                    .map((tab) => _buildFilterTab(tab, isDark))
                    .toList(),
              ),

              const SizedBox(height: 16),

              // Order Records List
              if (_filteredOrders.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  child: Text(
                    'No $_selectedFilter orders found.',
                    style: TextStyle(
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                )
              else
                ..._filteredOrders.map((o) => _buildOrderCard(o, isDark)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 36,
      width: 1,
      color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
    );
  }

  Widget _buildStat(String label, String val, bool isDark, Color color) {
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
          val,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildFilterTab(String label, bool isDark) {
    final isSelected = _selectedFilter == label;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: () => setState(() => _selectedFilter = label),
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
                    : (isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA)),
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
      ),
    );
  }

  Widget _buildOrderCard(OrderRecord o, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161618) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showOrderDetailModal(context, o, isDark),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E90FF).withValues(alpha: isDark ? 0.16 : 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(o.icon, color: const Color(0xFF1E90FF), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            o.store,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${o.orderId} • ${o.date}',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: o.statusColor.withValues(alpha: isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        o.status,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: o.statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark ? const Color(0xFF242426) : const Color(0xFFF0F0F3),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Amount',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          o.amount,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Cashback Earned',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          o.cashback,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E90FF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
