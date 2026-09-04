import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import 'get_help_screen.dart';
import 'missing_tickets_screen.dart';

class YourQueriesScreen extends StatelessWidget {
  static const String routeName = '/your-queries';

  const YourQueriesScreen({super.key});

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
          'Your Queries',
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Empty State Box
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.border,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.question_answer_outlined,
                          size: 38,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'No Active Queries',
                      style: AppTextStyles.sectionHeading(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                      ).copyWith(fontSize: 17),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You haven’t raised any support queries or tickets yet. If you have any issue regarding cashback tracking, missing orders, or withdrawals, feel free to contact us.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pushNamed(GetHelpScreen.routeName),
                      icon: const Icon(Icons.add_comment_outlined, size: 16),
                      label: Text(
                        'Raise a Support Query',
                        style: AppTextStyles.buttonText(color: AppColors.cardBackground),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF3F2B22) : AppColors.primaryBrown,
                        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.cardBackground,
                        side: isDark ? const BorderSide(color: Color(0xFF6B4C3D), width: 1) : null,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick Help Section
              Text(
                'POPULAR SUPPORT TOPICS',
                style: GoogleFonts.fraunces(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                ),
              ),

              const SizedBox(height: 12),

              _buildSupportCard(
                context,
                isDark: isDark,
                icon: Icons.confirmation_number_outlined,
                title: 'Missing Cashback Ticket',
                subtitle: 'Did not get cashback for a recent order? Raise a ticket',
                onTap: () => Navigator.of(context).pushNamed(MissingTicketsScreen.routeName),
              ),

              const SizedBox(height: 10),

              _buildSupportCard(
                context,
                isDark: isDark,
                icon: Icons.help_outline_rounded,
                title: 'Frequently Asked Questions',
                subtitle: 'Find quick answers to common cashback & referral queries',
                onTap: () => Navigator.of(context).pushNamed(GetHelpScreen.routeName),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportCard(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown),
        ),
        title: Text(
          title,
          style: AppTextStyles.cardTitle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.caption(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
        ),
        onTap: onTap,
      ),
    );
  }
}
