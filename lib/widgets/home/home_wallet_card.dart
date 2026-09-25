import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screens/wallet/withdraw_screen.dart';
import '../../theme/app_theme.dart';

/// A simplified, focused Home Wallet Card that highlights the user's
/// primary wallet balance with a clear call-to-action, eliminating
/// confusing sub-metrics from the home feed.
class HomeWalletCard extends StatelessWidget {
  final bool isDark;
  final String allTimeEarnings;
  final String cashback;
  final String rewards;
  final String referral;
  final VoidCallback? onTap;
  final VoidCallback? onWithdrawTap;

  const HomeWalletCard({
    super.key,
    required this.isDark,
    this.allTimeEarnings = '₹0.00',
    this.cashback = '₹0.00',
    this.rewards = '₹0.00',
    this.referral = '₹0.00',
    this.onTap,
    this.onWithdrawTap,
  });

  @override
  Widget build(BuildContext context) {
    final textAmount = isDark ? AppColors.darkTextPrimary : const Color(0xFF1E130D);
    final textSubtitle = isDark ? AppColors.darkTextMuted : const Color(0xFF64748B);
    final walletIconColor = isDark ? const Color(0xFF2563EB) : const Color(0xFF0F172A);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: (isDark ? AppColors.darkPrimary : AppColors.primaryBrown).withValues(alpha: 0.12),
        highlightColor: (isDark ? AppColors.darkPrimary : AppColors.primaryBrown).withValues(alpha: 0.05),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [
                      Color(0xFF132247),
                      Color(0xFF132247),
                      Color(0xFF0A1128),
                      Color(0xFF1B120E),
                    ]
                  : const [
                      Color(0xFFFFFFFF),
                      Color(0xFFFAF2E7),
                      Color(0xFFF2E5D2),
                      Color(0xFFFAF4EC),
                    ],
              stops: const [0.0, 0.35, 0.72, 1.0],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF634A38).withValues(alpha: 0.6)
                  : const Color(0xFFE2E8F0),
              width: 1.6,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : const Color(0xFF0F172A))
                    .withValues(alpha: isDark ? 0.5 : 0.08),
                blurRadius: 16,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: isDark
                    ? const Color(0xFF1E3A8A).withValues(alpha: 0.25)
                    : Colors.white.withValues(alpha: 0.9),
                blurRadius: 3,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: Stack(
              children: [
                // Top-Right Luxury Metallic Watermark Rings
                Positioned(
                  top: -24,
                  right: -24,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          (isDark ? const Color(0xFF2563EB) : const Color(0xFF2563EB))
                              .withValues(alpha: isDark ? 0.16 : 0.12),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -12,
                  right: -12,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: (isDark ? const Color(0xFF2563EB) : const Color(0xFF2563EB))
                            .withValues(alpha: isDark ? 0.18 : 0.14),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),

                // Compact, Focused Wallet Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      // 1. Wallet Icon in elevated squircle
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? const [Color(0xFF132247), Color(0xFF0A1128)]
                                : const [Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF6B4B36).withValues(alpha: 0.5)
                                : const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.account_balance_wallet_rounded,
                            color: walletIconColor,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // 2. Primary Information: Label, Amount, Available info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Wallet Balance',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: textSubtitle,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              allTimeEarnings,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: textAmount,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              '₹$cashback available to withdraw',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? const Color(0xFF81C784)
                                    : const Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 3. Simple Action: Withdraw CTA Button
                      GestureDetector(
                        onTap: () {
                          if (onWithdrawTap != null) {
                            onWithdrawTap!();
                          } else if (onTap != null) {
                            onTap!();
                          } else {
                            Navigator.of(context).pushNamed(WithdrawScreen.routeName);
                          }
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8.5,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primaryBrown,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: (isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.primaryBrown)
                                    .withValues(alpha: 0.32),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Withdraw',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 3.5),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 12,
                                color: Colors.white,
                              ),
                            ],
                          ),
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
  }
}
