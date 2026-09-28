import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

enum SpendingViewPeriod { day, month }

class SpendingDataPoint {
  final String label;
  final String fullDate;
  final double amount;
  final double cashback;
  final int orderCount;

  const SpendingDataPoint({
    required this.label,
    required this.fullDate,
    required this.amount,
    required this.cashback,
    this.orderCount = 0,
  });

  factory SpendingDataPoint.fromMap(Map<String, dynamic> map) {
    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return SpendingDataPoint(
      label: map['label']?.toString() ?? '',
      fullDate: map['fullDate']?.toString() ?? '',
      amount: parseDouble(map['amount']),
      cashback: parseDouble(map['cashback']),
      orderCount: map['orderCount'] is int
          ? map['orderCount'] as int
          : int.tryParse(map['orderCount']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'fullDate': fullDate,
      'amount': amount,
      'cashback': cashback,
      'orderCount': orderCount,
    };
  }
}

class WalletSpendingGraphCard extends StatefulWidget {
  final bool isDark;
  final bool hasShopped;
  final bool isLoading;
  final List<SpendingDataPoint>? dailyData;
  final List<SpendingDataPoint>? monthlyData;

  const WalletSpendingGraphCard({
    super.key,
    required this.isDark,
    this.hasShopped = false,
    this.isLoading = false,
    this.dailyData,
    this.monthlyData,
  });

  @override
  State<WalletSpendingGraphCard> createState() => _WalletSpendingGraphCardState();
}

class _WalletSpendingGraphCardState extends State<WalletSpendingGraphCard> {
  SpendingViewPeriod _activePeriod = SpendingViewPeriod.day;
  int _selectedIndex = 6; // Default to latest item

  static List<SpendingDataPoint> _generateDefaultDaily() {
    final now = DateTime.now();
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final fullDayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    final List<SpendingDataPoint> list = [];
    for (int i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final isToday = i == 0;
      final label = dayNames[d.weekday - 1];
      final fullDate = '${fullDayNames[d.weekday - 1]}, ${d.day} ${monthNames[d.month - 1]}${isToday ? ' (Today)' : ''}';
      list.add(SpendingDataPoint(
        label: label,
        fullDate: fullDate,
        amount: 0.0,
        cashback: 0.0,
        orderCount: 0,
      ));
    }
    return list;
  }

  static List<SpendingDataPoint> _generateDefaultMonthly() {
    final now = DateTime.now();
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final fullMonthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    final List<SpendingDataPoint> list = [];
    for (int i = 6; i >= 0; i--) {
      int m = now.month - i;
      int y = now.year;
      while (m <= 0) {
        m += 12;
        y -= 1;
      }
      final isCurrent = i == 0;
      final label = monthNames[m - 1];
      final fullDate = '${fullMonthNames[m - 1]} $y${isCurrent ? ' (MTD)' : ''}';
      list.add(SpendingDataPoint(
        label: label,
        fullDate: fullDate,
        amount: 0.0,
        cashback: 0.0,
        orderCount: 0,
      ));
    }
    return list;
  }

  List<SpendingDataPoint> get _currentData {
    if (_activePeriod == SpendingViewPeriod.day) {
      if (widget.dailyData != null && widget.dailyData!.isNotEmpty) {
        return widget.dailyData!;
      }
      return _generateDefaultDaily();
    } else {
      if (widget.monthlyData != null && widget.monthlyData!.isNotEmpty) {
        return widget.monthlyData!;
      }
      return _generateDefaultMonthly();
    }
  }

  SpendingDataPoint get _selectedPoint {
    final data = _currentData;
    if (_selectedIndex >= data.length) {
      return data.isNotEmpty ? data.last : const SpendingDataPoint(label: '', fullDate: '', amount: 0, cashback: 0);
    }
    return data[_selectedIndex];
  }

  double get _maxAmount {
    double max = 0;
    for (final p in _currentData) {
      if (p.amount > max) max = p.amount;
    }
    return max;
  }

  double get _totalSpend =>
      _currentData.fold(0.0, (sum, p) => sum + p.amount);

