import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import 'withdraw_screen.dart';

class PaymentsHistoryScreen extends StatefulWidget {
  static const String routeName = '/payments-history';

  const PaymentsHistoryScreen({super.key});

  @override
  State<PaymentsHistoryScreen> createState() => _PaymentsHistoryScreenState();
}

class _PaymentsHistoryScreenState extends State<PaymentsHistoryScreen> {
  String _selectedFilter = 'All'; // 'All', 'UPI', 'Bank', 'Amazon Pay'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).loadWalletData();
      }
    });
  }

  String _formatTxDate(dynamic raw) {
    if (raw == null) return 'Recent';
    try {
      final dt = DateTime.parse(raw.toString()).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final month = months[dt.month - 1];
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      final min = dt.minute.toString().padLeft(2, '0');
      return '${dt.day} $month ${dt.year} • $hour:$min $ampm';
    } catch (_) {
      return raw.toString();
    }
  }

  String _getMethodCategory(String desc) {
    final d = desc.toUpperCase();
    if (d.contains('UPI') || d.contains('VPAY') || d.contains('GPAY') || d.contains('PHONEPE')) {
      return 'UPI';
    } else if (d.contains('BANK') || d.contains('NEFT') || d.contains('IMPS') || d.contains('ACCOUNT')) {
      return 'Bank';
    } else if (d.contains('AMAZON') || d.contains('GIFT')) {
      return 'Amazon Pay';
    }
    return 'UPI';
  }

  IconData _getMethodIcon(String category) {
    switch (category) {
      case 'Bank':
        return Icons.account_balance_rounded;
      case 'Amazon Pay':
        return Icons.card_giftcard_rounded;
      case 'UPI':
      default:
        return Icons.qr_code_2_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = Provider.of<UserProvider>(context);

    // 100% REAL WITHDRAWAL TRANSACTIONS PURELY FROM DATABASE
    final allTxs = userProvider.walletTransactions;
    final withdrawalTxs = allTxs.where((tx) {
      final type = (tx['type'] ?? '').toString().toUpperCase();
      final amount = double.tryParse(tx['amount']?.toString() ?? '0') ?? 0.0;
      return type.contains('WITHDRAW') || amount < 0;
    }).toList();

    final filteredTxs = _selectedFilter == 'All'
        ? withdrawalTxs
        : withdrawalTxs.where((tx) {
            final desc = (tx['description'] ?? '').toString();
            return _getMethodCategory(desc) == _selectedFilter;
          }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.mainBackground,
        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.navyDark,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Payout History',
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await userProvider.loadWalletData();
          },
          color: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // =============================================================
              // 1. FILTER TABS (All, UPI, Bank, Amazon Pay) - FULL SCREEN WIDTH
              // =============================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 32,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFilterChip('All', isDark),
                        const SizedBox(width: 8),
                        _buildFilterChip('UPI', isDark),
                        const SizedBox(width: 8),
                        _buildFilterChip('Bank', isDark),
                        const SizedBox(width: 8),
                        _buildFilterChip('Amazon Pay', isDark),
                      ],
                    ),
                  ),
                ),
              ),

              Divider(height: 1, thickness: 1, color: isDark ? AppColors.darkBorder : AppColors.border),

              // =============================================================
              // 2. TRANSACTIONS LIST / EMPTY STATE (DYNAMIC)
              // =============================================================
              Expanded(
                child: userProvider.isLoadingWallet
                    ? Center(
                        child: CircularProgressIndicator(
                          color: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
                        ),
                      )
                    : filteredTxs.isEmpty
                        ? _buildEmptyState(context, isDark)
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredTxs.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemBuilder: (ctx, index) {
                              final tx = filteredTxs[index];
                              return _buildPayoutTile(context, tx, isDark);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isDark) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkPrimary : AppColors.accentBlue)
              : (isDark ? AppColors.darkSurface : AppColors.surfaceSubtle),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.darkPrimary : AppColors.accentBlue)
                : (isDark ? AppColors.darkBorder : AppColors.border),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildPayoutTile(BuildContext context, Map<String, dynamic> tx, bool isDark) {
    final rawAmount = double.tryParse(tx['amount']?.toString() ?? '0') ?? 0.0;
    final amountAbs = rawAmount.abs();
    final desc = (tx['description'] ?? 'Withdrawal request').toString();
    final status = (tx['status'] ?? 'CONFIRMED').toString().toUpperCase();
    final dateString = _formatTxDate(tx['createdAt'] ?? tx['created_at']);
    final methodCategory = _getMethodCategory(desc);
    final icon = _getMethodIcon(methodCategory);
    final txId = (tx['id'] ?? '').toString();

    final isSuccess = status == 'CONFIRMED' || status == 'COMPLETED' || status == 'SUCCESSFUL';
    final isPending = status == 'PENDING' || status == 'PROCESSING';

    final Color statusColor = isSuccess
        ? (isDark ? const Color(0xFF81C784) : const Color(0xFF16A34A))
        : (isPending
            ? const Color(0xFFD97706)
            : const Color(0xFFEF4444));

    return InkWell(
      onTap: () => _showReceiptModal(context, tx, amountAbs, desc, status, dateString, methodCategory, txId, isDark),
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
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
                color: (isDark ? const Color(0xFFEF4444) : const Color(0xFFFEE2E2)).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: const Color(0xFFEF4444)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          desc,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '-₹${amountAbs.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateString,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReceiptModal(
    BuildContext context,
    Map<String, dynamic> tx,
    double amount,
    String desc,
    String status,
    String dateString,
    String category,
    String txId,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1815) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
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
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF10B981),
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Payout Receipt',
                    style: GoogleFonts.plusJakartaSans(
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1E1E24),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${amount.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Divider(color: isDark ? AppColors.darkBorder : AppColors.border),
            const SizedBox(height: 10),
            _buildReceiptRow('Transaction ID', txId.isNotEmpty ? txId : 'N/A', isDark),
            const SizedBox(height: 8),
            _buildReceiptRow('Status', status, isDark),
            const SizedBox(height: 8),
            _buildReceiptRow('Payout Method', category, isDark),
            const SizedBox(height: 8),
            _buildReceiptRow('Date & Time', dateString, isDark),
            const SizedBox(height: 8),
            _buildReceiptRow('Details', desc, isDark),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Close Receipt'),
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
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surfaceSubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 42,
                color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Payout Requests Yet',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'When you withdraw your cashback or rewards to your UPI, Bank, or Amazon Pay, the transaction history and receipts will be recorded here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushNamed(WithdrawScreen.routeName),
              icon: const Icon(Icons.payments_outlined, size: 16),
              label: const Text('Request Payout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
