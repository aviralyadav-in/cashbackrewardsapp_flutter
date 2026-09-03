import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  /// Opens external website URL cleanly with validation and fallback.
  static Future<bool> openUrl(String urlString) async {
    final clean = urlString.trim();
    if (clean.isEmpty) return false;

    var formatted = clean;
    if (!formatted.startsWith('http://') && !formatted.startsWith('https://')) {
      formatted = 'https://$formatted';
    }

    final Uri? uri = Uri.tryParse(formatted);
    if (uri == null) return false;

    // Stage 1: Try launching in external application (Chrome / default browser)
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) return true;
    } catch (e) {
      debugPrint('External browser launch attempt: $e');
    }

    // Stage 2: Fallback to in-app browser view
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );
      if (launched) return true;
    } catch (e) {
      debugPrint('In-app browser launch attempt: $e');
    }

    // Stage 3: Fallback to platform default
    try {
      return await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
    } catch (e) {
      debugPrint('Error launching URL ($urlString): $e');
      return false;
    }
  }
}
