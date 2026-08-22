import 'package:flutter/material.dart';
import '../../models/brand_model.dart';
import '../../services/url_launcher_service.dart';

void showBrandConfirmationDialog(BuildContext context, BrandModel brand) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Header
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF1E90FF).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.exit_to_app_rounded,
                color: Color(0xFF1E90FF),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Redirecting to ${brand.name}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Description Subtitle
            Text(
              'You are leaving our app to visit ${brand.name}\'s official website.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),

            // Offer Summary Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E90FF).withValues(alpha: isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF1E90FF).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.card_giftcard,
                    color: Color(0xFF1E90FF),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          brand.cashbackPercentage,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E90FF),
                          ),
                        ),
                        Text(
                          'Cashback will be tracked automatically.',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                // Cancel / Go Back Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? Colors.white : Colors.black87,
                      side: BorderSide(
                        color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFD1D1D6),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Continue / Visit Website Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      final success = await UrlLauncherService.openUrl(brand.websiteUrl);
                      if (!success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Could not open ${brand.name} website'),
                            backgroundColor: const Color(0xFF1E90FF),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E90FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
