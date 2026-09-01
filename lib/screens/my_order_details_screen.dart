import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

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
      statusColor: AppColors.pending,
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
      statusColor: AppColors.pending,
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
      statusColor: AppColors.success,
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
      statusColor: AppColors.success,
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
      statusColor: AppColors.success,
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
      backgroundColor: isDark ? AppColors.darkCard : AppColors.cardBackground,
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
                  color: isDark ? AppColors.darkBorder : AppColors.border,
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
                      style: GoogleFonts.fraunces(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Order ID: ${o.orderId}',
                      style: AppTextStyles.caption(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: o.statusColor.withValues(alpha: isDark ? 0.2 : 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    o.status,
                    style: AppTextStyles.smallLabel(
                      color: o.statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: isDark ? AppColors.darkBorder : AppColors.border),
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
                  backgroundColor: AppColors.primaryBrown,
                  foregroundColor: AppColors.cardBackground,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  ),
                ),
                child: Text('Close', style: AppTextStyles.buttonText(color: AppColors.cardBackground)),
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
          style: AppTextStyles.caption(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        Text(
          val,
          style: isHighlight
              ? GoogleFonts.fraunces(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                )
              : AppTextStyles.cardTitle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ).copyWith(fontSize: 13),
        ),
      ],
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'My Order Details',
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
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
              // 1. Filter Chips
              Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Confirmed'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending'),
                ],
              ),

              const SizedBox(height: 18),

              // 2. Orders List
              if (_filteredOrders.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 48,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No orders in this status',
                          style: AppTextStyles.cardSubtitle(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._filteredOrders.map((order) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showOrderDetailModal(context, order, isDark),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.primaryBrown.withValues(alpha: 0.2)
                                          : AppColors.beigeSurface,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      order.icon,
                                      color: AppColors.primaryBrown,
                                      size: 22,
                                    ),
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
                                              order.store,
                                              style: GoogleFonts.fraunces(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: order.statusColor
                                                    .withValues(alpha: isDark ? 0.2 : 0.12),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                order.status,
                                                style: AppTextStyles.smallLabel(
                                                  color: order.statusColor,
                                                ).copyWith(fontSize: 11),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${order.orderId} • ${order.date}',
                                          style: AppTextStyles.caption(
                                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Divider(
                                height: 1,
                                color: isDark ? AppColors.darkBorder : AppColors.border,
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
                                        style: AppTextStyles.caption(
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        order.amount,
                                        style: AppTextStyles.cardTitle(
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Cashback Earned',
                                        style: AppTextStyles.caption(
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        order.cashback,
                                        style: GoogleFonts.fraunces(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
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
                }),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedFilter == label;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBrown
              : (isDark ? AppColors.darkSurface : AppColors.beigeSurface),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBrown
                : (isDark ? AppColors.darkBorder : AppColors.border),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonText(
            color: isSelected
                ? AppColors.cardBackground
                : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
          ).copyWith(fontSize: 12.5),
        ),
      ),
    );
  }
}