  double get _totalCashback =>
      _currentData.fold(0.0, (sum, p) => sum + p.cashback);

  String _formatAmount(double amt) {
    final str = amt.toStringAsFixed(0);
    final reg = RegExp(r'(\d+?)(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final primaryAccent =
        isDark ? AppColors.darkPrimary : AppColors.accentBlue;
    final cardBg = isDark ? AppColors.darkCard : AppColors.cardBackground;
    final cardBorder = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textMuted =
        isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    final selected = _selectedPoint;
    final data = _currentData;
    final maxAmt = _maxAmount;
    final hasAnySpend = _totalSpend > 0;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 42),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: primaryAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Fetching real data from database...',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
            // =================================================================
            // 1. HEADER: Title + Day/Month Toggle
            // =================================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: primaryAccent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: primaryAccent.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.insights_rounded,
                        color: primaryAccent,
                        size: 19,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Spending Analytics',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.storage_rounded,
                                    size: 9.5,
                                    color: Color(0xFF10B981),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Database Synced',
                                    style: TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? const Color(0xFF6EE7B7)
                                          : const Color(0xFF047857),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Segmented Filter Toggle: Day vs Month
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPeriodTab(
                          label: 'Daily',
                          period: SpendingViewPeriod.day,
                          primaryAccent: primaryAccent,
                          isDark: isDark,
                        ),
                        _buildPeriodTab(
                          label: 'Monthly',
                          period: SpendingViewPeriod.month,
                          primaryAccent: primaryAccent,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // =================================================================
            // 2. ACTIVE SELECTION TOOLTIP BANNER
            // =================================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? const [Color(0xFF25203F), Color(0xFF1E1A33)]
                        : const [Color(0xFFF3F6FE), Color(0xFFEAEFFE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.border,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: primaryAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  selected.fullDate.isNotEmpty
                                      ? selected.fullDate
                                      : 'No Data',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: textMuted,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (selected.orderCount > 0) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color:
                                        primaryAccent.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${selected.orderCount} ${selected.orderCount == 1 ? 'order' : 'orders'}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: primaryAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 3),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '₹${_formatAmount(selected.amount)} Spent',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: textPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Cashback Earned on that day/month
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              const Color(0xFF10B981).withValues(alpha: 0.35),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '+₹${_formatAmount(selected.cashback)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? const Color(0xFF81C784)
                                    : const Color(0xFF1B5E20),
                              ),
                            ),
                          ),
                          Text(
                            'Cashback',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? const Color(0xFF81C784)
                                  : const Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // =================================================================
            // 3. INTERACTIVE BAR CHART
            // =================================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 155,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Background Reference Dashed Gridlines
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildGridLine(
                              label: hasAnySpend
                                  ? '₹${_formatAmount(maxAmt)}'
                                  : '₹0',
                              isDark: isDark),
                          _buildGridLine(
                              label: hasAnySpend
                                  ? '₹${_formatAmount(maxAmt * 0.5)}'
                                  : '₹0',
                              isDark: isDark),
                          _buildGridLine(label: '₹0', isDark: isDark),
                          const SizedBox(height: 24), // Space for bottom labels
                        ],
                      ),
                    ),

                    if (!hasAnySpend)
                      Positioned(
                        top: 24,
                        left: 48,
                        right: 12,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurface.withValues(alpha: 0.88)
                                  : AppColors.surfaceSubtle.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : AppColors.border,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 13,
                                  color: textMuted,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'No store purchases in this period',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Interactive Columns
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 42, right: 6, bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(data.length, (index) {
                          final point = data[index];
                          final isSelected = index == _selectedIndex;
                          final hasSpend = point.amount > 0;
                          final double barHeight;
                          if (hasSpend && maxAmt > 0) {
                            final barHeightRatio =
                                (point.amount / maxAmt).clamp(0.08, 1.0);
                            barHeight = barHeightRatio * 96;
                          } else {
                            barHeight = 4.0;
                          }

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Selected Pulse Indicator Top Dot
                                  if (isSelected)
                                    Container(
                                      width: 4,
                                      height: 4,
                                      margin: const EdgeInsets.only(bottom: 3),
                                      decoration: BoxDecoration(
                                        color: primaryAccent,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryAccent.withValues(
                                                alpha: 0.6),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    const SizedBox(height: 7),

                                  // Bar Pillar
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 320),
                                    curve: Curves.easeOutCubic,
                                    width: isSelected ? 20 : 14,
                                    height: barHeight,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: hasSpend
                                            ? (isSelected
                                                ? [
                                                    primaryAccent,
                                                    isDark
                                                        ? const Color(0xFFB4A8E8)
                                                        : const Color(0xFF7C6BE8),
                                                  ]
                                                : [
                                                    isDark
                                                        ? AppColors.darkSurface
                                                        : AppColors.surfaceSubtle,
                                                    primaryAccent
                                                        .withValues(alpha: 0.6),
                                                  ])
                                            : [
                                                isDark
                                                    ? AppColors.darkSurface
                                                    : AppColors.surfaceSubtle,
                                                isDark
                                                    ? AppColors.darkBorder
                                                    : AppColors.border,
                                              ],
                                      ),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(7),
                                      ),
                                      boxShadow: isSelected && hasSpend
                                          ? [
                                              BoxShadow(
                                                color: primaryAccent
                                                    .withValues(alpha: 0.35),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : [],
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Bottom Label (Mon, Tue, ... or Apr, May, ...)
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      point.label,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10.5,
                                        fontWeight: isSelected
                                            ? FontWeight.w800
                                            : FontWeight.w600,
                                        color: isSelected
                                            ? primaryAccent
                                            : textMuted,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Divider
            Divider(
              height: 1,
              color: isDark
                  ? AppColors.darkBorder.withValues(alpha: 0.5)
                  : AppColors.border.withValues(alpha: 0.7),
            ),

            // =================================================================
            // 4. PERIOD SUMMARY STATS TRAY (Total, Average, Total Cashback)
            // =================================================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              color: isDark
                  ? AppColors.darkSurface.withValues(alpha: 0.6)
                  : AppColors.surfaceSubtle.withValues(alpha: 0.8),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMetricPillar(
                      label: _activePeriod == SpendingViewPeriod.day
                          ? 'Weekly Spend'
                          : 'Period Spend',
                      value: '₹${_formatAmount(_totalSpend)}',
                      textPrimary: textPrimary,
                      textMuted: textMuted,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                  Expanded(
                    child: _buildMetricPillar(
                      label: _activePeriod == SpendingViewPeriod.day
                          ? 'Daily Avg'
                          : 'Monthly Avg',
                      value:
                          '₹${_formatAmount(data.isEmpty ? 0 : _totalSpend / data.length)}',
                      textPrimary: textPrimary,
                      textMuted: textMuted,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                  Expanded(
                    child: _buildMetricPillar(
                      label: 'Total Cashback',
                      value: '₹${_formatAmount(_totalCashback)}',
                      textPrimary: isDark
                          ? const Color(0xFF81C784)
                          : const Color(0xFF2E7D32),
                      textMuted: textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

  Widget _buildPeriodTab({
    required String label,
    required SpendingViewPeriod period,
    required Color primaryAccent,
    required bool isDark,
  }) {
    final isSelected = _activePeriod == period;

    return GestureDetector(
      onTap: () {
        setState(() {
          _activePeriod = period;
          _selectedIndex = (_currentData.length - 1).clamp(0, 6);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? primaryAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryAccent.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildGridLine({required String label, required bool isDark}) {
    return Row(
      children: [
        SizedBox(
          width: 38,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
              textAlign: TextAlign.left,
              maxLines: 1,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 0.8,
            color: isDark
                ? Colors.white.withValues(alpha: 0.07)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricPillar({
    required String label,
    required String value,
    required Color textPrimary,
    required Color textMuted,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: textMuted,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: textPrimary,
                letterSpacing: -0.2,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
