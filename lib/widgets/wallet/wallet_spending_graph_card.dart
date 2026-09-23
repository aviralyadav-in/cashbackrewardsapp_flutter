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
    this.orderCount = 1,
  });
}

class WalletSpendingGraphCard extends StatefulWidget {
  final bool isDark;
  final bool hasShopped;

  const WalletSpendingGraphCard({
    super.key,
    required this.isDark,
    this.hasShopped = false,
  });

  @override
  State<WalletSpendingGraphCard> createState() => _WalletSpendingGraphCardState();
}

class _WalletSpendingGraphCardState extends State<WalletSpendingGraphCard> {
  SpendingViewPeriod _activePeriod = SpendingViewPeriod.day;
  int _selectedIndex = 6; // Default to latest item

  static const List<SpendingDataPoint> _dailyData = [
    SpendingDataPoint(
      label: 'Mon',
      fullDate: 'Monday, 1 Sep',
      amount: 1250,
      cashback: 95,
      orderCount: 1,
    ),
    SpendingDataPoint(
      label: 'Tue',
      fullDate: 'Tuesday, 2 Sep',
      amount: 820,
      cashback: 65,
      orderCount: 1,
    ),
    SpendingDataPoint(
      label: 'Wed',
      fullDate: 'Wednesday, 3 Sep',
      amount: 2150,
      cashback: 180,
      orderCount: 2,
    ),
    SpendingDataPoint(
      label: 'Thu',
      fullDate: 'Thursday, 4 Sep',
      amount: 980,
      cashback: 75,
      orderCount: 1,
    ),
    SpendingDataPoint(
      label: 'Fri',
      fullDate: 'Friday, 5 Sep',
      amount: 3450,
      cashback: 290,
      orderCount: 3,
    ),
    SpendingDataPoint(
      label: 'Sat',
      fullDate: 'Saturday, 6 Sep',
      amount: 4890,
      cashback: 420,
      orderCount: 4,
    ),
    SpendingDataPoint(
      label: 'Sun',
      fullDate: 'Sunday, 7 Sep (Today)',
      amount: 1650,
      cashback: 140,
      orderCount: 2,
    ),
  ];

  static const List<SpendingDataPoint> _monthlyData = [
    SpendingDataPoint(
      label: 'Mar',
      fullDate: 'March 2026',
      amount: 4200,
      cashback: 340,
      orderCount: 5,
    ),
    SpendingDataPoint(
      label: 'Apr',
      fullDate: 'April 2026',
      amount: 5800,
      cashback: 460,
      orderCount: 7,
    ),
    SpendingDataPoint(
      label: 'May',
      fullDate: 'May 2026',
      amount: 6900,
      cashback: 580,
      orderCount: 8,
    ),
    SpendingDataPoint(
      label: 'Jun',
      fullDate: 'June 2026',
      amount: 4300,
      cashback: 350,
      orderCount: 5,
    ),
    SpendingDataPoint(
      label: 'Jul',
      fullDate: 'July 2026',
      amount: 8400,
      cashback: 710,
      orderCount: 11,
    ),
    SpendingDataPoint(
      label: 'Aug',
      fullDate: 'August 2026',
      amount: 6100,
      cashback: 510,
      orderCount: 8,
    ),
    SpendingDataPoint(
      label: 'Sep',
      fullDate: 'September 2026 (MTD)',
      amount: 7850,
      cashback: 680,
      orderCount: 9,
    ),
  ];

  List<SpendingDataPoint> get _currentData {
    final source =
        _activePeriod == SpendingViewPeriod.day ? _dailyData : _monthlyData;
    if (!widget.hasShopped) {
      return source
          .map((p) => SpendingDataPoint(
                label: p.label,
                fullDate: p.fullDate,
                amount: 0,
                cashback: 0,
                orderCount: 0,
              ))
          .toList();
    }
    return source;
  }

  SpendingDataPoint get _selectedPoint {
    final data = _currentData;
    if (_selectedIndex >= data.length) {
      return data.last;
    }
    return data[_selectedIndex];
  }

  double get _maxAmount {
    double max = 0;
    for (final p in _currentData) {
      if (p.amount > max) max = p.amount;
    }
    return max > 0 ? max : 1.0;
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
        isDark ? AppColors.darkPrimary : AppColors.primaryBrown;
    final cardBg = isDark ? AppColors.darkCard : AppColors.cardBackground;
    final cardBorder = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : const Color(0xFF1E1E24);
    final textMuted =
        isDark ? AppColors.darkTextMuted : const Color(0xFF64748B);

    final selected = _selectedPoint;
    final data = _currentData;
    final maxAmt = _maxAmount;

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
            // =================================================================
            // 1. HEADER: Title + Day/Month Toggle
            // =================================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
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
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Spending Analytics',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                          // Text(
                          //   'Track spends & earned cashback',
                          //   style: GoogleFonts.plusJakartaSans(
                          //     fontSize: 11,
                          //     fontWeight: FontWeight.w500,
                          //     color: textMuted,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),

                  // Segmented Filter Toggle: Day vs Month
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1815)
                          : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : const Color(0xFFE2E8F0),
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
                        ? const [Color(0xFF132247), Color(0xFF0A1128)]
                        : const [Color(0xFFFBF4EA), Color(0xFFF3E7D5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF1E3A8A)
                        : const Color(0xFFE2E8F0),
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
                              Text(
                                selected.fullDate,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '₹${_formatAmount(selected.amount)} Spent',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                        children: [
                          Text(
                            '+₹${_formatAmount(selected.cashback)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? const Color(0xFF81C784)
                                  : const Color(0xFF1B5E20),
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
                              label: '₹${_formatAmount(maxAmt)}', isDark: isDark),
                          _buildGridLine(
                              label: '₹${_formatAmount(maxAmt * 0.5)}',
                              isDark: isDark),
                          _buildGridLine(label: '₹0', isDark: isDark),
                          const SizedBox(height: 24), // Space for bottom labels
                        ],
                      ),
                    ),

                    // Interactive Columns
                    Padding(
                      padding: const EdgeInsets.only(left: 42, right: 6, bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(data.length, (index) {
                          final point = data[index];
                          final isSelected = index == _selectedIndex;
                          final barHeightRatio = (point.amount / maxAmt).clamp(0.08, 1.0);
                          final double barHeight = barHeightRatio * 96;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            behavior: HitTestBehavior.opaque,
                            child: SizedBox(
                              width: 32,
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
                                    width: isSelected ? 22 : 16,
                                    height: barHeight,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: isSelected
                                            ? [
                                                primaryAccent,
                                                isDark
                                                    ? const Color(0xFFFF9E80)
                                                    : const Color(0xFF2563EB),
                                              ]
                                            : [
                                                isDark
                                                    ? const Color(0xFF1C2D5A)
                                                    : const Color(0xFFE2E8F0),
                                                isDark
                                                    ? const Color(0xFF1E3A8A)
                                                    : const Color(0xFFE2E8F0),
                                              ],
                                      ),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(7),
                                      ),
                                      boxShadow: isSelected
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
                                  Text(
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
                  ? const Color(0xFF1F1713).withValues(alpha: 0.5)
                  : const Color(0xFFFAF4EC).withValues(alpha: 0.6),
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
                          '₹${_formatAmount(_totalSpend / data.length)}',
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
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
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
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.grey.shade400 : const Color(0xFF6B5548)),
          ),
        ),
      ),
    );
  }

  Widget _buildGridLine({required String label, required bool isDark}) {
    return Row(
      children: [
        SizedBox(
          width: 36,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
            textAlign: TextAlign.left,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: textMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}
