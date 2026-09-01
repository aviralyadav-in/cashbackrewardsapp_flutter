import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

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
      'statusColor': AppColors.pending,
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
      'statusColor': AppColors.primaryBrown,
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
      'statusColor': AppColors.success,
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
      backgroundColor: isDark ? AppColors.darkCard : AppColors.cardBackground,
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
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Add Missing Cashback Ticket',
              style: AppTextStyles.cardTitle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
              ).copyWith(fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              'Fill in your shopping details within 10 days of purchase.',
              style: AppTextStyles.caption(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: storeCtrl,
              decoration: InputDecoration(
                labelText: 'Store Name (e.g. Amazon, Flipkart)',
                filled: true,
                fillColor:
                    isDark ? AppColors.darkSurface : AppColors.beigeSurface,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: orderIdCtrl,
              decoration: InputDecoration(
                labelText: 'Order / Transaction ID',
                filled: true,
                fillColor:
                    isDark ? AppColors.darkSurface : AppColors.beigeSurface,
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
                    isDark ? AppColors.darkSurface : AppColors.beigeSurface,
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
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBrown,
                  foregroundColor: AppColors.cardBackground,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  ),
                ),
                child: Text(
                  'Submit Ticket',
                  style: AppTextStyles.buttonText(color: AppColors.cardBackground).copyWith(fontSize: 15),
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
                      ticket['store'] as String,
                      style: GoogleFonts.fraunces(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ticket: ${ticket['ticketId']}',
                      style: AppTextStyles.caption(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (ticket['statusColor'] as Color)
                        .withValues(alpha: isDark ? 0.2 : 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ticket['status'] as String,
                    style: AppTextStyles.smallLabel(
                      color: ticket['statusColor'] as Color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(
              color: isDark ? AppColors.darkBorder : AppColors.border,
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
                    ? AppColors.darkSurface
                    : AppColors.beigeSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                ticket['note'] as String,
                style: AppTextStyles.body(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ).copyWith(fontSize: 12.5),
              ),
            ),
            const SizedBox(height: 20),
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
                child: Text('Close',
                    style: AppTextStyles.buttonText(color: AppColors.cardBackground)),
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
          style: AppTextStyles.caption(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: isHighlight
              ? GoogleFonts.fraunces(
                  fontSize: 13.5,
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
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.mainBackground,
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
          'Missing Cashback',
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
              // Info Banner Header
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.border,
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
                        color: AppColors.primaryBrown
                            .withValues(alpha: isDark ? 0.18 : 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.help_outline_rounded,
                          color: AppColors.primaryBrown, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Missing Cashback?',
                            style: AppTextStyles.cardTitle(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Raise a ticket within 10 days if your cashback did not track.',
                            style: AppTextStyles.caption(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Filter Chips Row
              Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Active'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Resolved'),
                ],
              ),

              const SizedBox(height: 18),

              // List of Tickets
              if (_filteredTickets.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.inbox_rounded,
                            size: 48,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          'No tickets found in this section',
                          style: AppTextStyles.cardSubtitle(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._filteredTickets.map((ticket) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.border,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showTicketDetails(context, ticket, isDark),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ticket['store'] as String,
                                    style: GoogleFonts.fraunces(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: (ticket['statusColor'] as Color)
                                          .withValues(
                                              alpha: isDark ? 0.2 : 0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      ticket['status'] as String,
                                      style: AppTextStyles.smallLabel(
                                        color: ticket['statusColor'] as Color,
                                      ).copyWith(fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${ticket['ticketId']} • Order on ${ticket['orderDate']}',
                                style: AppTextStyles.caption(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Expected: ${ticket['expectedCashback']}',
                                    style: GoogleFonts.fraunces(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'View Details',
                                        style: AppTextStyles.smallLabel(
                                          color: AppColors.primaryBrown,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 11,
                                        color: AppColors.primaryBrown,
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

              // Add Ticket Button
              ElevatedButton.icon(
                onPressed: () => _showAddTicketModal(context, isDark),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                label: const Text('Add New Missing Ticket'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBrown,
                  foregroundColor: AppColors.cardBackground,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  ),
                  elevation: 2,
                  textStyle: AppTextStyles.buttonText(color: AppColors.cardBackground).copyWith(fontSize: 14),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filterName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedFilter == filterName;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = filterName;
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
                : (isDark
                    ? AppColors.darkBorder
                    : AppColors.border),
          ),
        ),
        child: Text(
          filterName,
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
